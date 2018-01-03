//
//  NetworkBase.m
//  HGInspirationNotes
//
//  Created by 小雨很美 on 2017/12/17.
//  Copyright © 2017年 小雨很美. All rights reserved.
//

#import "NetworkBase.h"

#import "HGSignin.h"


NSString * const SSOBaseURLString = @"https://testsso.wecaiwu.com/";
NSString * const TRADEBaseURLString = @"https://testtrade.wecaiwu.com/";


@implementation NetworkBase
- (AFNetworkReachabilityStatus)hg_networkStatus{
	return [[AFNetworkReachabilityManager sharedManager] networkReachabilityStatus];
}
- (void)setRemovesKeysWithNullValues:(BOOL)removesKeysWithNullValues{
	[[AFAppDotNetAPIClient sharedClient] setRemovesKeysWithNullValues:removesKeysWithNullValues];
}
- (NSString *)pieceURL:(NSString *)pathUrl baseURLType:(HGBaseURLType)baseURLType{
	NSString *baseURL = ( {
		NSString *baseURL;
		switch (baseURLType) {
			case SSOHOME:
				baseURL = SSOBaseURLString;
				break;
			case TRADEHOME:
				baseURL = TRADEBaseURLString;
			case MANAGEHOST:
				baseURL = [HGSignin mangerHOST];
				break;
			case TRADEHOST:
				baseURL = [HGSignin tradeHOST];
				break;
			default:
				break;
		}
		baseURL;
	});
	if (baseURL == nil ) {
		assert("bassurl");
	}
	
	NSURL *url = [NSURL URLWithString:pathUrl relativeToURL:[NSURL URLWithString:baseURL]];
	return url.absoluteString;
}
- (NSURLSessionDataTask *)af_request_af:(NSString *)url baseURLType:(HGBaseURLType)baseURLType networkType:(HGNetworkType)networkType params:(NSDictionary *)params callback:(Net_callback)callback{

	AFAppDotNetAPIClient *manager = [AFAppDotNetAPIClient sharedClient];
	url = [self pieceURL:url baseURLType:baseURLType];

	if (networkType == GET) {
		return [manager GET:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
			callback(nil,responseObject, task);
		} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
			callback(error,nil, task);
		}];
	}else if (networkType == POST){
		return [manager POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
			callback(nil,responseObject,task);
		} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
			callback(error,nil,task);
		}];
	}else if (networkType == PUT){
		return [manager PUT:url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
			callback(nil,responseObject, task);
		} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
			callback(error,nil, task);
		}];
	}else if (networkType == DELETE){
		return [manager DELETE:url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
			callback(nil,responseObject, task);
		} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
			callback(error,nil, task);
		}];
	}
	return nil;
}
- (NSURLSessionDataTask *)af_request_af:(NSString *)url baseURLType:(HGBaseURLType)baseURLType networkType:(HGNetworkType) networkType params:(NSDictionary *)params constructingBodyWithBlock:(void (^)(id<AFMultipartFormData>))block callback:(Net_callback)callback{
	url = [self pieceURL:url baseURLType:baseURLType];
	return [[AFAppDotNetAPIClient sharedClient] POST:url parameters:params constructingBodyWithBlock:block progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
		callback(nil,responseObject, task);
	} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
		callback(error,nil, task);
	}];
}
//[[ServiceAsst instance] collect_post_accept:dic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//
//	[formData appendPartWithFileData:self.headImageData name:@"userfile" fileName:@"userfile.jpg" mimeType:@"image/jpeg"];
//
//} callback:^int(NSDictionary *status, NSDictionary *data) {
//
//	if ([data objectForKey:@"code"]) {
//		[weakSelf hadSubmitedShow];
//		NSUserDefaults * useDef = [NSUserDefaults standardUserDefaults];
//
//		NSString * str = [NSString stringWithFormat:@"%@%@",APPLYKEY,[MineUserInfoModel loadUserInfo].uid];
//
//		[useDef setObject:[weakSelf getNowDate] forKey:str];
//		[useDef synchronize];
//	}
//	return 0;
//}];
@end
