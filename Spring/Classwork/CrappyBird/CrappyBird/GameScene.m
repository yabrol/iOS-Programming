//
//  GameScene.m
//  CrappyBird
//
//  Created by Yukti on 3/9/15.
//  Copyright (c) 2015 Yukti. All rights reserved.
//

#import "GameScene.h"
#import "CPPipeSpriteNode.h"

static const CGFloat kGroundHeight = 56.0;

static const uint32_t kPlayerCategory = 0x1 << 0;
static const uint32_t kPipeCategory = 0x1 << 1;
static const uint32_t kGroundCategory = 0x1 << 2;

@implementation GameScene{
    //instance variables
    SKSpriteNode *_ground;
    SKSpriteNode *_player;
    NSTimer *_timer;
    
}

- (id) initWithSize:(CGSize)size{
    if ([super initWithSize:size]) {
        //custom init code
        self.backgroundColor = [SKColor colorWithRed:.69 green:.84 blue:.97 alpha:1];
        
        //position of sprite is middle. if no position given, is automatically put in left bottom corner
        _ground = [SKSpriteNode spriteNodeWithImageNamed:@"Ground"];
        //stretch ground
        [_ground setXScale:self.size.width/kGroundHeight]; //image is 56x56
        _ground.position = CGPointMake(self.size.width/2, _ground.size.height/2);//move up & to center
        
        //physics world for whole world. physics body for just one obj
        self.physicsWorld.gravity = CGVectorMake(0, -9.8);
        
        [self addChild:_ground];
        
        [self setUpPlayer];
        
//        [self addObstacle];
        _timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(addObstacle) userInfo:nil repeats:YES];
        
        //for collisioins
        _ground.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:_ground.size];
        [_ground.physicsBody setAffectedByGravity:NO];
        [_ground.physicsBody setDynamic:NO];
        
        [self.physicsWorld setContactDelegate:self];
        
        //ground and bird can collide
        [_ground.physicsBody setCategoryBitMask:kGroundCategory];
        [_ground.physicsBody setCollisionBitMask:kPlayerCategory];
        
        
    }
    return self;
}

//creates random float between min and max
static const CGFloat randomFloat(CGFloat Min, CGFloat Max){
    return floor(((rand()%RAND_MAX)/(RAND_MAX*1.0))*(Max-Min)+Min);
}

-(void) addObstacle{
    CGFloat centerY = randomFloat(100,400);
    CGFloat pipeBottomHeight = (self.size.height - kGroundHeight) - (centerY + (120/2));
    
    CPPipeSpriteNode *pipeBottom = [CPPipeSpriteNode pipeWithHeight:pipeBottomHeight];
    
    [self addChild:pipeBottom];
    
    //moves pipe across
    SKAction *pipeAction = [SKAction moveToX:-(pipeBottom.size.width/2) duration:6];
    [pipeBottom runAction:pipeAction completion:^{
        [pipeBottom removeFromParent];
    }];
}

-(void) setUpPlayer{
    _player = [SKSpriteNode spriteNodeWithImageNamed:@"Bird"];
    _player.position = CGPointMake(self.size.width/2, self.size.height/2);
    
    
    _player.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:_player.size];
    
    [self addChild:_player];
//    [_player.physicsBody setAllowsRotation:NO];
    
    [_player.physicsBody setCategoryBitMask:kPlayerCategory];
    [_player.physicsBody setContactTestBitMask:kPipeCategory | kGroundCategory];
//    [_player.physicsBody setCollisionBitMask:kPipeCategory|kGroundCategory];
    
    _player.physicsBody.restitution = 0.5;
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    _player.physicsBody.velocity = CGVectorMake(0, 400);
//    _player.physicsBody.angularVelocity = 1.5*_player.physicsBody.angularVelocity + .01;
//    _player.physicsBody.angularDamping = 1;
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

-(void)didBeginContact:(SKPhysicsContact *)contact{
    NSLog(@"contact");
    SKAction *_punchSound = [SKAction playSoundFileNamed:@"punch3.mp3" waitForCompletion:NO];
    [self runAction:_punchSound];
}

@end
