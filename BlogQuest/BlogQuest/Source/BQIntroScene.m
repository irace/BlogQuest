//
//  BQIntroScene.m
//  BlogQuest
//
//  Created by Brian Michel on 5/9/14.
//  Copyright (c) 2014 Brian Michel. All rights reserved.
//

#import "BQIntroScene.h"
#import "BQBlinkingLabelNode.h"

@interface BQIntroScene ()

@property (nonatomic) BQBlinkingLabelNode *tapAnyWhereNode;
@property (nonatomic) SKSpriteNode *titleImageNode;

@end

@implementation BQIntroScene

- (instancetype)initWithSize:(CGSize)size {
    self = [super initWithSize:size];
    if (self) {
        self.backgroundColor = [SKColor blackColor];
        
        _tapAnyWhereNode = [[BQBlinkingLabelNode alloc] init];
        _tapAnyWhereNode.text = @"TAP ANYWHERE";
        _tapAnyWhereNode.fontName = @"Arcadepix Plus";
        _tapAnyWhereNode.fontSize = 30.0;
        _tapAnyWhereNode.fontColor = [UIColor whiteColor];
        
        _tapAnyWhereNode.position = CGPointMake(round(self.size.width / 2), 30);
        
        _titleImageNode = [SKSpriteNode spriteNodeWithImageNamed:@"title_screen"];
        _titleImageNode.size = size;
        _titleImageNode.position = CGPointMake(round(_titleImageNode.size.width/2), round(_titleImageNode.size.height/2));
        _titleImageNode.zPosition = -1;
        
        [self addChild:_tapAnyWhereNode];
        [self addChild:_titleImageNode];
        [_tapAnyWhereNode startAnimating];
    }
    return self;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];

    [self.introSceneDelegate introSceneTappedAnyWhere:self];
}

@end
