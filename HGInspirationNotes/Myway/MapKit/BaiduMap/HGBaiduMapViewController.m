//
//  HGBaiduMapViewController.m
//  HGInspirationNotes
//
//  Created by 小雨很美 on 2018/1/7.
//  Copyright © 2018年 小雨很美. All rights reserved.
//

#import "HGBaiduMapViewController.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
@interface HGBaiduMapViewController ()<BMKMapViewDelegate>
@property (weak, nonatomic) IBOutlet BMKMapView *baiduMapView;

@end

@implementation HGBaiduMapViewController
{
	BOOL enableCustomMap;
}
+ (void)initialize {
		//设置自定义地图样式，会影响所有地图实例
		//注：必须在BMKMapView对象初始化之前调用
	NSString* path = [[NSBundle mainBundle] pathForResource:@"custom_config_清新蓝" ofType:@""];
	[BMKMapView customMapStyle:path];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

	enableCustomMap = NO;
}

-(void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[_baiduMapView viewWillAppear];
	_baiduMapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
	[BMKMapView enableCustomMapStyle:enableCustomMap];
}

-(void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[BMKMapView enableCustomMapStyle:NO];//关闭个性化地图
	[_baiduMapView viewWillDisappear];
	_baiduMapView.delegate = nil; // 不用时，置nil
}
- (void)dealloc {
	if (_baiduMapView) {
		_baiduMapView = nil;
	}
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - action

- (IBAction)changeMapStyleAction:(UISegmentedControl *)sender {
	/*
	 *注：必须在BMKMapView对象初始化之前设置自定义地图样式，设置后会影响所有地图实例
	 *设置方法：+ (void)customMapStyle:(NSString*) customMapStyleJsonFilePath;
	 */
	enableCustomMap = sender.selectedSegmentIndex == 1;
		//打开/关闭个性化地图
	[BMKMapView enableCustomMapStyle:enableCustomMap];
}
- (IBAction)changeMapTypeAction:(UISegmentedControl *)sender {
	NSInteger index = sender.selectedSegmentIndex;
	switch (index) {
		case 0:
			_baiduMapView.mapType = BMKMapTypeStandard;
			break;
		case 1:
			_baiduMapView.mapType = BMKMapTypeSatellite;
			break;
		default:
			break;
	}
}
- (IBAction)setSwitchValueChanged:(UISwitch *)sender {
	BOOL isOn = sender.isOn;
	switch (sender.tag) {
		case 0:
			[_baiduMapView setTrafficEnabled:isOn];
			break;

		case 1:
			[_baiduMapView setBuildingsEnabled:isOn];
			break;

		case 2:
			[_baiduMapView setBaiduHeatMapEnabled:isOn];
			break;

		case 3:
			[_baiduMapView setShowMapPoi:isOn];
			break;

		default:
			break;
	}
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
