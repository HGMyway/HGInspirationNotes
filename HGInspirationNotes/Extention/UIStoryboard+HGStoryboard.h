//
//  UIStoryboard+HGStoryboard.h
//  HGInspirationNotes
//
//  Created by 小雨很美 on 2017/12/17.
//  Copyright © 2017年 小雨很美. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIStoryboard (HGStoryboard)
+ (UITabBarController *)mainTabbar;
+ (UINavigationController *)loginNavigation;

+ (__kindof UIViewController *)hg_instantiateViewControllerWithIdentifier:(NSString *)identifier;
+ (__kindof UIViewController *)hg_instantiateViewControllerWithIdentifier:(NSString *)identifier andStoryboardWithName:(NSString *)sbName;
@end
