//
//  BQViewController.m
//  BlogQuest
//
//  Created by Brian Michel on 5/8/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import "BQCredentials.h"
#import "BQRootViewController.h"
#import "BQMainScene.h"
#import "BQVideoScene.h"
#import "BQIntroScene.h"
#import "BQUserNode.h"
#import "TMAPIClient.h"

@interface BQRootViewController() <BQIntroSceneDelegate, BQMainSceneDelegate, BQVideoSceneDelegate>

@property (nonatomic, readonly) SKView *skView;
@property (nonatomic) BQMainScene *scene;
@property (nonatomic) BQIntroScene *introScene;
@property (nonatomic) BQVideoScene *videoScene;

@property (nonatomic) UIImageView *imageView;

@end

@implementation BQRootViewController

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.imageView = [[UIImageView alloc] init];
    self.imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.imageView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.imageView];

    [TMAPIClient sharedInstance].OAuthConsumerKey = @"BZq839sLlBOF4QGu85o2hdwqFvQ9dvbjPJ5rRoPH1aKO19l4wF";
    [TMAPIClient sharedInstance].OAuthConsumerSecret = @"NDEeOA07WwejOhAkFjZQ0Lqx8IpZnWWIEBV8TJSvgQcLYCpu34";
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    if (!self.introScene) {
        self.introScene = [BQIntroScene sceneWithSize:self.skView.bounds.size];
        self.introScene.introSceneDelegate = self;
        [self.skView presentScene:self.introScene];
        
        self.videoScene = [BQVideoScene sceneWithSize:self.skView.bounds.size];
        self.videoScene.videoSceneDelegate = self;
    }
}

- (BOOL)shouldAutorotate {
    return YES;
}

#pragma mark - UIResponder

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (NSArray *)keyCommands {
    return @[[UIKeyCommand keyCommandWithInput:@" " modifierFlags:0 action:@selector(spacebarTapped)]];
}

#pragma mark - Actions

- (void)spacebarTapped {
    [self.scene jumpUser];
}

#pragma mark - BQIntroSceneDelegate

- (void)introSceneTappedAnyWhere:(BQIntroScene *)scene {
    SKTransition *transition = [SKTransition fadeWithDuration:0.3];
    [self.introScene.view presentScene:self.videoScene transition:transition];
}

#pragma mark - BQVideoSceneDelegate

- (void)videoSceneTappedAnyWhere:(BQVideoScene *)scene {
    if ([BQCredentials isLoggedIn]) {
        [TMAPIClient sharedInstance].OAuthToken = [BQCredentials OAuthToken];
        [TMAPIClient sharedInstance].OAuthTokenSecret = [BQCredentials OAuthTokenSecret];
        [self transitionToMainScene];
    }
    else {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Login"
                                                                                 message:nil
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"Email address";
        }];
        
        [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"Password";
            textField.secureTextEntry = YES;
        }];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"Submit" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSString *emailAddress = alertController.textFields[0].text;
            NSString *password = alertController.textFields[1].text;
            
            [[TMAPIClient sharedInstance] xAuth:emailAddress password:password callback:^(NSError *error) {
                if (!error) {
                    [[TMAPIClient sharedInstance] userInfo:^(NSDictionary *response, NSError *error) {
                        if (!error) {
                            [BQCredentials setBlogName:response[@"user"][@"name"]
                                            OAuthToken:[TMAPIClient sharedInstance].OAuthToken
                                      OAuthTokenSecret:[TMAPIClient sharedInstance].OAuthTokenSecret];
                            
                            [self dismissViewControllerAnimated:YES completion:^{
                                [self transitionToMainScene];
                            }];
                        }
                    }];
                }
            }];
        }]];
         
        [self presentViewController:alertController animated:true completion:nil];
    }
}

#pragma mark - BQMainSceneDelegate

- (void)mainSceneDidReset:(BQMainScene *)scene {
    // Hack to quickly just start over
    
    [self.scene.view presentScene:self.introScene transition:[SKTransition fadeWithDuration:0.3]];
    
    self.scene = [BQMainScene sceneWithSize:self.skView.bounds.size];
    self.scene.mainSceneDelegate = self;
    SKTransition *transition = [SKTransition fadeWithDuration:0.3];
    [self.introScene.view presentScene:self.scene transition:transition];
}

#pragma mark - Private

- (void)transitionToMainScene {
    self.scene = [BQMainScene sceneWithSize:self.skView.bounds.size];
    self.scene.mainSceneDelegate = self;
    SKTransition *transition = [SKTransition fadeWithDuration:0.3];
    [self.videoScene.view presentScene:self.scene transition:transition];
}

- (SKView *)skView {
    return (SKView *)self.view;
}

@end
