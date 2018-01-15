//
//  HGMATools.h
//  HGInspirationNotes
//
//  Created by 小雨很美 on 2018/1/10.
//  Copyright © 2018年 小雨很美. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MAMapKit/MAMapKit.h>
@interface HGMATools : NSObject
+ (void)saveCurrentLocation:(CLLocation *)location fileName:(NSString *)fileName;
+ (NSDictionary *)makeCurrentLocationDict:(CLLocation *)location;
+ (UIColor *)getColorForSpeed:(float)speed;
+ (void)addFullPathOverlay:(NSString *)fileName block:(void(^)(MAMultiPolyline *polyLine, NSArray *speedColors))block;
+ (void)addPathWithArray:(NSArray *)pointArray block:(void(^)(MAMultiPolyline *polyLine, NSArray *speedColors))block;
@end
