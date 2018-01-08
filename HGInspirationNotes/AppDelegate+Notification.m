//
//  AppDelegate+Notification.m
//  HGInspirationNotes
//
//  Created by 小雨很美 on 2018/1/4.
//  Copyright © 2018年 小雨很美. All rights reserved.
//

#import "AppDelegate+Notification.h"
#import <UserNotifications/UserNotifications.h>
#import <UserNotifications/UNUserNotificationCenter.h>

#import <XGPush.h>
@interface AppDelegate ()<UNUserNotificationCenterDelegate, UIApplicationDelegate,XGPushDelegate>

@end
@implementation AppDelegate (Notification)
#pragma mark -
- (void)setGPush:(NSDictionary *)launchOptions{
		//打开debug开关
	[[XGPush defaultManager] setEnableDebug:NO];

	[[XGPush defaultManager] startXGWithAppID:2200274594 appKey:@"I64RTHL33I9L" delegate:self];
	[[XGPush defaultManager] reportXGNotificationInfo:launchOptions];
}
- (void)userNotification{
		//iOS 10
	UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
	center.delegate = self;
	[center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
		if (!error) {
			NSLog(@"request authorization succeeded!");
		}
	}];
}

#pragma mark - UNUserNotificationCenterDelegate
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
	 completionHandler(UNNotificationPresentationOptionAlert | UNNotificationPresentationOptionSound);
}
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler{
	completionHandler();
}
#pragma mark - UIApplicationDelegate



- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
	NSLog(@"%@", [NSString stringWithFormat:@"Device Token: %@", deviceToken]);
	[[XGPushTokenManager defaultTokenManager] registerDeviceToken:deviceToken];// 此方法可以不需要调用，SDK已经在内部处理
	NSLog(@"%@",[XGPushTokenManager defaultTokenManager].deviceTokenString);

}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
	NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}


/**
 收到通知的回调

 @param application  UIApplication 实例
 @param userInfo 推送时指定的参数
 */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
	[[XGPush defaultManager] reportXGNotificationInfo:userInfo];
}


/**
 收到静默推送的回调

 @param application  UIApplication 实例
 @param userInfo 推送时指定的参数
 @param completionHandler 完成回调
 */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {

	[[XGPush defaultManager] reportXGNotificationInfo:userInfo];
	completionHandler(UIBackgroundFetchResultNewData);
}


#pragma mark - XGPushDelegate
	// iOS 10 新增 API
	// iOS 10 会走新 API, iOS 10 以前会走到老 API
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
	// App 用户点击通知的回调
	// 无论本地推送还是远程推送都会走这个回调
- (void)xgPushUserNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {
	[[XGPush defaultManager] reportXGNotificationInfo:response.notification.request.content.userInfo];

	completionHandler();
}

	// App 在前台弹通知需要调用这个接口
- (void)xgPushUserNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
	[[XGPush defaultManager] reportXGNotificationInfo:notification.request.content.userInfo];
	completionHandler(UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert);
}
#endif



/**
 @brief 监控信鸽推送服务地启动情况

 @param isSuccess 信鸽推送是否启动成功
 @param error 信鸽推送启动错误的信息
 */
- (void)xgPushDidFinishStart:(BOOL)isSuccess error:(nullable NSError *)error{
//	NSLog(@"信鸽推送是否启动成功");
}

/**
 @brief 监控信鸽服务的终止情况

 @param isSuccess 信鸽推送是否终止
 @param error 信鸽推动终止错误的信息
 */
- (void)xgPushDidFinishStop:(BOOL)isSuccess error:(nullable NSError *)error{
//	NSLog(@"信鸽推送是否终止");
}


/**
 @brief 监控信鸽服务上报推送消息的情况

 @param isSuccess 上报是否成功
 @param error 上报失败的信息
 */
- (void)xgPushDidReportNotification:(BOOL)isSuccess error:(nullable NSError *)error{
//	NSLog(@"上报是否成功");
}


@end
