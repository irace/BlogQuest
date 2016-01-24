//
//  BQBlinkingLabelNode.m
//  BlogQuest
//
//  Created by Brian Michel on 5/9/14.
//  Copyright (c) 2014 Brian Michel. All rights reserved.
//

#import "BQBlinkingLabelNode.h"

@implementation BQBlinkingLabelNode

- (void)startAnimating {
    SKAction *fadeOut = [SKAction fadeAlphaTo:0.7 duration:0.5];
    SKAction *fadeIn = [SKAction fadeAlphaTo:1.0 duration:0.8];
    SKAction *group = [SKAction repeatActionForever:[SKAction sequence:@[fadeOut, fadeIn]]];
    group.timingMode = SKActionTimingEaseInEaseOut;
    
    [self runAction:group withKey:@"blink"];
}

- (void)stopAnimating {
    [self removeActionForKey:@"blink"];
    [self runAction:[SKAction fadeAlphaTo:1.0 duration:0.3]];
}
@end
