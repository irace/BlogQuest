//
//  BQCollectibleNode.h
//  BlogQuest
//
//  Created by Bryan Irace on 5/8/14.
//  Copyright (c) 2014 Bryan Irace. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "BQCollectable.h"

extern NSString * const BQCoinWasCollectedNotification;

@interface BQCoinNode : SKSpriteNode <BQCollectable>

+ (instancetype)followCoin;

+ (instancetype)likeCoin;

+ (instancetype)reblogCoin;

- (void)collect;

- (void)startSpinning;

- (void)stopSpinning;

@end
