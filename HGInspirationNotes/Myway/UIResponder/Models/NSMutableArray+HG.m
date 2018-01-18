//
//  NSMutableArray+HG.m
//  HGInspirationNotes
//
//  Created by 小雨很美 on 2018/1/15.
//  Copyright © 2018年 小雨很美. All rights reserved.
//

#import "NSMutableArray+HG.h"
#import <objc/runtime.h>
@implementation NSMutableArray (HG)
+ (void)load{
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		[self swizzleSEL:@selector(addObject:) withSEL:@selector(hg_addObject:)];
	});
}
- (void)hg_addObject:(id)anObject{
	[self hg_addObject:anObject];
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
