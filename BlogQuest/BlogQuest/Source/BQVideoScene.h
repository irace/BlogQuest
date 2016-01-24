//
//  BQVideoScene.h
//  BlogQuest
//
//  Created by Bryan Irace on 5/9/14.
//  Copyright (c) 2014 Bryan Irace. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
@protocol BQVideoSceneDelegate;

@interface BQVideoScene : SKScene

@property (nonatomic, weak) id <BQVideoSceneDelegate> videoSceneDelegate;

@end

@protocol BQVideoSceneDelegate <NSObject>

- (void)videoSceneTappedAnyWhere:(BQVideoScene *)scene;

@end
