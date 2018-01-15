//
//  HGSuperResponderView.m
//  HGInspirationNotes
//
//  Created by 小雨很美 on 2018/1/15.
//  Copyright © 2018年 小雨很美. All rights reserved.
//

#import "HGSuperResponderView.h"

@implementation HGSuperResponderView
- (void)awakeFromNib{
	[super awakeFromNib];
			[self addTap];
}
- (void)addTap{
	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
	[self addGestureRecognizer:tap];
}
- (void)tapAction:(UITapGestureRecognizer *)tap{
	NSLog(@"supertap");
	
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (BOOL)isFirstResponder{
	BOOL flag = [super isFirstResponder];
	return flag;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
	NSLog(@"superddddstart");
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
	NSLog(@"superdddend");
}
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
	UIView *view = [super hitTest:point withEvent:event];
	return view;
}
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender{
	BOOL flag = [super canPerformAction:action withSender:sender];
	return flag;
}
- (BOOL)canBecomeFirstResponder{
	BOOL flag = [super canBecomeFirstResponder];
	return flag;
}
@end
