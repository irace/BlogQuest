//
//  BQGroundNode.m
//  BlogQuest
//
//  Created by Brian Michel on 5/8/14.
//  Copyright (c) 2014 Brian Michel. All rights reserved.
//

#import "BQGroundNode.h"

@implementation BQGroundNode

- (id)initWithSize:(CGSize)size {
    if (self = [super initWithTexture:[SKTexture textureWithImageNamed:@"ground"] color:[UIColor clearColor] size:size]) {
        self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:CGRectInset(self.frame, 0, 15)];
    }
    
    return self;
}

@end
