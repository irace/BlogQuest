//
//  SKNode+Audio.m
//  BlogQuest
//
//  Created by Brian Michel on 5/9/14.
//  Copyright (c) 2014 Brian Michel. All rights reserved.
//

#import "SKNode+Audio.h"

@implementation SKNode (Audio)
- (void)playEffectNamed:(NSString *)name wait:(BOOL)wait {
    SKAction *action = [SKAction playSoundFileNamed:[NSString stringWithFormat:@"%@.mp3", name] waitForCompletion:wait];
    [self runAction:action];
}
@end
