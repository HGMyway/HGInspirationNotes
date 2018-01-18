//
//  HGGesturePasswordView.h
//  HGInspirationNotes
//
//  Created by 小雨很美 on 2018/1/16.
//  Copyright © 2018年 小雨很美. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol HGGesturePasswordDelegate <NSObject>
@optional
- (void)hgGesturePasswordStart;
- (void)hgGesturePasswordMove:(NSArray <NSNumber*>*)selectNumber;
- (void)hgGesturePasswordOver:(NSArray <NSNumber*>*)selectNumber isFalse:(BOOL)isFalse;
@end
@interface HGGesturePasswordView : UIView
@property (nonatomic, weak) id<HGGesturePasswordDelegate> delegate;

- (void)resetStates;
@end
