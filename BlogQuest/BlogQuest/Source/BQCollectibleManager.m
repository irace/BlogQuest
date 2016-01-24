//
//  BQCollectibleManager.m
//  BlogQuest
//
//  Created by Bryan Irace on 5/8/14.
//  Copyright (c) 2014 Bryan Irace. All rights reserved.
//

#import "BQCollectibleManager.h"
#import "BQCollectibleNode.h"

static CGFloat const StepSize = 10;

@interface BQCollectibleManager()

@property (nonatomic, weak) SKScene *scene;
@property (nonatomic) BQCollectibleNode *collectible;

@end

@implementation BQCollectibleManager

- (instancetype)initWithScene:(SKScene *)scene {
    if (self = [super init]) {
        _scene = scene;
    }
    
    return self;
}

- (void)update:(CFTimeInterval)currentTime {
    if (self.collectible) {
        self.collectible.position = CGPointMake(self.collectible.position.x - StepSize, self.collectible.position.y);

        if (![self.scene intersectsNode:self.collectible]) {
            [self.collectible removeFromParent];
            self.collectible = nil;
        }
    }
    else {
        self.collectible = [self randomCollectible];
        [self.scene addChild:self.collectible];
        [self.collectible startSpinning];
    }
}

#pragma - Private

- (BOOL)containsNode:(SKNode *)node {
    return self.collectible == node;
}

- (void)handleCollisionWithNode:(SKNode *)node {
    [self.collectible collected];
    self.collectible = nil;
}

- (BQCollectibleNode *)randomCollectible {
    static CGFloat const BottomMargin = 80;
    static CGFloat const TopMargin = 10;
    
    BQCollectibleNode *collectible;
    
    switch (arc4random_uniform(3)) {
        case 0:     collectible = [BQCollectibleNode heartNode];     break;
        case 1:     collectible = [BQCollectibleNode reblogNode];    break;
        default:    collectible = [BQCollectibleNode avatarNode];    break;
    }
    
    collectible.position = CGPointMake(CGRectGetWidth(self.scene.frame),
                                       arc4random_uniform(CGRectGetHeight(self.scene.frame) - BottomMargin - TopMargin) + BottomMargin);
    
    return collectible;
}

@end
