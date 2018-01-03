//
//  NetworkAsst.h
//  HGInspirationNotes
//
//  Created by 小雨很美 on 2017/12/17.
//  Copyright © 2017年 小雨很美. All rights reserved.
//

#import "NetworkBase.h"
FOUNDATION_EXPORT NSString * const url_sso_login;
FOUNDATION_EXPORT NSString * const url_organization_alldepartments;


@class HGUserInfoDBModel;

typedef void (^departMents_callback)(NSError *error , NSArray <HGUserInfoDBModel *>*data, NSURLSessionDataTask *dataTask);

@interface NetworkAsst : NetworkBase
+(instancetype ) defaultNetwork;
- (NSURLSessionDataTask *)hg_signinParam:(NSDictionary *)param callback:(Net_callback)callBack;

- (NSURLSessionDataTask *)hg_alldepartmentsParam:(NSDictionary *)param callback:(departMents_callback)callBack;

@end
