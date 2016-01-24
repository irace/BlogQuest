//
//  BQUserNode.m
//  BlogQuest
//
//  Created by Brian Michel on 5/8/14.
//  Copyright (c) 2014 Brian Michel. All rights reserved.
//

#import "BQUserNode.h"
#import "BQCollisions.h"
#import "BQCredentials.h"
#import "SDWebImageManager.h"
#import "SKNode+Audio.h"

static CGFloat const UserStepSize = 3;
static CGFloat const UserJumpMagnitude = 60;

@interface BQUserNode()

@property (nonatomic) BOOL canSquish;

@end

@implementation BQUserNode

- (id)init {
    if (self = [super initWithImageNamed:@"gene"]) {
        self.name = @"User";
        self.physicsBody.categoryBitMask = CATEGORY_MAIN_CHARACTER;
        self.physicsBody.collisionBitMask = CATEGORY_ENEMIES;
        self.physicsBody.contactTestBitMask = CATEGORY_COLLECTIBLES | CATEGORY_ENEMIES;
        
        self.physicsBody.friction = 0.8;
        
        [self loadAvatarForBlogName:[BQCredentials blogName]];
        
        self.canSquish = YES;
    }
    
    return self;
}

- (void)moveForwardUpdatingPosition:(BOOL)updatePosition {
    if (updatePosition) {
        [self runAction:[SKAction moveByX:UserStepSize y:0 duration:0.5]];
    }
}

- (void)jump {
    [self.physicsBody applyImpulse:CGVectorMake(0, UserJumpMagnitude)];
    [self playEffectNamed:@"jump" wait:NO];
    
    self.canSquish = YES;
}

@end
