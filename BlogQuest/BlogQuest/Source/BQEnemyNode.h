//
//  BQEnemyNode.h
//  BlogQuest
//
//  Created by Brian Michel on 5/8/14.
//  Copyright (c) 2014 Brian Michel. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef NS_ENUM(NSUInteger, BQEnemyNodeType) {
    BQEnemyNodeTypeBlade = 0,
    BQEnemyNodeTypeBurningMan,
    BQEnemyNodeTypeOcto,
    BQEnemyNodeTypeBowser
};

@interface BQEnemyNode : SKSpriteNode

+ (BQEnemyNode *)spawnEnemyType:(BQEnemyNodeType)type inBounds:(CGRect)bounds;

- (instancetype)initWithTexture:(SKTexture *)texture;
- (void)beginAnimatingToDesintation:(CGPoint)destination withCallback:(dispatch_block_t)callback;
- (void)beginDropAndWalkToDestination:(CGPoint)destination inBounds:(CGRect)bounds withCallback:(dispatch_block_t)callback;
@end
