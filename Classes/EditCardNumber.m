//
//  EditCardNumber.m
//  Rouletter
//
//  Created by t-suzuki on 10/06/30.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "EditCardNumber.h"


@implementation EditCardNumber

@synthesize rouletteSelector, bgmSelector;


#pragma mark -
- (NSString *)dataFilePath {
	NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString * documentsDirectory = [paths objectAtIndex:0];
	NSString * filePath = [documentsDirectory stringByAppendingPathComponent:kDataFileName];
	return filePath;
}


#pragma mark -
#pragma mark IBAction
- (IBAction) saveAction {
//	NSLog(@"saveAction");
	
	NSInteger selectedValue		= [rouletteSelector selectedSegmentIndex];
	NSInteger selectedBgmValue	= [bgmSelector selectedSegmentIndex];
	
	NSMutableDictionary	* dataPlist = [[NSMutableDictionary alloc] init];
	[dataPlist setObject:[NSString stringWithFormat:@"%d", selectedValue] forKey:kDataKeyName];
	[dataPlist setObject:[NSString stringWithFormat:@"%d", selectedBgmValue] forKey:kDataBgmKeyName];
	[dataPlist writeToFile:[self dataFilePath] atomically:YES];
	[dataPlist release];
}

- (IBAction) doneAction {
//	NSLog(@"doneAction");
	[self dismissModalViewControllerAnimated:YES];
} 


#pragma mark -

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
//	NSLog(@"EditCardNumber - viewDidLoad");
	
	if ([[NSFileManager defaultManager] fileExistsAtPath:[self dataFilePath]]) {
		NSMutableDictionary * dataPlist = [[NSMutableDictionary alloc]
										   initWithContentsOfFile:[self dataFilePath]];
		[rouletteSelector setSelectedSegmentIndex:[[dataPlist objectForKey:kDataKeyName] intValue]];
		[bgmSelector setSelectedSegmentIndex:[[dataPlist objectForKey:kDataBgmKeyName] intValue]];
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
	
	self.rouletteSelector = nil;
}


- (void)dealloc {
	[rouletteSelector release];
	
	[super dealloc];
}


@end
