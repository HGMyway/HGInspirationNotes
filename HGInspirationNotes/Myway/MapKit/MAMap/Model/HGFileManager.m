//
//  HGFileManager.m
//  HGInspirationNotes
//
//  Created by 小雨很美 on 2018/1/9.
//  Copyright © 2018年 小雨很美. All rights reserved.
//

#import "HGFileManager.h"
static const void * const kManagerDispatchQueueSpecificKey = &kManagerDispatchQueueSpecificKey;
@implementation HGFileManager{
	dispatch_queue_t    _queue;
	NSString *_filePath;
}

+ (instancetype)hg_fileManagerWithFileName:(NSString *)fileName{
	HGFileManager *fManager= [[self alloc] initWithFileName:fileName];
	return fManager;
}

- (instancetype)initWithFileName:(NSString *)fileName{
	self = [super init];
	_filePath = [self getMAMapFilePathWith:fileName];

	_queue = dispatch_queue_create([[NSString stringWithFormat:@"HG_FileManager.%@", self] UTF8String], NULL);
	dispatch_queue_set_specific(_queue, kManagerDispatchQueueSpecificKey, (__bridge void *)self, NULL);

	return self;
}
- (NSString *)getMAMapFilePathWith:(NSString *)fileName{
	if (!_filePath) {
			// 得到Documents路径
		NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
			// 创建一个文件路径
		NSString *filePath = [docPath stringByAppendingPathComponent:@"MAMapPaths"];

		// 创建文件首先需要一个文件管理对象
		NSFileManager *fileManager = [NSFileManager defaultManager];
		BOOL fileExist = [fileManager fileExistsAtPath:filePath];
		if (!fileExist) {
			fileExist = [fileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
		}
		if (fileName) {
			filePath = [filePath stringByAppendingFormat:@"/%@",fileName];
		}
			// 创建文件
		BOOL flag = [fileManager fileExistsAtPath:filePath];
		if (!flag) {
			flag = [fileManager createFileAtPath:filePath contents:[@"[]" dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
		}
		if (flag) {
			_filePath = filePath;
		}
	}
	return _filePath;
}

- (void)dealloc{
	if (_queue) {
		_queue = 0x00;
	}
}
- (void)inFilePath:(void (^)(NSString *))block{
	dispatch_sync(_queue, ^{
		block(_filePath);
	});
}
@end
