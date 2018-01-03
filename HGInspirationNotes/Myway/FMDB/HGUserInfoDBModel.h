//
//  HGUserInfoDBModel.h
//  HGInspirationNotes
//
//  Created by 小雨很美 on 2017/12/26.
//  Copyright © 2017年 小雨很美. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "HGBaseModel.h"
@class HGUserInfoDBModel;
typedef void(^ReadAllBlock)(NSArray <HGUserInfoDBModel *>* resultArrau);
@interface HGUserInfoDBModel : NSObject
@property (nonatomic) NSInteger ID;
@property (nonatomic,copy) NSString *uid;
@property (nonatomic,copy) NSString *uname;
@property (nonatomic,copy) NSString *age;



- (BOOL)save;
- (BOOL)saveQueue;
+ (void)readAllQueue:(ReadAllBlock)block;
+ (NSArray <HGUserInfoDBModel *>*)readAll;
+ (BOOL)cleanAll;

- (NSString *)cellTitle;
@end
