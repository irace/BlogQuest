//
//  BQAvatarNode.m
//  BlogQuest
//
//  Created by Bryan Irace on 5/9/14.
//  Copyright (c) 2014 Bryan Irace. All rights reserved.
//

#import "BQAvatarNode.h"
#import "SDWebImageManager.h"

static CGFloat const AvatarSize = 50;

@implementation BQAvatarNode

#pragma mark - Initialization

- (instancetype)initWithImageNamed:(NSString *)name {
    CGSize size = CGSizeMake(AvatarSize, AvatarSize);
    
    if (self = [super initWithImageNamed:name]) {
        self.size = size;
        self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:AvatarSize/2];
        self.insets = UIEdgeInsetsZero;
    }
    
    return self;
}

#pragma mark - BQAvatarNode

- (void)loadAvatarForBlogName:(NSString *)blogName {
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.tumblr.com/v2/blog/%@.tumblr.com/avatar/128", blogName]];
    
    [[SDWebImageManager sharedManager] downloadWithURL:URL options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
        if (image) {
            [self addChild:({
                CGSize size = CGSizeMake(self.size.width - (self.insets.left + self.insets.right), self.size.height - (self.insets.top + self.insets.bottom));
                
                SKSpriteNode *node = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImage:circularImage(image, size)]];
                node.size = size;
                node;
            })];
        }
    }];
}

#pragma mark - Private

static UIImage *circularImage(UIImage *image, CGSize size) {
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    
    UIGraphicsBeginImageContextWithOptions(size, NO, [[UIScreen mainScreen] scale]);
    [[UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:size.width/2] addClip];
    [image drawInRect:rect];
    UIImage *circularImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return circularImage;
}

@end
