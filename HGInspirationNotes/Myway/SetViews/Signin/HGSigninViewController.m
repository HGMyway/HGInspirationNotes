	//
	//  HGSigninViewController.m
	//  HGInspirationNotes
	//
	//  Created by 小雨很美 on 2017/12/17.
	//  Copyright © 2017年 小雨很美. All rights reserved.
	//

#import "HGSigninViewController.h"


#import <ReactiveCocoa/ReactiveCocoa.h>
#import "AppDelegate+SwitchRoot.h"

#import "NetworkAsst.h"

#import "HGSignin.h"
@interface HGSigninViewController ()

@property (weak, nonatomic) IBOutlet UITextField *userNameTF;
@property (weak, nonatomic) IBOutlet UITextField *passWordTF;
@property (weak, nonatomic) IBOutlet UIButton *signinButton;
@property (strong, nonatomic) HGSignin *hgsignin;
@end




@implementation HGSigninViewController
	//@synthesize name = _name;

	//@synthesize
	//编译器期间，让编译器自动生成getter/setter方法。
	//当有自定义的存或取方法时，自定义会屏蔽自动生成该方法
	//@dynamic
	//告诉编译器，不自动生成getter/setter方法，避免编译期间产生警告
	//然后由自己实现存取方法
	//或存取方法在运行时动态创建绑定：主要使用在CoreData的实现NSManagedObject子类时使用，由Core Data框架在程序运行的时动态生成子类属性

- (void)viewDidLoad {
	[super viewDidLoad];
		// Do any additional setup after loading the view.
	self.hgsignin = [[HGSignin alloc] init];
	self.hgsignin.userName = [HGSignin preUserEmail];
	self.userNameTF.text = self.hgsignin.userName;
	[self customEnableSignButton];
}
- (void)customEnableSignButton{
	id  signals = @[[self.userNameTF rac_textSignal],[self.passWordTF rac_textSignal]];

	__weak typeof(self.hgsignin) weakSign = self.hgsignin;
	RAC(self,signinButton.enabled) = [RACSignal combineLatest:signals
													   reduce:^id(NSString *name, NSString *passWord){
														   weakSign.userName = name;
														   weakSign.passWord = passWord;
														   return @(name.length >0 && passWord.length > 0);
													   }];
}
- (IBAction)signButtonAction:(UIButton *)sender {
	__weak typeof(self) weakSelf = self;
	[[NetworkAsst defaultNetwork] hg_signinParam:[self.hgsignin toParam] callback:^(NSError *error, NSDictionary *data, NSURLSessionDataTask *dataTask) {
		if (error == nil) {
			if ([HGSignin isLogin]) {
				[HGSignin setPreUserEmail:weakSelf.hgsignin.userName];
				[[AppDelegate defaultDelegate] switchToTabBarViewController];
			}
		}else{
			UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"错误信息" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
			[alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}]];
			[self presentViewController:alert animated:YES completion:nil];
		}
	}];

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

@end
