//
//  BQVideoScene.m
//  BlogQuest
//
//  Created by Bryan Irace on 5/9/14.
//  Copyright (c) 2014 Bryan Irace. All rights reserved.
//

@import MediaPlayer;
@import AVFoundation;
#import "BQVideoScene.h"

@interface BQVideoScene()

@property (nonatomic) SKVideoNode *videoNode;

@end

@implementation BQVideoScene

#pragma mark - SKScene

- (instancetype)initWithSize:(CGSize)size {
    self = [super initWithSize:size];
    if (self) {
        self.backgroundColor = [SKColor blackColor];
    }
    
    return self;
}

- (void)didMoveToView:(SKView *)view {
    [super didMoveToView:view];
    
    [self resetVideoPlayer];
}

- (void)willMoveFromView:(SKView *)view {
    [super willMoveFromView:view];
    
    [self.videoNode pause];
}

#pragma mark - UIResponder

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    
    [self.videoNode pause];
    
    [self.videoSceneDelegate videoSceneTappedAnyWhere:self];
}

#pragma mark - Audio Player

- (void)resetVideoPlayer {
    [self.videoNode removeFromParent];
    
    self.videoNode = [SKVideoNode videoNodeWithVideoURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"intro_movie" ofType:@"mp4"]]];
    self.videoNode.size = self.size;
    self.videoNode.position = CGPointMake(round(self.size.width/2), round(self.size.height/2));
    [self addChild:self.videoNode];
    [self.videoNode play];
}

@end
