	//
	//  AppDelegate+Map.m
	//  HGInspirationNotes
	//
	//  Created by 小雨很美 on 2018/1/7.
	//  Copyright © 2018年 小雨很美. All rights reserved.
	//

#import "AppDelegate+Map.h"
#import <AMapFoundationKit/AMapFoundationKit.h>

NSString * const APIKey  = @"15f424c4f2f5977f4f7501b3570f2689";

@implementation AppDelegate (Map)
- (void)setMAMap
{
	if ([APIKey length] == 0){
		NSString *reason = [NSString stringWithFormat:@"apiKey为空，请检查key是否正确设置。"];
		NSLog(@"%@",reason);
	}
	[AMapServices sharedServices].apiKey = (NSString *)APIKey;
}
@end
