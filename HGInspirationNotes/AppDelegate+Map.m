//
//  AppDelegate+Map.m
//  HGInspirationNotes
//
//  Created by 小雨很美 on 2018/1/7.
//  Copyright © 2018年 小雨很美. All rights reserved.
//

#import "AppDelegate+Map.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <objc/runtime.h>
BMKMapManager* _mapManager;
NSString * const baidu_AK  = @"SH6AwPLXdORCaCuwniLB0nalRWNGjGpF";
@interface AppDelegate()<BMKGeneralDelegate>

@end

@implementation AppDelegate (Map)
- (void)setBaiduMap{
	// 要使用百度地图，请先启动BaiduMapManager
	_mapManager = [[BMKMapManager alloc] init];
	/**
	 *百度地图SDK所有接口均支持百度坐标（BD09）和国测局坐标（GCJ02），用此方法设置您使用的坐标类型.
	 *默认是BD09（BMK_COORDTYPE_BD09LL）坐标.
	 *如果需要使用GCJ02坐标，需要设置CoordinateType为：BMK_COORDTYPE_COMMON.
	 */
	if ([BMKMapManager setCoordinateTypeUsedInBaiduMapSDK:BMK_COORDTYPE_BD09LL]) {
		NSLog(@"经纬度类型设置成功");
	}else{
		NSLog(@"经纬度类型设置失败");
	}
	BOOL ret = [_mapManager start:baidu_AK generalDelegate:self];
	if (!ret) {
		NSLog(@"manager start failed!");
	}
}
- (void)onGetNetworkState:(int)iError{
	if (0 == iError) {
		NSLog(@"联网成功");
	}
	else{
		NSLog(@"onGetNetworkState %d",iError);
	}
}
- (void)onGetPermissionState:(int)iError
{
	if (0 == iError) {
		NSLog(@"授权成功");
	}
	else {
		NSLog(@"onGetPermissionState %d",iError);
	}
}
@end
