//
//  PreferencesController.h
//  RSTrixieEditor
//
//  Created by Erik Stainsby on 12-02-21.
//  Copyright (c) 2012 Roaring Sky. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface PreferencesController : NSWindowController

@property (strong) IBOutlet NSUserDefaults *defaults;

@property (weak) IBOutlet NSTextField * googleAPIKey;
@property (weak) IBOutlet NSTextField * jqueryVersion;
@property (weak) IBOutlet NSTextField * jqueryUIVersion;

- (IBAction) dismissPreferenceWindow:(id)sender;
- (void) setApplicationDefaults;

@end
