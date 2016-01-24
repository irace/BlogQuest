//
//  BQPost.m
//  BlogQuest
//
//  Created by Bryan Irace on 5/9/14.
//  Copyright (c) 2014 Bryan Irace. All rights reserved.
//

#import "BQPost.h"

@interface BQPost()

@property (nonatomic, copy) NSString *blogName;
@property (nonatomic, copy) NSURL *imageURL;

@end

@implementation BQPost

- (instancetype)initWithBlogName:(NSString *)blogName postID:(NSString *)postID imageURL:(NSURL *)imageURL {
    if (self = [super init]) {
        _blogName = [blogName copy];
        _postID = [postID copy];
        _imageURL = [imageURL copy];       
    }
    
    return self;
}

@end
