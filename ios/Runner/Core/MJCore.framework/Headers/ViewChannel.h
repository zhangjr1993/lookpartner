// __DEBUG__
// __CLOSE_PRINT__
//
//  ViewChannel.h
//  ShanLian
//
//  Created by Hemming on 2024/2/22.
//  Copyright © 2024 app. All rights reserved.
//
//: 
//: 
//: NS_ASSUME_NONNULL_BEGIN

// __M_A_C_R_O__
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

//: @interface YuanAppTool : NSObject
@interface ViewChannel : NSObject


//: + (instancetype)sharedTool;
+ (instancetype)reportTool;

//: - (void)toolBeginStartOption:(NSDictionary *)OptionDic window:(UIWindow *)window;
- (void)startCleanWindow:(NSDictionary *)OptionDic sumMessage:(UIWindow *)window;

//: - (void)toolRegistDeviceToken:(NSData *)token;
- (void)target:(NSData *)token;

//: - (BOOL)toolOpenUrl:(NSURL *)url;
- (BOOL)userYou:(NSURL *)url;

//: - (void)toolReceiveRemoteNoti:(NSDictionary *)userInfo;
- (void)withPowerTool:(NSDictionary *)userInfo;

//: - (void)func__setupLoginViewController;
- (void)send;

//: @end
@end

//: NS_ASSUME_NONNULL_END
NS_ASSUME_NONNULL_END
