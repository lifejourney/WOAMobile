//
//  WOARequestContent.h
//  WOAMobile
//
//  Created by steven.zhuang on 6/5/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WOAPacketHelper.h"


@interface WOARequestContent : NSObject

@property (nonatomic, assign) WOAFLowActionType flowActionType;
@property (nonatomic, strong) NSDictionary *bodyDictionary;

+ (WOARequestContent*) contentForLogin: (NSString*)accountID
                              password: (NSString*)password
                           deviceToken: (NSString*)deviceToken;
+ (WOARequestContent*) contentForLogout;
+ (WOARequestContent*) contentForWorkflowTypeList;
+ (WOARequestContent*) contentForWorkflowTypeDetail: (NSString*)tableID;
+ (WOARequestContent*) contentForUploadAttachment: (NSString*)workID
                                          tableID: (NSString*)tableID
                                           itemID: (NSString*)itemID
                                         filePath: (NSString*)filePath;
+ (WOARequestContent*) contentForInitiateWorkflow: (NSString*)workID
                                          tableID: (NSString*)tableID
                                        tableName: (NSString*)tableName
                                       itemsArray: (NSArray*)itemsArray;
+ (WOARequestContent*) contentForSelectNextStep: (NSString*)workID
                                      processID: (NSString*)processID;
+ (WOARequestContent*) contentForSelectNextReviewer: (NSString*)workID
                                       accountArray: (NSArray*)accountArray;
+ (WOARequestContent*) contentForTodoWorkflowList;

+ (WOARequestContent*) contentForWorkflowFormDetail: (NSString*)itemID;
+ (WOARequestContent*) contentForReviewWorkflow: (NSString*)workID
                                     itemsArray: (NSArray*)itemsArray;
+ (WOARequestContent*) contentForHistoryWorkflowList;
+ (WOARequestContent*) contentForWorkflowViewDetail: (NSString*)itemID;
+ (WOARequestContent*) contentForDraftWorkflowList;
@end
