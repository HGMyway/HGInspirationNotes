	//
	//  NetworkAsst.m
	//  HGInspirationNotes
	//
	//  Created by 小雨很美 on 2017/12/17.
	//  Copyright © 2017年 小雨很美. All rights reserved.
	//

#import "NetworkAsst.h"

#import <YYModel/YYModel.h>
#import "HGSignin.h"
#import "HGUserInfoDBModel.h"

NSString * const url_sso_login  = @"sso/login/";

NSString * const url_organization_alldepartments  = @"/organization/alldepartments/";

NSString * const CustomErrorDomain  = @"com.myway.error";

@implementation NetworkAsst
+(instancetype ) defaultNetwork
{
	NetworkAsst *asst = [[NetworkAsst alloc] init];
	asst.removesKeysWithNullValues = YES;
	return asst;
}
- (NSURLSessionDataTask *)hg_signinParam:(NSDictionary *)param callback:(Net_callback)callBack{
	self.removesKeysWithNullValues = NO;
	return [self af_request_af:url_sso_login baseURLType:SSOHOME networkType:POST params:param callback:^(NSError *error, NSDictionary *data,NSURLSessionDataTask *dataTask ) {

		if ([[data objectForKey:@"errorCode"] integerValue]) {
			NSMutableDictionary *errorUserInfo = [NSMutableDictionary dictionary];
			[errorUserInfo setValue:[data objectForKey:@"msg"] forKey:NSLocalizedDescriptionKey];
			[errorUserInfo setValue:data forKey:@"data"];
			error = [NSError errorWithDomain:CustomErrorDomain code:[[data objectForKey:@"errorCode"] integerValue] userInfo:errorUserInfo];
		}else{
			[HGSignin doLogin:data];
			[NetworkAsst  saveHTTP_HOST:dataTask];
		}
		if (callBack) {
			callBack(error, data, dataTask);

		}
	}];
}
+ (void)saveHTTP_HOST:(NSURLSessionDataTask *)task{
	NSHTTPURLResponse *currentResponse = (NSHTTPURLResponse *)task.response;
	NSString *HTTP_HOST = [[currentResponse allHeaderFields] objectForKey:@"HTTP_HOST"];
	NSString *bodyString = [[NSString alloc] initWithData:task.originalRequest.HTTPBody encoding:NSUTF8StringEncoding];

	if (HTTP_HOST && [bodyString  containsString:@"appmanagebackend"]){
		NSURLComponents *urlComponents = [[NSURLComponents alloc] init];
		urlComponents.scheme = task.originalRequest.URL.scheme;
		urlComponents.host = HTTP_HOST;
		[HGSignin setMangerHOST:urlComponents.URL.absoluteString];
	}
	else if (HTTP_HOST && [bodyString  containsString:@"tradebackend"]){
		NSURLComponents *urlComponents = [[NSURLComponents alloc] init];
		urlComponents.scheme = task.originalRequest.URL.scheme;
		urlComponents.host = HTTP_HOST;
		[HGSignin setTradeHOST:urlComponents.URL.absoluteString];
	}
}

- (NSURLSessionDataTask *)hg_alldepartmentsParam:(NSDictionary *)param callback:(departMents_callback)callBack
{
	return [self af_request_af:url_organization_alldepartments baseURLType:MANAGEHOST  networkType:GET params:param callback:^(NSError *error, NSDictionary *data,NSURLSessionDataTask *dataTask ) {

		NSArray <NSDictionary *>*dataArray = [data objectForKey:@"data"];
		if (dataArray) {
			NSMutableArray <HGUserInfoDBModel *>*modelsArray = [NSMutableArray array];
			[dataArray enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
				HGUserInfoDBModel *model = [HGUserInfoDBModel new];
				model.uid = [obj[@"id"] stringValue];
				model.uname = obj[@"name"];
				model.age = obj[@"lastupdate"];
				[modelsArray addObject:model];
			}];
			callBack(error,modelsArray,dataTask);
		}else{
			if (!error) {
				error = [NSError errorWithDomain:dataTask.currentRequest.URL.absoluteString
											code:-1
										userInfo:@{NSLocalizedDescriptionKey: @"haha"}];
			}
			if (callBack) {
				callBack(error,nil,dataTask);
			}
		}

	}];
}
@end
