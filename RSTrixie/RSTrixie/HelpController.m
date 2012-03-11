//
//  HelpController.m
//  RSTrixieEditor
//
//  Created by Erik Stainsby on 12-02-20.
//  Copyright (c) 2012 Roaring Sky. All rights reserved.
//

#import "HelpController.h"

@interface HelpController ()

@end

@implementation HelpController

@synthesize popover = _popover;
@synthesize helpCaption = _helpCaption;
@synthesize helpText = _helpText;


- (IBAction) showHelp:(id)sender {
	
	if( [sender tag] == 0 ) {
		[_helpCaption setStringValue:@"Action"];
		[_helpText setStringValue:@"The action or event which triggers the behaviour described below."];
	}	
	else if ([sender tag] == 1) {
		[_helpCaption setStringValue:@"Reaction"];
		[_helpText setStringValue:@"The desired effect or behaviour."];
	}
	else if ([sender tag] == 2) {
		[_helpCaption setStringValue:@"Condition"];
		[_helpText setStringValue:@"Any conditions or limits which must be satisfied before the effect is rendered."];
	}
	else {
		[_helpCaption setStringValue:@"Not Found"];
		[_helpText setStringValue:@"A related help topic for this subject could not be found."];
	}
	[_popover showRelativeToRect:[sender bounds] ofView:sender preferredEdge:NSMaxYEdge];
}

@end
