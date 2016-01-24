//
//  BQMyScene.m
//  BlogQuest
//
//  Created by Brian Michel on 5/8/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import "BQCredentials.h"
#import "BQMainScene.h"
#import "BQHUDView.h"
#import "BQGroundNode.h"
#import "BQUserNode.h"
#import "BQBackgroundNode.h"
#import "BQCoinNode.h"
#import "BQCollectableManager.h"
#import "BQPhotoNode.h"
#import "BQTumblrDataAggregator.h"
#import "BQEnemyManager.h"
#import "BQCredentials.h"
#import "SKNode+Audio.h"
#import "BQGameOverView.h"
#import <TMTumblrSDK/TMAPIClient.h>

@interface BQMainScene () <SKPhysicsContactDelegate, BQCollectableManagerDelegate>

@property (nonatomic) BQUserNode *user;
@property (nonatomic) BQPhotoNode *photo;
@property (nonatomic) UIImageView *imageView;
@property (nonatomic) BQRepeatableNode *ground;
@property (nonatomic) BQBackgroundNode *background;
@property (nonatomic) BQCollectableManager *collectibleManager;
@property (nonatomic) BQEnemyManager *enemyManager;
@property (nonatomic) BQTumblrDataAggregator *dataAggregator;
@property (nonatomic) BQGameOverView *gameOverView;

@property (nonatomic) BQHUDView *hudView;

@property (nonatomic) UITouch *firstTouch;
@property (nonatomic) BOOL showingDeathAlert;

@property (nonatomic) AVAudioPlayer *audioPlayer;
@property (nonatomic) UIImage *deathScreenshot;

@end

@implementation BQMainScene

#pragma mark - SKScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        self.backgroundColor = [UIColor blackColor];
        self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
        self.physicsWorld.contactDelegate = self;
        
        [self setup];
    }
    
    return self;
}

- (void)update:(CFTimeInterval)currentTime {
    CGFloat maxUserXPosition = [self maxUserXPosition];
    
    if (self.firstTouch) {
        BOOL userShouldMove = self.user.position.x < maxUserXPosition;
        
        [self.user moveForwardUpdatingPosition:userShouldMove];
        
        if (!userShouldMove) {
            [self.background update:currentTime];
            [self.ground update:currentTime];
            [self.collectibleManager update:currentTime];
            [self.enemyManager update:currentTime];
        }
    }
}

- (void)didMoveToView:(SKView *)view {
    [super didMoveToView:view];
    
    [self.audioPlayer play];
    
    self.hudView = [[BQHUDView alloc] init];
    [self.view addSubview:self.hudView];
}

- (void)willMoveFromView:(SKView *)view {
    [super willMoveFromView:view];
    
    [self.audioPlayer stop];
}

#pragma mark - UIResponder

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (!self.firstTouch) {
        self.firstTouch = [touches anyObject];
    }
    else {
        [self.user jump];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if ([touches containsObject:self.firstTouch]) {
        self.firstTouch = nil;
    }
}

#pragma mark - BQMainScene

- (void)jumpUser {
    if (!self.showingDeathAlert) {
        [self.user jump];
    }
}

#pragma mark - Private

- (void)setup {
    [self.children makeObjectsPerformSelector:@selector(removeFromParent)];
    
    self.showingDeathAlert = NO;
    
    self.photo = [[BQPhotoNode alloc] initWithSize:self.size];
    self.photo.position = CGPointMake(round(self.size.width/2), round(self.size.height/2));
    [self addChild:self.photo];
    
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"game_loop" withExtension:@"mp3"] error:nil];
    self.audioPlayer.numberOfLoops = -1;
    
    self.ground = [[BQRepeatableNode alloc] initWithImages:@[@"ground", @"ground"] size:CGSizeMake(self.size.width, 50) velocity:-25 identifier:@"ground"];
    self.ground.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:CGRectInset(self.ground.frame, 0, 15)];
    
    self.ground.position = CGPointMake(round(self.size.width/2), round(50 / 2));
    [self addChild:self.ground];
    
    self.background = [[BQBackgroundNode alloc] initWithSize:self.size];
    self.background.position = CGPointMake(round(self.size.width)/2,
                                           CGRectGetMaxY(self.ground.frame) + round(CGRectGetHeight(self.background.frame) / 2));
    
    [self addChild:self.background];
    
    self.user = [[BQUserNode alloc] init];
    self.user.position = CGPointMake(20, round(self.size.height / 2));
    [self addChild:self.user];
    
    self.collectibleManager = [[BQCollectableManager alloc] initWithScene:self delegate:self];
    
    self.enemyManager = [[BQEnemyManager alloc] initWithScene:self];
    
    self.dataAggregator = [[BQTumblrDataAggregator alloc] init];
}

