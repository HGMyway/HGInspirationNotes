//
//  HGSafeMutableArray.m
//  HGInspirationNotes
//
//  Created by 小雨很美 on 2018/1/15.
//  Copyright © 2018年 小雨很美. All rights reserved.
//

#import "HGSafeMutableArray.h"
@implementation HGSafeMutableArray
{
	@private
	NSMutableArray *_array;
}
- (instancetype)init{
	self = [super init];
	_array = [NSMutableArray array];
	return self;
}
- (void)addObject:(nonnull id)anObject {
	dispatch_sync(dispatch_get_main_queue(), ^{
		[_array addObject:anObject];
	});
}
@end
