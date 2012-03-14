//
//  LocatorView.m
//  RSTrixie
//
//  Created by Erik Stainsby on 12-03-14.
//  Copyright (c) 2012 Roaring Sky. All rights reserved.
//

#import "LocatorView.h"

@implementation LocatorView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSLog(@"%s- [%04d] %@", __PRETTY_FUNCTION__, __LINE__, @"");
			// Initialization code here.
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];

	NSLog(@"%s- [%04d] %@", __PRETTY_FUNCTION__, __LINE__, @"");
	
		// blank my own background first ...
	CGContextRef ctx = (CGContextRef)[[NSGraphicsContext currentContext] graphicsPort];
	CGContextSetLineWidth(ctx,2.0);
	CGContextSetRGBStrokeColor(ctx, 0, 0, 1, 1);
	
		//	CGContextSetRGBFillColor(ctx, 0, 0, 1, 0.2);
		//	CGContextFillRect(ctx,self.bounds);
	
	NSRect b = [self bounds];
	
	NSRect inset = NSInsetRect(b, 5, 5);
	
	CGPathRef path = CGPathCreateWithEllipseInRect(inset,nil);
		//	CGPathAddRect(path, nil, inset);
	CGContextAddPath(ctx, path);

	CGContextStrokePath(ctx);
}

@end
