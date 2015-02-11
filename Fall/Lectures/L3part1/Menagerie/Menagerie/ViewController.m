//
//  ViewController.m
//  Menagerie
//
//  Created by Tim Novikoff on 9/23/14.
//  Copyright (c) 2014 Tim Novikoff. All rights reserved.
//

#import "ViewController.h"
#import "TableViewController.h"

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UITextField *detailTextField;
@property (strong, nonatomic) IBOutlet UITextField *mainTextField;
@property (strong, nonatomic) IBOutlet UISegmentedControl *mySegmentedControl;
@property (strong, nonatomic) NSMutableDictionary *allItems;
@property (strong, nonatomic) TableViewController *tableViewController;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.allItems = [[NSUserDefaults standardUserDefaults] objectForKey:@"allItems"];
    
    if (self.allItems == nil) {
        self.allItems = [[NSMutableDictionary alloc] init];
    }
    
}
- (IBAction)addToListButtonPressed:(id)sender {
    NSLog(@"add-to-list button pressed");
    
    NSMutableArray *array;
    NSString *key;
    if (self.mySegmentedControl.selectedSegmentIndex == 0) {
        key = @"needsView";
    }
    else{
        key = @"noViewNeeded";
    }
    array = [[self.allItems objectForKey: key] mutableCopy];
    
    if (array == nil) {
        array = [[NSMutableArray alloc] init];
    }

    NSString *mainText = self.mainTextField.text;
    NSString *detailText = self.detailTextField.text;
    
    NSDictionary *dictionary = @{@"mainText": mainText, @"detailText": detailText};
    
    [array addObject:dictionary];
    
    [self.allItems setObject:array forKey:key];
    
    [[NSUserDefaults standardUserDefaults] setObject:self.allItems forKey:@"allItems"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    self.mainTextField.text = @"";
    self.detailTextField.text = @"";
    
    [self.mainTextField becomeFirstResponder];
}
- (IBAction)showListButtonPressed:(id)sender {
    NSLog(@"allItemsDictionary: \n%@", self.allItems);
    
    self.tableViewController = [[TableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    self.tableViewController.allItemsDictionary = self.allItems;
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:self.tableViewController];
    
    [self presentViewController:navController animated:YES completion:^{
        NSLog(@"the thing finished presenting");
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
