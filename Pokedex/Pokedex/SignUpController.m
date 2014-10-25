//
//  SignUpController.m
//  Pokedex
//
//  Created by Yukti Abrol on 10/25/14.
//  Copyright (c) 2014 Yukti. All rights reserved.
//

#import "SignUpController.h"

@interface SignUpController ()

@end

@implementation SignUpController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)pushedSignUpButton:(id)sender {
    NSMutableDictionary *creds;
    NSMutableArray *usernames;
    NSArray *prevUserNames;
    NSUserDefaults *defaults;
    //make sure not already in userdefaults
    
    
    //add to user defaults
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
