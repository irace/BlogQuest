//
//  BQTumblrDataAggregator.m
//  BlogQuest
//
//  Created by Bryan Irace on 5/9/14.
//  Copyright (c) 2014 Bryan Irace. All rights reserved.
//

#import "BQTumblrDataAggregator.h"
#import "BQDashboardPhotoPostAggregationOperation.h"

static NSUInteger MinPostCount = 100;

@interface BQTumblrDataAggregator()

@property (nonatomic) NSMutableArray *posts;
@property (nonatomic) NSOperationQueue *queue;

@end

@implementation BQTumblrDataAggregator

- (id)init {
    if (self = [super init]) {
        _queue = [[NSOperationQueue alloc] init];
        _queue.maxConcurrentOperationCount = 1;
        
        _posts = [NSMutableArray new];
        
        [self MOAR];
    }
    
    return self;
}

- (BQPost *)nextPost {
    if ([self.posts count] == 0) {
        return nil;
    }
    
    BQPost *post = [self.posts firstObject];
    [self.posts removeObject:post];
    return post;
}

- (void)MOAR {
    typeof(self) __weak weakSelf = self;
    
    BQPost *lastPost = [self.posts lastObject];
    
    BQDashboardPhotoPostAggregationOperation *operation = [[BQDashboardPhotoPostAggregationOperation alloc] initWithBeforeID:lastPost.postID];
    typeof(operation) __weak weakOperation = operation;
    
    operation.completionBlock = ^{
        [weakSelf.posts addObjectsFromArray:weakOperation.posts];
        
        NSLog(@"Aggregated %lu more posts", (unsigned long)[weakOperation.posts count]);
        
        if ([weakSelf.posts count] < MinPostCount && !weakOperation.error) {
            [weakSelf MOAR];
        }
    };
    
    [self.queue addOperation:operation];
}

@end
