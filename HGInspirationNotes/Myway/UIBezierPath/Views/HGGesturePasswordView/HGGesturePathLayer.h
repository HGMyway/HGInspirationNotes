//
//  HGGesturePathLayer.h
//  HGInspirationNotes
//
//  Created by 小雨很美 on 2018/1/16.
//  Copyright © 2018年 小雨很美. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface HGGesturePathLayer : CALayer
- (void)resetPath;
- (void)addPoint:(CGPoint)point;
- (void)moveTailPoint:(CGPoint)point;
- (void)overByRemoveTail:(BOOL)remove;
@end
