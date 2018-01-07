//
//  AppDelegate+Notification.h
//  HGInspirationNotes
//
//  Created by 小雨很美 on 2018/1/4.
//  Copyright © 2018年 小雨很美. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (Notification)
- (void)setGPush:(NSDictionary *)launchOptions;

- (void)userNotification;
@end
