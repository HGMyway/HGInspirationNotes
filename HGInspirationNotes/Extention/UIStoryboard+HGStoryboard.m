//
//  UIStoryboard+HGStoryboard.m
//  HGInspirationNotes
//
//  Created by 小雨很美 on 2017/12/17.
//  Copyright © 2017年 小雨很美. All rights reserved.
//

#import "UIStoryboard+HGStoryboard.h"

@implementation UIStoryboard (HGStoryboard)

+ (UITabBarController *)mainTabbar{
	return [self hg_instantiateViewControllerWithIdentifier:@"mainTabbar"];
}
+ (UINavigationController *)loginNavigation{
	return  [self hg_instantiateViewControllerWithIdentifier:@"loginNav"];
}

+ (__kindof UIViewController *)hg_instantiateViewControllerWithIdentifier:(NSString *)identifier{
	return [self hg_instantiateViewControllerWithIdentifier:identifier andStoryboardWithName:@"Main"];
}
+ (__kindof UIViewController *)hg_instantiateViewControllerWithIdentifier:(NSString *)identifier andStoryboardWithName:(NSString *)sbName{
	return  [[UIStoryboard storyboardWithName:sbName bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:identifier];
}
@end
