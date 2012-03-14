//
//  DOMElement+RSLDOMExtensions.m
//  RSLightning 0.7
//
//  Created by Erik Stainsby on 2011/11/06.
//  Copyright (c) 2011 Roaring Sky Software. All rights reserved.
//

#import "DOMElement+RSLDOMExtensions.h"

@implementation DOMElement (RSLDOMExtensions)

- (NSArray*) _getClasses {
	return [[self getAttribute:@"class"] componentsSeparatedByString:@" "];
}

- (BOOL) hasClass:(NSString*)_className {
	NSArray * _classes = [self _getClasses];
	for(NSString * aClass in _classes) {
		if( [aClass isEqualToString:_className] ) {
			return YES;
		}
	}
	return NO;
}

- (void) addClass:(NSString*)_className {
	if( ![self hasClass:_className]) {
		NSMutableArray * _classes = [[self _getClasses] mutableCopy]; 
		[_classes addObject: _className];
		[self setAttribute:@"class" value:[_classes componentsJoinedByString:@" "]];
	}
}
	
- (void) removeClass:(NSString*)_className {
	if([self hasClass:_className]){
		NSArray * _classes = [[self _getClasses] mutableCopy]; 
		NSMutableArray * _out = [[NSMutableArray alloc] initWithCapacity:[_classes count]-1];
		for(NSString * _class in _classes) {
			if(![_class isEqualToString: _className]) {
				[_out addObject:_class];
			}
		}
		[self setAttribute:@"class" value:[_out componentsJoinedByString:@" "]];
	}
}

- (void) replaceClass:(NSString*)_className withClass:(NSString*)otherClassName {
	if([self hasClass: _className]) {
		[self removeClass:_className];
		[self addClass:otherClassName];
	}
}

@end
