//
//  BQEnemyManager.m
//  BlogQuest
//
//  Created by Brian Michel on 5/8/14.
//  Copyright (c) 2014 Brian Michel. All rights reserved.
//

#import "BQEnemyManager.h"
#import "BQEnemyNode.h"
#import "BQUserNode.h"

@interface BQEnemyManager ()

@property (nonatomic) CFTimeInterval lastTimeInterval;
@property (nonatomic) NSUInteger outstandingEnemies;
@end


@implementation BQEnemyManager

- (instancetype)initWithScene:(SKScene *)scene {
    self = [super init];
    if (self) {
        _scene = scene;
    }
    return self;
}

- (void)update:(CFTimeInterval)time {
    CFTimeInterval delta = 0;
    if (self.lastTimeInterval) {
        delta = time - self.lastTimeInterval;
    }
    
    self.lastTimeInterval = time;
    [self spawnEnemiesWithTime:time];
}

- (BOOL)spawnEnemiesWithTime:(CFTimeInterval)time {
    if (!self.outstandingEnemies) {
        NSUInteger randomDivisor = arc4random_uniform(9);
        if (randomDivisor) {
            BOOL tryToSpawn = (int)time % randomDivisor;
            
            if (tryToSpawn) {
                //spawn
                [self spawnEnemies:arc4random_uniform(2)];
                return YES;
            }
        }
    }
    
    return NO;
}

- (void)spawnEnemies:(NSUInteger)numberOfEnemies {
    for (NSUInteger i = 0; i < numberOfEnemies; i++) {
        BQEnemyNodeType type = arc4random_uniform(4);
        BQEnemyNode *node = [BQEnemyNode spawnEnemyType:type inBounds:self.scene.frame];
        node.name = @"enemy";
        self.outstandingEnemies += 1;
        [self.scene addChild:node];
        
        typeof(self) __weak weakSelf = self;
        void (^callback)() = ^{
            weakSelf.outstandingEnemies -= 1;
            [node removeFromParent];
        };
        if (type == BQEnemyNodeTypeBowser) {
            [node beginDropAndWalkToDestination:CGPointMake(-100, 70) inBounds:self.scene.frame withCallback:callback];
        } else {
            [node beginAnimatingToDesintation:CGPointMake(-100, arc4random_uniform(self.scene.size.height)) withCallback:callback];
        }
    }
}

- (BOOL)containsNode:(SKNode *)node {
    return [node.name isEqualToString:@"enemy"];
}

@end
