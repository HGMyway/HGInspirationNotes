//
//  HGGesturePathIndicatorView.m
//  HGInspirationNotes
//
//  Created by 小雨很美 on 2018/1/16.
//  Copyright © 2018年 小雨很美. All rights reserved.
//

#import "HGGesturePathIndicatorView.h"

@implementation HGGesturePathIndicatorView
{
	
	NSArray <NSNumber *>* _path;
	NSMutableArray <CALayer *>* _layers;
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
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {

    // Drawing code
	if (_layers.count == 0) {
		_layers = [NSMutableArray array];
		NSInteger pointCount = 9;
		CGFloat cellInset = 4;
		CGFloat cellWidth = self.bounds.size.width / 3.0 ;
		CGFloat cellHeight = self.bounds.size.height / 3.0;

		for (NSInteger index = 0; index < pointCount; index++) {
			CALayer *pointLayer = [CALayer layer];
			NSInteger line = index % 3;
			NSInteger queue = index / 3;
			pointLayer.frame = 	CGRectInset(CGRectMake(cellWidth * line, cellHeight * queue, cellWidth , cellHeight ), cellInset, cellInset);
			pointLayer.cornerRadius = cellWidth /2 - cellInset;
			pointLayer.borderColor = UIColorFromRGB(0x999999).CGColor;
			[self.layer addSublayer:pointLayer];
			[_layers addObject:pointLayer];
		}
	}

	[_layers enumerateObjectsUsingBlock:^(CALayer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop){
		if ([_path containsObject:@(idx)]) {
			obj.backgroundColor = UIColorFromRGB(0xee7040).CGColor;
			obj.borderWidth = 0;
		}else{
			obj.backgroundColor = [UIColor whiteColor].CGColor;
			obj.borderWidth = 1;
		}
	}];
}
- (void)setPath:(NSArray <NSNumber *>*)path{
	_path = path;
	[self setNeedsDisplay];
}


@end
