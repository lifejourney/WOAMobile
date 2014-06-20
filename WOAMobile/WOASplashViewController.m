//
//  WOASplashViewController.m
//  WOAMobile
//
//  Created by steven.zhuang on 6/20/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import "WOASplashViewController.h"

@interface WOASplashViewController ()

@property (nonatomic, weak) NSObject<WOASplashViewControllerDelegate> *delegate;

@end

@implementation WOASplashViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
    }
    return self;
}

- (instancetype) initWithDelegate: (NSObject<WOASplashViewControllerDelegate> *)delegate
{
    if (self = [self initWithNibName: nil bundle: nil])
    {
        self.delegate = delegate;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame: self.view.frame];
    imageView.image = [UIImage imageNamed: @"Splash"];
    [self.view addSubview: imageView];
    
    UILabel *versionLabel = [[UILabel alloc] initWithFrame: CGRectZero];
    versionLabel.text = [[NSBundle mainBundle] objectForInfoDictionaryKey: (NSString*)kCFBundleVersionKey];
    [versionLabel sizeToFit];
    CGRect labelRect = versionLabel.frame;
    labelRect.origin.x = (self.view.frame.size.width - labelRect.size.width) / 2;
    labelRect.origin.y = self.view.frame.size.height - labelRect.size.height - 40;
    [versionLabel setFrame: labelRect];
    [self.view addSubview: versionLabel];
    
    [self performSelector: @selector(closeSelf) withObject: nil afterDelay: 3.0f];
}

- (void) closeSelf
{
    [self dismissViewControllerAnimated: NO completion: ^
    {
        if (_delegate && [_delegate respondsToSelector: @selector(splashViewDidHiden)])
        {
            [_delegate splashViewDidHiden];
        }
    }];
}

@end
