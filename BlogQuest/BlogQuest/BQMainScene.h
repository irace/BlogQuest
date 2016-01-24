//
//  BQMyScene.h
//  BlogQuest
//

//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@protocol BQMainSceneDelegate;

@interface BQMainScene : SKScene

@property (weak) id<BQMainSceneDelegate> mainSceneDelegate;

- (void)jumpUser;

@end

@protocol BQMainSceneDelegate <NSObject>

- (void)mainSceneDidReset:(BQMainScene *)scene;

@end
