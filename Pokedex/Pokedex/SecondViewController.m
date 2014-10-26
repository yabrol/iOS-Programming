//
//  SecondViewController.m
//  Pokedex
//
//  Created by Yukti Abrol on 10/25/14.
//  Copyright (c) 2014 Yukti. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //get info
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *row = [defaults objectForKey:@"row"];
    int test = [row intValue];
    test +=1;
    NSString *num;
    if (test < 100) {
        if (test < 10) {
            num = [NSString stringWithFormat:@"00%i", test];
        }
        else
        {
            num = [NSString stringWithFormat:@"0%i",test];
        }
    }
    else{
        num = [NSString stringWithFormat:@"%i",test];
    }
    NSString *path = [NSString stringWithFormat:@"%@.jpg",num];
    
    [self.imageView setImage:[UIImage imageNamed:path]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
