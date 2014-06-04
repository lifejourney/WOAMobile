//
//  WOACheckForUpdate.m
//  WOAMobile
//
//  Created by steven.zhuang on 6/4/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import "WOACheckForUpdate.h"


#define kSelfAppleID @"827404068"

@interface WOACheckForUpdate ()

@property (nonatomic, assign) BOOL forceUpdate;

- (void) showAlertWithAppStoreVersion: (NSString*)currentAppStoreVersion;

@end


@implementation WOACheckForUpdate

#pragma mark UIAlertView delegate

- (void) alertView: (UIAlertView *)alertView clickedButtonAtIndex: (NSInteger)buttonIndex
{
    BOOL gotoAppStore = NO;
    
    if (self.forceUpdate)
    {
        gotoAppStore = YES;
    }
    else
    {
        if (buttonIndex == 1)
            gotoAppStore = YES;
    }
    
    if (gotoAppStore)
    {
        NSString *iTunesString = [NSString stringWithFormat: @"https://itunes.apple.com/app/id%@", kSelfAppleID];
        
        [[UIApplication sharedApplication] openURL: [NSURL URLWithString: iTunesString]];
        
    }
}

#pragma mark - Public

- (void) checkingUpdateFromAppStore: (BOOL)forceUpdate
{
    self.forceUpdate = forceUpdate;
    
    NSString *storeString = [NSString stringWithFormat: @"http://itunes.apple.com/lookup?id=%@", kSelfAppleID];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: storeString]];
    request.HTTPMethod = @"GET";
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest: request
                                       queue: queue
                           completionHandler: ^(NSURLResponse *response, NSData *data, NSError *error)
    {
        if ([data length] > 0 && !error)
        {
            NSDictionary *appData = [NSJSONSerialization JSONObjectWithData: data
                                                                    options: NSJSONReadingAllowFragments
                                                                      error: nil];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                NSArray *versionsInAppStore = [[appData valueForKey: @"results"] valueForKey: @"version"];
                
                if (versionsInAppStore && [versionsInAppStore count] > 0)
                {
                    NSString *currentAppStoreVersion = [versionsInAppStore firstObject];
                    NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey: (NSString*)kCFBundleVersionKey];
                    
                    if ([currentVersion compare: currentAppStoreVersion options: NSNumericSearch] == NSOrderedAscending)
                    {
                        [self showAlertWithAppStoreVersion: currentAppStoreVersion];
                    }
                }
            });
        }
    }];
}

#pragma mark - Private

- (void) showAlertWithAppStoreVersion: (NSString *)currentAppStoreVersion
{
    //NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey: (NSString*)kCFBundleNameKey];
    
    NSString *msgTitle = @"有可用更新";
    NSString *msgContent = [NSString stringWithFormat: @"最新版本: %@", currentAppStoreVersion];
    UIAlertView *alertView;
    
    if (self.forceUpdate)
    {
        alertView = [[UIAlertView alloc] initWithTitle: msgTitle
                                               message: msgContent
                                              delegate: self
                                     cancelButtonTitle: @"确定"
                                     otherButtonTitles: nil, nil];
    }
    else
    {
        alertView = [[UIAlertView alloc] initWithTitle: msgTitle
                                               message: msgContent
                                              delegate: self
                                     cancelButtonTitle: @"以后再说"
                                     otherButtonTitles: @"确定", nil];
    }
    
    [alertView show];
}

@end
