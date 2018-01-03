//
//  AFAppDotNetAPIClient.h
//  HGInspirationNotes
//
//  Created by 小雨很美 on 2017/12/17.
//  Copyright © 2017年 小雨很美. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

@interface AFAppDotNetAPIClient : AFHTTPSessionManager

@property (nonatomic) BOOL removesKeysWithNullValues;

+ (instancetype)sharedClient;
@end
