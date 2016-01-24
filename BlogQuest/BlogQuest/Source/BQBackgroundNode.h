//
//  BQBackgroundNode.h
//  BlogQuest
//
//  Created by Brian Michel on 5/8/14.
//  Copyright (c) 2014 Brian Michel. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

#define BQBackgroundNodeHeight 270

@interface BQBackgroundNode : SKSpriteNode

- (instancetype)initWithSize:(CGSize)size;

- (void)update:(CFTimeInterval)time;

@end

@interface BQRepeatableNode : SKSpriteNode

- (instancetype)initWithImages:(NSArray *)images size:(CGSize)size velocity:(CGFloat)velocity identifier:(NSString *)identifier;
- (void)update:(CFTimeInterval)time;

@end
