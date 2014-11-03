//
//  HWViewController.m
//  HelloWorld
//
//  Created by Yukti Abrol on 9/9/14.
//  Copyright (c) 2014 Yukti. All rights reserved.
//

#import "HWViewController.h"

@interface HWViewController ()
@property (strong, nonatomic) IBOutlet UILabel *myAwesomeLabel;
@property (assign, nonatomic) int theCount;
@property (strong, nonatomic) IBOutlet UITextField *myTextField;

@property (strong, nonatomic) NSArray *validPasswords;

@end

@implementation HWViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSLog(@"Hello Console, my good friend");//prints this in the console
    NSLog(@"Hello again.");
    
    self.myAwesomeLabel.text = @"Hello Goats";
    
    int k = 5;
    
    for (int j=0; j <k; j++) {
        NSLog(@"j = %d",j);
    }
    
    if(k==5){
        NSLog(@"k was 5");
    }
    else{
        NSLog(@"k was not 5");
    }
    
    self.theCount = 0; //initialized at 0
    
    //NSArray *myArray = [[NSArray alloc] init];
    //nesting functions -> calling init on return of alloc
    //nsarray is wrapper class around C array
    //NS = next step
    //creates empty array -> for objects (doesnt have to be all strings, etc)
    
    NSArray *myArray = [[NSArray alloc] initWithObjects:@"dog", @"cat", @"goat", nil];
    NSLog(@"my array is: %@", myArray);
    //%@ for objects
    //immutable array
    
    NSArray *myLiteralArray = @[@"apple",@"orange",@"banana"];
    //shorthand to do myarray
    NSLog(@"my literal array is: %@", myLiteralArray);
    
    
    NSMutableArray *myMutableArray = [[NSMutableArray alloc] init];
    [myMutableArray addObject:@"red"];
    [myMutableArray addObject:@"green"];
    [myMutableArray addObject:@"yellow"];
    [myMutableArray addObjectsFromArray:myLiteralArray];
    
    NSLog(@"my mutable array is: %@", myMutableArray);
    
    NSMutableArray *mutableVersionOfLiteralArray = [myLiteralArray mutableCopy];
    [mutableVersionOfLiteralArray addObject:@"iPhone"];
    //trying to do literal version of mutable array. a bit tougher
    
    NSLog(@"my mutable array is: %@", mutableVersionOfLiteralArray);
    
    NSDictionary *dictionary1 = [[NSDictionary alloc] initWithObjectsAndKeys:@"Tim",@"first name", @"Nordosov", @"last name", @"iOS programming", @"passion",  nil];
    
    NSLog(@"the dictionary is: %@", dictionary1);
    
    NSMutableDictionary *mutableDictionary = [[NSMutableDictionary alloc] init];
    [mutableDictionary setObject:@"cornell tech" forKey:@"my fave campus"];
    [mutableDictionary setObject:@"stanford" forKey:@"my least fave uni"];
    
    NSLog(@"my mutable dictionary is: %@", mutableDictionary);
    
    NSDictionary *literalDictionary = @{@"fave fruit": @"passion fruit", @"fave array": myMutableArray};
    
    NSLog(@"my literal dictionary: %@", literalDictionary);
    
    self.validPasswords  =@[@"estrin", @"ramin"];
    
    NSLog(@"the valid passowords are: \n%@", self.validPasswords);
}

- (IBAction)myButtonPressed:(id)sender {
    self.theCount++;
    if(self.theCount == 1)
    {
        NSLog(@"I've been pressed once.");
    }
    else
    {
        NSLog(@"I've been pressed %d", self.theCount);
    }
    
    NSLog(@"I've been pressed!");
    
    NSLog(@"the text field is: %@", self.myTextField.text);
    
    NSString *attemptedPassword = self.myTextField.text;
    
//    for(NSString *password in self.validPasswords){
//        if([password isEqualToString:attemptedPassword]){
//            NSLog(@"Success");
//        }
//    }
    
    
//    BOOL didSucceed = NO;
//    
//    for(NSString *password in self.validPasswords){
//        if([password isEqualToString:attemptedPassword]){
//            didSucceed = YES;
//        }
//    }
//    if(didSucceed){
//        NSLog(@"Success");
//    }
//    else{
//        NSLog(@"Failure");
//    }
    
    if([self.validPasswords containsObject:attemptedPassword]){
        NSLog(@"Success!");
    }//contains object uses isequal method inside it
    else{
        NSLog(@"Fail!");
        [UIView animateWithDuration:2
                         animations:^{self.myTextField.center = CGPointMake(160, 900);}];
    }
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
