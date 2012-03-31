//
//  NSBezierPath+Goemetry.m
//  RSTrixie
//
//  Created by Erik Stainsby on 12-03-15.
//  Copyright (c) 2012 Roaring Sky. All rights reserved.
//

#import "NSBezierPath+Goemetry.h"

@implementation NSBezierPath (Goemetry)


- (CGPathRef)			newQuartzPath
{
	CGMutablePathRef mpath = [self newMutableQuartzPath];
	CGPathRef		 path = CGPathCreateCopy(mpath);
    CGPathRelease(mpath);
	
		// the caller is responsible for releasing the returned value when done
	
	return path;
}


- (CGMutablePathRef)	newMutableQuartzPath
{
    NSInteger i, numElements;
	
		// If there are elements to draw, create a CGMutablePathRef and draw.
	
    numElements = [self elementCount];
    if (numElements > 0)
    {
        CGMutablePathRef    path = CGPathCreateMutable();
        NSPoint             points[3];
		
        for (i = 0; i < numElements; i++)
        {
            switch ([self elementAtIndex:i associatedPoints:points])
            {
                case NSMoveToBezierPathElement:
                    CGPathMoveToPoint(path, NULL, points[0].x, points[0].y);
                    break;
					
                case NSLineToBezierPathElement:
                    CGPathAddLineToPoint(path, NULL, points[0].x, points[0].y);
                    break;
					
                case NSCurveToBezierPathElement:
                    CGPathAddCurveToPoint(path, NULL, points[0].x, points[0].y,
										  points[1].x, points[1].y,
										  points[2].x, points[2].y);
                    break;
					
                case NSClosePathBezierPathElement:
                    CGPathCloseSubpath(path);
                    break;
					
				default:
					break;
            }
        }
		
			// the caller is responsible for releasing this ref when done
		
		return path;
    }
	
    return nil;
}

@end
