//
//  BQCredentials.m
//  BlogQuest
//
//  Created by Bryan Irace on 5/8/14.
//  Copyright (c) 2014 Bryan Irace. All rights reserved.
//

#import "BQCredentials.h"

static NSString * const BlogNameKey = @"BlogNameKey";
static NSString * const OAuthTokenKey = @"OAuthTokenKey";
static NSString * const OAuthTokenSecretKey = @"OAuthTokenSecretKey";

@implementation BQCredentials

+ (BOOL)isLoggedIn {
    return [self blogName] && [self OAuthToken] && [self OAuthTokenSecret];
}

+ (void)setBlogName:(NSString *)blogName OAuthToken:(NSString *)OAuthToken OAuthTokenSecret:(NSString *)OAuthTokenSecret {
    [[NSUserDefaults standardUserDefaults] setObject:blogName forKey:BlogNameKey];
    [[NSUserDefaults standardUserDefaults] setObject:OAuthToken forKey:OAuthTokenKey];
    [[NSUserDefaults standardUserDefaults] setObject:OAuthTokenSecret forKey:OAuthTokenSecretKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)blogName {
    return [[NSUserDefaults standardUserDefaults] objectForKey:BlogNameKey];
}

+ (NSString *)OAuthToken {
    return [[NSUserDefaults standardUserDefaults] objectForKey:OAuthTokenKey];
}

+ (NSString *)OAuthTokenSecret {
    return [[NSUserDefaults standardUserDefaults] objectForKey:OAuthTokenSecretKey];
}

@end
