//
//  BQCollectableManager.h
//  BlogQuest
//
//  Created by Bryan Irace on 5/8/14.
//  Copyright (c) 2014 Bryan Irace. All rights reserved.
//

@import SpriteKit;
@protocol BQCollectableManagerDelegate;
#import "BQPost.h"

@interface BQCollectableManager : NSObject

- (instancetype)initWithScene:(SKScene *)scene delegate:(id<BQCollectableManagerDelegate>)delegate;

- (void)update:(CFTimeInterval)currentTime;

- (BOOL)containsNode:(SKNode *)node;

- (void)handleCollisionWithNode:(SKNode *)node;

@end

@protocol BQCollectableManagerDelegate <NSObject>

- (BQPost *)nextPost;

@end
