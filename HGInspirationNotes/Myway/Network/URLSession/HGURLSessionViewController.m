//
//  HGURLSessionViewController.m
//  HGInspirationNotes
//
//  Created by 小雨很美 on 2017/12/17.
//  Copyright © 2017年 小雨很美. All rights reserved.
//

#import "HGURLSessionViewController.h"

@interface HGURLSessionViewController ()

@end

@implementation HGURLSessionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)requestAction:(id)sender {

	NSString *urlStr=@"http://www.cnblogs.com/wendingding/p/3813572.html";
	NSURL *url=[NSURL URLWithString:urlStr];
	NSURLRequest *request=[NSURLRequest requestWithURL:url ];

	NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"list"];


		// 3.采用苹果提供的共享session
	NSURLSession *sharedSession = [NSURLSession sharedSession];
	NSURLSessionTask *task = [sharedSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
		NSLog(@"ddd");

	}];
	[task resume];

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
