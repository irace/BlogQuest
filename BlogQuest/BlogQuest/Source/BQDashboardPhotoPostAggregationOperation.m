//
//  BQDashboardPhotoPostAggregationOperation.m
//  BlogQuest
//
//  Created by Bryan Irace on 5/9/14.
//  Copyright (c) 2014 Bryan Irace. All rights reserved.
//

#import "BQPost.h"
#import "BQDashboardPhotoPostAggregationOperation.h"
#import "TMAPIClient.h"

@interface BQDashboardPhotoPostAggregationOperation()

@property (nonatomic) NSArray *posts;
@property (nonatomic) NSError *error;
@property (nonatomic, copy) NSString *beforeID;

@end

@implementation BQDashboardPhotoPostAggregationOperation



- (instancetype)initWithBeforeID:(NSString *)beforeID {
    if (self = [super init]) {
        _beforeID = [beforeID copy];
    }
    
    return self;
}

#pragma marm - NSOperation

- (void)main {
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    NSMutableDictionary *params = [@{ @"type" : @"photo" } mutableCopy];
    
    if (self.beforeID) {
        params[@"before_id"] = self.beforeID;
    }
    
    [[TMAPIClient sharedInstance] dashboard:params callback:^(NSDictionary *response, NSError *error) {
        if (error) {
            self.error = error;
        }
        else {
            NSMutableArray *posts = [NSMutableArray new];
            
            [response[@"posts"] enumerateObjectsUsingBlock:^(NSDictionary *post, NSUInteger idx, BOOL *stop) {
                NSURL *imageURL = firstPhotoURLFromPostDictionary(post);
                BOOL postIsUsable = [self postIsUsable:post];
                
                if (imageURL && postIsUsable) {
                    [posts addObject:[[BQPost alloc] initWithBlogName:post[@"blog_name"]
                                                               postID:[post[@"id"] stringValue]
                                                             imageURL:imageURL]];
                }
            }];
            
            self.posts = [posts copy];
        }
        
        dispatch_semaphore_signal(semaphore);
    }];
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
}

- (BOOL)postIsUsable:(NSDictionary *)post {
    NSArray *tags = post[@"tags"];
    for (NSString *tag in tags) {
        if ([tag caseInsensitiveCompare:@"blogquest"] == NSOrderedSame) {
            return NO;
        }
    }
    return YES;
}

#pragma mark - Safety
        
NSURL *firstPhotoURLFromPostDictionary(NSDictionary *postDictionary) {
    NSArray *photos = postDictionary[@"photos"];
    
    if ([photos isKindOfClass:[NSArray class]]) {
        NSDictionary *firstPhoto = [photos firstObject];
        
        if ([firstPhoto isKindOfClass:[NSDictionary class]]) {
            NSDictionary *firstPhotoOriginalSize = firstPhoto[@"original_size"];
            
            if ([firstPhotoOriginalSize isKindOfClass:[NSDictionary class]]) {
                NSString *firstPhotoOriginalSizeURLString = firstPhotoOriginalSize[@"url"];
                
                if ([firstPhotoOriginalSizeURLString isKindOfClass:[NSString class]]) {
                    return [NSURL URLWithString:firstPhotoOriginalSizeURLString];
                }
            }
        }
    }
    
    return nil;
}

@end
