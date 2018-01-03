//
//  HGRunLoopThreadKeepViewController.m
//  HGInspirationNotes
//
//  Created by 小雨很美 on 2017/12/19.
//  Copyright © 2017年 小雨很美. All rights reserved.
//http://www.jianshu.com/p/902741bcf707
//
//http://blog.csdn.net/wzf906819823/article/details/47207509   //控制线程(NSThread)和运行时循环(NSRunLoop)的退出
//https://bestswifter.com/runloop-and-thread/  深入研究 Runloop 与线程保活
#import "HGRunLoopThreadKeepViewController.h"

#import "HGThread.h"

#import <objc/runtime.h>
#import <objc/message.h>

@interface HGRunLoopThreadKeepViewController ()
@property (nonatomic,strong) HGThread *currentThread;
@property (nonatomic,assign) HGThread *curreddntThread;
@property (nonatomic,assign) NSInteger dddd;

@end


@implementation HGRunLoopThreadKeepViewController
{
	BOOL _hgCancel;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

//	[self registerMainRunloopObserver];
	[self startHGThread];
}
- (void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated{
	[super viewWillDisappear:animated];
}
- (void)viewDidDisappear:(BOOL)animated{
	[super viewDidDisappear:animated];
	[self stopHGThread];
}
- (IBAction)logThreadInfo:(UIButton *)sender {
	if (!_hgCancel && self.currentThread && !self.currentThread.isCancelled) {
			[self performSelector:@selector(subThreadOperation) onThread:self.currentThread withObject:nil waitUntilDone:NO];
	}
}
- (IBAction)stopThread:(UIButton *)sender {
	[self stopHGThread];
}

- (void)startHGThread{
	self.currentThread = [[HGThread alloc] initWithTarget:self selector:@selector(subThreadEntryPoint) object:nil];
	self.currentThread.name = @"mywayTestThread";
	[self.currentThread start];
}
- (void)stopHGThread{
	if (self.currentThread && !self.currentThread.cancelled) {
		_hgCancel = YES;
		[self performSelector:@selector(stopThread) onThread:self.currentThread withObject:nil waitUntilDone:NO];
	}
}
- (void)stopThread{
	[[NSThread currentThread] cancel];
	CFRunLoopStop(CFRunLoopGetCurrent());

}
- (void)subThreadEntryPoint{
	@autoreleasepool{
		NSRunLoop *runloop = [NSRunLoop currentRunLoop];
//		http://www.jianshu.com/p/ccceb83a5511

//		CFRunLoopSource
//
//		RunLoop的数据源抽象类（类似于OC中的protocol）
//
//		RunLoop定义了两个版本的source：Source0 和 Source1
//
//	Source0:处理的是App内部的事件、App自己负责管理，如按钮点击事件等。
//
//	Source1:由RunLoop和内核管理，Mach Port驱动，如CFMachPort、CFMessagePort

//		Cocoa为iOS线程间通信提供2种方式，1种是performSelector，另1种是Port。
//		第2种为NSMachPort方式。NSPort有3个子类，NSSocketPort、NSMessagePort、NSMachPort，但在iOS下只有NSMachPort可用。
//
//		使用的方式为接收线程中注册NSMachPort，在另外的线程中使用此port发送消息，则被注册线程会收到相应消息，然后最终在主线程里调用某个回调函数。
//
//		可以看到，使用NSMachPort的结果为调用了其它线程的1个函数，而这正是performSelector所做的事情，所以，NSMachPort是个鸡肋。线程间通信应该都通过performSelector来搞定
		
		[runloop addPort:[NSMachPort port] forMode:NSRunLoopCommonModes];
		//1、这种方式runloop无法退出
//		[runloop run];
		//2、这种方式runloop无法启动
//		[runloop runMode:NSRunLoopCommonModes beforeDate:[NSDate distantFuture]];
		//3、这是个好方法
		 CFRunLoopRun();
	}
}
- (void)subThreadOperation{
	@autoreleasepool{
		if ([NSThread currentThread].isCancelled || _hgCancel ) {
			return;
		}
		NSLog(@"%@----子线程任务开始",[NSThread currentThread]);
		[NSThread sleepForTimeInterval:3.0];
		NSLog(@"%@----子线程任务结束",[NSThread currentThread]);

	}
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc{
	NSLog(@"%s",__func__);
}
- (void)receiveRunloopInfo{
	NSLog(@"%s",__func__);
}
static void RunLoopCallBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info){
	NSPointerArray *weakPointers = (__bridge NSPointerArray *)info;
	HGRunLoopThreadKeepViewController *runLoopKeepVC = [weakPointers pointerAtIndex:0];
	if (runLoopKeepVC) {
		[runLoopKeepVC receiveRunloopInfo];
	}

}
//
- (void)registerMainRunloopObserver{
//	http://blog.csdn.net/jeffasd/article/details/50505550
	NSPointerArray *weakPointers = [NSPointerArray weakObjectsPointerArray];
	[weakPointers addPointer:(__bridge void * _Nullable)(self)];
	CFRunLoopRef runLoop = CFRunLoopGetCurrent();
	CFOptionFlags activies = (kCFRunLoopBeforeWaiting|kCFRunLoopExit);
	CFRunLoopObserverContext context =  {
		0,//CFIndex	version;
		(__bridge void *)weakPointers,//void *	info;
		&CFRetain,//const void *(*retain)(const void *info);
		&CFRelease,//void	(*release)(const void *info);
		NULL//CFStringRef	(*copyDescription)(const void *info);
	} ;
//	一个CFRunLoopObserver仅可以注册在Runloop中一次，但它可以注册在多个Runloop Mode中。
	CFRunLoopObserverRef runloopObserver = CFRunLoopObserverCreate(NULL, activies, YES, INT_MAX, &RunLoopCallBack, &context);
 	CFRunLoopObserverRef runloopObserverHandler = CFRunLoopObserverCreateWithHandler(NULL, activies, YES, INT_MAX, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
		NSLog(@"%s",__func__);
	});
	CFRunLoopAddObserver(runLoop, runloopObserver, kCFRunLoopCommonModes);
	CFRunLoopAddObserver(runLoop, runloopObserverHandler, kCFRunLoopCommonModes);
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
