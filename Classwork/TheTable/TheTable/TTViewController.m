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
@property (strong, nonatomic) IBOutlet UISegmentedControl *mySegmentedController;

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
    
//    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(dismissModalViewControllerAnimated:)];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(myCustomSelector:)]; //don't need last colon

    
    [self.myTableViewController.navigationItem setRightBarButtonItem:doneButton];
    
//    [self presentViewController:self.myTableViewController animated:YES completion:nil];
    
    [self presentViewController:navController animated:YES completion:nil];
    
}

- (void) myCustomSelector: (id) sender{
    NSLog(@"donion rings");
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)pressedSegmentedViewController:(id)sender {
//    int n = self.mySegmentedController.selectedSegmentIndex;
    UISegmentedControl *control = (UISegmentedControl *) sender;
    int n = control.selectedSegmentIndex;
    NSLog(@"%d", n);
    
     }

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
