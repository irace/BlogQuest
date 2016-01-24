//
//  BQPhotoNode.h
//  BlogQuest
//
//  Created by Bryan Irace on 5/9/14.
//  Copyright (c) 2014 Bryan Irace. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface BQPhotoNode : SKNode

- (instancetype)initWithSize:(CGSize)size;

- (void)replaceWithPhotoAtURL:(NSURL *)URL;

@end
