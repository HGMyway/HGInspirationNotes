//
//  HGGesturePathLayer.m
//  HGInspirationNotes
//
//  Created by 小雨很美 on 2018/1/16.
//  Copyright © 2018年 小雨很美. All rights reserved.
//

#import "HGGesturePathLayer.h"
#import "HGGestureConfig.h"

@implementation HGGesturePathLayer
{
	NSMutableArray <NSString *>*_pathPoints;
	CGPoint _tailPoint ;
}
- (instancetype)init{
	self = [super init];
	_pathPoints = [NSMutableArray array];
	return self;
}
- (void)resetPath{
	if (_pathPoints.count) {
		[_pathPoints removeAllObjects];
		[self setNeedsDisplay];
	}
}
- (void)addPoint:(CGPoint)point{
	[_pathPoints addObject:NSStringFromCGPoint(point)];
	_tailPoint = point;
	[self setNeedsDisplay];
}
- (void)moveTailPoint:(CGPoint)point{
	_tailPoint = point;
	[self setNeedsDisplay];
}
- (void)overByRemoveTail:(BOOL)remove{
	if (_pathPoints.count  && remove) {
		_tailPoint = CGPointFromString(_pathPoints.lastObject);
		[self setNeedsDisplay];
	}
}
- (void)drawInContext:(CGContextRef)ctx{
	if(_pathPoints.count<=0){
		return;
	}
	[_pathPoints enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
		CGContextSetLineWidth(ctx, HGPathWidth);
		CGContextSetLineJoin(ctx, kCGLineJoinRound);

		CGFloat *ColorComponents =(CGFloat *)CGColorGetComponents([HGPasswordLineColor CGColor]);
		CGContextSetRGBStrokeColor (ctx, ColorComponents[0], ColorComponents[1], ColorComponents[2], ColorComponents[3]);
		CGPoint point = CGPointFromString(obj);
		if (idx == 0) {
			CGContextMoveToPoint(ctx, point.x, point.y);
		}else{
			CGContextAddLineToPoint(ctx, point.x, point.y);
		}
	}];
	CGContextAddLineToPoint(ctx, _tailPoint.x, _tailPoint.y);
	CGContextDrawPath(ctx, kCGPathStroke);
}
@end
