//
//  AppDelegate.m
//  Prime Print x-callback-url Sample
//
//  Created by komatsu on 2014/04/14.
//  Copyright (c) 2014 iWare inc. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    NSURL *url = [launchOptions objectForKey:UIApplicationLaunchOptionsURLKey];
    
#ifdef DEBUG
    NSLog(@"%@", [AppDelegate callbackDictionary:url]);
#endif
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
}

- (void)applicationWillTerminate:(UIApplication *)application
{
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    NSDictionary *callbackInformation = [AppDelegate callbackDictionary:url];
    if(callbackInformation) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:callbackInformation[@"errorMessage"] message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    return YES;
}

+ (NSDictionary *)callbackDictionary:(NSURL *)url
{
    if(url == nil) {
        return nil;
    }
    
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    
    NSArray *pairs = [url.query componentsSeparatedByString:@"&"];
    [pairs enumerateObjectsUsingBlock:^(NSString *pair, NSUInteger idx, BOOL *stop) {
        NSArray *comps = [pair componentsSeparatedByString:@"="];
        if (comps.count >= 2) {
            NSMutableString *str = [NSMutableString stringWithString:comps[1]];
            for(NSInteger i = 2 ; i < comps.count ; i++) {
                [str appendFormat:@"=%@", comps[i]];
            }
            NSString *value = [str stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [result setObject:value forKey:comps[0]];
        } else if(comps.count > 2) {
            
        }
    }];
    
    return result;
    
}


@end
