//
//  MyUIScrollView.m
//  Rouletter
//
//  Created by t-suzuki on 10/07/12.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MyUIScrollView.h"


@implementation MyUIScrollView

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//	NSLog(@"my > touchesBegan ... ",[touches description]);
	[self.nextResponder touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
//	NSLog(@"my > touchesMoved ... ",[touches description]);
	[self.nextResponder touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
//	NSLog(@"my > touchesEnded ... ", [touches description]);
	[self.nextResponder touchesEnded:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
//	NSLog(@"my > touchesCancelled ... ",[touches description]);
	[self.nextResponder touchesCancelled:touches withEvent:event];
}


@end
