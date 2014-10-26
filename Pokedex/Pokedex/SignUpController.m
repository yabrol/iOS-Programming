//
//  SignUpController.m
//  Pokedex
//
//  Created by Yukti Abrol on 10/25/14.
//  Copyright (c) 2014 Yukti. All rights reserved.
//

#import "SignUpController.h"

@interface SignUpController ()
@property (strong, nonatomic) IBOutlet UITextField *userNameText;
@property (strong, nonatomic) IBOutlet UITextField *passwordText;

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
    UIAlertView *alert;
    //make sure not empty
    if([self.userNameText.text length]==0 || [self.passwordText.text length]==0){
        alert = [[UIAlertView alloc] initWithTitle:@"Values missing" message:@"Enter all fields" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    NSMutableDictionary *creds;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    creds = [[[defaults objectForKey:@"credentials"] mutableCopy] objectAtIndex:0];
    NSString *user = [self.userNameText.text lowercaseString];
    
    //make sure not already in userdefaults
    if([creds objectForKey:user] != nil)
    {
        alert = [[UIAlertView alloc] initWithTitle:@"Username Claimed" message:@"Try a different username" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    
    
    //add to user defaults
    if([creds count] == 0)
    {
        creds = [[NSMutableDictionary alloc] init];
    }
    [creds setValue:self.passwordText.text forKey:[self.userNameText.text lowercaseString]];
    
    [defaults setValue:creds forKey:@"credentials"];
    [defaults synchronize];
    
    NSLog(@"signed up %@", creds);
    [self performSegueWithIdentifier:@"LoginSignupSegue" sender:self];
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
