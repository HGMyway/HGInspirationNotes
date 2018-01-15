

	//
//  HGResponderTestView.m
//  HGInspirationNotes
//
//  Created by 小雨很美 on 2018/1/15.
//  Copyright © 2018年 小雨很美. All rights reserved.
//

#import "HGResponderTestView.h"

@implementation HGResponderTestView
- (void)awakeFromNib{
	[super awakeFromNib];
//	[self addTap];
}

- (void)addTap{
	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
	[self addGestureRecognizer:tap];
}
- (void)tapAction:(UITapGestureRecognizer *)tap{
	NSLog(@"tap");
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
	[super touchesBegan:touches withEvent:event];
	NSLog(@"ddddstart");
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
	[super touchesEnded:touches withEvent:event];
	NSLog(@"dddend");
}
- (BOOL)isFirstResponder{
	BOOL flag = [super isFirstResponder];
	return flag;
}
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender{
	BOOL flag = [super canPerformAction:action withSender:sender];
	return flag;
}

//- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//	[super touchesMoved:touches withEvent:event];
//}
//- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//	[super touchesCancelled:touches withEvent:event];
//}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
	UIView *view = [super hitTest:point withEvent:event];
	return view;
}
- (BOOL)canBecomeFirstResponder{
	BOOL flag = [super canBecomeFirstResponder];
	return flag;
}
@end
