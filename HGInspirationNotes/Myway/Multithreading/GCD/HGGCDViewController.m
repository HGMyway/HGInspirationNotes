	//
	//  HGGCDViewController.m
	//  HGInspirationNotes
	//
	//  Created by 小雨很美 on 2017/12/17.
	//  Copyright © 2017年 小雨很美. All rights reserved.
	//

#import "HGGCDViewController.h"

static BOOL _isCancel;

@interface HGGCDViewController ()
@property (weak, nonatomic) IBOutlet UILabel *topLabel;

@end

@implementation HGGCDViewController
{
	dispatch_queue_t _queue;
}

- (void)viewDidLoad {
	[super viewDidLoad];
		// Do any additional setup after loading the view.

}


- (void)gcdConcurrentGroupAction{
	[self setStringValue:@"myway0"];
	dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
	dispatch_group_t group = dispatch_group_create();

	dispatch_group_async(group, queue, ^{
			//					[self requestData];
		[self setStringValue:@"myway2"];
	});
	dispatch_group_async(group, queue, ^{
		[self setStringValue:@"myway2"];
	});
	dispatch_group_async(group, queue, ^{
			//		[self requestData];
		[self setStringValue:@"myway2"];
	});
	dispatch_group_async(group, queue, ^{
			//dispatch_apply与dispatch_sync一样会等待处理执行结束，所以推荐在dispatch_async中非同步执行dispatch_apply
		dispatch_apply(100, queue, ^(size_t index) {
			NSLog(@"%zu",index);
		});
	});
	for (NSInteger index = 0; index < 50; index++) {
		dispatch_group_async(group, queue, ^{
				//		[self requestData];
			[self setStringValue:@"myway1"];
		});
	}
	dispatch_barrier_async(queue, ^{
		[self setStringValue:@"myway3"];
	});

	dispatch_group_async(group, queue, ^{
			//		[self requestData];
		[self setStringValue:@"myway4"];
	});
	dispatch_group_async(group, queue, ^{
			//		[self requestData];
		[self setStringValue:@"myway4"];
	});

	dispatch_group_notify(group, dispatch_get_main_queue(), ^{
		NSLog(@"结束");
	});


	NSLog(@"done");



	dispatch_group_notify(group, dispatch_get_main_queue(), ^{
			//		NSLog(@"array %@",array);
	});
	NSLog(@"全部结束?");
	long isOver = dispatch_group_wait(group, DISPATCH_TIME_FOREVER);//等待group结束
	NSLog(@"isOver %ld",isOver);
	dispatch_barrier_async(queue, ^{
			//		NSLog(@"array %@",_array);
	});


	NSLog(@"全部结束");
}


- (void)setStringValue:(NSString *)string{
	NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
	[def setObject:string forKey:@"myway"];
	[def synchronize];
	NSLog(@"%@ 修改",string);

}

- (void)asynAddArray{

	dispatch_queue_t myConcurrentDispatchQueue = dispatch_queue_create("com.myway.gcd.Concurrent", DISPATCH_QUEUE_CONCURRENT);
	dispatch_group_t group = dispatch_group_create();
		//	dispatch_queue_t myConcurrentDispatchQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);

		//iOS 6.0之前需要手动调用 dispatch_release()释放创建的 dispatch_queue_t；
		//Block 会通过dispatch_retain() 持有 dispatch_queue ，并在结束的时候通过dispatch_release()释放dispatch_queue

	NSMutableArray *mArray = [NSMutableArray array];
		//
		//		//不考虑顺序将所有数据追加到数组，
		//		//这种写法是用Concurrent更新array，所以执行后内存错误导致程序异常结束概率很高
		//	for (NSInteger index = 0; index < 100; index++) {
		//		dispatch_async(myConcurrentDispatchQueue, ^{
		//			[mArray addObject:[NSString stringWithFormat:@"%ld",(long)index]];
		//			[self setStringValue:[NSString stringWithFormat:@"%ld",(long)index]];
		//		});
		//	}

	dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);

	for (NSInteger index = 0; index < 100; index++) {


		dispatch_group_async(group, myConcurrentDispatchQueue, ^{
			dispatch_group_enter(group);
				//等待 dispatch semaphore
				//一直等待，直到dispatch semaphore 计数值大于1
			dispatch_async(myConcurrentDispatchQueue, ^{
				dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
					//因为dispatch semaphore 计数值大于等于1
					//所以将dispatch semaphore 计数值减1
				[mArray addObject:[NSString stringWithFormat:@"%ld - %lu",(long)index,(unsigned long)mArray.count]];
				[self setStringValue:[NSString stringWithFormat:@"%ld",(long)index]];
					//排他控制结束
					//通过dispatch semaphore signal 函数将dispatch semaphore 技术加1
					//如果有通过dispatch semaphore wait 等待dispatch semaphore计数增加的线程，就由最先等待的线程执行
				dispatch_semaphore_signal(semaphore);
				dispatch_group_leave(group);
			});

		});
	}

	NSLog(@"befor%@",mArray);

	dispatch_group_notify(group, myConcurrentDispatchQueue, ^{
		NSLog(@"notify%@",mArray);
	});

	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), myConcurrentDispatchQueue, ^{
		NSLog(@"haha");
	});

	dispatch_barrier_async(myConcurrentDispatchQueue, ^{
		NSLog(@"barrier%@",mArray);
	});

}

