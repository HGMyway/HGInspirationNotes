//
//  HGOperationQueueViewController.m
//  HGInspirationNotes
//
//  Created by 小雨很美 on 2017/12/17.
//  Copyright © 2017年 小雨很美. All rights reserved.
//

#import "HGOperationQueueViewController.h"
#import "HGOperation.h"

@interface HGOperationQueueViewController ()

@end

@implementation HGOperationQueueViewController
{
	NSTimer *_timer;
	NSInteger _timerCount;
}
- (void)viewDidLoad {
	[super viewDidLoad];
		// Do any additional setup after loading the view.
		//	[self currentQueue];
		//	NSLog(@"currentQueue");
		//	[self customQueue];
		//	NSLog(@"customQueue");
		//	[self mainQueue];
		//	NSLog(@"mainQueue");
	[self addTimer];
}
- (void)addTimer{

	_timerCount = 0;
		//	NSTimer *timer = [NSTimer timerWithTimeInterval:2 repeats:YES block:^(NSTimer * _Nonnull timer) {
		//		NSLog(@"hahaTimer");
		//	}];
		//	timer.fireDate = [NSDate distantFuture];
		//	[timer fire];
	[NSThread detachNewThreadWithBlock:^{
		NSLog(@"thread");


		_timer = [NSTimer timerWithTimeInterval:2 target:self selector:@selector(timeTagert) userInfo:nil repeats:YES];
		[[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
		[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:6]];

	}];
		//	_timer = [NSTimer scheduledTimerWithTimeInterval:2 repeats:YES block:^(NSTimer * _Nonnull timer) {
		//		NSLog(@"block");
		//
		//	}];

		//	_timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(timeTagert) userInfo:nil repeats:YES];
		//	_timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeTagert) userInfo:nil repeats:YES];
		//	_timer.fireDate = [NSDate distantPast];
		//	[_timer fire];
}
- (void)timeTagert{
	_timerCount++;
	NSLog(@"timeTagert%ld",(long)_timerCount);
	if (_timerCount == 2) {
		[_timer invalidate];
			//		[_timer invalidate];
			//		_timer.fireDate = [NSDate distantFuture];
			//		_timer.fireDate = [NSDate distantPast];
			//		[_timer fire];
	}
}
- (void)mainQueue{
	NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];

	HGOperation *operation = [[HGOperation alloc] init];

		//	NSInvocation
	NSInvocationOperation *invocationOpration = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(invocationOperation:) object:@"mainQueueInvocation"];
	NSBlockOperation *blockOperation = [NSBlockOperation blockOperationWithBlock:^{
		NSLog(@"mainQueueblock");
	}];

	[mainQueue addOperationWithBlock:^{
		NSLog(@"mainQueueaddOperationWithBlock");
	}];

	[mainQueue addOperation:operation];
	[mainQueue addOperation:invocationOpration];
	[mainQueue addOperation:blockOperation];
	[mainQueue cancelAllOperations];
}
- (void)currentQueue{

	NSOperationQueue *currentQueue = [NSOperationQueue currentQueue];

	HGOperation *operation = [[HGOperation alloc] init];

		//	NSInvocation
	NSInvocationOperation *invocationOpration = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(invocationOperation:) object:@"currentQueueInvocation"];
	NSBlockOperation *blockOperation = [NSBlockOperation blockOperationWithBlock:^{
		NSLog(@"currentQueueblock");
	}];

	[currentQueue addOperationWithBlock:^{
		NSLog(@"currentQueueaddOperationWithBlock");
	}];

	[currentQueue addOperation:operation];
	[currentQueue addOperation:invocationOpration];
	[currentQueue addOperation:blockOperation];
}
- (void)customQueue{
	NSOperationQueue *customQueue = [[NSOperationQueue alloc] init];

	HGOperation *operation = [[HGOperation alloc] init];

		//	NSInvocation
	NSInvocationOperation *invocationOpration = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(invocationOperation:) object:@"customQueueInvocation"];
	NSBlockOperation *blockOperation = [NSBlockOperation blockOperationWithBlock:^{
		NSLog(@"customQueueblock");
	}];

	[customQueue addOperationWithBlock:^{
		NSLog(@"customQueueaddOperationWithBlock");
	}];
	[customQueue addOperation:operation];
	[customQueue addOperation:invocationOpration];
	[customQueue addOperation:blockOperation];
}
- (void)invocationOperation:(NSString *)object{
	NSLog(@"invocationSEL");
	NSLog(@"%@",object);
}
- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
		// Dispose of any resources that can be recreated.
}
- (void)dealloc{
	NSLog(@"dealloc");
}

@end
