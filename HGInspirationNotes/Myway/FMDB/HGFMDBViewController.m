//
//  HGFMDBViewController.m
//  HGInspirationNotes
//
//  Created by 小雨很美 on 2017/12/25.
//  Copyright © 2017年 小雨很美. All rights reserved.
//

#import "HGFMDBViewController.h"
//#import "HGSqlManager.h"
#import "HGUserInfoDBModel.h"

#import <FMDB/FMDatabaseQueue.h>

#import "NetworkAsst.h"
@interface HGFMDBViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, copy) NSArray <HGUserInfoDBModel *>*dataSource;
@property (nonatomic, strong) HGUserInfoDBModel *currentUserModel;
@end

@implementation HGFMDBViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

	self.dataSource = [HGUserInfoDBModel readAll];
//	self.dataSource = [[HGSqlManager sharedManager] get_TestData];
}
- (HGUserInfoDBModel *)currentUserModel{
	if (!_currentUserModel) {
		_currentUserModel = [HGUserInfoDBModel new];
	}
	return _currentUserModel;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - action

- (IBAction)saveButtonAction:(UIButton *)sender {

	[self requestDepartments];
//	if (self.textField.text.length) {
////		self.currentUserModel.uid = self.textField.text;
////		self.currentUserModel.uname = self.textField.text;
////		self.currentUserModel.age = self.textField.text;
////		[self.currentUserModel save];
//
//		[self asynSave];
//
//		self.dataSource = [HGUserInfoDBModel readAll];
//		[self.tableView reloadData];
//	}
}

- (IBAction)readButtonAction:(UIButton *)sender {
	__weak typeof(self) weakSelf = self;
	[HGUserInfoDBModel readAllQueue:^(NSArray<HGUserInfoDBModel *> *resultArray) {
		weakSelf.dataSource = resultArray;
		[self.tableView reloadData];
	}];

//	self.dataSource = [HGUserInfoDBModel readAll];
//	[self.tableView reloadData];

}
- (IBAction)cleanButtonAction:(UIButton *)sender {
	[HGUserInfoDBModel cleanAll];
	self.dataSource = [HGUserInfoDBModel readAll];
	[self.tableView reloadData];
}

//- (void)asynSave{
//
//	dispatch_group_t group = dispatch_group_create();
//	dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
////
//	dispatch_group_async(group, queue, ^{
//		if ([self insertIntoTablePerson]) {
//			NSLog(@"Demon 插入成功 - %@", [NSThread currentThread]);
//		}else{
//			NSLog(@"Demon 插入失败 - %@", [NSThread currentThread]);
//		}
//	});
//
//}

#pragma mark -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	HGUserInfoDBModel *model = [self.dataSource objectAtIndex:indexPath.row];
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
	cell.textLabel.text = [model cellTitle];
	return cell;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (BOOL)insertIntoTablePerson:(HGUserInfoDBModel *)model{
	return  [model saveQueue];
}
- (void)asynSave:(NSArray <HGUserInfoDBModel *>*)modelArray{
	dispatch_group_t group = dispatch_group_create();
	dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
	[modelArray enumerateObjectsUsingBlock:^(HGUserInfoDBModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {

		dispatch_group_enter(group);
				dispatch_group_async(group, queue, ^{
					[self insertIntoTablePerson:obj];
					dispatch_group_leave(group);
//
//					if ([self insertIntoTablePerson:obj]) {
//						NSLog(@"Demon 插入成功 - %@", [NSThread currentThread]);
//					}else{
//						NSLog(@"Demon 插入失败 - %@", [NSThread currentThread]);
//					}
				});
	}];


	dispatch_group_notify(group, dispatch_get_main_queue(), ^{
		[self readButtonAction:nil];
	});



}

- (void)requestDepartments{


	NSDictionary *param = @{@"pagenum":@1,@"company":@3};
	__weak typeof(self) weakSelf = self;
	[[NetworkAsst defaultNetwork] hg_alldepartmentsParam:param callback:^(NSError *error, NSArray<HGUserInfoDBModel *> *data, NSURLSessionDataTask *dataTask) {
		[weakSelf asynSave:data];
	}];

}

@end
