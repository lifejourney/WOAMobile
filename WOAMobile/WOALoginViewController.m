//
//  WOALoginViewController.m
//  WOAMobile
//
//  Created by steven.zhuang on 5/31/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import "WOALoginViewController.h"
#import "WOAAppDelegate.h"
#import "WOAPropertyInfo.h"
#import "WOAFlowController.h"


@interface WOALoginViewController () <UITextFieldDelegate>

@property (nonatomic, strong) IBOutlet UILabel *appTitleLabel;
@property (nonatomic, strong) IBOutlet UITextField *accountTextField;
@property (nonatomic, strong) IBOutlet UITextField *passwordTextField;
@property (nonatomic, strong) IBOutlet UIButton *loginButton;

- (IBAction) onLoginAction: (id)sender;

@property (nonatomic, strong) UIResponder *latestResponder;

- (BOOL) validateInput;

- (void) tapOutsideKeyboardAction;

@end

@implementation WOALoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (instancetype) init
{
    if (self = [self initWithNibName: @"WOALoginViewController" bundle: [NSBundle mainBundle]])
    {
    }
    
    return self;
}

- (BOOL) validateInput
{
    return YES;
}

- (void) tapOutsideKeyboardAction
{
    if ([self.accountTextField isFirstResponder])
    {
        [self.accountTextField resignFirstResponder];
    }
    
    if ([self.passwordTextField isFirstResponder])
    {
        [self.passwordTextField resignFirstResponder];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(tapOutsideKeyboardAction)];
    [self.view addGestureRecognizer: tapGesture];
    
    NSString *latestAccountID = [WOAPropertyInfo latestLoginAccountID];
    if (latestAccountID)
    {
        self.accountTextField.text = latestAccountID;
    }
    
    if ([self.accountTextField.text length] > 0)
        [self.passwordTextField becomeFirstResponder];
    else
        [self.accountTextField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL) textField: (UITextField *)textField shouldChangeCharactersInRange: (NSRange)range replacementString: (NSString *)string
{
    NSString *resultString = [textField.text stringByReplacingCharactersInRange: range withString: string];
    
    if ([resultString length] > 0)
    {
        
    }
    
    return YES;
}

- (BOOL) textFieldShouldReturn: (UITextField *)textField
{
    if (textField == self.accountTextField)
    {
        [self.passwordTextField becomeFirstResponder];
    }
    
    return YES;
}

- (void) textFieldDidBeginEditing: (UITextField *)textField
{
    self.latestResponder = textField;
}


- (IBAction) onLoginAction: (id)sender
{
    if ([self validateInput])
    {
        [self.latestResponder resignFirstResponder];
        
        WOAAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        [appDelegate showLoadingViewController];
        
        
        WOARequestContent *requestContent = [WOARequestContent requestContentForLogin: self.accountTextField.text
                                                                             password: self.passwordTextField.text];
        [WOAFlowController sendAsynRequestWithContent: requestContent
                                                queue: appDelegate.operationQueue
                                  completeOnMainQueue: YES
                                    completionHandler: ^(WOAResponeContent *responseContent)
        {
            [appDelegate hideLoadingViewController];
            
            if (responseContent.requestResult == WOAHTTPRequestResult_Success)
            {
                [WOAPropertyInfo saveLatestLoginAccount: self.accountTextField.text];
                
                [appDelegate dismissLoginViewController: YES];
                
                [appDelegate switchToInitiateWorkflow];
            }
            else
            {
                NSLog(@"Login fail: %d, HTTPStatus=%d", responseContent.requestResult, responseContent.HTTPStatus);
            };
        }];
    }
}

@end




