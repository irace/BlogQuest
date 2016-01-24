//
//  BQcollectableManager.m
//  BlogQuest
//
//  Created by Bryan Irace on 5/8/14.
//  Copyright (c) 2014 Bryan Irace. All rights reserved.
//

#import "BQCollectableManager.h"
#import "BQCoinNode.h"
#import "BQFolloweeNode.h"
#import "BQPost.h"

static CGFloat const StepSize = 10;

@interface BQCollectableManager()

@property (nonatomic, weak) SKScene *scene;
@property (nonatomic, strong) SKNode<BQCollectable> *collectable;
@property (nonatomic, weak) id<BQCollectableManagerDelegate> delegate;

@end

@implementation BQCollectableManager

- (instancetype)initWithScene:(SKScene *)scene delegate:(id<BQCollectableManagerDelegate>)delegate {
    if (self = [super init]) {
        _delegate = delegate;
        _scene = scene;
    }
    
    return self;
}

- (void)update:(CFTimeInterval)currentTime {
    if (self.collectable) {
        self.collectable.position = CGPointMake(self.collectable.position.x - StepSize, self.collectable.position.y);
        
        if (![self.scene intersectsNode:self.collectable]) {
            [self.collectable removeFromParent];
            self.collectable = nil;
        }
    }
    else {
        static CGFloat const BottomMargin = 80;
        static CGFloat const TopMargin = 10;
        
        self.collectable = [self randomCollectable];
        
        if ([self.collectable respondsToSelector:@selector(startSpinning)]) {
            [self.collectable performSelector:@selector(startSpinning)];
        }
        
        self.collectable.position = CGPointMake(CGRectGetWidth(self.scene.frame),
                                                arc4random_uniform(CGRectGetHeight(self.scene.frame) - BottomMargin - TopMargin) + BottomMargin);
        
        [self.scene addChild:self.collectable];
    }
}

#pragma - Private

- (BOOL)containsNode:(SKNode *)node {
    return self.collectable == node;
}

- (void)handleCollisionWithNode:(SKNode *)node {
    [self.collectable collect];
    self.collectable = nil;
}

- (SKNode<BQCollectable> *)randomCollectable {
    switch (arc4random_uniform(4)) {
        case 0:
            return [BQCoinNode followCoin];
        case 1:
            return [BQCoinNode reblogCoin];
        case 2: {
            BQPost *post = [self.delegate nextPost];
            
            if (post) {
                return [[BQFolloweeNode alloc] initWithPost:post];
            }
        } default:
            return [BQCoinNode likeCoin];
    }
}

@end
