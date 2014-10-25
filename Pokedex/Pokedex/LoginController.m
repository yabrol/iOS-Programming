//
//  LoginController.m
//  Pokedex
//
//  Created by Yukti Abrol on 10/25/14.
//  Copyright (c) 2014 Yukti. All rights reserved.
//

#import "LoginController.h"

@interface LoginController ()

@end

@implementation LoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)pushedLoginButton:(id)sender {
    //check if credentials correct
    NSDictionary *credentials;
    NSArray *users;
    NSString *username = @"";
    
    if(username.length < 1){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No User" message:@"There is no user, sign up" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    
    [self performSegueWithIdentifier:@"LoginSegue" sender:self];
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
