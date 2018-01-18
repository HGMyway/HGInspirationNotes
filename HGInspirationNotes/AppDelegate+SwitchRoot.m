//
//  AppDelegate+SwitchRoot.m
//  HGInspirationNotes
//
//  Created by 小雨很美 on 2017/12/17.
//  Copyright © 2017年 小雨很美. All rights reserved.
//

#import "AppDelegate+SwitchRoot.h"
#import "UIStoryboard+HGStoryboard.h"
@implementation AppDelegate (SwitchRoot)
+ (instancetype)defaultDelegate{
	AppDelegate *defaultDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
	return defaultDelegate;
}
- (void)switchToTabBarViewController{
	[UIView transitionWithView:self.window duration:1.0 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
		self.window.rootViewController = [UIStoryboard mainTabbar];
	} completion:nil];
}
- (void)switchToLoginViewController{
	[UIView transitionWithView:self.window duration:1.0 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
		self.window.rootViewController = [UIStoryboard loginNavigation];
	} completion:nil];
}



@end
