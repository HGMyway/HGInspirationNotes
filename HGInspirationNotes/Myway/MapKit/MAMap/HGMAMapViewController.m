	//
	//  HGMAMapViewController.m
	//  HGInspirationNotes
	//
	//  Created by 小雨很美 on 2018/1/8.
	//  Copyright © 2018年 小雨很美. All rights reserved.
	//

#import "HGMAMapViewController.h"
#import <MAMapKit/MAMapKit.h>
#import "HGFileManager.h"
#import <AMapLocationKit/AMapLocationKit.h>

#import "UIStoryboard+HGStoryboard.h"

#import "HGFileManager.h"
#import "HGMATools.h"
@interface HGMAMapViewController ()<MAMapViewDelegate,AMapLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet MAMapView *MAMapView;
@property (nonatomic,strong) AMapLocationManager *locationManager;

//@property (nonatomic,strong) AMapGeoFenceManager *geoFenceManager;
@end

@implementation HGMAMapViewController
{
	CLLocation *_lastUserLocation;
	CLLocationDistance _stepDistance;
	
	NSArray *_speedColors;

	NSString *_currentFileName;
}
+ (instancetype)shard{
	static HGMAMapViewController *_shareMAMapVC;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		_shareMAMapVC = [UIStoryboard hg_instantiateViewControllerWithIdentifier:@"HGMAMapViewController"];
	});
	return _shareMAMapVC;
}


- (void)viewDidLoad {
	[super viewDidLoad];
	_stepDistance = 2;
	_currentFileName = @"file1";

	[self addFullPathOverlay];
	[self customUserPoint];
	[self configMAMap];
	[self configMALocationManager];
}
- (void)configMALocationManager{

	self.locationManager = [[AMapLocationManager alloc] init];
	self.locationManager.delegate = self;
	self.locationManager.distanceFilter = 2;
	self.locationManager.allowsBackgroundLocationUpdates = YES;
	[self.locationManager startUpdatingLocation];
	[self.locationManager startUpdatingHeading];
	
}
- (void)configMAMap{
	self.MAMapView.delegate = self;
	self.MAMapView.pausesLocationUpdatesAutomatically = NO;
	self.MAMapView.customizeUserLocationAccuracyCircleRepresentation = YES;
	self.MAMapView.showsUserLocation = YES;
	self.MAMapView.userTrackingMode = MAUserTrackingModeFollowWithHeading;
	self.MAMapView.userLocation.title = @"我的位置";
}
- (void)customUserPoint{

	MAUserLocationRepresentation *represent = [[MAUserLocationRepresentation alloc] init];
	represent.showsAccuracyRing = NO;
	represent.showsHeadingIndicator = NO;
	represent.image = [UIImage imageNamed:@"Map/userPosition"];
	[self.MAMapView updateUserLocationRepresentation:represent];
}
- (void)viewDidAppear:(BOOL)animated{
	[super viewDidAppear:animated];
	
		//	[self.MAMapView addOverlay:_polyline];
		//
		//	const CGFloat screenEdgeInset = 20;
		//
		//	UIEdgeInsets inset = UIEdgeInsetsMake(screenEdgeInset, screenEdgeInset, screenEdgeInset, screenEdgeInset);
		//	[self.MAMapView setVisibleMapRect:_polyline.boundingMapRect edgePadding:inset animated:NO];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
		// Dispose of any resources that can be recreated.
}

#pragma mark - action

- (IBAction)runOrStopButtonAction:(UIButton *)sender {
	sender.selected = !sender.isSelected;
}


#pragma mark - MAMapViewDelegate
//- (void)mapViewDidFinishLoadingMap:(MAMapView *)mapView{
//	[self addFullPathOverlay];
//}
/**
 * @brief 根据overlay生成对应的Renderer
 * @param mapView 地图View
 * @param overlay 指定的overlay
 * @return 生成的覆盖物Renderer
 */
- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id<MAOverlay>)overlay{
	if ([overlay isKindOfClass:[MAMultiPolyline class]]){
		MAMultiColoredPolylineRenderer * polylineRenderer = [[MAMultiColoredPolylineRenderer alloc] initWithMultiPolyline:overlay];
		
		polylineRenderer.lineWidth = 8.f;
//		polylineRenderer.strokeColor =  [UIColor greenColor];
		polylineRenderer.strokeColors = _speedColors;
		polylineRenderer.gradient = YES;
		
		return polylineRenderer;
	}
	
	return nil;
}




- (void)addPathWithArray:(NSArray *)pointArray{
	__weak typeof(self) weakSelf = self;
	[HGMATools addPathWithArray:pointArray block:^(MAMultiPolyline *polyLine, NSArray *speedColors) {
		[weakSelf addOverlay:polyLine speedColors:speedColors];
	}];
}
- (void)addFullPathOverlay{
	__weak typeof(self) weakSelf = self;
	[HGMATools addFullPathOverlay:_currentFileName block:^(MAMultiPolyline *polyLine, NSArray *speedColors) {
		[weakSelf addOverlay:polyLine speedColors:speedColors];
	}];

}
- (void)addOverlay:(MAMultiPolyline *)polyline speedColors:(NSArray *)speedColors{
	_speedColors = speedColors;
	[self.MAMapView addOverlay:polyline];
}





#pragma mark - AMapLocationManagerDelegate

/**
 *  @brief 当定位发生错误时，会调用代理的此方法。
 *  @param manager 定位 AMapLocationManager 类。
 *  @param error 返回的错误，参考 CLError 。
 */
- (void)amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error{
	
}


/**
 *  @brief 定位权限状态改变时回调函数
 *  @param manager 定位 AMapLocationManager 类。
 *  @param status 定位权限状态。
 */
- (void)amapLocationManager:(AMapLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{

}

/**
 *  @brief 连续定位回调函数.注意：如果实现了本方法，则定位信息不会通过amapLocationManager:didUpdateLocation:方法回调。
 *  @param manager 定位 AMapLocationManager 类。
 *  @param location 定位结果。
 *  @param reGeocode 逆地理信息。
 */
- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode{

	CLLocationDistance distance = [location distanceFromLocation:_lastUserLocation];
	if (_lastUserLocation == nil) {
		_lastUserLocation = [location copy];
	}
	if (distance > _stepDistance || distance == -1) {
		[HGMATools saveCurrentLocation:location fileName:_currentFileName];
		[self addPathWithArray:@[[HGMATools makeCurrentLocationDict:_lastUserLocation],[HGMATools makeCurrentLocationDict:location]]];
		self.MAMapView.centerCoordinate = location.coordinate;
		_lastUserLocation = [location copy];
	}
}


/**
 *  @brief 设备方向改变时回调函数
 *  @param manager 定位 AMapLocationManager 类。
 *  @param newHeading 设备朝向。
 */
- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading{
	MAAnnotationView *userLocationView = [self.MAMapView viewForAnnotation:self.MAMapView.userLocation];
	[UIView animateWithDuration:0.1 animations:^{
		double degree = newHeading.trueHeading - self.MAMapView.rotationDegree;
		userLocationView.imageView.transform = CGAffineTransformMakeRotation(degree * M_PI / 180.f );
	}];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
