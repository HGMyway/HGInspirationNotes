//
//  HGSignin.m
//  HGInspirationNotes
//
//  Created by 小雨很美 on 2017/12/17.
//  Copyright © 2017年 小雨很美. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HGSignin.h"
#import <YYModel/YYModel.h>

#import "AFAppDotNetAPIClient.h"

FOUNDATION_EXPORT NSString * const kLoginStatus;
 NSString * const kLoginStatus  = @"login_status";

FOUNDATION_EXPORT NSString * const kLoginUserDict;
NSString * const kLoginUserDict  = @"user_dict";

FOUNDATION_EXPORT NSString * const kLoginPreUserEmail;
NSString * const kLoginPreUserEmail  = @"pre_user_email";

FOUNDATION_EXPORT NSString * const kLoginPassword;
NSString * const kLoginPassword  = @"kLoginPassword";

FOUNDATION_EXPORT NSString * const kLoginDataListPath;
NSString * const kLoginDataListPath  = @"login_data_list_path.plist";


FOUNDATION_EXPORT NSString * const kTradeHOST;
NSString * const kTradeHOST  = @"kTradeHOST";

FOUNDATION_EXPORT NSString * const kMangerHOST;
NSString * const kMangerHOST  = @"kMangerHOST";

static HGUser *curLoginUser;

@implementation HGSignin


- (NSDictionary *)toParam{
	return @{
			@"appid":@"appmanagebackend",
			@"device" : @{
						@"devType": @"iPhone",
						@"deviceID": @"F203B262-6002-4441-928D-1C55A40B2C2E",
						@"deviceInfo" : @"MacBook Pro",
						@"manufacturer": @"Apple",
						@"osType" : @"ios",
						@"osVersion": @"11.0"},
			@"username": self.userName,
			@"password": self.passWord,
			@"lastversion":@"4.0.0",
			};
}
+ (BOOL)isLogin{
	NSNumber *loginStatus = [[NSUserDefaults standardUserDefaults] objectForKey:kLoginStatus];
	if (loginStatus.boolValue && [self curLoginUser]) {
		HGUser *loginUser = [self curLoginUser];
		if (loginUser.staffId.integerValue == 0) {
			return NO;
		}
		return YES;
	}else{
		return NO;
	}
}

+ (void)doLogin:(NSDictionary *)loginData{
	if (loginData) {
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		[defaults setObject:[NSNumber numberWithBool:YES] forKey:kLoginStatus];

		NSData *data = [NSKeyedArchiver archivedDataWithRootObject:loginData];
		[defaults setObject:data forKey:kLoginUserDict];

		curLoginUser = [HGUser yy_modelWithDictionary:loginData];
		[defaults synchronize];
//		[Login setXGAccountWithCurUser];

//		[self saveLoginData:loginData];
	}else{
		[self doLogout];
	}
}
+ (void)doLogout{
	[UIApplication sharedApplication].applicationIconBadgeNumber = 0;
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:[NSNumber numberWithBool:NO] forKey:kLoginStatus];
	[defaults synchronize];
		//删掉 coding 的 cookie
	NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
	[cookies enumerateObjectsUsingBlock:^(NSHTTPCookie *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
		if ([obj.domain hasSuffix:@".coding.net"]) {
			[[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:obj];
		}
	}];
//	[Login setXGAccountWithCurUser];
}
//+ (BOOL)saveLoginData:(NSDictionary *)loginData{
//
//}


+ (void)setPreUserEmail:(NSString *)emailStr{
	if (emailStr.length <= 0) {
		return;
	}
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:emailStr forKey:kLoginPreUserEmail];
	[defaults synchronize];
}

+ (NSString *)preUserEmail{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	return [defaults objectForKey:kLoginPreUserEmail];
}
+ (void)setPassWord:(NSString *)passWord{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	if (passWord.length <= 0) {
		[defaults removeObjectForKey:kLoginPassword];
	}else{
		[defaults setObject:passWord forKey:kLoginPassword];
	}
	[defaults synchronize];
}
+ (NSString *)passWord{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	return [defaults objectForKey:kLoginPassword];
}
+ (void)setTradeHOST:(NSString *)tradeHOST{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	if (tradeHOST.length <= 0) {
		[defaults removeObjectForKey:kTradeHOST];
	}else{
		[defaults setObject:tradeHOST forKey:kTradeHOST];
	}
	[defaults synchronize];
}
+ (NSString *)tradeHOST{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	return [defaults objectForKey:kTradeHOST];
}
+ (void)setMangerHOST:(NSString *)mangerHOST{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	if (mangerHOST.length <= 0) {
		[defaults removeObjectForKey:kMangerHOST];
	}else{
		[defaults setObject:mangerHOST forKey:kMangerHOST];
	}
	[defaults synchronize];
}
+ (NSString *)mangerHOST{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	return [defaults objectForKey:kMangerHOST];
}
+ (HGUser *)curLoginUser{
	if (!curLoginUser) {
		NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:kLoginUserDict];
		NSDictionary *loginData = [NSKeyedUnarchiver unarchiveObjectWithData:data];
		curLoginUser = loginData?[HGUser yy_modelWithDictionary:loginData]: nil;
	}
	return curLoginUser;
}
@end
