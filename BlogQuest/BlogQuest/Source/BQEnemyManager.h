//
//  BQEnemyManager.h
//  BlogQuest
//
//  Created by Brian Michel on 5/8/14.
//  Copyright (c) 2014 Brian Michel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

@interface BQEnemyManager : NSObject

@property (weak) SKScene *scene;

- (instancetype)initWithScene:(SKScene *)scene;

- (void)update:(CFTimeInterval)time;
- (BOOL)containsNode:(SKNode *)node;
@end
