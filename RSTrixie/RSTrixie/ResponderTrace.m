//
//  ResponderTrace.m
//  RSTrixieEditor
//
//  Created by Erik Stainsby on 12-02-22.
//  Copyright (c) 2012 Roaring Sky. All rights reserved.
//

#import "ResponderTrace.h"

@implementation ResponderTrace
- (IBAction) trace: (id)sender 
{
	NSWindow * keyWindow = [NSApp keyWindow];
	NSWindow * mainWindow = [NSApp mainWindow];
	count = 1;
	NSLog(@"******** Begin trace ********");
	[self traceChain:[keyWindow firstResponder]];
	if(keyWindow != mainWindow) {
		[self traceChain:[mainWindow firstResponder]];
	}
	[self traceChain:NSApp];
	[self traceChain:[NSDocumentController sharedDocumentController]];
	NSLog(@"******** End of trace ********");
}

- (void) traceChain:(id)currentResponder {
	while( currentResponder	) {
		NSLog(@"Responder: %d: %@",count, currentResponder);
		count++;
		if([currentResponder isKindOfClass:[NSWindow class]] || [currentResponder isKindOfClass:[NSApplication class]]) {
			id delegate = [currentResponder delegate];
			if( delegate ) {
				NSLog(@"Responder %d (delegate): %@", count, [currentResponder delegate]);
				count++;
			}
		}
		
		if( [currentResponder respondsToSelector:@selector(nextResponder)] ) {
			currentResponder = [currentResponder nextResponder];
		}
		else {
			currentResponder = nil;
		}
	}
}

@end
