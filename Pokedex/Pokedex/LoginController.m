//
//  LoginController.m
//  Pokedex
//
//  Created by Yukti Abrol on 10/25/14.
//  Copyright (c) 2014 Yukti. All rights reserved.
//

#import "LoginController.h"

@interface LoginController ()
@property (strong, nonatomic) IBOutlet UITextField *usernameText;
@property (strong, nonatomic) IBOutlet UITextField *passwordText;

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
    UIAlertView *alert;
    //make sure not empty
    if([self.usernameText.text length]==0 || [self.passwordText.text length]==0){
        alert = [[UIAlertView alloc] initWithTitle:@"Values missing" message:@"Enter all fields" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    NSMutableDictionary *creds;
    NSMutableArray *usernames;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    creds = [[defaults objectForKey:@"credentials"] mutableCopy];
    usernames = [[defaults objectForKey:@"usernames"] mutableCopy];
    NSString *realpw = @"";
    //make sure already in userdefaults
    for(NSString *x in usernames){
        if([x caseInsensitiveCompare: self.usernameText.text])
        {
            //check if pw correct
            realpw = [creds objectForKey:[x lowercaseString]];
            if([self.passwordText.text isEqualToString:realpw]){
                NSLog(@"%@", creds);
                [self performSegueWithIdentifier:@"LoginSegue" sender:self];
            }
            alert = [[UIAlertView alloc] initWithTitle:@"Wrong password" message:@"Try again" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
    }
    
    //not there, send warning
    alert = [[UIAlertView alloc] initWithTitle:@"No such username" message:@"Sign up" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    return;
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
