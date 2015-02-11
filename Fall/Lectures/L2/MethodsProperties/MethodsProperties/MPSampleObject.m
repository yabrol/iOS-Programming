//
//  MPSampleObject.m
//  MethodsProperties
//
//  Created by Tim Novikoff on 9/16/14.
//  Copyright (c) 2014 Tim Novikoff. All rights reserved.
//

#import "MPSampleObject.h"

@interface MPSampleObject ()

@property (nonatomic, strong) NSString *privateStringProperty;

@end

@implementation MPSampleObject

- (void) doStuff{
    
    self.privateStringProperty = @"the value of private string property";
    
    [self doPrivateStuff];
}

- (void) doPrivateStuff{
    NSLog(@"%@", self.privateStringProperty);
    
//    [self doStuffParameter1:@"so much wow" parameter2:@"all the things!"];
}

- (void) doStuffParameter1: (NSString *) parameter1 parameter2: (NSString *) parameter2{
    
    NSLog(@"parameter 1: %@", parameter1);
    NSLog(@"parameter 2: %@", parameter2);
}
@end
