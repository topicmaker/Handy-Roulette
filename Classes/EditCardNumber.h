//
//  EditCardNumber.h
//  Rouletter
//
//  Created by t-suzuki on 10/06/30.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RouletterViewController.h"

@interface EditCardNumber : UIViewController {	
	UISegmentedControl * rouletteSelector;
	UISegmentedControl * bgmSelector;
}

@property (nonatomic, retain) IBOutlet UISegmentedControl * rouletteSelector, * bgmSelector;

- (IBAction) saveAction;
- (IBAction) doneAction;

@end
