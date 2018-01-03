//
//  HGUserInfoDBModel.m
//  HGInspirationNotes
//
//  Created by 小雨很美 on 2017/12/26.
//  Copyright © 2017年 小雨很美. All rights reserved.
//

#import "HGUserInfoDBModel.h"
#import "HGSqlManager.h"
#import <UIKit/UIKit.h>
@implementation HGUserInfoDBModel
//在我并没有对类做任何操作的情况下，+load 方法会被默认执行，并且是在 main 函数之前执行的。

+ (void)initialize{
	[self createTable];
}

+ (BOOL)createTable{
	BOOL res = [[HGSqlManager sharedManager] open];
	if (res == NO) {
		NSLog(@"%s 数据库打开失败",__func__);
		return res;
	}
	res = [[[HGSqlManager sharedManager]  fmdb_instance] executeUpdate:@"create table if not exists HGTest_User (id integer primary key autoincrement, uid text UNIQUE NOT NULL  , uname text , age text )"];
	if (res == NO) {
		NSLog(@"%s 数据库创建失败",__func__);
	}

	[[HGSqlManager sharedManager] close];
	return res;

}

- (BOOL)save{
	BOOL res = [[HGSqlManager sharedManager] open];
	if (res == NO) {
		NSLog(@"%s 数据库打开失败",__func__);
		return res;
	}
//	res =[[[HGSqlManager sharedManager] fmdb_instance] executeUpdate:@"delete from HGTest_User where  uid =? ",self.uid];
//	if (res == NO) {
//		NSLog(@"删除数据失败");
//	}
	res = [[[HGSqlManager sharedManager] fmdb_instance]executeUpdate:@"INSERT INTO HGTest_User(uid , uname , age) VALUES (? , ? , ?) ",self.uid,self.uname,self.age];

	if (res == NO) {
		NSLog(@"添加数据失败");
	}

	[[HGSqlManager sharedManager] close];
	return res;
}
- (BOOL)saveQueue{
	NSString *stringPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	NSString *path = [stringPath stringByAppendingPathComponent:hg_myway_db];
	FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:path];
	__weak typeof(self) weakSelf = self;
	[queue inDatabase:^(FMDatabase *db) {
		__strong typeof(self) strongSelf = weakSelf;
		if ([db executeUpdate:@"INSERT INTO HGTest_User(uid , uname , age) VALUES (? , ? , ?) ",strongSelf.uid,strongSelf.uname,strongSelf.age]) {
			NSLog(@"Demon 插入成功 - %@", [NSThread currentThread]);
		}else{
			NSLog(@"Demon 插入失败 - %@", [NSThread currentThread]);
		}
	}];
	return YES;
}

+ (void)readAllQueue:(ReadAllBlock)block{
	block = [block copy];
	NSString *stringPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	NSString *path = [stringPath stringByAppendingPathComponent:hg_myway_db];
	FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:path];
	[queue inDatabase:^(FMDatabase *db) {
	FMResultSet *set = [db executeQuery:@"SELECT * FROM HGTest_User"];
	NSMutableArray *mArray = [NSMutableArray array];
		while ([set next]) {
			HGUserInfoDBModel *model = [HGUserInfoDBModel new];
			model.ID = [set intForColumn:@"id"];
			model.uid = [set stringForColumn:@"uid"];
			model.uname = [set stringForColumn:@"uname"];
			model.age = [set stringForColumn:@"age"];
			[mArray addObject:model];
		}
		if (block) {
			block(mArray);
		}
	}];

}
+ (NSArray <HGUserInfoDBModel *>*)readAll{

	NSMutableArray *mArray = [NSMutableArray array];
	[[HGSqlManager sharedManager] open];
	FMResultSet *set = [[[HGSqlManager sharedManager] fmdb_instance]executeQuery:@"SELECT * FROM HGTest_User"];

	while ([set next]) {
		HGUserInfoDBModel *model = [HGUserInfoDBModel new];
		model.ID = [set intForColumn:@"id"];
		model.uid = [set stringForColumn:@"uid"];
		model.uname = [set stringForColumn:@"uname"];
		model.age = [set stringForColumn:@"age"];
		[mArray addObject:model];
	}
	[[HGSqlManager sharedManager] close];
	return mArray;
}

+ (BOOL)cleanAll{
	BOOL res = [[HGSqlManager sharedManager] open];
	if (res == NO) {
		NSLog(@"%s 数据库打开失败",__func__);
		return res;
	}

		//	;  //清空数据
		//	;//自增长ID为0
	res = [[[HGSqlManager sharedManager] fmdb_instance] executeUpdate:@"delete from HGTest_User"];
	if (res == NO) {
		NSLog(@"%s 清空HGTest_User失败",__func__);
	}
	res = [[[HGSqlManager sharedManager] fmdb_instance] executeUpdate:@"update sqlite_sequence SET seq = 0 where name ='HGTest_User' "];
	if (res == NO) {
		NSLog(@"%s 重置HGTest_User seq 失败",__func__);
	}

	[[HGSqlManager sharedManager] close];
	return res;
}



- (NSString *)cellTitle{
	NSMutableString *mString = [NSMutableString string];
	[mString appendFormat:@"%ld",(long)self.ID];
	[mString appendString:@","];
	[mString appendString:self.uid];
	[mString appendString:@","];
	[mString appendString:self.uname];
	[mString appendString:@","];
	[mString appendString:self.age];
	return [mString copy];
}
@end
