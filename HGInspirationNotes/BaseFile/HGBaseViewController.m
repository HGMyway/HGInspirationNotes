//
//  HGBaseViewController.m
//  HGInspirationNotes
//
//  Created by 小雨很美 on 2017/12/26.
//  Copyright © 2017年 小雨很美. All rights reserved.
//

#import "HGBaseViewController.h"

@interface HGBaseViewController ()

@end

@implementation HGBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc{
	NSLog(@"%s",__func__);
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
