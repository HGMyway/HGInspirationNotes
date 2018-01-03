//
//  AFAppDotNetAPIClient.m
//  HGInspirationNotes
//
//  Created by 小雨很美 on 2017/12/17.
//  Copyright © 2017年 小雨很美. All rights reserved.
//

#import "AFAppDotNetAPIClient.h"

//static NSString * const AFAppDotNetAPIBaseURLString = @"https://testsso.wecaiwu.com/";
//#define SSO_HOME_URL  @"https://testsso.wecaiwu.com/"
//#define  TRADE_HOME_URL @"https://testtrade.wecaiwu.com/"

static AFAppDotNetAPIClient *_sharedClient = nil;
@implementation AFAppDotNetAPIClient
/**
 问题：
 1、多线程保证单例安全
dispatch_once是线程安全的，它可以保证在多个线程同时调用的时候，dispatch_once只会执行一次，并且所有的线程在dispatch_once返回之前都会进入等待状态。
 2、ipv6适配   如使用NSURLSession和CFNetwork框架,并且使用域名链接,你不需要改变任何东西为您的应用程序使用IPv6地址。如果你的链接未使用域名,你现在应该使用它了https:developer.apple.com/library/ios/documentation/NetworkingInternetWeb/Conceptual/NetworkingOverview/CommonPitfalls/CommonPitfalls.html#//apple_ref/doc/uid/TP40010220-CH4-SW20

 只说了NSURLSession和CFNetwork的API不需要改变，但是并没有提及到NSURLConnection。 从上文的参考资料中，我们看到NSURLSession、NSURLConnection同属于Cocoa的url loading system，可以猜测出NSURLConnection在ios9上是支持IPV6的。

 应用里面的API网络请求，大家一般都会选择AFNetworking进行请求发送，由于历史原因，应用的代码基本上都深度引用了AFHTTPRequestOperation类，所以目前API网络请求均需要通过NSURLConnection发送出去，所以必须确认NSURLConnection是否支持IPV6. 经过测试，NSURLConnection在最新的iOS9系统上是支持IPV6的。


 IPv6比IPv4更加高效
 除了解决IPv4的耗尽问题,IPv6比IPv4更高效。例如,IPv6:
 避免了网络地址转换的需要（NAT）
 通过使用简化的头提供了更快的路由通过网络
 防止网络碎片
 避免广播邻居地址解析

 http:www.skyfox.org/ios-app-support-ipv6-dns64-nat64.html
https:www.jianshu.com/p/a6bab07c4062
 3、https适配
 http:www.jianshu.com/p/b03ae4a1a2d3
 http:www.jianshu.com/p/10e120f0cefc
 4、公共请求数据
 @return <#return value description#>
 */

+ (instancetype)sharedClient{

	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
//		_sharedClient = [[AFAppDotNetAPIClient alloc] initWithBaseURL:[NSURL URLWithString:[AFAppDotNetAPIClient baseURLString]]];
		_sharedClient = [[AFAppDotNetAPIClient alloc] init];
	});
	return _sharedClient;
}

- (instancetype)init{
	self = [super init];
	AFJSONResponseSerializer *serializer = [AFJSONResponseSerializer serializer];
	serializer.readingOptions = NSJSONReadingAllowFragments;
	serializer.removesKeysWithNullValues = YES;
	serializer = [AFJSONResponseSerializer serializer];
	serializer.acceptableStatusCodes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(200, 6000)];
	serializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain",@"image/jpeg",nil];
	self.responseSerializer = serializer;


	[self.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
//	[self.requestSerializer setValue:url.absoluteString forHTTPHeaderField:@"Referer"];

	self.securityPolicy  = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
		//	self.securityPolicy.allowInvalidCertificates = YES;
	return self;
}


	//+ (id)changeJsonClient{
	//	_sharedClient = [[AFAppDotNetAPIClient alloc] initWithBaseURL:[NSURL URLWithString:[AFAppDotNetAPIClient baseURLString]]];
	//	return _sharedClient;
	//}

//- (id)initWithBaseURL:(NSURL *)url {
//	self = [super initWithBaseURL:url];
//	if (!self) {
//		return nil;
//	}
//
//	AFJSONResponseSerializer *serializer = [AFJSONResponseSerializer serializer];
//	serializer.readingOptions = NSJSONReadingAllowFragments;
//	serializer.removesKeysWithNullValues = YES;
//	serializer = [AFJSONResponseSerializer serializer];
//	serializer.acceptableStatusCodes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(200, 6000)];
//	serializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain",@"image/jpeg",nil];
//	self.responseSerializer = serializer;
//
//
//	[self.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
//	[self.requestSerializer setValue:url.absoluteString forHTTPHeaderField:@"Referer"];
//
//	self.securityPolicy  = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
////	self.securityPolicy.allowInvalidCertificates = YES;
//
//	return self;
//}
//- (void)setRemovesKeysWithNullValues:(BOOL)removesKeysWithNullValues{
//	AFJSONResponseSerializer *serializer = (AFJSONResponseSerializer *)self.responseSerializer;
//	serializer.removesKeysWithNullValues = removesKeysWithNullValues;
//	self.responseSerializer = serializer;
//}
//
//+ (NSString *)baseURLString{
//	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//	return [defaults valueForKey:AFAppDotNetAPIBaseURLString] ?: AFAppDotNetAPIBaseURLString;
//}
//
//+ (void)changeBaseURLStrTo:(NSString *)baseURLStr{
//	if (baseURLStr.length <= 0) {
//		baseURLStr = AFAppDotNetAPIBaseURLString;
//	}
//
//	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//	[defaults setObject:baseURLStr forKey:AFAppDotNetAPIBaseURLString];
//	[defaults synchronize];
//
//	[AFAppDotNetAPIClient changeJsonClient];
//
//}
@end
