//
//  NumberCard.h
//  Rouletter
//
//  Created by t-suzuki on 10/06/28.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RouletterViewController.h"

@interface NumberCard : UIViewController {
	UIImageView * backgroundImageView;
	UILabel * numberLabel;
	NSString * numberLabelValue;
	NSString * colorValue;
	
///	NSString *  myOrderValue;
}
@property (nonatomic, retain) IBOutlet UILabel * numberLabel;
@property (nonatomic, retain) IBOutlet UIImageView * backgroundImageView;
@property (nonatomic, retain) NSString * numberLabelValue;
@property (nonatomic, retain) NSString * colorValue;

///@property (nonatomic, retain) NSString *  myOrderValue;

@end
