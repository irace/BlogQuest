//
//  BQDashboardPhotoPostAggregationOperation.h
//  BlogQuest
//
//  Created by Bryan Irace on 5/9/14.
//  Copyright (c) 2014 Bryan Irace. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BQDashboardPhotoPostAggregationOperation : NSOperation

@property (nonatomic, readonly) NSArray *posts;
@property (nonatomic, readonly) NSError *error;

- (instancetype)initWithBeforeID:(NSString *)beforeID;

@end
