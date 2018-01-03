//
//  UIView+HookForMainThreadUI.m
//  HGInspirationNotes
//
//  Created by 小雨很美 on 2018/1/2.
//  Copyright © 2018年 小雨很美. All rights reserved.
//

#import "UIView+HookForMainThreadUI.h"
#import <objc/runtime.h>

@implementation UIView (HookForMainThreadUI)
+ (void)load{
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		[self swizzleSEL:@selector(setNeedsLayout) withSEL:@selector(hg_setNeedsLayout)];
		[self swizzleSEL:@selector(setNeedsDisplay) withSEL:@selector(hg_setNeedsDisplay)];
	});
}
- (void)hg_setNeedsDisplay{
	[self checkIfMainThread];
	[self hg_setNeedsDisplay];
}
- (void)hg_setNeedsLayout{
	[self checkIfMainThread];
	[self hg_setNeedsLayout];
}
- (void)checkIfMainThread{
#ifdef DEBUG
	if (![[NSThread currentThread] isMainThread]) {
		NSLog(@"%@",[NSThread currentThread]);
//		[self.class alert];
	}
#endif
}
+ (void)alert{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"alertTitle" message:[[NSThread currentThread] description] delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
	[alert show];
}

+ (void)swizzleSEL:(SEL)originalSEL withSEL:(SEL)swizzledSEL {

	Class class = [self class];
	Method originalMethod = class_getInstanceMethod(class, originalSEL);
	Method swizzledMethod = class_getInstanceMethod(class, swizzledSEL);

	BOOL didAddMethod =
	class_addMethod(class,
					originalSEL,
					method_getImplementation(swizzledMethod),
					method_getTypeEncoding(swizzledMethod));

	if (didAddMethod) {
		class_replaceMethod(class,
							swizzledSEL,
							method_getImplementation(originalMethod),
							method_getTypeEncoding(originalMethod));
	} else {
		method_exchangeImplementations(originalMethod, swizzledMethod);
	}
}
@end
