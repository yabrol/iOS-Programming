//
//  MPSampleObject.h
//  MethodsProperties
//
//  Created by Tim Novikoff on 9/16/14.
//  Copyright (c) 2014 Tim Novikoff. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MPSampleObject : NSObject

@property (nonatomic,strong) NSString *publicStringProperty;

- (void) doStuff;
- (void) doStuffParameter1: (NSString *) parameter1 parameter2: (NSString *) parameter2;

@end
