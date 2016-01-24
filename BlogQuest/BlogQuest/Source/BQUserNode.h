//
//  BQUserNode.h
//  BlogQuest
//
//  Created by Brian Michel on 5/8/14.
//  Copyright (c) 2014 Brian Michel. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "BQAvatarNode.h"

@interface BQUserNode : BQAvatarNode

- (void)moveForwardUpdatingPosition:(BOOL)updatePosition;

- (void)jump;

@end
