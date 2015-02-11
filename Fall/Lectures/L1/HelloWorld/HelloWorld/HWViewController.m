//
//  HWViewController.m
//  HelloWorld
//
//  Created by Tim Novikoff on 9/6/14.
//  Copyright (c) 2014 Tim Novikoff. All rights reserved.
//

#import "HWViewController.h"

@interface HWViewController ()
@property (strong, nonatomic) IBOutlet UILabel *myAwesomeLabel;
@property (assign, nonatomic) int myCounter;
@property (strong, nonatomic) IBOutlet UITextField *myTextField;
@property (strong, nonatomic) NSArray *validPasswords;
@end

@implementation HWViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //this allocates and intitializes the property validPasswords
    self.validPasswords = @[@"eggs", @"milk", @"ham"];

    //this is how you change the text of a label
    self.myAwesomeLabel.text = @"Goat";

    //this is how you log something in the console
    NSLog(@"Hello Console!");
    
    //this is how you create an integer whose scope is the enclosing function
    int myInteger = 5;
    
    //this is how you log an integer. (Or a BOOL, incidentally.)
    //NSLog takes a formatted string, and %d is the syntax for an int or BOOL
    NSLog(@"My integer is: %d", myInteger);
    
    //this is the syntax for if statements. notice double == for comparison
    if (myInteger == 5) {
        NSLog(@"the integers were equal");
    }
    else{
        NSLog(@"the integers were not equal");
    }
    
    //this is the syntax for a for-loop
    for (int i = 0; i<myInteger; i++) {
        NSLog(@"%d", i);//this logs an integer without anything else
    }
    
    //this is how you create a string.
//    NSString *sampleString = @"sample";
    
    //this is another way to create a string.
    //the part to the right of the equals sign is equivalent to @""
    NSString *anotherString = [[NSString alloc] init];
    
    //this exemplifies using a method on NSString for appending strings to other strings
    NSString *thirdString = [anotherString stringByAppendingString:@" goat"];
    
    //this logs a string
    NSLog(@"%@", thirdString);
    
    //this is how you create an array
    NSArray *myArray = [[NSArray alloc] initWithObjects:@"cat", @"dog", @"spacegoat", nil];
    
    //this is how you log an array. you can log any object (NSBlah) using %@ in the formmated string. The \n logs things on a new line
    NSLog(@"My array is:\n%@", myArray);
    
    //this is how you create a MUTABLE array. we can alter mutable objects
    NSMutableArray *myFirstMutableArray = [[NSMutableArray alloc] init];
    NSLog(@"My mutable array:\n%@", myFirstMutableArray);
    
    //this is how you add an object to a mutable array
    [myFirstMutableArray addObject:@"frog"];
    NSLog(@"My mutable array:\n%@", myFirstMutableArray);
    
    //this is how you add all the objects in one array into another array
    [myFirstMutableArray addObjectsFromArray:myArray];
    NSLog(@"My mutable array:\n%@", myFirstMutableArray);
    
    //this is how you create an array with literals
    NSArray *literalArray = @[@"dragon", @"unicorn", @"penguin"];
    [myFirstMutableArray addObjectsFromArray:literalArray];
    NSLog(@"My mutable array:\n%@", myFirstMutableArray);
    
    //there's literals for mutable objects, but you can make a mutable copy like this
    NSMutableArray *mutableFromLiteralArray = [literalArray mutableCopy];
    [mutableFromLiteralArray insertObject:@"spacegoat" atIndex:2];
    NSLog(@"My mutable literal array:\n%@", mutableFromLiteralArray);
    
    //this is how you create a mutable dictionary
    //there's a literal for dictionaries, but we didn't go over it in class (google it!)
    NSMutableDictionary *myMutableDictionary = [[NSMutableDictionary alloc] init];
    [myMutableDictionary setObject:@"dog" forKey:@"my favorite house pet"];
    [myMutableDictionary setObject:@"goat" forKey:@"my favorite barn animal"];
    NSLog(@"my dictionary: %@", myMutableDictionary);
    
    //this is how you querry a dictionary
    NSString *animal = [myMutableDictionary objectForKey:@"my favorite barn animal"];
    NSLog(@"the animal is: %@", animal);
}

//
- (IBAction)myButtonPressed:(id)sender {
    
    //at first we created and initialized validPasswords here, before making it a class property and moving that code into viewDidLoad
//    NSArray *validPasswords = @[@"eggs", @"milk", @"ham"];

    
    //this gets the string from the text field
    NSString *attemptedPassword = self.myTextField.text;
    
    //this is how you instantiate a BOOL. Note that there is no * because it's not a pointer
    BOOL valid = NO;
    
    //this loop goes through validPasswords and flips the BOOL to yes if there's a match
    //note there are a few quicker ways to achieve this. exercise for the reader!
    for (int i = 0; i<self.validPasswords.count; i++) {
        NSString *validPassword = [self.validPasswords objectAtIndex:i];
        if ([attemptedPassword isEqualToString:validPassword]) {
            valid = YES;
        }
    }
    
    if (valid) {
        NSLog(@"valid password");
    }
    else{
        NSLog(@"invalid password");
    }
    

    //here we increment the counter.
    self.myCounter = self.myCounter + 1;
    NSLog(@"the button has been pressed %d times.", self.myCounter);

    //this is how you create an NSString using the formatted string structure
    NSString *myString = [NSString stringWithFormat:@"pressed %d", self.myCounter];
    
    //changes what shows up in the label on the iPhone.
    self.myAwesomeLabel.text = myString;
    
    //well, this is just how you log stuff
    NSLog(@"I've been pressed!");
    
    //this changes the text to camel
    self.myAwesomeLabel.text = @"Camel";//overrides teh previous setting of the label's text, and overridden again later
    
    //this logs a formatted string with a string inserted
    NSLog(@"My favorite barn animal is: %@", self.myAwesomeLabel.text);
    
    //this changes the text of the label to reflect the contents of the text field at the time that the button was pressed
    self.myAwesomeLabel.text = self.myTextField.text;
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
