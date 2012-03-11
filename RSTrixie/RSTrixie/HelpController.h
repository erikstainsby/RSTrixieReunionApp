//
//  HelpController.h
//  RSTrixieEditor
//
//  Created by Erik Stainsby on 12-02-20.
//  Copyright (c) 2012 Roaring Sky. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface HelpController : NSViewController < NSPopoverDelegate >

@property (weak) IBOutlet NSPopover * popover;
@property (weak) IBOutlet NSTextField * helpCaption;
@property (weak) IBOutlet NSTextField * helpText;

- (IBAction) showHelp:(id)sender;

@end
