//
//  BQCollectibleNode.m
//  BlogQuest
//
//  Created by Bryan Irace on 5/8/14.
//  Copyright (c) 2014 Bryan Irace. All rights reserved.
//

#import "BQCoinNode.h"
#import "BQCollisions.h"
#import "SKNode+Audio.h"

NSString * const BQCoinWasCollectedNotification = @"BQCoinWasCollectedNotification";

@implementation BQCoinNode

#pragma mark - Initialization

+ (instancetype)followCoin {
    return [[self alloc] initWithImageNamed:@"follow"];
}

+ (instancetype)likeCoin {
    return [[self alloc] initWithImageNamed:@"like"];
}

+ (instancetype)reblogCoin {
    return [[self alloc] initWithImageNamed:@"reblog"];
}

- (instancetype)initWithImageNamed:(NSString *)name {
    if (self = [super initWithImageNamed:name]) {
        self.size = CGSizeMake(27.5, 27.5);
        self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.size];
        self.physicsBody.dynamic = NO;
        self.physicsBody.categoryBitMask = CATEGORY_COLLECTIBLES;
    }
    
    return self;
}

- (void)startSpinning {
    SKAction *spin1 = [SKAction scaleXTo:1.0 duration:0.5];
    
    SKAction *spin2 = [SKAction scaleXTo:-1.0 duration:0.5];
    
    SKAction *action = [SKAction sequence:@[spin1, spin2]];
    [self runAction:[SKAction repeatActionForever:action] withKey:@"spin"];
}

- (void)stopSpinning {
    [self removeActionForKey:@"spin"];
}


#pragma mark - BQCollectibleNode

- (void)collect {
    [[NSNotificationCenter defaultCenter] postNotificationName:BQCoinWasCollectedNotification object:nil];
    
    [self runAction:
     [SKAction sequence:@[
        [SKAction group:@[
            [SKAction fadeOutWithDuration:0.3],
            [SKAction moveByX:0 y:20 duration:0.2],
            [SKAction scaleBy:2 duration:0.3],
            [SKAction rotateByAngle:180 * M_PI / 180 duration:0.5]
        ]],
        [SKAction removeFromParent]
    ]]];
    [self playEffectNamed:@"coin" wait:NO];
}

@end
