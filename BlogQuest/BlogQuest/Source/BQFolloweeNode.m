//
//  BQFolloweeNode.m
//  BlogQuest
//
//  Created by Bryan Irace on 5/9/14.
//  Copyright (c) 2014 Bryan Irace. All rights reserved.
//

#import "BQFolloweeNode.h"
#import "BQCollisions.h"
#import "SKNode+Audio.h"

static CGFloat const AvatarInset = 6;
NSString * const BQFolloweeWasCollectedNotification = @"BQFolloweeWasCollectedNotification";

@interface BQFolloweeNode()

@property (nonatomic) BQPost *post;

@end

@implementation BQFolloweeNode

- (instancetype)initWithPost:(BQPost *)post {
    if (self = [super initWithImageNamed:@"avatar_ring"]) {
        self.physicsBody.dynamic = NO;
        self.physicsBody.categoryBitMask = CATEGORY_COLLECTIBLES;
        self.insets = UIEdgeInsetsMake(AvatarInset, AvatarInset, AvatarInset, AvatarInset);
        self.post = post;
        
        [self loadAvatarForBlogName:post.blogName];
    }
    
    return self;
}

#pragma mark - BQCollectibleNode

- (void)collect {
    [self playEffectNamed:@"holy" wait:NO];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:BQFolloweeWasCollectedNotification object:self.post];
    
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
}

@end
