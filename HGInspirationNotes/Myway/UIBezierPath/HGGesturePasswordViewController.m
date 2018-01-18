
	//
//  HGGesturePasswordViewController.m
//  HGInspirationNotes
//
//  Created by 小雨很美 on 2018/1/16.
//  Copyright © 2018年 小雨很美. All rights reserved.
//

#import "HGGesturePasswordViewController.h"
#import "HGGesturePasswordView.h"
#import "HGGesturePathIndicatorView.h"

@interface HGGesturePasswordViewController ()<HGGesturePasswordDelegate>
@property (weak, nonatomic) IBOutlet HGGesturePasswordView *gestureView;
@property (weak, nonatomic) IBOutlet HGGesturePathIndicatorView *gesturePathView;

@end

@implementation HGGesturePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	self.gestureView.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - HGGesturePasswordDelegate
- (void)hgGesturePasswordOver:(NSArray<NSNumber *> *)selectNumber isFalse:(BOOL)isFalse{
	[self.gesturePathView setPath:selectNumber];
}
- (void)hgGesturePasswordMove:(NSArray<NSNumber *> *)selectNumber{
	[self.gesturePathView setPath:selectNumber];
}
@end
