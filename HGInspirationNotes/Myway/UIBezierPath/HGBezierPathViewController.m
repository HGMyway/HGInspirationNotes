
	//
//  HGBezierPathViewController.m
//  HGInspirationNotes
//
//  Created by 小雨很美 on 2017/12/22.
//  Copyright © 2017年 小雨很美. All rights reserved.
//

#import "HGBezierPathViewController.h"
#import "HGSignView.h"
@interface HGBezierPathViewController ()
@property (weak, nonatomic) IBOutlet HGSignView *signView;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation HGBezierPathViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
- (IBAction)clearImage:(UIButton *)sender {
	[self.signView clearSignature];
}
- (IBAction)createImage:(UIButton *)sender {
	self.imageView.image = [self.signView getSignatureImage];
}

@end
