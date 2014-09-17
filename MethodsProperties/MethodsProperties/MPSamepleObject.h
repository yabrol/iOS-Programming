//
//  MPSamepleObject.h
//  MethodsProperties
//
//  Created by Yukti Abrol on 9/16/14.
//  Copyright (c) 2014 Yukti. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MPSamepleObject : NSObject

@property (nonatomic, strong) NSString *publicStringProperty;
//anyone can read an h file, but m file is

//public methods declarations
- (void) doStuff;

- (void) doStuffParameter1: (NSString *) parameter1 Parameter2: (NSString *) parameter2;

@end
