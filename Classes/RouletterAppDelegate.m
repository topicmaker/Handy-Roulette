//
//  RouletterAppDelegate.m
//  Rouletter
//
//  Created by t-suzuki on 10/06/28.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "RouletterAppDelegate.h"
#import "RouletterViewController.h"

@implementation RouletterAppDelegate

@synthesize window;
@synthesize viewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after app launch    
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];
	
	return YES;
}


- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end
