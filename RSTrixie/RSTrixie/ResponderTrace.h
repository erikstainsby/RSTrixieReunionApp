//
//  ResponderTrace.h
//  RSTrixieEditor
//
//  Created by Erik Stainsby on 12-02-22.
//  Copyright (c) 2012 Roaring Sky. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ResponderTrace : NSObject
{
	int count;
}

- (IBAction) trace: (id)sender;
- (void) traceChain:(id)currentResponder;

@end

