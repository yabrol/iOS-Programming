//
//  HW1ViewController.m
//  HW1
//
//  Created by Yukti Abrol on 9/13/14.
//  Copyright (c) 2014 Yukti. All rights reserved.
//

#import "HW1ViewController.h"

@interface HW1ViewController ()
@property (strong, nonatomic) IBOutlet UITextField *firstTextbox;
@property (strong, nonatomic) IBOutlet UITextField *secondTextbox;
@property (strong, nonatomic) IBOutlet UILabel *combinedText;

@property (strong, nonatomic) NSMutableArray *myList;

@end

@implementation HW1ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    //create array
    self.myList = [[NSMutableArray alloc] init];
}
- (IBAction)combineButtonPressed:(id)sender {
    NSString *word1 = self.firstTextbox.text;
    NSString *word2 = self.secondTextbox.text;
    
    NSString *combinedWord = [word1 stringByAppendingString:word2];
    
    self.combinedText.text = combinedWord;
    
    [self.myList addObject:combinedWord];
    
    NSString *printList = @"";
    for( NSString *words in self.myList){
        printList = [printList stringByAppendingString:words];
        printList = [printList stringByAppendingString:@"\n"];
    }
    NSLog(@"Current list of portmanteaus: (\n%@)",printList);
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
