//
//  BQIntroScene.h
//  BlogQuest
//
//  Created by Brian Michel on 5/9/14.
//  Copyright (c) 2014 Brian Michel. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@protocol BQIntroSceneDelegate;

@interface BQIntroScene : SKScene

@property (nonatomic, weak) id <BQIntroSceneDelegate> introSceneDelegate;

@end

@protocol BQIntroSceneDelegate <NSObject>

- (void)introSceneTappedAnyWhere:(BQIntroScene *)scene;

@end
