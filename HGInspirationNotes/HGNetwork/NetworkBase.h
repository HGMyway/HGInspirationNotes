//
//  NetworkBase.h
//  HGInspirationNotes
//
//  Created by 小雨很美 on 2017/12/17.
//  Copyright © 2017年 小雨很美. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "AFAppDotNetAPIClient.h"
#import "AFNetworkReachabilityManager.h"

FOUNDATION_EXPORT NSString * const SSOBaseURLString;
FOUNDATION_EXPORT NSString * const TRADEBaseURLString;


typedef NS_ENUM(NSInteger, HGBaseURLType) {
	SSOHOME          =  0 ,
	TRADEHOME         ,
	MANAGEHOST  ,
	TRADEHOST,
};


typedef NS_ENUM(NSInteger, HGNetworkType) {
	GET          =  0 ,
	POST  ,
	PUT,
	DELETE,
};

typedef void (^Net_callback)(NSError *error , NSDictionary *data, NSURLSessionDataTask *dataTask);

@interface NetworkBase : NSObject

@property (nonatomic) BOOL removesKeysWithNullValues;

- (AFNetworkReachabilityStatus)hg_networkStatus;
-(NSURLSessionDataTask *) af_request_af:(NSString *)url baseURLType:(HGBaseURLType)baseURLType networkType:(HGNetworkType) networkType params:(NSDictionary *)params callback:(Net_callback) callback;
-(NSURLSessionDataTask *) af_request_af:(NSString *)url baseURLType:(HGBaseURLType)baseURLType networkType:(HGNetworkType) networkType params:(NSDictionary *)params constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block callback:(Net_callback)callback;

@end
