//
//  HGSignView.m
//  HGInspirationNotes
//
//  Created by 小雨很美 on 2017/12/22.
//  Copyright © 2017年 小雨很美. All rights reserved.
//

#import "HGSignView.h"
@interface HGSignView ()

@end
@implementation HGSignView
{
	CGRect _contentRect;
	CGPoint _points[5];
	NSInteger _control;
	UIBezierPath *_bezierPath;

}
- (instancetype)init{
	self = [super init];
	[self config];
	return self;
}
- (void)awakeFromNib{
	[super awakeFromNib];
	[self config];
}
- (void)config{
	self.multipleTouchEnabled = NO;
	self.backgroundColor = [UIColor clearColor];
	_bezierPath = [UIBezierPath bezierPath];
	[_bezierPath setLineWidth:2.0];
	_contentRect = CGRectNull;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
	UIColor *storkeColor = [UIColor redColor] ;
	[storkeColor setStroke];
	[_bezierPath stroke];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
	_control = 0;
	UITouch *touch = [touches anyObject];
	_points[0] = [touch locationInView:self];
	CGPoint startPoint = _points[0];
	CGPoint endPoint = CGPointMake(startPoint.x + 1.5, startPoint.y + 2);
	[_bezierPath moveToPoint:startPoint];
	[_bezierPath addLineToPoint:endPoint];
}
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
	UITouch *touch = [touches anyObject];
	CGPoint touchPoint = [touch locationInView:self];
	_control++;
	_points[_control] = touchPoint;
 
	if (_control == 4){
		_points[3] = CGPointMake((_points[2].x + _points[4].x)/2.0, (_points[2].y + _points[4].y)/2.0);

		[self resetContetRect];
			//设置画笔起始点
		[_bezierPath moveToPoint:_points[0]];
			//endPoint终点 controlPoint1、controlPoint2控制点
		[_bezierPath addCurveToPoint:_points[3] controlPoint1:_points[1] controlPoint2:_points[2]];
			//setNeedsDisplay会自动调用drawRect方法，这样可以拿到UIGraphicsGetCurrentContext，就可以画画了
		[self setNeedsDisplay];

		_points[0] = _points[3];
		_points[1] = _points[4];
		_control = 1;
	}
}
- (void)resetContetRect{
	[self resetContetRect:_points[0]];
	[self resetContetRect:_points[3]];
}
- (void)resetContetRect:(CGPoint)point{
	if (CGRectIsNull(_contentRect)) {
		_contentRect = CGRectMake(point.x, point.y, 0, 0);
	}

	if (point.x < _contentRect.origin.x) {
		_contentRect = CGRectMake(point.x, _contentRect.origin.y, CGRectGetMaxX(_contentRect) - point.x, _contentRect.size.height);
	}
	if (point.y < _contentRect.origin.y) {
		_contentRect = CGRectMake(_contentRect.origin.x, point.y, _contentRect.size.width, CGRectGetMaxY(_contentRect) - point.y);
	}
	if (CGRectGetMaxX(_contentRect) < point.x) {
			_contentRect = CGRectMake(_contentRect.origin.x, _contentRect.origin.y, point.x - _contentRect.origin.x, _contentRect.size.height);
	}
	if (CGRectGetMaxY(_contentRect) < point.y) {
		_contentRect = CGRectMake(_contentRect.origin.x, _contentRect.origin.y, _contentRect.size.width,point.y - _contentRect.origin.y);
	}
}

#pragma mark - 清除签名
- (void)clearSignature{
	[_bezierPath removeAllPoints];
	_contentRect = CGRectNull;
	[self setNeedsDisplay];
}
#pragma mark - 获取图片
- (UIImage *)getSignatureImage {
//		//设置为NO，UIView是透明这里的图片就是透明的
	UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 1.0);  //NO，YES 控制是否透明
	[self.layer renderInContext:UIGraphicsGetCurrentContext()];
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();

	CGImageRef imageRef = image.CGImage;
	CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef,_contentRect );

	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextDrawImage(context, _contentRect, subImageRef);
	UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
	CGImageRelease(subImageRef);
	UIGraphicsEndImageContext();

	return smallImage;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
	if ([gestureRecognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]]) {
		return NO;
	}else{
		return [super gestureRecognizerShouldBegin:gestureRecognizer];
	}
}
@end
