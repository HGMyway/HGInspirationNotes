//
//  HGDBBaseModel.m
//  HGInspirationNotes
//
//  Created by 小雨很美 on 2017/12/26.
//  Copyright © 2017年 小雨很美. All rights reserved.
//

#import "HGDBBaseModel.h"
#import <YYModel.h>
#import "HGSqlManager.h"

@implementation HGDBBaseModel

- (void)insertDB{
	[[HGSqlManager sharedManager] insertData:[self dbDict] dbName: [[self class] dbName]];
}

+ (void)createTable{

}

+ (NSString *)dbName{
//	NSAssert(NO, @"Should use method of a subclass.");
	return @"HGTestDB";
	return nil;
}
+ (NSString *)tableName{
	return NSStringFromClass(HGDBBaseModel.class);
}
+ (NSString *)primaryKey {
	return nil;
}
- (NSDictionary *)dbDict{
	return  [self yy_modelToJSONObject];
}





@end
