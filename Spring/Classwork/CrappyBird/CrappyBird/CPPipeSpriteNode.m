//
//  CPPipeSpriteNode.m
//  CrappyBird
//
//  Created by Yukti on 3/9/15.
//  Copyright (c) 2015 Yukti. All rights reserved.
//

#import "CPPipeSpriteNode.h"
static const uint32_t kPlayerCategory = 0x1 << 0;
static const uint32_t kPipeCategory = 0x1 << 1;
static const uint32_t kGroundCategory = 0x1 << 2;

@implementation CPPipeSpriteNode

+(CPPipeSpriteNode *) pipeWithHeight: (float) height{
    NSString *pipeImageName;
    CGFloat pipeYOffset;
    
    pipeImageName = @"PipeBottom";
    pipeYOffset = 54;
    
    CPPipeSpriteNode *pipe = [[CPPipeSpriteNode alloc] initWithImageNamed:pipeImageName];
    [pipe setCenterRect:CGRectMake(26.0/56, 26.0/56, 4.0/56, 4.0/56)];
    //streches pipe
    [pipe setYScale:height/pipe.size.height];
    //puts bottom of pipe on top of ground
    [pipe setPosition:CGPointMake(320-(pipe.size.width/2), abs(pipeYOffset + (pipe.size.height/2)))];
    
    pipe.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:pipe.size];
    
    [pipe.physicsBody setAffectedByGravity:NO];
    [pipe.physicsBody setDynamic:NO];
    
    [pipe.physicsBody setCategoryBitMask:kPipeCategory];
    [pipe.physicsBody setContactTestBitMask:kPlayerCategory | kGroundCategory];
    
    return pipe;
}

@end
