//
//  RSAppDelegate.h
//  RSTrixie
//
//  Created by Erik Stainsby on 12-02-15.
//  Copyright (c) 2012 Roaring Sky. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>
#import <RSTrixiePlugin/RSTrixie.h>
#import "RSTrixie.h"

@interface RSAppDelegate : NSObject <NSApplicationDelegate>

@property (retain) IBOutlet NSWindow * window;
	//@property (retain) IBOutlet RSTrixieEditor * editorController;
@property (retain) IBOutlet RSTrixie * browserController;

@end
