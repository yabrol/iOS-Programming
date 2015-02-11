//
//  MPViewController.m
//  MethodsProperties
//
//  Created by Tim Novikoff on 9/16/14.
//  Copyright (c) 2014 Tim Novikoff. All rights reserved.
//

#import "MPViewController.h"
#import "MPSampleObject.h"

@interface MPViewController ()

@end

@implementation MPViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    MPSampleObject *sampleObject = [[MPSampleObject alloc] init];
    sampleObject.publicStringProperty = @"the value of public string property";
    
    NSLog(@"%@", sampleObject);
    NSLog(@"%@", sampleObject.publicStringProperty);
    
    //does not work bc it is a private property
//    sampleObject.privateStringProperty = @"the value of public string property";
    
    [sampleObject doStuff];
    
    [sampleObject doStuffParameter1:@"Rebecca Black" parameter2:@"why you no"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
