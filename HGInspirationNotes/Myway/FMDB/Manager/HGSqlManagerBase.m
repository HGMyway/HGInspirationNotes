//
//  HGSqlManagerBase.m
//  HGInspirationNotes
//
//  Created by 小雨很美 on 2017/12/25.
//  Copyright © 2017年 小雨很美. All rights reserved.
//


#import "HGSqlManagerBase.h"



@implementation HGSqlManagerBase

-(FMDatabase *) fmdb_instance
{
	static FMDatabase *obj=nil;
	static dispatch_once_t onceToken;
	NSString *stringPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	NSString *path = [stringPath stringByAppendingPathComponent:hg_myway_db];
	dispatch_once(&onceToken,^{
		obj=[FMDatabase databaseWithPath:path];
	});

	return obj;
}


-(BOOL) open
{
	return [[self fmdb_instance] open];
}

-(BOOL) close
{
	return [[self fmdb_instance] close];
}



-(BOOL)beginTransaction
{
	return  [[self fmdb_instance] beginTransaction];
}
-(BOOL)commit
{
	return [[self fmdb_instance] commit];
}
-(BOOL)rollback
{
	return [[self fmdb_instance] rollback];
}
-(BOOL)inTransaction
{
	return [[self fmdb_instance] isInTransaction];
}
-(BOOL)beginDeferredTransaction
{
	return [[self fmdb_instance] beginDeferredTransaction];
}

@end
