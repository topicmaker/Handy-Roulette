//
//  RouletterAppDelegate.h
//  Rouletter
//
//  Created by t-suzuki on 10/06/28.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RouletterViewController;

@interface RouletterAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    RouletterViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet RouletterViewController *viewController;

@end

