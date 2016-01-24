//
//  BQAvatarNode.h
//  BlogQuest
//
//  Created by Bryan Irace on 5/9/14.
//  Copyright (c) 2014 Bryan Irace. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface BQAvatarNode : SKSpriteNode

@property (nonatomic) UIEdgeInsets insets;

- (void)loadAvatarForBlogName:(NSString *)blogName;

@end
