//
//  MPViewController.m
//  MethodsProperties
//
//  Created by Yukti Abrol on 9/16/14.
//  Copyright (c) 2014 Yukti. All rights reserved.
//

#import "MPViewController.h"
#import "MPSamepleObject.h"

@interface MPViewController ()

@end

@implementation MPViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    MPSamepleObject *sampleObject = [[MPSamepleObject alloc] init];
    sampleObject.publicStringProperty = @"the value of public string property";
    
    NSLog(@"%@", sampleObject);
    NSLog(@"%@",sampleObject.publicStringProperty);
    
    //sampleObject.privateStringProperty doesnt work b/c is a private property
    
    [sampleObject doStuff];
    
    [sampleObject doStuffParameter1:@"Rebecca Black" Parameter2:@"why you no"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
