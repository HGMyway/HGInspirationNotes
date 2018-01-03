//
//  HGGCDViewController.m
//  HGInspirationNotes
//
//  Created by 小雨很美 on 2017/12/17.
//  Copyright © 2017年 小雨很美. All rights reserved.
//

#import "HGGCDViewController.h"

@interface HGGCDViewController ()
@property (weak, nonatomic) IBOutlet UILabel *topLabel;

@end

@implementation HGGCDViewController
{
	NSMutableArray *_array;
}

- (void)viewDidLoad {
	[super viewDidLoad];
		// Do any additional setup after loading the view.
	NSMutableArray *mArray = [NSMutableArray array];

	for (NSInteger index = 0; index < 10; index++) {
		dispatch_async(dispatch_get_main_queue(), ^{
			[mArray addObject:[NSString stringWithFormat:@"%ld",(long)index]];
		});
	}
	NSLog(@"%@",mArray);
	dispatch_barrier_async(dispatch_get_main_queue(), ^{
		NSLog(@"%@",mArray);
	});
	_array = [NSMutableArray array];

}
- (void)gcdSerialAction{
	dispatch_queue_t mySerialDispatchQueue = dispatch_queue_create("com.myway.gcd.serial", NULL);
	dispatch_group_t group = dispatch_group_create();
	dispatch_group_async(group, mySerialDispatchQueue, ^{
		NSLog(@"dd");
	});
}
- (void)gcdConcurrentAction{
	[self setStringValue:@"myway1"];
	dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);

	dispatch_async(queue, ^{
		[self setStringValue:@"myway2"];
	});

	dispatch_async(queue, ^{
		[self setStringValue:@"myway2"];
	});

	dispatch_async(queue, ^{
		[self setStringValue:@"myway2"];
	});

	for (NSInteger index = 0; index < 50; index++) {
		dispatch_async(queue, ^{
			[self setStringValue:@"myway2"];
		});
	}
	for (NSInteger index = 0; index < 50; index++) {
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), queue, ^{
			[self setStringValue:@"mywayafter"];
		});
	}
		//	dispatch_async(queue, ^{
		//dispatch_apply与dispatch_sync一样会等待处理执行结束，所以推荐在dispatch_async中非同步执行dispatch_apply
		//		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), queue, ^{
	dispatch_apply(100, queue, ^(size_t index) {
		NSLog(@"%@",[NSString stringWithFormat:@"%zu",index]);
	});
		//		});

		//	});


		//不考虑顺序将所有数据追加到数组，
		//这种写法是用global dispatch queue更新array，所以执行后内存错误导致程序异常结束概率很高
		//	for (NSInteger index = 0; index < 100; index++) {
		//		dispatch_async(queue, ^{
		//			[_array addObject:[NSString stringWithFormat:@"%ld - %lu",(long)index,(unsigned long)_array.count]];
		//		});
		//	}

	dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
	for (NSInteger index = 0; index < 100; index++) {
		dispatch_async(queue, ^{
				//等待 dispatch semaphore
				//一直等待，直到dispatch semaphore 计数值大于1
			dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
				//因为dispatch semaphore 计数值大于等于1
				//所以将dispatch semaphore 计数值减1
			[_array addObject:[NSString stringWithFormat:@"%ld - %lu",(long)index,(unsigned long)_array.count]];
				//排他控制结束
				//通过dispatch semaphore signal 函数将dispatch semaphore 技术加1
				//如果有通过dispatch semaphore wait 等待dispatch semaphore计数增加的线程，就由最先等待的线程执行
			dispatch_semaphore_signal(semaphore);
		});
	}

	dispatch_barrier_async(queue, ^{

		[self setStringValue:@"myway3"];
		NSLog(@"%@",_array);
	});

	for (NSInteger index = 0; index < 50; index++) {
		dispatch_async(queue, ^{
			[self setStringValue:@"myway4"];
		});
	}
	dispatch_async(queue, ^{
		[self setStringValue:@"myway4"];
	});

	NSLog(@"array 长度 %lu",(unsigned long)_array.count);


	NSLog(@"全部结束");
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


	NSLog(@"array 长度 %lu",(unsigned long)_array.count);

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
//	[self gcdConcurrentAction];
//	[self gcdConcurrentGroupAction];
		self.topLabel.text = @"ddd";
}


@end
