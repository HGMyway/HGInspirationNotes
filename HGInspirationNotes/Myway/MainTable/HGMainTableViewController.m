//
//  HGMainTableViewController.m
//  HGInspirationNotes
//
//  Created by 小雨很美 on 2017/12/17.
//  Copyright © 2017年 小雨很美. All rights reserved.
//

#import "HGMainTableViewController.h"
#import "AppDelegate+SwitchRoot.h"

#import "HGMAMapViewController.h"
@interface HGMainTableViewController ()
@property (nonatomic, strong) NSMutableArray *titles;
@property (nonatomic, strong) NSMutableArray *classNames;
@property (nonatomic, strong) NSMutableArray *segueNames;
@end

@implementation HGMainTableViewController

- (void)viewDidLoad {
	[super viewDidLoad];

		// Uncomment the following line to preserve selection between presentations.
		// self.clearsSelectionOnViewWillAppear = NO;

		// Uncomment the following line to display an Edit button in the navigation bar for this view controller.
		// self.navigationItem.rightBarButtonItem = self.editButtonItem;
//	[UIApplication sharedApplication].applicationIconBadgeNumber = 0;
	[self addCellTitle:@"URLConnection" segueName:@"rootToConnection"];
	[self addCellTitle:@"URLSession" segueName:@"rootToSession"];
	[self addCellTitle:@"OperationQueue" segueName:@"rootToOperationQueue"];
	[self addCellTitle:@"GCD" segueName:@"rootToGCD"];
	[self addCellTitle:@"Runloop" segueName:@"rootToRunloop"];
//	[self addCellTitle:@"ReactCocoa" segueName:@"rootToReactiveCocoa"];
//	[self addCellTitle:@"PromiseKit" segueName:@"rootToPromiseKit"];
	[self addCellTitle:@"MethodInvalid" segueName:@"rootToMethodInvalid"];
	[self addCellTitle:@"DataStruct" segueName:@"rootToDataStruct"];
	[self addCellTitle:@"RunLoopThreadKeep" segueName:@"rootToRunLoopThreadKeep"];

	[self addCellTitle:@"BezierPath" segueName:@"rootToBezierPath"];

	[self addCellTitle:@"FMDB" segueName:@"rootToFMDB"];
	
	[self addCellTitle:@"LocalNotification" segueName:@"rootToLocalNotification"];
	[self addCellTitle:@"PushNotification" segueName:@"rootToPushNotification"];
	[self addCellTitle:@"MKMapView" segueName:@"rootToMKMapView"];
	[self addCellTitle:@"MAMapView" segueName:@"rootToMAMapView"];

	[self addCellTitle:@"Responder" segueName:@"rootToResponder"];





}
- (void)addCellTitle:(nonnull NSString *)title segueName:(nonnull NSString *)segueName{
	[self.titles addObject:title];
	[self.segueNames addObject:segueName];
}
- (NSMutableArray *)titles{
	if (_titles == nil) _titles = [NSMutableArray array];
	return _titles;
}

- (NSMutableArray *)segueNames{
	if (_segueNames == nil) _segueNames = [NSMutableArray array];
	return _segueNames;
}


- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
		// Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
	cell.textLabel.text = [self.titles objectAtIndex:indexPath.row];
	return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	if ([[self.segueNames objectAtIndex:indexPath.row] isEqualToString:@"rootToMAMapView"]) {
		[self.navigationController pushViewController:[HGMAMapViewController shard] animated:YES];
	}else{
		[self performSegueWithIdentifier:[self.segueNames objectAtIndex:indexPath.row] sender:[self.titles objectAtIndex:indexPath.row]];
	}

}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

- (IBAction)signOutButtonAction:(UIBarButtonItem *)sender {
	[[AppDelegate defaultDelegate] switchToLoginViewController];

}

#pragma mark - Navigation

	// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
		// Get the new view controller using [segue destinationViewController].
		// Pass the selected object to the new view controller.
	segue.destinationViewController.title = sender;
}
@end
