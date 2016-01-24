//
//  BQEnemyNode.m
//  BlogQuest
//
//  Created by Brian Michel on 5/8/14.
//  Copyright (c) 2014 Brian Michel. All rights reserved.
//

#import "BQEnemyNode.h"
#import "BQCollisions.h"

#define DEG_TO_RAD(__DEGREE__) (__DEGREE__ * (M_PI / 180))

@implementation BQEnemyNode

+ (BQEnemyNode *)spawnEnemyType:(BQEnemyNodeType)type inBounds:(CGRect)bounds {
    NSMutableArray *images = [NSMutableArray array];
    
    switch (type) {
        case BQEnemyNodeTypeBlade:
            [images addObject:[SKTexture textureWithImageNamed:@"enemy_blade01"]];
            [images addObject:[SKTexture textureWithImageNamed:@"enemy_blade02"]];
            break;
        case BQEnemyNodeTypeBurningMan:
            [images addObject:[SKTexture textureWithImageNamed:@"enemy_burn01"]];
            [images addObject:[SKTexture textureWithImageNamed:@"enemy_burn02"]];
            break;
        case BQEnemyNodeTypeOcto:
            //
            [images addObject:[SKTexture textureWithImageNamed:@"enemy_octo01"]];
            [images addObject:[SKTexture textureWithImageNamed:@"enemy_octo02"]];
            [images addObject:[SKTexture textureWithImageNamed:@"enemy_octo03"]];
            break;
        case BQEnemyNodeTypeBowser:
            [images addObject:[SKTexture textureWithImageNamed:@"enemy_16bowser01"]];
            [images addObject:[SKTexture textureWithImageNamed:@"enemy_16bowser02"]];
            [images addObject:[SKTexture textureWithImageNamed:@"enemy_16bowser03"]];
            [images addObject:[SKTexture textureWithImageNamed:@"enemy_16bowser04"]];
            [images addObject:[SKTexture textureWithImageNamed:@"enemy_16bowser05"]];
        default:
            break;
    }
    
    BQEnemyNode *enemy = [[self class] enemyForImages:images];
    enemy.xScale = 0.3;
    enemy.yScale = 0.3;
    enemy.position = CGPointMake(CGRectGetMaxX(bounds), arc4random_uniform(bounds.size.height));
    
    return enemy;
}

+ (BQEnemyNode *)enemyForImages:(NSArray *)images {
    SKTexture *firstFrame = images[0];
    
    BQEnemyNode *node = [[BQEnemyNode alloc] initWithTexture:firstFrame];
    [node runAction:[SKAction repeatActionForever:[SKAction animateWithTextures:images timePerFrame:0.3 resize:NO restore:YES]]];
    node.xScale = 0.3;
    node.yScale = 0.3;
    
    return node;
}

- (instancetype)initWithTexture:(SKTexture *)texture {
    self = [super initWithTexture:texture];
    if (self) {
        self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:(self.texture.size.width / 2)];
        self.physicsBody.dynamic = NO;
        self.physicsBody.categoryBitMask = CATEGORY_ENEMIES;
    }
    return self;
}

- (void)beginAnimatingToDesintation:(CGPoint)destination withCallback:(dispatch_block_t)callback {
    SKAction *rotation = [SKAction rotateByAngle:DEG_TO_RAD(0) duration:8.0];
    SKAction *move = [SKAction moveTo:destination duration:5];
    
    SKAction *actionGroup = [SKAction group:@[rotation, move]];
    [self runAction:actionGroup completion:callback];
}

- (void)beginDropAndWalkToDestination:(CGPoint)destination inBounds:(CGRect)bounds withCallback:(dispatch_block_t)callback {
    self.position = CGPointMake(CGRectGetWidth(bounds), 70);
    
    SKAction *walk = [SKAction moveTo:destination duration:5];
    
    [self runAction:walk completion:callback];
}


@end
