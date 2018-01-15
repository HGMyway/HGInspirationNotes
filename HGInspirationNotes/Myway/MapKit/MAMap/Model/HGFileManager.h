//
//  HGFileManager.h
//  HGInspirationNotes
//
//  Created by 小雨很美 on 2018/1/9.
//  Copyright © 2018年 小雨很美. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HGFileManager : NSObject

+ (instancetype)hg_fileManagerWithFileName:(NSString *)fileName;
- (void)inFilePath:(void (^)(NSString *filePath))block;
@end
