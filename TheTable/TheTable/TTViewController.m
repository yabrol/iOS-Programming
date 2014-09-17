//
//  TTViewController.m
//  TheTable
//
//  Created by Yukti Abrol on 9/16/14.
//  Copyright (c) 2014 Yukti. All rights reserved.
//

#import "TTViewController.h"
#import "TTTableViewController.h"

@interface TTViewController ()

@property (nonatomic, strong) TTTableViewController *myTableViewController;

@end

@implementation TTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
//    self.myTableViewController = [[TTTableViewController alloc] initWithStyle:UITableViewStylePlain];
    self.myTableViewController = [[TTTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    
    self.myTableViewController.view.frame = self.view.bounds; //take up whole screen
    
//    [self.view addSubview:self.myTableViewController.view];
    
    NSString *savedName = [[NSUserDefaults standardUserDefaults] objectForKey:@"name"];
    NSLog(@"the saved name is %@", savedName);
}
- (IBAction)PresentTableViewButtonPressed:(id)sender {
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:self.myTableViewController];
    
//    [self presentViewController:self.myTableViewController animated:YES completion:nil];
    
    [self presentViewController:navController animated:YES completion:nil];
    
}
- (IBAction)pressedSegmentedViewController:(id)sender {
    UISegmentedControl *segmentedControl = (UISegmentedControl *) sender;
    NSInteger selectedSegment = segmentedControl.selectedSegmentIndex;
    
    if (selectedSegment == 0) {
        //toggle the correct view to be visible
        [firstView setHidden:NO];
        [secondView setHidden:YES];
    }
    else{
        //toggle the correct view to be visible
        [firstView setHidden:YES];
        [secondView setHidden:NO];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
