//
//  HGRunloopViewController.m
//  HGInspirationNotes
//
//  Created by 小雨很美 on 2017/12/17.
//  Copyright © 2017年 小雨很美. All rights reserved.
//
//http://sunshineyg888.github.io/2016/05/21/RunLoop-详解/
//http://www.jianshu.com/p/ac05ac8428ac
//http://www.swiftyper.com/2017/01/04/runloop-learning-note/

#import "HGRunloopViewController.h"

@interface HGRunloopViewController ()

@end

@implementation HGRunloopViewController
{
	NSTimer *_timer;
}
- (void)viewDidLoad {
	[super viewDidLoad];
		// Do any additional setup after loading the view.
	[self addTimer];
}
- (void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	[self addTimer];
}
- (void)viewWillDisappear:(BOOL)animated{
	[super viewWillDisappear:animated];
	[self timerInvalidate];
}

- (void)addTimer{
	if (_timer == nil) {
		//用target方式创建的timer会强引用self，如果timer不释放，self也不会；
//		_timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFunc:) userInfo:nil repeats:YES];

		//用block不会循环引用，可以在dealloc中释放timer

//		GCD定时器
//		　　GCD定时器的优点有很多，首先不受Mode的影响，而NSTimer受Mode影响时常不能正常工作，除此之外GCD的精确度明显高于NSTimer，这些优点让我们有必要了解GCD定时器这种方法。

//		　1.1.2.1 CFRunloopTimerRef 基于时间的触发器
//
//		　　NSTimer
//
//		　　首先说一下NSTimer，一个NSRunloop可以创建多个Timer。因为定时器只会运行在指定的Mode下 ，一旦Runloop进入其他模式， 定时器就不会工作了。
		_timer = [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
			NSLog(@"retainCount = %ld",CFGetRetainCount((__bridge CFTypeRef)(timer)));
		}];
	}
}
- (void)timerInvalidate{
	[_timer invalidate];
	_timer = nil;
}
- (void)timeFunc:(NSTimer *)timer{
	NSLog(@"retainCount = %ld",CFGetRetainCount((__bridge CFTypeRef)(timer)));
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc{
	NSLog(@"dealloc");
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

/*
 http://www.cocoachina.com/ios/20150601/11970.html

 //RunLoop 和线程
 RunLoop 的作用就是来管理线程的，当线程的 RunLoop 开启后，线程就会在执行完任务后，处于休眠状态，随时等待接受新的任务，而不是退出。

 //只有主线程的RunLoop是默认开启的，所以程序在开启后，会一直运行，不会退出。其他线程的RunLoop 如果需要开启，就手动开启，


 //猜想runloop内部是如何实现的？
 1、有一个判断循环的条件，满足条件，就一直循环
 2、线程得到唤醒事件被唤醒，事件处理完毕以后，回到睡眠状态，等待下次唤醒

 */
