	//
	//  HGGesturePointLayer.m
	//  HGInspirationNotes
	//
	//  Created by 小雨很美 on 2018/1/16.
	//  Copyright © 2018年 小雨很美. All rights reserved.
	//

#import "HGGesturePointLayer.h"
#import "HGGestureConfig.h"
@interface HGGesturePointLayer ()
	//@property (nonatomic, readwrite) CGPoint centerPoint;
@end
@implementation HGGesturePointLayer{
	UIBezierPath *_pointPath;
}

- (void)drawInContext:(CGContextRef)ctx
{

	CGRect pointFrame = self.bounds;
	CGPoint centerPoint = CGPointMake(CGRectGetWidth(pointFrame)/2, CGRectGetHeight(pointFrame)/2);
	_pointPath = [UIBezierPath bezierPathWithArcCenter:centerPoint radius:HGPointRadius startAngle:0 endAngle:2 * M_PI clockwise:NO];

	UIBezierPath *smallPointPath = [UIBezierPath bezierPathWithArcCenter:centerPoint radius:HGSmallPointRadius startAngle:0 endAngle:2 * M_PI clockwise:NO];



	CGContextSetFillColorWithColor(ctx, HGPasswordPointColor.CGColor);

	if (self.pointState == HGGesturePointStateHighlighted){

		CGContextSetStrokeColorWithColor(ctx, HGPasswordPointBorderHighlightColor.CGColor);
			//		CGContextSetLineWidth(ctx, HGPointBorderWidth);
		CGContextAddPath(ctx, _pointPath.CGPath);
		CGContextDrawPath(ctx, kCGPathFillStroke);

		CGContextSetFillColorWithColor(ctx, HGPasswordSmallPointHighlightColor.CGColor);
		CGContextAddPath(ctx, smallPointPath.CGPath);
		CGContextDrawPath(ctx, kCGPathFill);
	}else if (self.pointState == HGGesturePointStateWarn){

		CGContextSetStrokeColorWithColor(ctx, HGPasswordPointBorderWarnColor.CGColor);
			//		CGContextSetLineWidth(ctx, HGPointBorderWidth);
		CGContextAddPath(ctx, _pointPath.CGPath);
		CGContextDrawPath(ctx, kCGPathFillStroke);

		CGContextSetFillColorWithColor(ctx, HGPasswordSmallPointWarnColor.CGColor);
		CGContextAddPath(ctx, smallPointPath.CGPath);
		CGContextDrawPath(ctx, kCGPathFill);
	}
	else{
		CGContextSetStrokeColorWithColor(ctx, HGPasswordPointBorderColor.CGColor);
			//		CGContextSetLineWidth(ctx, HGPointBorderWidth);
		CGContextAddPath(ctx, _pointPath.CGPath);
		CGContextDrawPath(ctx, kCGPathFillStroke);

		CGContextSetFillColorWithColor(ctx, HGPasswordSmallPointColor.CGColor);
		CGContextAddPath(ctx, smallPointPath.CGPath);
		CGContextDrawPath(ctx, kCGPathFill);
	}
}
- (void)setPointState:(HGGesturePointState)pointState{
	if (_pointState != pointState) {
		_pointState = pointState;
		[self setNeedsDisplay];
	}
}

- (BOOL)hg_containsPoint:(CGPoint)p{
	CGPoint testPoint = CGPointMake(p.x - self.frame.origin.x, p.y - self.frame.origin.y);
	return  [_pointPath containsPoint:testPoint];
}
- (CGPoint)centerPoint{
	return CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
}
@end
