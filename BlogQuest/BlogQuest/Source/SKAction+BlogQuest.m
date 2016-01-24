//
//  SKTexture+BlogQuest.m
//  BlogQuest
//
//  Created by Brian Michel on 5/9/14.
//  Copyright (c) 2014 Brian Michel. All rights reserved.
//

#import "SKAction+BlogQuest.h"
#import <SDWebImage/NSData+ImageContentType.h>

@implementation SKAction (BlogQuest)
+ (SKAction *)bq_actionWithImage:(UIImage *)image {
    if (image.images) {
        CGFloat frameDuration = image.duration / [image.images count];
        NSMutableArray *textures = [NSMutableArray arrayWithCapacity:[image.images count]];
        for (UIImage *frameImage in image.images) {
            SKTexture *texture = [SKTexture textureWithImage:frameImage];
            [textures addObject:texture];
        }
        return [SKAction animateWithTextures:textures timePerFrame:frameDuration resize:NO restore:YES];
    }
    return nil;
}
@end
