//
//  WOAPropertyInfo.m
//  WOAMobile
//
//  Created by steven.zhuang on 5/31/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import "WOAPropertyInfo.h"


@implementation WOAPropertyInfo

+ (void) saveObject: (id)value key: (NSString*)key subKey: (NSString*)subKey
{
    if (key && [key length] > 0 && subKey && [subKey length] > 0)
    {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        
        NSDictionary *prevInfo = [userDefaults objectForKey: key];
        NSMutableDictionary *currentInfo = [NSMutableDictionary dictionaryWithDictionary: prevInfo];
        
        if (value)
        {
            [currentInfo setObject: value forKey: subKey];
        }
        else
        {
            [currentInfo removeObjectForKey: subKey];
        }
        
        [userDefaults setObject: currentInfo forKey: key];
        [userDefaults synchronize];
    }
}

+ (NSString*) stringValueFromKey: (NSString*)key subKey: (NSString*)subKey
{
    NSString *value = nil;
    
    if (key && [key length] > 0 && subKey && [subKey length] > 0)
    {
        NSDictionary *prevInfo = [[NSUserDefaults standardUserDefaults] objectForKey: key];
        
        if (prevInfo)
        {
            value = [prevInfo valueForKey: subKey];
        }
    }
    
    return value;
}

+ (NSString*) latestLoginAccountID
{
    return [self stringValueFromKey: @"latestAccount" subKey: @"accountID"];
}

+ (void) saveLatestLoginAccount: (NSString*)accountID
{
    [self saveObject: accountID key: @"latestAccount" subKey: @"accountID"];
}

@end
