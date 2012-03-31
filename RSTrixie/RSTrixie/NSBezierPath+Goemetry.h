//
//  NSBezierPath+Goemetry.h
//  RSTrixie
//
//  Created by Erik Stainsby on 12-03-15.
//  Copyright (c) 2012 Roaring Sky. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSBezierPath (Goemetry)

- (CGPathRef)			newQuartzPath;
- (CGMutablePathRef)	newMutableQuartzPath;

@end
