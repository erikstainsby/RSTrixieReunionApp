//
//  RSTrixieBrowser.h
//  RSTrixieEditor
//
//  Created by Erik Stainsby on 12-02-18.
//  Copyright (c) 2012 Roaring Sky. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>
#import <RSTrixiePlugin/RSTrixie.h>
#import "NSView+RSPositionView.h"
#import "RSIntermediateRuleDelegate.h"
#import "RSLocatorView.h"
#import "RSPanelPopoverController.h" 
#import "RSTokenView.h"



@interface RSTrixie : NSWindowController < NSComboBoxDataSource, NSComboBoxDelegate, NSTableViewDelegate, NSTableViewDataSource >
{
	BOOL _hasJQuery;
	BOOL _hasJQueryUI;
}

@property (retain) IBOutlet RSLocatorView * locator;
@property (retain) IBOutlet RSPanelPopoverController * panelPopoverController;
@property (retain) IBOutlet id currentPlugin; 
@property (retain) IBOutlet NSBox * tokenCollection;
@property (assign) NSPoint nextTokenOrigin;

#pragma mark - Web browser props

@property (retain) NSArray * resourceCache;
@property (retain) NSMutableArray * history;
@property (retain) IBOutlet NSComboBox * urlLocationBox;
@property (retain) IBOutlet WebView * webview;
@property (retain) NSDictionary * pageDict;

#pragma mark - Rulte Editor toolbox props

@property (weak) IBOutlet NSPopover * triggerPopover;
@property (weak) IBOutlet NSPopover * reactionPopover;
@property (weak) IBOutlet NSPopover * filterPopover;

@property (retain) IBOutlet NSPanel * exportPanel;
@property (retain) IBOutlet NSTextView * exportEditor;

@property (retain) IBOutlet NSView * actionPanel;
@property (retain) IBOutlet NSView * reactionPanel;
@property (retain) IBOutlet NSView * filterPanel;
@property (retain) IBOutlet NSView * commentPanel;
@property (retain) IBOutlet NSTextField * comment;

@property (retain) NSArray * actionPlugins;
@property (retain) NSArray * reactionPlugins;
@property (retain) NSArray * filterPlugins;

@property (retain) IBOutlet NSPopUpButton * actionMenu;
@property (retain) IBOutlet NSPopUpButton * reactionMenu;
@property (retain) IBOutlet NSPopUpButton * filterMenu;

@property (retain) IBOutlet NSButton * actionHelp;
@property (retain) IBOutlet NSButton * reactionHelp;
@property (retain) IBOutlet NSButton * filterHelp;

@property (retain) RSActionPlugin * activeActionPlugin;
@property (retain) RSReactionPlugin * activeReactionPlugin;
@property (retain) RSConditionPlugin * activeFilterPlugin;

#pragma mark - Rule Table storage props

@property (retain) IBOutlet NSTableView * ruleTable;
@property (retain) IBOutlet NSMutableArray * ruleTableData;

@property (retain) IBOutlet NSTableView * intermediateTable;
@property (retain) IBOutlet RSIntermediateRuleDelegate * intermediateDelegate;

#pragma mark - Trixie editor methods

- (IBAction)	showActionPlugin:(id)sender;
- (IBAction)	showReactionPlugin:(id)sender;
- (IBAction)	showFilterPlugin:(id)sender;

- (NSURL *)		applicationSupportDirectoryURL;
- (NSArray *)	userlandPluginsWithPrefix:(NSString*)prefix;

- (IBAction)	setActionSelectorStringValue:(id)sender;
- (IBAction)	setReactionSelectorStringValue:(id)sender;
- (IBAction)	setFilterSelectorStringValue:(id)sender;

- (IBAction)	addCommentToIntermediateTable:(id)sender;
- (IBAction)	addActionToIntermediateTable:(id)sender;
- (IBAction)	addReactionToIntermediateTable:(id)sender;
- (IBAction)	addFilterToIntermediateTable:(id)sender;

- (IBAction)	addRule:(id)sender;
- (IBAction)	removeRule:(id)sender;
- (IBAction)	showExportPanel:(id)sender;

- (void)		placeLocator:(NSNotification *) nota;
- (IBAction)	activatePlugin:(id)sender;


#pragma mark - Table DataSource & Delegate support methods

- (NSInteger)	numberOfRowsInTableView:(NSTableView *)tableView;
- (id)			tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row;
- (void)		tableView:(NSTableView *)aTableView setObjectValue:(id)anObject forTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex;

- (void)		appendRule:(RSTrixieRule *) rule;


#pragma mark - WebView delegate methods & UIDelegate methods

- (IBAction)	goForwardOrBack:(id)sender;
- (void)		webView:(WebView *)sender didFinishLoadForFrame:(WebFrame *)frame;
- (void)		webView:(WebView *)sender didReceiveTitle:(NSString *)title forFrame:(WebFrame *)frame;
- (void)		webView:(WebView*) sender makeFirstResponder:(NSResponder *)responder;
- (NSArray *)	webView:(WebView *)sender contextMenuItemsForElement:(NSDictionary *)element defaultMenuItems:(NSArray *)defaultMenuItems;

#pragma mark - NSComboBox datasource methods

- (NSInteger)	numberOfItemsInComboBox:(NSComboBox *)aComboBox;
- (id)			comboBox:(NSComboBox *)aComboBox objectValueForItemAtIndex:(NSInteger)index;

#pragma mark - relay settings to editorController

- (IBAction)	quickSetActionSelector:(id)sender;
- (IBAction)	quickSetReactionSelector:(id)sender;
- (IBAction)	quickSetFilterSelector:(id)sender;

- (IBAction)	reloadScriptIntoPage:(id)sender;
- (void)		injectScript;

@end