- (void)reset {
    [self.gameOverView removeFromSuperview];
    
    self.view.paused = NO;
    
    [self.mainSceneDelegate mainSceneDidReset:self];
}

- (CGFloat)maxUserXPosition {
    // TODO: Should eventually take into account if we're at the end of the world
    return CGRectGetWidth(self.frame)/3;
}

#pragma mark - BQCollectableManagerDelegate

- (BQPost *)nextPost {
    return [self.dataAggregator nextPost];
}

#pragma mark - SKPhysicsContactDelegate

- (void)didBeginContact:(SKPhysicsContact *)contact {
    SKNode *nodeA = contact.bodyA.node;
    SKNode *nodeB = contact.bodyB.node;
    
    if (nodeA == self.user || nodeB == self.user) {
        if ([self.collectibleManager containsNode:nodeA]) {
            [self.collectibleManager handleCollisionWithNode:nodeA];
        }

        if ([self.collectibleManager containsNode:nodeB]) {
            [self.collectibleManager handleCollisionWithNode:nodeB];
        }
        
        if ([self.enemyManager containsNode:nodeA]) {
            [self showDeathAlert];
        }
        
        if ([self.enemyManager containsNode:nodeB]) {
            [self showDeathAlert];
        }
    }
}

- (void)showDeathAlert {
    if (self.showingDeathAlert) {
        return;
    }
    
    [self playEffectNamed:@"79__plagasul__long-scream" wait:NO];
    
    self.showingDeathAlert = YES;
    self.view.paused = NO;
    
    self.deathScreenshot = [self renderCurrentScreenAsImage];
    
    self.filter = [CIFilter filterWithName:@"CITwirlDistortion" keysAndValues:@"inputRadius",@400,@"inputCenter", [CIVector vectorWithX:200 Y:100], nil];
    self.shouldEnableEffects = YES;
    
    self.gameOverView = [[BQGameOverView alloc] initWithFrame:self.frame];
    [self.view addSubview:self.gameOverView];
    [self.gameOverView.startOverButton addTarget:self action:@selector(startOver) forControlEvents:UIControlEventTouchUpInside];
    [self.gameOverView.postToTumblrButton addTarget:self action:@selector(postToTumblr) forControlEvents:UIControlEventTouchUpInside];
    [self.gameOverView animateIn];
}

- (UIImage *)renderCurrentScreenAsImage {
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, NO, [UIScreen mainScreen].scale);
    [self.view drawViewHierarchyInRect:self.view.bounds afterScreenUpdates:NO];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return viewImage;
}

- (void)startOver {
    [self reset];
}

- (void)postToTumblr {
    UIImage *image = self.deathScreenshot;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"screen_shot.jpg"];
    
    NSData *imageData = UIImageJPEGRepresentation(image, 0.7);
    [imageData writeToFile:filePath atomically:YES];
    
    NSDictionary *params = @{
        @"caption": [NSString stringWithFormat:@"I just scored %li in BlogQuest!", (unsigned long)[self.hudView coins]],
        @"tags": @"BlogQuest, Hack Day 2014"
    };
    
    [[TMAPIClient sharedInstance] photo:[BQCredentials blogName]
                          filePathArray:@[filePath]
                       contentTypeArray:@[@"image/jpg"]
                          fileNameArray:@[[[NSProcessInfo processInfo] globallyUniqueString]]
                             parameters:params callback:nil];
    
    [self reset];
}

@end
