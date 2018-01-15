//
//  HGMATools.m
//  HGInspirationNotes
//
//  Created by 小雨很美 on 2018/1/10.
//  Copyright © 2018年 小雨很美. All rights reserved.
//

#import "HGMATools.h"

#import "HGFileManager.h"
@implementation HGMATools

+ (NSDictionary *)makeCurrentLocationDict:(CLLocation *)location{
	NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
	[mDict setValue:@(location.course) forKey:@"course"];
	[mDict setValue:@(location.speed) forKey:@"speed"];
	[mDict setValue:@(location.horizontalAccuracy) forKey:@"horizontalAccuracy"];
	[mDict setValue:@(location.coordinate.latitude) forKey:@"latitude"];
	[mDict setValue:@(location.coordinate.longitude) forKey:@"longtitude"];
	[mDict setValue:@(location.altitude) forKey:@"altitude"];
	[mDict setValue:location.timestamp.description forKey:@"timestamp"];
	return [mDict copy];
}

+ (void)saveCurrentLocation:(CLLocation *)location fileName:(NSString *)fileName{

	NSDictionary *dict = [self makeCurrentLocationDict:location];
	[[HGFileManager hg_fileManagerWithFileName:fileName]  inFilePath:^(NSString *filePath) {
		NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:filePath];
			//		[fileHandle seekToEndOfFile];  //将节点跳到文件的末尾
		unsigned long long fileLenth = [fileHandle seekToEndOfFile];

		[fileHandle seekToFileOffset:fileLenth - 1];
		if (fileLenth >2) {
			[fileHandle writeData:[@"," dataUsingEncoding:NSUTF8StringEncoding] ];
		}
		[fileHandle writeData:[NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil]];
		[fileHandle writeData:[@"]" dataUsingEncoding:NSUTF8StringEncoding] ];
		[fileHandle synchronizeFile];
		[fileHandle closeFile];
	}];
}

+ (UIColor *)getColorForSpeed:(float)speed
{
	const float lowSpeedTh = 2.f;
	const float highSpeedTh = 3.5f;
	const CGFloat warmHue = 0.02f; //偏暖色
	const CGFloat coldHue = 0.4f; //偏冷色

	float hue = coldHue - (speed - lowSpeedTh)*(coldHue - warmHue)/(highSpeedTh - lowSpeedTh);
	return [UIColor colorWithHue:hue saturation:1.f brightness:1.f alpha:1.f];
}

+ (void)addFullPathOverlay:(NSString *)fileName block:(void(^)(MAMultiPolyline *polyLine, NSArray *speedColors))block{
	block = [block copy];
	[[HGFileManager hg_fileManagerWithFileName:fileName] inFilePath:^(NSString *filePath) {
		NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingAtPath:filePath];
		NSData *jsdata = [fileHandle readDataToEndOfFile];
		[fileHandle closeFile];
		NSArray *dataArray = [NSJSONSerialization JSONObjectWithData:jsdata options:NSJSONReadingAllowFragments error:nil];
		[self addPathWithArray:dataArray block:block];
	}];
}

+ (void)addPathWithArray:(NSArray *)pointArray block:(void(^)(MAMultiPolyline *polyLine, NSArray *speedColors))block{
	block = [block copy];
	NSMutableArray *indexes = [NSMutableArray array];
	NSMutableArray *speedColors = [NSMutableArray array];
	if (pointArray){
		NSInteger count = pointArray.count;
		CLLocationCoordinate2D *  runningCoords = (CLLocationCoordinate2D *)malloc(count * sizeof(CLLocationCoordinate2D));
		for (int i = 0; i < count; i++){
			@autoreleasepool{
				NSDictionary * data = pointArray[i];
				runningCoords[i].latitude = [data[@"latitude"] doubleValue];
				runningCoords[i].longitude = [data[@"longtitude"] doubleValue];

				UIColor * speedColor = [HGMATools getColorForSpeed:[data[@"speed"] floatValue]];
				[speedColors addObject:speedColor];
				[indexes addObject:@(i)];
			}
		}
		block([MAMultiPolyline polylineWithCoordinates:runningCoords count:count drawStyleIndexes:indexes],[speedColors copy]);
		free(runningCoords);
	}else{
		block(nil,nil);
	}

}
@end
