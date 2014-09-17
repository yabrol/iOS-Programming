//
//  HW1AdvancedViewController.m
//  HW1Advanced
//
//  Created by Yukti Abrol on 9/13/14.
//  Copyright (c) 2014 Yukti. All rights reserved.
//

#import "HW1AdvancedViewController.h"

@interface HW1AdvancedViewController ()
@property (strong, nonatomic) IBOutlet UITextField *firstTextbox;
@property (strong, nonatomic) IBOutlet UITextField *secondTextbox;
@property (strong, nonatomic) IBOutlet UILabel *combinedText;

@property (strong, nonatomic) IBOutlet UITextField *combinedTextbox;
@property (strong, nonatomic) IBOutlet UILabel *firstText;
@property (strong, nonatomic) IBOutlet UILabel *secondText;

@property (strong, nonatomic) NSMutableArray *myList;
@property (strong, nonatomic) NSMutableDictionary *myDict;

@end

@implementation HW1AdvancedViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    //create arrays
    self.myList = [[NSMutableArray alloc] init];
    self.myDict = [[NSMutableDictionary alloc] init];
}
- (IBAction)combineButtonPressed:(id)sender {
    NSString *word1 = self.firstTextbox.text;
    NSString *word2 = self.secondTextbox.text;
    
    NSString *combinedWord = [word1 stringByAppendingString:word2];
    
    self.combinedText.text = combinedWord;
    
    [self.myList addObject:combinedWord];
    
    NSArray *theWords = @[word1, word2];
    
    [self.myDict setObject:theWords forKey:combinedWord];
    
    NSLog(@"current list of portmanteaus: %@", self.myList);
    NSLog(@"Current portmanteau dictionary: %@", self.myDict);
    
}
- (IBAction)showPiecesButtonPressed:(id)sender {
    NSString *fullWord = self.combinedTextbox.text;
    
    if(self.myDict [fullWord]){
        NSArray *theWords = [self.myDict objectForKey:fullWord];
        self.firstText.text = theWords[0];
        self.secondText.text = theWords[1];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
