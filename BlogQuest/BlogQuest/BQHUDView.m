//
//  BQHUDView.m
//  BlogQuest
//
//  Created by Bryan Irace on 5/9/14.
//  Copyright (c) 2014 Bryan Irace. All rights reserved.
//

#import "BQHUDView.h"
#import "BQFolloweeNode.h"
#import "BQCoinNode.h"

@interface BQHUDView()

@property (nonatomic) NSUInteger coinCount;
@property (nonatomic) UILabel *label;

@end

@implementation BQHUDView

- (id)init {
    static CGFloat const Padding = 3;
    
    if (self = [super initWithFrame:CGRectMake(Padding, Padding, 92, 52)]) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"counter_bg"]];
        imageView.frame = self.frame;
        [self addSubview:imageView];
        
        static CGFloat const LabelOffset = 7;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(Padding,
                                                                   LabelOffset + Padding,
                                                                   CGRectGetWidth(self.frame),
                                                                   CGRectGetHeight(self.frame) - (LabelOffset + Padding))];
        label.textColor = [UIColor whiteColor];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont fontWithName:@"Arcadepix Plus" size:30];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"0";
        [self addSubview:label];
        self.label = label;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(increment) name:BQFolloweeWasCollectedNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(increment) name:BQCoinWasCollectedNotification object:nil];
    }
    
    return self;
}

- (NSUInteger)coins {
    return self.coinCount;
}

#pragma mark - Private

- (void)increment {
    self.coinCount++;
    
    self.label.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.coinCount];
}

@end
