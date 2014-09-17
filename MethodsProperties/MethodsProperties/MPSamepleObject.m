//
//  MPSamepleObject.m
//  MethodsProperties
//
//  Created by Yukti Abrol on 9/16/14.
//  Copyright (c) 2014 Yukti. All rights reserved.
//

#import "MPSamepleObject.h"

@interface MPSamepleObject()

@property (nonatomic, strong) NSString *privateStringProperty;

@end

@implementation MPSamepleObject

- (void) doStuff {
    
    self.privateStringProperty = @"the value of the private string property";
    
    [self doPrivateStuff];
}

- (void) doPrivateStuff {
    
    NSLog(@"%@",self.privateStringProperty);
    
//    [self doStuffParameter1:@"so much wow" Parameter2:@"all the things!"];
}

- (void) doStuffParameter1: (NSString *) parameter1 Parameter2: (NSString *) parameter2{
    //ctrl + click on function name to refactor
    NSLog(@" parameter 1: %@", parameter1);
    NSLog(@" parameter 2: %@", parameter2);
}

@end
