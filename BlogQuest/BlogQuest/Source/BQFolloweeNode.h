//
//  BQFolloweeNode.h
//  BlogQuest
//
//  Created by Bryan Irace on 5/9/14.
//  Copyright (c) 2014 Bryan Irace. All rights reserved.
//

#import "BQAvatarNode.h"
#import "BQCollectable.h"
#import "BQPost.h"

extern NSString * const BQFolloweeWasCollectedNotification;

@interface BQFolloweeNode : BQAvatarNode <BQCollectable>

- (instancetype)initWithPost:(BQPost *)post;

@end
