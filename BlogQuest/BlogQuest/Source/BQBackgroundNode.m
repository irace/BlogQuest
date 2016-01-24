//
//  BQBackgroundNode.m
//  BlogQuest
//
//  Created by Brian Michel on 5/8/14.
//  Copyright (c) 2014 Brian Michel. All rights reserved.
//

#import "BQBackgroundNode.h"

#define BQDefaultClampValue 80

@interface BQBackgroundNode()

@property (nonatomic) CGFloat maxEndWidth;

@property (nonatomic) BQRepeatableNode *weirdShitNode;
@property (nonatomic) BQRepeatableNode *housesNode;

@end

@implementation BQBackgroundNode
- (instancetype)initWithSize:(CGSize)size {
    self = [super init];
    if (self) {
        self.size = CGSizeMake(size.width, BQBackgroundNodeHeight);
        
        NSMutableArray *weirdShitArray = [NSMutableArray arrayWithCapacity:3];
        for (NSInteger i = 1; i < 4; i++) {
            NSString *weirdShitImageName = [NSString stringWithFormat:@"weird_%li", (long)i];
            [weirdShitArray addObject:weirdShitImageName];
        }
        self.weirdShitNode = [[BQRepeatableNode alloc] initWithImages:weirdShitArray size:self.size velocity:-17 identifier:@"weird_shit"];
        self.weirdShitNode.name = @"weird_shit";
        self.weirdShitNode.zPosition = -90;
        [self addChild:self.weirdShitNode];
        
        self.housesNode = [[BQRepeatableNode alloc] initWithImages:@[@"far_bg", @"far_bg"] size:self.size velocity:-2 identifier:@"houses"];
        self.housesNode.alpha = 1.0;
        self.housesNode.name = @"houses";
        self.housesNode.zPosition = -95;
        self.housesNode.position = CGPointMake(0, -210);
        [self addChild:self.housesNode];
    }
    return self;
}

- (void)update:(CFTimeInterval)time {
    [self.weirdShitNode update:time];
    [self.housesNode update:time];
}

- (void)addNewBuildings {
    NSUInteger numberOfBuildingsToAdd = [self numberOfBulidingsToAdd];
    for (NSUInteger i = 0; i < numberOfBuildingsToAdd; i++) {
        SKSpriteNode *building = [self newBuildingNode];
        building.position = CGPointMake(self.maxEndWidth + (i * building.size.width) + arc4random_uniform(80), 0);
        
        self.maxEndWidth = building.position.x + building.size.width;
        [self addChild:building];
    }
}

- (NSUInteger)numberOfBulidingsToAdd {
    return  arc4random() % 6;
}

- (SKSpriteNode *)newBuildingNode {
    SKSpriteNode *node = [[SKSpriteNode alloc] initWithTexture:[SKTexture textureWithImage:[UIImage imageNamed:@"background"]]];
    node.xScale = 0.5;
    node.yScale = 0.5;
    node.zPosition = -100;
    node.name = @"bulding";

    return node;
}
@end

@interface BQRepeatableNode ()

@property (nonatomic) NSString *identifier;

@end

@implementation BQRepeatableNode {
    NSTimeInterval _lastUpdateTime;
    NSTimeInterval _dt;
    CGFloat _velocity;
    CGFloat _adjustedWidth;
}

- (instancetype)initWithImages:(NSArray *)images size:(CGSize)size velocity:(CGFloat)velocity identifier:(NSString *)identifier {
    self = [super init];
    if (self) {
        self.size = size;
        self.identifier = identifier;
        _velocity = velocity;
        [self setupNodesWithImages:images];
    }
    return self;
}

- (void)setupNodesWithImages:(NSArray *)images {
    
    __block CGFloat lastX = 0;
    [images enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        SKSpriteNode *node = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:obj]];
        node.name = self.identifier;
        node.size = CGSizeMake(node.size.width, node.size.height);
        node.position = CGPointMake(lastX,  round(self.frame.size.height/2) - round(node.size.height/2));
        lastX += CGRectGetWidth(node.frame);
        [self addChild:node];
    }];
}

-(void)update:(CFTimeInterval)currentTime {
    _dt = 0.3;
    _lastUpdateTime = currentTime;
    [self moveBackground];
}

-(void)moveBackground
{
    [self enumerateChildNodesWithName:self.identifier usingBlock:^(SKNode *node, BOOL *stop){
        SKSpriteNode *bg  = (SKSpriteNode *)node;
        CGPoint bgVelocity = CGPointMake(_velocity, 0); //The speed at which the background image will move
        CGPoint amountToMove = CGPointMultiplyScalar (bgVelocity,_dt);
        bg.position = CGPointAdd(bg.position,amountToMove);
        
        if (![bg intersectsNode:self] && bg.position.x <= 0)
        {
            CGFloat maxX = CGRectGetWidth(self.frame);
            CGFloat random = 0;
            CGFloat updateX = maxX + random;
            bg.position = CGPointMake(updateX, bg.position.y);
        }
    }];
}

CGPoint CGPointAdd(CGPoint p1, CGPoint p2)
{
    return CGPointMake(p1.x + p2.x, p1.y + p2.y);
}

CGPoint CGPointMultiplyScalar(CGPoint p1, CGFloat p2)
{
    return CGPointMake(p1.x * p2, p1.y * p2);
}

@end
