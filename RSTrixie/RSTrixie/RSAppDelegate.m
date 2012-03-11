//
//  RSAppDelegate.m
//  RSTrixie
//
//  Created by Erik Stainsby on 12-02-15.
//  Copyright (c) 2012 Roaring Sky. All rights reserved.
//

#import "RSAppDelegate.h"

@implementation RSAppDelegate

@synthesize window;
	//@synthesize editorController;
@synthesize browserController;

- (id)init {
	if(nil!=(self=[super init]))
	{
		NSLog(@"%s- [%04d] %@", __PRETTY_FUNCTION__, __LINE__, @"");
		
			//		editorController = [[RSTrixieEditor alloc] init];
			//		[[editorController window] makeKeyAndOrderFront:self];
		
		browserController = [[RSTrixie alloc] init];
		[[browserController window] orderFront:self];
	}
	return self;
}


- (void) applicationWillFinishLaunching:(NSNotification*) aNotification {
	
}

- (void) applicationDidFinishLaunching:(NSNotification*) aNotification {
}


- (BOOL) applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
	return YES;
}


@end
