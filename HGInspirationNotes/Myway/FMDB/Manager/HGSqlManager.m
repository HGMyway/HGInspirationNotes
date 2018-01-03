//
//  HGSqlManager.m
//  HGInspirationNotes
//
//  Created by 小雨很美 on 2017/12/25.
//  Copyright © 2017年 小雨很美. All rights reserved.
//

#import "HGSqlManager.h"
#define  HGTest_Table @"HGTest_Table"

@implementation HGSqlManager
+ (HGSqlManager *)sharedManager{
	static HGSqlManager *sharedManager;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		sharedManager = [[HGSqlManager alloc] init];

	});
	return sharedManager;
}
- (void)changeDB{
//	[self open];
		// 变更数据库表为一个旧数据表
	NSString *sqlStr = [NSString stringWithFormat:@"ALTER TABLE %@ RENAME TO %@", HGTest_Table, [HGTest_Table stringByAppendingString:@"_Old"]];

		// 执行SQL语句操作
	[[self fmdb_instance] executeUpdate:sqlStr];

		// 创建新的数据表
	NSString *executeStr = [NSString stringWithFormat:@"create table if not exists %@ (LocID integer primary key autoincrement not null,messageID text unique,Content text,TypeName text,SendTime text,CreateTime integer,Status integer,msgtype text,apply_id text,userid text,message_last_id text)",HGTest_Table];

	BOOL bRet = [[self fmdb_instance] executeUpdate:executeStr];
	if (bRet) {
			// 从旧数据表把旧数据插入新的数据表中
		NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO %@ SELECT * ,'','','' FROM %@", HGTest_Table, [HGTest_Table stringByAppendingString:@"_Old"]];
		[[self fmdb_instance] executeUpdate:insertSql];
	}
		// 删除旧的数据表
	[[self fmdb_instance] executeUpdate:[NSString stringWithFormat:@"DROP TABLE %@",[HGTest_Table stringByAppendingString:@"_Old"]]];
//	[self close];
}
- (void)addColum{

	if (![[self fmdb_instance] columnExists:@"pid" inTableWithName:HGTest_Table]) {
		NSString *alertStr = [NSString stringWithFormat:@"ALTER TABLE %@ ADD %@ INTEGER",HGTest_Table,@"pid"];
		[[self fmdb_instance] executeUpdate:alertStr];
	}
}

- (BOOL)createTestTable{
	BOOL res = [self open];
		//    创建大的学习计划表

	res = [[self fmdb_instance] executeUpdate:@"create table if not exists HGTest_Table(id integer primary key autoincrement, pid text UNIQUE NOT NULL  , data text)"];
	if (res == NO) {
		NSLog(@"%s 数据库创建失败",__func__);
	}
	[self close];
	return res;
}
- (BOOL)insertTestData:(NSString *)text{
	[self createTestTable];
	BOOL res = [self open];
	if (res == NO) {
		NSLog(@"%s 数据库打开失败",__func__);
		return res;
	}

	res =[[self fmdb_instance] executeUpdate:@"delete from HGTest_Table where  data =? ",text];
	if (res == NO) {
		NSLog(@"删除学习记录数据失败");
	}
	res = [[self fmdb_instance]executeUpdate:@"INSERT INTO HGTest_Table(data) VALUES (?) ",text];

	if (res == NO) {
		NSLog(@"添加学习计划数据失败");
	}

	[self close];
	return res;
}

-(NSArray *)get_TestData
{
	NSMutableArray *mArray = [NSMutableArray array];
	[self open];
	FMResultSet *set = [[self fmdb_instance]executeQuery:@"SELECT * FROM HGTest_Table"];
	while ([set next]) {
		[mArray addObject:[set stringForColumn:@"data"]];
	}
	[self close];
	return mArray;
}




- (void)createTableIfNotExists:(NSString *)tableName{
	BOOL res = [self open];
		//    创建大的学习计划表

	res = [[self fmdb_instance] executeUpdate:@"create table if not exists HGTest_Table(id integer primary key autoincrement, pid text UNIQUE NOT NULL  , data text)"];
	if (res == NO) {
		NSLog(@"%s 数据库创建失败",__func__);
	}
	[self close];
}
- (BOOL)insertData:(NSDictionary *)dict dbName:(NSString *)dbName{
	BOOL res = [self open];

	[self close];
	return res;
}
@end
