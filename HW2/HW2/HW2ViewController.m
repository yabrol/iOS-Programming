//
//  HW2ViewController.m
//  HW2
//
//  Created by Yukti Abrol on 9/17/14.
//  Copyright (c) 2014 Yukti. All rights reserved.
//

#import "HW2ViewController.h"
#import "HW2TableViewController.h"

@interface HW2ViewController ()
@property (strong, nonatomic) IBOutlet UITextField *itemNameField;
@property (strong, nonatomic) IBOutlet UITextField *itemDescriptionField;
@property (strong, nonatomic) IBOutlet UIButton *addToListButton;
@property (strong, nonatomic) HW2TableViewController *viewController;

@end

@implementation HW2ViewController
{
    int segment;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.viewController = [[HW2TableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    
    self.viewController.view.frame = self.view.bounds;
    
//    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"toBuyDict"];
//    self.viewController.toBuyDict = [NSKeyedUnarchiver unarchiveObjectWithData:data];
//    NSData *data2 =[[NSUserDefaults standardUserDefaults] objectForKey:@"toDoDict"];
//    self.viewController.toDoDict = [NSKeyedUnarchiver unarchiveObjectWithData:data2];
    
}
- (IBAction)viewListButtonPressed:(id)sender {
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:self.viewController];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(myCustomSelector:)];
    
    [self.viewController.navigationItem setRightBarButtonItem:doneButton];
    [self presentViewController:navController animated:YES completion:nil];
    
}

- (IBAction)addToListButtonPressed:(id)sender {
    
    if(segment==1){
        //to do
        NSLog(@"in to do list loop");
        
        [self.viewController addToDoDictKey:self.itemNameField.text andObject:self.itemDescriptionField.text];
        NSLog(@"button press do: %@",self.viewController.toDoDict);
        
    }
    else if (segment==0){
        //to buy
        NSLog(@"in to buy list loop");
        
        [self.viewController addToBuyDictKey:self.itemNameField.text andObject:self.itemDescriptionField.text];
        NSLog(@"button press buy: %@", self.viewController.toBuyDict);
        
    }
    
    self.itemDescriptionField.text = nil;
    self.itemNameField.text = nil;
    
    //save in memory for next usage of app
//        [[NSUserDefaults standardUserDefaults] setObject:self.viewController.toDoDict forKey:@"toDoDict"];
//        [[NSUserDefaults standardUserDefaults] setObject:self.viewController.toBuyDict forKey:@"toBuyDict"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

- (IBAction)segmentedButtonPressed:(id)sender {
    UISegmentedControl *control = (UISegmentedControl *) sender;
    segment = control.selectedSegmentIndex;
}

- (void) myCustomSelector: (id) sender{
    NSLog(@"pressed done");
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
