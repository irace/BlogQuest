//
//  SKNode+Audio.h
//  BlogQuest
//
//  Created by Brian Michel on 5/9/14.
//  Copyright (c) 2014 Brian Michel. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface SKNode (Audio)
- (void)playEffectNamed:(NSString *)name wait:(BOOL)wait;
@end