- (void)dispatch_set_target_queue_test{
	dispatch_queue_t lowDispatct = dispatch_queue_create("com.myway.low", NULL);
	dispatch_queue_t highDispatct = dispatch_queue_create("com.myway.hight", NULL);
	dispatch_set_target_queue(lowDispatct, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0));
	dispatch_set_target_queue(highDispatct, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0));

		//	dispatch_queue_t serDispatct = dispatch_queue_create("com.myway.hight", NULL);
		//	dispatch_set_target_queue(highDispatct, serDispatct);
		//	dispatch_set_target_queue(lowDispatct, serDispatct);




	for (NSInteger index = 0; index < 100; index++) {
		dispatch_async(lowDispatct, ^{
			NSLog(@"low index %ld",(long)index);;

		});
	}

	for (NSInteger index = 0; index < 100; index++) {
		dispatch_async(highDispatct, ^{
			NSLog(@"high index %ld",(long)index);;

		});
	}

}

- (void)dispatch_after_test{
	dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 3ull * NSEC_PER_SEC);
	dispatch_after(time, dispatch_get_main_queue(), ^{
		NSLog(@"等待至少3秒后执行");
	});

	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		NSLog(@"等待至少3秒后执行");
	});


}
- (void)dispatch_group_test{
		//	dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
		//		_queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
		//	_queue = dispatch_get_main_queue();
	_queue = dispatch_queue_create("com.myway.test", DISPATCH_QUEUE_CONCURRENT);

	dispatch_suspend(_queue);
	dispatch_group_t group = dispatch_group_create();
	for (NSInteger index = 0; index<10; index++) {
		__weak typeof(self) weakSelf = self;
		dispatch_group_async(group, _queue, ^{
			[weakSelf setStringValue:[NSString stringWithFormat:@"blk%ld",(long)index]];
		});
	}


		//	dispatch_sync(queue, ^{
		//		NSLog(@"sync");
		//	});

	dispatch_group_notify(group, dispatch_get_main_queue(), ^{
		NSLog(@"done");
	});
	long result = dispatch_group_wait(group, DISPATCH_TIME_NOW);
	if (result == 0) {
			//属于group的全部处理执行结束
		NSLog(@"属于group的全部处理执行结束");
	}else{
			//属于group的处理未全部执行结束
		NSLog(@"属于group的处理未全部执行结束");
	}

		//	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		//		dispatch_resume(_queue);
		//	});


}
	//通过dispatch_walltime用来计算绝对时间
dispatch_time_t getDispatchTimeByDate(NSDate *date){
	NSTimeInterval interval;
	double second, subsecond;
	struct timespec time;
	dispatch_time_t milestone;

	interval = [date timeIntervalSince1970];
	subsecond = modf(interval, &second);
	time.tv_sec = second;
	time.tv_nsec = subsecond * NSEC_PER_SEC;
	milestone = dispatch_walltime(&time, 0);
	return milestone;
}

- (void)dispatch_sync_test{
		//这样会死锁
	dispatch_sync(dispatch_get_main_queue(), ^{
		NSLog(@"hehe");
	});
}

- (void)dispatch_apply_test{
	dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);

	dispatch_async(queue, ^{
		dispatch_apply(10, queue, ^(size_t index) {
			NSLog(@"%zu",index);
		});
		NSLog(@"done");//done必定在最后的位置输出，因为dispatch_apply会等待全部处理执行结束
		dispatch_async(dispatch_get_main_queue(), ^{
				//main queue 处理UI等；
		});
	});
}
- (void)dispatch_cancel{
	for (NSInteger index = 0; index<20; index++) {
		dispatch_async(dispatch_get_main_queue(), ^{
			dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
				if (_isCancel) {
					NSLog(@"block is cancel");
					return ;
				}
				NSLog(@" %ld",(long)index);
				_isCancel = (index == 10);
			});

		});
	}
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
- (IBAction)gcdConcurrentAction:(id)sender {
	[self asynAddArray];
		//	[self gcdConcurrentAction];
		//	[self gcdConcurrentGroupAction];
		//	[self dispatch_set_target_queue_test];
		//	[self dispatch_after_test];
		//	[self dispatch_group_test];
		//	[self dispatch_sync_test];
		//	[self dispatch_apply_test];
		//	[self dispatch_cancel];
}

- (IBAction)gcdResumeAction:(UIButton *)sender {
		//	if (_queue) {
		//		dispatch_resume(_queue);
		//	}
	_isCancel = YES;
}



@end
