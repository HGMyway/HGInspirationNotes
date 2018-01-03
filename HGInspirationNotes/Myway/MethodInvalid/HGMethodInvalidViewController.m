//
//  HGMethodInvalidViewController.m
//  HGInspirationNotes
//
//  Created by 小雨很美 on 2017/12/17.
//  Copyright © 2017年 小雨很美. All rights reserved.
//

#import "HGMethodInvalidViewController.h"
#import <objc/runtime.h>
@interface HGMethodInvalidViewController ()

@end

@implementation HGMethodInvalidViewController

- (void)viewDidLoad {
	[super viewDidLoad];
		// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
		// Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation

 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
- (IBAction)DynamicMethodResolution:(UIButton *)sender {
//	[self performSelector:NSSelectorFromString(@"run") withObject:nil afterDelay:3] ;
			[self performSelector:@selector(rund)];
//	[[self class] cancelPreviousPerformRequestsWithTarget:self];

		[[self class] performSelector:NSSelectorFromString(@"rund")] ;

}
static void dynamicMethodIMP(id self, SEL _cmd)
{
		// implementation ....
	NSLog(@"dd");
}
+ (void)adddddd{
	NSLog(@"addddd");
}
+ (BOOL)resolveClassMethod:(SEL)sel{
	BOOL flag = [super resolveClassMethod:sel];

	if (sel == @selector(rund)){
class_addMethod(object_getClass(self), sel, class_getMethodImplementation(object_getClass(self), @selector(adddddd)), "v@:");

		return YES;
	}
	return flag;
}
+ (BOOL)resolveInstanceMethod:(SEL)sel{
	BOOL flag = [super resolveInstanceMethod:sel];
		//	if ([NSStringFromSelector(sel) isEqualToString:@"run"]) {
		//
		//	}else
	if (sel == @selector(rund)){
		class_addMethod([self class], sel, (IMP)dynamicMethodIMP, "v@:");
		return YES;
	}
	return flag;
}
	//1. instancesRespondToSelector只能写在类名后面，respondsToSelector可以写在类名和实例名后面。
//2. [类 instancesRespondToSelector]判断的是该类的实例是否包含某方法，等效于：[该类的实例 respondsToSelector]。
//3. [类 respondsToSelector]用于判断是否包含某个类方法。
	//+ (BOOL)instancesRespondToSelector:(SEL)aSelector{
	//	return YES;
	//}
- (id)forwardingTargetForSelector:(SEL)aSelector{
		//	if ([NSStringFromSelector(aSelector) isEqualToString:@"run"]) {
		//		return [[NSClassFromString(@"HGDataStructViewController") alloc] init];
		//	}

	id  forwardTargate = [super forwardingTargetForSelector:aSelector];
	return forwardTargate;
}
	//- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector{
	////	NSMethodSignature * methodSign = [NSMethodSignature methodSignatureForSelector:aSelector];
	////	return methodSign;
	//	NSString *sel = NSStringFromSelector(aSelector);
	//	if ([sel rangeOfString:@"set"].location == 0) {
	//			//动态造一个 setter函数
	//		return [NSMethodSignature signatureWithObjCTypes:"v@:@"];
	//	} else {
	//			//动态造一个 getter函数
	//		return [NSMethodSignature signatureWithObjCTypes:"@@:"];
	//	}
	//}
	//- (void)forwardInvocation:(NSInvocation *)anInvocation{
	//		//拿到函数名
	//	NSString *key = NSStringFromSelector([anInvocation selector]);
	//	NSLog(@"dd");
	//}
- (void)doesNotRecognizeSelector:(SEL)aSelector{
	NSLog(@"ddd");
}

@end
