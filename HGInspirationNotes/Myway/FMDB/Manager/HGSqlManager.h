//
//  HGSqlManager.h
//  HGInspirationNotes
//
//  Created by 小雨很美 on 2017/12/25.
//  Copyright © 2017年 小雨很美. All rights reserved.
//

#import "HGSqlManagerBase.h"
@interface HGSqlManager : HGSqlManagerBase
+ (HGSqlManager *)sharedManager;
- (BOOL)insertTestData:(NSString *)text;
-(NSArray *)get_TestData;


- (BOOL)insertData:(NSDictionary *)dict dbName:(NSString *)dbName;

@end
