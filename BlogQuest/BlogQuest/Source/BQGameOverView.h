//
//  BQGameOverView.h
//  BlogQuest
//
//  Created by Bryan Irace on 5/9/14.
//  Copyright (c) 2014 Bryan Irace. All rights reserved.
//

@interface BQGameOverView : UIView

@property (nonatomic, readonly) UIButton *startOverButton;
@property (nonatomic, readonly) UIButton *postToTumblrButton;

- (void)animateIn;

@end
