//
//  BQCredentials.h
//  BlogQuest
//
//  Created by Bryan Irace on 5/8/14.
//  Copyright (c) 2014 Bryan Irace. All rights reserved.
//

@interface BQCredentials : NSObject

+ (NSString *)blogName;

+ (NSString *)OAuthToken;

+ (NSString *)OAuthTokenSecret;

+ (BOOL)isLoggedIn;

+ (void)setBlogName:(NSString *)blogName OAuthToken:(NSString *)OAuthToken OAuthTokenSecret:(NSString *)OAuthTokenSecret;

@end
