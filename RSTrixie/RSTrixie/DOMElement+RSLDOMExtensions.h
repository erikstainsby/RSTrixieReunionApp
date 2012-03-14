//
//  DOMElement+RSLDOMExtensions.h
//  RSLightning 0.7
//
//  Created by Erik Stainsby on 2011/11/06.
//  Copyright (c) 2011 Roaring Sky Software. All rights reserved.
//

#import <WebKit/WebKit.h>

@interface DOMElement (RSLDOMExtensions)
{
	
}

- (BOOL) hasClass:(NSString*)className;
- (void) addClass:(NSString*)className; 
- (void) removeClass:(NSString*)className;
- (void) replaceClass:(NSString*)className withClass:(NSString*)otherClassName; 

@end
