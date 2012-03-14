//
//  RSWebView.h
//  RSTrixieEditor
//
//  Created by Erik Stainsby on 12-02-18.
//  Copyright (c) 2012 Roaring Sky. All rights reserved.
//

#import <WebKit/WebKit.h>

@interface RSWebView : WebView

@property (assign) NSTrackingRectTag trackingRectTag;

- (BOOL) acceptsFirstResponder;


@end
