//
//  TVViewController.m
//  TableeVieww
//
//  Created by Tim Novikoff on 9/13/14.
//  Copyright (c) 2014 Tim Novikoff. All rights reserved.
//

#import "TVViewController.h"
#import "TVTableViewController.h"


@interface TVViewController ()

@property (nonatomic, strong) TVTableViewController *myTableViewController;

@end

@implementation TVViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
 
    
    
    
    self.myTableViewController = [[TVTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    self.myTableViewController.view.frame = self.view.bounds;
//    [self.view addSubview:self.myTableViewController.view];
}
- (IBAction)myButtonPressed:(id)sender {
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:self.myTableViewController];
    
    [self presentViewController:navController animated:YES completion:nil];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
