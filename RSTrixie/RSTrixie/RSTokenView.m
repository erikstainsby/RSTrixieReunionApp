//
//  RSTokenView.m
//  RSTrixie
//
//  Created by Erik Stainsby on 12-03-19.
//  Copyright (c) 2012 Roaring Sky. All rights reserved.
//

#import "RSTokenView.h"

@implementation RSTokenView

@synthesize text = _text;
@synthesize attr;
@synthesize caption;
@synthesize fg;
@synthesize bg;
@synthesize opacity;
@synthesize representedObject;


- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void) encodeWithCoder:(NSCoder *) encoder {
	NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:[self text],@"text",nil];
	[encoder encodeObject:dict forKey:@"dict"];
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
	
	NSLog(@"%s- [%04d] %@", __PRETTY_FUNCTION__, __LINE__, @"");
	
		// blank my own background first ...
	CGContextRef ctx = (CGContextRef)[[NSGraphicsContext currentContext] graphicsPort];
	CGContextSetLineWidth(ctx,2.0);
	
		//[fg set];		// for text
	[bg setStroke];		// border & background fill
	[bg setFill];
	
	NSSize strSize = [[self text] sizeWithAttributes:attr];
	
	NSRect b = [self bounds];
	b.size.width = strSize.width + 20;
	b.size.height = strSize.height + 6;
	
	NSLog(@"%s- [%04d] inner bounds: %@", __PRETTY_FUNCTION__, __LINE__, NSStringFromRect(b));
	
	NSBezierPath * nspath = [NSBezierPath bezierPathWithRoundedRect:b xRadius:b.size.height/2 yRadius:b.size.height/2];
	
	CGMutablePathRef path = [nspath newMutableQuartzPath];
	CGPathRef p = CGPathCreateCopy(path);

	CGContextAddPath(ctx, p);
	CGContextFillPath(ctx);
	CGContextStrokePath(ctx);

	[[self text] drawAtPoint:NSMakePoint(10,3) withAttributes:attr];
}

@end
