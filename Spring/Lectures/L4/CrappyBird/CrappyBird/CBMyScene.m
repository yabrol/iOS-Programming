//
//  CBMyScene.m
//  CrappyBird
//
//  Created by Tim Novikoff on 3/8/14.
//  Copyright (c) 2014 Tim Novikoff. All rights reserved.
//

#import "CBMyScene.h"
#import "CBPipe.h"

static const CGFloat kGroundHeight = 56.0;

static const uint32_t kPlayerCategory = 0x1 << 0;
static const uint32_t kPipeCategory = 0x1 << 1;
static const uint32_t kGroundCategory = 0x1 << 2;


@implementation CBMyScene{
    SKSpriteNode *_ground;
    SKSpriteNode *_player;
    NSTimer *_pipeTimer;
    
}

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor colorWithRed:.69 green:.84 blue:.97 alpha:1];
        
        _ground = [SKSpriteNode spriteNodeWithImageNamed:@"Ground"];
        [_ground setCenterRect:CGRectMake(26.0/kGroundHeight, 26.0/kGroundHeight, 4.0/kGroundHeight, 4.0/kGroundHeight)];
        [_ground setXScale:self.size.width/kGroundHeight];
        [_ground setPosition:CGPointMake(self.size.width/2, _ground.size.height/2)];
        [self addChild:_ground];

        [self setupPlayer];
        
        _ground.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:_ground.size];
        [_ground.physicsBody setCategoryBitMask:kGroundCategory];
        [_ground.physicsBody setCollisionBitMask:kPlayerCategory];
        [_ground.   physicsBody setAffectedByGravity:NO];
        [_ground.physicsBody setDynamic:NO];

        _pipeTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(addObstacle) userInfo:nil repeats:YES];

        [self.physicsWorld setContactDelegate:self];
//        [self addObstacle];
    }
    return self;
}

static const CGFloat kPipeSpeed = 3.5;
static const CGFloat kPipeGap = 120;
static const CGFloat kPipeFrequency = kPipeSpeed/2;

static const CGFloat randomFloat(CGFloat Min, CGFloat Max){
    return floor(((rand() % RAND_MAX) / (RAND_MAX * 1.0)) * (Max - Min) + Min);
}

- (void) addObstacle{
    
    CGFloat centerY = randomFloat(100, 400);
    CGFloat pipeBottomHeight = (self.size.height - kGroundHeight) - (centerY + (kPipeGap/2));
    
    CBPipe *pipeBottom = [CBPipe pipeWithHeight:pipeBottomHeight];
    [self addChild:pipeBottom];

    // Move bottom pipe
    SKAction *pipeAction = [SKAction moveToX:-(pipeBottom.size.width/2) duration:6];
    [pipeBottom runAction:pipeAction completion:^{
        [pipeBottom removeFromParent];
    }];
}

- (void) setupPlayer{
    _player = [SKSpriteNode spriteNodeWithImageNamed:@"Bird"];
    [_player setPosition:CGPointMake(self.size.width/2, self.size.height/2)];
    [self addChild:_player];
    
    _player.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:_player.size];
    [_player.physicsBody setAllowsRotation:NO];

    
    [_player.physicsBody setCategoryBitMask:kPlayerCategory];
    [_player.physicsBody setContactTestBitMask:kPipeCategory | kGroundCategory];
    [_player.physicsBody setCollisionBitMask:kGroundCategory | kPipeCategory];

    [_player.physicsBody setRestitution:.1];
    

}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  [_player.physicsBody setVelocity:CGVectorMake(_player.physicsBody.velocity.dx, 400)];
}

-(void)update:(CFTimeInterval)currentTime {
}


- (void)didBeginContact:(SKPhysicsContact *)contact
{
    SKAction *_punchSound = [SKAction playSoundFileNamed:@"punch3.mp3" waitForCompletion:NO];
    [self runAction:_punchSound];
}
@end
