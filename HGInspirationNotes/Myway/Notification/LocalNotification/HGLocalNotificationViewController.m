//
//  HGLocalNotificationViewController.m
//  HGInspirationNotes
//
//  Created by 小雨很美 on 2018/1/4.
//  Copyright © 2018年 小雨很美. All rights reserved.
//

#import "HGLocalNotificationViewController.h"
#import <UserNotifications/UserNotifications.h>
@interface HGLocalNotificationViewController ()

@end

@implementation HGLocalNotificationViewController
{
	NSInteger _localNotificationIndex;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	_localNotificationIndex = 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)pushLocalNotification:(UIButton *)sender {
	[self pushOneNotification];
}

- (void)pushOneNotification{
		//Local Notification
	UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
	content.title = @"这岂是偶然";
	content.subtitle = @"不是的";
	content.body = @"哈哈哈";
	content.badge = @0;


UNTimeIntervalNotificationTrigger *trigger1 = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:5 repeats:NO];

//		//2 分钟后提醒
//	UNTimeIntervalNotificationTrigger *trigger1 = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:120 repeats:NO];
//
//		//每小时重复 1 次喊我喝水
//	UNTimeIntervalNotificationTrigger *trigger2 = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:3600 repeats:YES];
//
//		//每周一早上 8：00 提醒我给老婆做早饭
//	NSDateComponents *components = [[NSDateComponents alloc] init];
//	components.weekday = 2;
//	components.hour = 8;
//	UNCalendarNotificationTrigger *trigger3 = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:components repeats:YES];
//
//		//#import <CoreLocation/CoreLocation.h>
//		//一到麦当劳就喊我下车
//	CLRegion *region = [[CLRegion alloc] init];
//	UNLocationNotificationTrigger *trigger4 = [UNLocationNotificationTrigger triggerWithRegion:region repeats:NO];
	NSString *requestIdentifier = [NSString stringWithFormat:@"requestID%ld",(long)_localNotificationIndex];
	_localNotificationIndex++;
	UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:requestIdentifier
																		  content:content
																		  trigger:trigger1];

	UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
	[center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
		if (error) {
			NSLog(@"推送失败");
			NSLog(@"%@",error);
		}else{
			NSLog(@"推送成功");
		}

	}];



		//Remote Notification
//		{
//	"aps" : {
//		"alert" : {
//			"title" : "Introduction to Notifications",
//			"subtitle" : "Session 707",
//			"body" : "Woah! These new notifications look amazing! Don’t you agree?"
//		},
//		"badge" : 1
//	},
//		}

}

@end
