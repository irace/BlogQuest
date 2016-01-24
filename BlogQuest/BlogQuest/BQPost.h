//
//  BQPost.h
//  BlogQuest
//
//  Created by Bryan Irace on 5/9/14.
//  Copyright (c) 2014 Bryan Irace. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BQPost : NSObject

@property (nonatomic, copy, readonly) NSString *blogName;
@property (nonatomic, copy, readonly) NSString *postID;
@property (nonatomic, copy, readonly) NSURL *imageURL;

- (instancetype)initWithBlogName:(NSString *)blogName postID:(NSString *)postID imageURL:(NSURL *)imageURL;

@end
