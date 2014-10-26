//
//  FirstViewController.m
//  Pokedex
//
//  Created by Yukti Abrol on 10/25/14.
//  Copyright (c) 2014 Yukti. All rights reserved.
//

#import "FirstViewController.h"

@interface FirstViewController ()
@property (strong, nonatomic) IBOutlet UITextView *labelText;

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //get info
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *nameList = [defaults objectForKey:@"names"];
    NSArray *typeList = [defaults objectForKey:@"types"];
    NSArray *descList = [defaults objectForKey:@"desc"];
    NSString *row = [defaults objectForKey:@"row"];
    int test = [row intValue];
    
    self.labelText.text = [NSString stringWithFormat:@"Name: %@ \nType: %@ \nDescription: %@",
                           [nameList objectAtIndex:test],
                           [typeList objectAtIndex:test],
                           [descList objectAtIndex:test]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
