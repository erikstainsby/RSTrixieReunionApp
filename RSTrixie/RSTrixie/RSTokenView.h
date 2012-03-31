//
//  RSTokenView.h
//  RSTrixie
//
//  Created by Erik Stainsby on 12-03-19.
//  Copyright (c) 2012 Roaring Sky. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "NSBezierPath+Goemetry.h"
#import "RSTrixie.h"

@interface RSTokenView : NSView

@property (retain) IBOutlet NSString * text;
@property (retain) IBOutlet NSDictionary * attr;
@property (retain) IBOutlet NSTextField * caption;
@property (assign) NSColor * fg;
@property (assign) NSColor * bg;
@property (assign) float opacity;
@property (retain) RSTrixiePlugin * representedObject;

@end
