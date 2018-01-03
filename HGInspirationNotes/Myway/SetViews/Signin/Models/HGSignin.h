//
//  HGSignin.h
//  HGInspirationNotes
//
//  Created by 小雨很美 on 2017/12/17.
//  Copyright © 2017年 小雨很美. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HGUser.h"
@interface HGSignin : NSObject
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *passWord;

@property (class, nonatomic, copy) NSString *mangerHOST;
@property (class, nonatomic, copy) NSString *tradeHOST;

@property (class, nonatomic, copy) NSString *passWord;


- (NSDictionary *)toParam;
+ (HGUser *)curLoginUser;

+ (NSString *)preUserEmail;
+ (void)setPreUserEmail:(NSString *)emailStr;

+ (BOOL) isLogin;
+ (void)doLogin:(NSDictionary *)loginData;
+ (void)doLogout;

@end
