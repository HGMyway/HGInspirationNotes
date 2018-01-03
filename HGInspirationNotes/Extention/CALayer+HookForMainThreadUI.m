//
//  CALayer+HookForMainThreadUI.m
//  HGInspirationNotes
//
//  Created by 小雨很美 on 2018/1/2.
//  Copyright © 2018年 小雨很美. All rights reserved.
//

#import "CALayer+HookForMainThreadUI.h"
#import <objc/runtime.h>

@implementation CALayer (HookForMainThreadUI)
+ (void)load{
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		[self swizzleSEL:@selector(setNeedsDisplayInRect:) withSEL:@selector(hg_setNeedsDisplayInRect:)];
	});
}
- (void)hg_setNeedsDisplayInRect:(CGRect)r{
	[self checkIfMainThread];
	[self hg_setNeedsDisplayInRect:r];
}
- (void)checkIfMainThread{
#ifdef DEBUG
	if (![[NSThread currentThread] isMainThread]) {
		NSLog(@"%@",[NSThread currentThread]);
	}
#endif
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
