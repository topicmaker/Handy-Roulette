//
//  NumberCard.m
//  Rouletter
//
//  Created by t-suzuki on 10/06/28.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "NumberCard.h"


@implementation NumberCard

@synthesize backgroundImageView;
@synthesize numberLabel;
@synthesize numberLabelValue;
@synthesize colorValue;

///@synthesize myOrderValue;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
	// Label
	if (numberLabelValue == nil) {
		NSLog(@"[error] numberLabelValue @NumberCard");
	}
	numberLabel.text = numberLabelValue;

	
//	NSLog(@"fontName : %@",numberLabel.font.fontName);
//	NSLog(@"familyName : %@",numberLabel.font.familyName);

	
/*
	// UIColor 調査
	UIColor* check_color = self.view.backgroundColor;
	const CGFloat* cs1 = CGColorGetComponents(check_color.CGColor);
	NSLog(@"[1] R:%.3f G:%.3f B:%.3f A:%.3f", cs1[0], cs1[1], cs1[2], cs1[3]);
*/	
	
///	NSLog(@"colorValue : %@ ... %@",colorValue, numberLabelValue);
	
	// Color
	self.numberLabel.textColor = kMyWhiteColor;
	if ([colorValue isEqualToString:@"g"]) {
		self.backgroundImageView.image = [UIImage imageNamed:@"bg_green.png"];
	}
	if ([colorValue isEqualToString:@"r"]) {
		self.backgroundImageView.image = [UIImage imageNamed:@"bg_red.png"];
	}
	if ([colorValue isEqualToString:@"b"]) {
		self.backgroundImageView.image = [UIImage imageNamed:@"bg_black.png"];
	}
	
	[super viewDidLoad];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	
	self.backgroundImageView = nil;
	self.numberLabel = nil;
	self.numberLabelValue = nil;
	self.colorValue = nil;
	
///	self.myOrderValue = nil;
}


- (void)dealloc {
	[backgroundImageView release];
	[numberLabel release];
	[numberLabelValue release];
	[colorValue release];
	
///	[myOrderValue release];
	
    [super dealloc];
}


@end
