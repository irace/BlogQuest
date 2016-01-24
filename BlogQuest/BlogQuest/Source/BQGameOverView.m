//
//  BQGameOverView.m
//  BlogQuest
//
//  Created by Bryan Irace on 5/9/14.
//  Copyright (c) 2014 Bryan Irace. All rights reserved.
//

#import "BQGameOverView.h"

static CGFloat const ButtonHeight = 150;
static CGFloat const ButtonWidth = 284;

@interface BQGameOverView()

@property (nonatomic) UIView *redView;
@property (nonatomic) UILabel *gameOverLabel;
@property (nonatomic) UIButton *startOverButton;
@property (nonatomic) UIButton *postToTumblrButton;

@end

@implementation BQGameOverView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.redView = [[UIView alloc] initWithFrame:self.frame];
        self.redView.backgroundColor = [UIColor redColor];
        self.redView.alpha = 0;
        [self addSubview:self.redView];
        
        self.gameOverLabel = [[UILabel alloc] init];
        self.gameOverLabel.alpha = 0;
        self.gameOverLabel.font = [UIFont fontWithName:@"Arcadepix Plus" size:60];
        self.gameOverLabel.textColor = [UIColor whiteColor];
        self.gameOverLabel.text = @"GAME OVER";
        [self.gameOverLabel sizeToFit];
        [self addSubview:self.gameOverLabel];
        
        UIButton *(^newButton)(NSString *) = ^(NSString *text) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
            button.frame = CGRectMake(0, 0, ButtonWidth, ButtonHeight);
            button.titleLabel.font = [UIFont fontWithName:@"Arcadepix Plus" size:40];
            button.tintColor = [UIColor whiteColor];
            button.alpha = 0;
            button.titleLabel.adjustsFontSizeToFitWidth = YES;
            [self addSubview:button];
            [button setTitle:text forState:UIControlStateNormal];
            return button;
        };
        
        self.startOverButton = newButton(@"PLAY AGAIN");
        
        self.postToTumblrButton = newButton(@"POST SCORE TO TUMBLR");
    }
    
    return self;
}

- (void)animateIn {
    static CGFloat const TranslateDistance = 25;
    
    self.gameOverLabel.center = CGPointMake(CGRectGetWidth(self.frame)/2, CGRectGetHeight(self.frame)/2);
    
    self.startOverButton.frame = ({
        CGRect frame = self.startOverButton.frame;
        frame.origin = CGPointMake(ButtonWidth, CGRectGetHeight(self.frame) - ButtonHeight);
        frame;
    });
    
    self.postToTumblrButton.frame = ({
        CGRect frame = self.postToTumblrButton.frame;
        frame.origin = CGPointMake(0, CGRectGetHeight(self.frame) - ButtonHeight);
        frame;
    });
    
    [UIView animateWithDuration:0.3 animations:^{
        self.redView.alpha = 0.6;
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            self.gameOverLabel.alpha = 1;
            self.gameOverLabel.frame = ({
                CGRect frame = self.gameOverLabel.frame;
                frame.origin.y -= TranslateDistance;
                frame;
            });
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 animations:^{
                self.startOverButton.alpha = 1;
                self.postToTumblrButton.alpha = 1;
            }];
        }];
    }];
}

@end
