//
//  HGGesturePointLayer.h
//  HGInspirationNotes
//
//  Created by 小雨很美 on 2018/1/16.
//  Copyright © 2018年 小雨很美. All rights reserved.
//


#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSUInteger, HGGesturePointState){
	HGGesturePointStateNormal = 0 ,
	HGGesturePointStateHighlighted = 1 << 0,
	HGGesturePointStateDisabled = 1 << 1,
	HGGesturePointStateSelected = 1 << 2,
	HGGesturePointStateWarn = 1 << 3,
};

@interface HGGesturePointLayer : CALayer

@property (nonatomic) HGGesturePointState pointState;

@property (nonatomic) NSInteger tag;

//@property(nonatomic,getter=isEnabled) BOOL enabled;
//@property(nonatomic,getter=isSelected) BOOL selected;
//@property(nonatomic,getter=isHighlighted) BOOL highlighted;
@property (nonatomic, readonly) CGPoint centerPoint;

- (BOOL)hg_containsPoint:(CGPoint)p;
@end
