//
//  BQPhotoNode.m
//  BlogQuest
//
//  Created by Bryan Irace on 5/9/14.
//  Copyright (c) 2014 Bryan Irace. All rights reserved.
//

#import "BQFolloweeNode.h"
#import "BQPhotoNode.h"
#import "SDWebImageManager.h"
#import "SKAction+BlogQuest.h"

@interface BQPhotoNode()

@property (nonatomic) SKSpriteNode *photoNode;
@property (nonatomic) CGSize size;

@property (nonatomic) dispatch_queue_t actionProcessorQueue;

@end

@implementation BQPhotoNode

- (instancetype)initWithSize:(CGSize)size {
    if (self = [super init]) {
        _size = size;
        self.zPosition = -200;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(followeeWasCollected:)
                                                     name:BQFolloweeWasCollectedNotification
                                                   object:nil];
        
        self.actionProcessorQueue = dispatch_queue_create("com.tumblr.blogquest.gif", DISPATCH_QUEUE_CONCURRENT);
    }
    
    return self;
}

- (void)replaceWithPhotoAtURL:(NSURL *)URL {
    typeof(self) __weak weakSelf = self;
    
    [[SDWebImageManager sharedManager] downloadWithURL:URL options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
        if (image) {
            [weakSelf.photoNode removeFromParent];
            
            dispatch_async(self.actionProcessorQueue, ^{
                SKAction *action = [SKAction bq_actionWithImage:image];
                
                weakSelf.photoNode = ({
                    SKSpriteNode *node;
                    if (action) {
                        node = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImage:image]];
                        [node runAction:[SKAction repeatActionForever:action]];
                    } else {
                        node = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImage:image]];
                    }
                    node.size = weakSelf.size;
                    node;
                });
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf addChild:weakSelf.photoNode];
                    [weakSelf.photoNode runAction:[SKAction group:@[
                        [SKAction fadeInWithDuration:0.3],
                        [SKAction sequence:@[
                            [SKAction scaleTo:1.05 duration:0.2],
                            [SKAction scaleTo:1 duration:0.3]
                        ]]
                    ]]];
                });
            });

        }
    }];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Notifications

- (void)followeeWasCollected:(NSNotification *)note {
    BQPost *post = note.object;
    
    [self replaceWithPhotoAtURL:post.imageURL];
}

@end
