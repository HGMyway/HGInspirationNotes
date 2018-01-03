//
//  AppDelegate+SwitchRoot.h
//  HGInspirationNotes
//
//  Created by 小雨很美 on 2017/12/17.
//  Copyright © 2017年 小雨很美. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (SwitchRoot)
+ (instancetype)defaultDelegate;
- (void)switchToTabBarViewController;
- (void)switchToLoginViewController;
@end
