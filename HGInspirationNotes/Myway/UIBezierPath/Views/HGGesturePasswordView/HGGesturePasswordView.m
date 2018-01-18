	//
	//  HGGesturePasswordView.m
	//  HGInspirationNotes
	//
	//  Created by 小雨很美 on 2018/1/16.
	//  Copyright © 2018年 小雨很美. All rights reserved.
	//

#import "HGGesturePasswordView.h"
#import "HGGesturePointLayer.h"
#import "HGGesturePathLayer.h"

#import "HGGestureConfig.h"

@implementation HGGesturePasswordView
{
	NSMutableArray <HGGesturePointLayer *>* _pointArray;
	HGGesturePathLayer *_pathLayer;
	NSMutableArray <NSNumber *>* _selectedPoints;

}

- (instancetype)init{
	self = [super init];
	self.backgroundColor = [UIColor whiteColor];
	return self;
}
- (void)awakeFromNib{
	[super awakeFromNib];
	self.backgroundColor = [UIColor whiteColor];
}

- (void)config{
	if (_pathLayer == nil) {
		_pathLayer = [HGGesturePathLayer layer];
		_pathLayer.frame = self.bounds;
		[self.layer addSublayer:_pathLayer];
	}
}

	// Only override drawRect: if you perform custom drawing.
	// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
		// Drawing code
	[self config];
	[self setPoints];

}

- (void)setPoints{
	CGFloat cellWidth = self.bounds.size.width / 3.0 ;
	CGFloat cellHeight = self.bounds.size.height / 3.0;

	if (!_pointArray) {
		_pointArray = [NSMutableArray array];
		_selectedPoints = [NSMutableArray array];
		NSInteger pointCount = 9;
		for (NSInteger index = 0; index < pointCount; index++) {
			HGGesturePointLayer *pointLayer = [HGGesturePointLayer layer];
			pointLayer.tag = index;
			[self.layer addSublayer:pointLayer];
			[_pointArray addObject:pointLayer];
		}
	}

	[_pointArray enumerateObjectsUsingBlock:^(HGGesturePointLayer * _Nonnull pointLayer, NSUInteger index, BOOL * _Nonnull stop) {
		NSInteger line = index % 3;
		NSInteger queue = index / 3;
		pointLayer.frame = CGRectMake(cellWidth * line, cellHeight * queue, cellWidth, cellHeight);
		[pointLayer setNeedsDisplay];
	}];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
	[super touchesBegan:touches withEvent:event];
	[self startTouches:touches withEvent:event];
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
	[super touchesEnded:touches withEvent:event];
	[self endTouches:touches withEvent:event];
}
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
	[super touchesMoved:touches withEvent:event];
	[self moveTouches:touches withEvent:event];
}

- (void)startTouches:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
	[self resetStates];
	if ([self.delegate respondsToSelector:@selector(hgGesturePasswordStart)]) {
		[self.delegate hgGesturePasswordStart];
	}
}
- (void)endTouches:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
	[_pathLayer overByRemoveTail:YES];
	BOOL isWarn = _selectedPoints.count < HGPasswordMinLength;
	if (isWarn) {
		[_pointArray enumerateObjectsUsingBlock:^(HGGesturePointLayer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
			if (obj.pointState == HGGesturePointStateHighlighted) {
				obj.pointState = HGGesturePointStateWarn;
				[obj setNeedsDisplay];
			}
		}];
		[_pathLayer resetPath];
	}
	if ([self.delegate respondsToSelector:@selector(hgGesturePasswordOver:isFalse:)]) {
		[self.delegate hgGesturePasswordOver:[_selectedPoints copy] isFalse:isWarn];
	}
}
- (void)moveTouches:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
	UITouch *anyTouch = [touches anyObject];
	CGPoint anyTouchPoint = [anyTouch locationInView:self];
	CGPoint testPoint = CGPointMake(anyTouchPoint.x + self.layer.frame.origin.x, anyTouchPoint.y + self.layer.frame.origin.y);
	CALayer *layer = [self.layer hitTest:testPoint];
	HGGesturePointLayer *hgPointLayer = (HGGesturePointLayer *)layer;
	if ([hgPointLayer isKindOfClass:[HGGesturePointLayer class]] &&(hgPointLayer.pointState == HGGesturePointStateNormal) && [hgPointLayer hg_containsPoint:anyTouchPoint]) {
		[self selectPoint:hgPointLayer];
	}else{
		[_pathLayer moveTailPoint:anyTouchPoint];
	}
	if ([self.delegate respondsToSelector:@selector(hgGesturePasswordMove:)]) {
		[self.delegate hgGesturePasswordMove:[_selectedPoints copy]];
	}
}
- (void)selectPoint:(HGGesturePointLayer *)pointLayer{
	pointLayer.pointState = HGGesturePointStateHighlighted;
	[_selectedPoints addObject:@(pointLayer.tag)];
	[_pathLayer addPoint:pointLayer.centerPoint];
}

- (void)resetStates{
	[_pathLayer resetPath];
	[_selectedPoints removeAllObjects];
	[_pointArray enumerateObjectsUsingBlock:^(HGGesturePointLayer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
		obj.pointState = HGGesturePointStateNormal;
	}];

}

@end
