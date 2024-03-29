//
//  RSTrixieBrowser.m
//  RSTrixieEditor
//
//  Created by Erik Stainsby on 12-02-18.
//  Copyright (c) 2012 Roaring Sky. All rights reserved.
//

#import "RSTrixie.h"

@interface RSTrixie ()

- (NSString *) despoolScript;

@end

@implementation RSTrixie


@synthesize locator; 
@synthesize panelPopoverController;
@synthesize currentPlugin;
@synthesize tokenCollection;
@synthesize nextTokenOrigin;

@synthesize resourceCache;
@synthesize history;
@synthesize urlLocationBox;
@synthesize webview;
@synthesize pageDict;

@synthesize triggerPopover = _triggerPopover;
@synthesize reactionPopover = _reactionPopover;
@synthesize filterPopover = _filterPopover;

@synthesize exportPanel;
@synthesize exportEditor;

@synthesize actionPanel;		// custom view
@synthesize reactionPanel;		// custom view
@synthesize filterPanel;		// custom view
@synthesize commentPanel;
@synthesize comment;			// NSTextField

@synthesize actionPlugins;		// view controllers 
@synthesize reactionPlugins;	// view controllers 
@synthesize filterPlugins;	// view controllers 

@synthesize actionMenu;			// popup button
@synthesize reactionMenu;		// popup button
@synthesize filterMenu;		// popup button

@synthesize actionHelp;
@synthesize reactionHelp;
@synthesize filterHelp;

@synthesize activeActionPlugin;
@synthesize activeReactionPlugin;
@synthesize activeFilterPlugin;

@synthesize ruleTable;
@synthesize ruleTableData;

@synthesize intermediateTable;
@synthesize intermediateDelegate;


- (id)init {

    self = [super initWithWindowNibName:@"RSTrixie" owner:self];
    if (self) {
		
		actionPlugins = [NSMutableArray array];
		reactionPlugins = [NSMutableArray array];
		filterPlugins = [NSMutableArray array];
		
		RSTrixieLoader * loader = [[RSTrixieLoader alloc] init];
		
		NSLog(@"%s- [%04d] %@", __PRETTY_FUNCTION__, __LINE__, loader);
		
		[self setActionPlugins:		[loader loadPluginsWithPrefix:@"Action"		ofType:@"bundle"]];
		[self setReactionPlugins:	[loader loadPluginsWithPrefix:@"Reaction"	ofType:@"bundle"]];
		[self setFilterPlugins:		[loader loadPluginsWithPrefix:@"Condition"	ofType:@"bundle"]];
		
		NSLog(@"%s- [%04d] filter plugins loaded: %lu", __PRETTY_FUNCTION__, __LINE__, [filterPlugins count]);
		
		[[webview menu] setAutoenablesItems:NO];
		[webview setMaintainsBackForwardList:YES];
		
		[ruleTable setDelegate: self];
		ruleTableData = [NSMutableArray array];
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(placeLocator:) name:nnRSWebViewLeftMouseDownEventNotification object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(injectScript:) name:nnRSTrixieReloadJavascriptNotification object:nil];
    }
    return self;
}

#pragma mark - Trixie editor methods

- (void) windowDidLoad {
	
    [super windowDidLoad];
	
	NSPoint pt = NSMakePoint([self window].frame.size.width, [self window].frame.size.height);
	[locator setFrameOrigin:pt];
	[[[self window] contentView] addSubview:locator];
	
	NSMenu * menu = [[NSMenu alloc] init];
	for(RSActionPlugin * p in actionPlugins)
	{
		NSMenuItem * menuItem = [[NSMenuItem alloc] initWithTitle:[p pluginName] action:@selector(showActionPlugin:) keyEquivalent:@""];
		[menuItem setRepresentedObject:p];
		[menu addItem:menuItem];
			//		NSLog(@"%s- [%04d] added action menu item for plugin: %@", __PRETTY_FUNCTION__, __LINE__, [p name]);
	}
	[actionMenu setMenu:menu];
	menu = nil;
	
	NSMenu * menu2 = [[NSMenu alloc] init];	
	for(RSReactionPlugin * p in reactionPlugins)
	{
		NSMenuItem * menuItem = [[NSMenuItem alloc] initWithTitle:[p pluginName] action:@selector(showReactionPlugin:) keyEquivalent:@""];
		[menuItem setRepresentedObject:p];
		[menu2 addItem:menuItem];
			//		NSLog(@"%s- [%04d] added reaction menu item for plugin: %@", __PRETTY_FUNCTION__, __LINE__, [p name]);
	}
	[reactionMenu setMenu:menu2];
	menu2 = nil;
	
	NSMenu * menu3 = [[NSMenu alloc] init];	
	for(RSConditionPlugin * p in filterPlugins)
	{
		NSMenuItem * menuItem = [[NSMenuItem alloc] initWithTitle:[p pluginName] action:@selector(showFilterPlugin:) keyEquivalent:@""];
		[menuItem setRepresentedObject:p];
		[menu3 addItem:menuItem];
			//		NSLog(@"%s- [%04d] added filter menu item for plugin: %@", __PRETTY_FUNCTION__, __LINE__, [p name]);
	}
	[filterMenu setMenu:menu3];
	menu3 = nil;
	
		// now we can set the current plugin's views
	
		//	[self showActionPlugin:		];
		//	[self showReactionPlugin:	[reactionMenu itemAtIndex:0]];
		//	[self showFilterPlugin:		[filterMenu itemAtIndex:0]];
	
	intermediateDelegate = [[RSIntermediateRuleDelegate alloc] init];
	[intermediateTable setDelegate:intermediateDelegate];
	[intermediateTable setDataSource:intermediateDelegate];
	[intermediateDelegate setRulePartsTable:intermediateTable];
	 
	nextTokenOrigin = NSMakePoint(tokenCollection.frame.origin.x+10,0);
	
}

- (IBAction)	showActionPlugin:(id)sender {
	
	NSString * name = [sender title];
	RSActionPlugin * p  = [sender representedObject];
	
	if( activeActionPlugin == nil) {
		[actionPanel addSubview:[p view]];
	}
	else {	
		[actionPanel replaceSubview:[activeActionPlugin view] with:[p view]];
	}
	[[p view] setFrameTopLeftPoint:actionMenu.frame.origin];
	
	currentPlugin = p;
	activeActionPlugin = p;
	
	NSLog(@"%s- [%04d] %@", __PRETTY_FUNCTION__, __LINE__, name);
}
- (IBAction)	showReactionPlugin:(id)sender {
	
	NSString * name = [sender title];
	RSReactionPlugin * p  = [sender representedObject];
	
	if( activeReactionPlugin == nil) {
		[reactionPanel addSubview:[p view]];
	}
	else {
		[reactionPanel replaceSubview:[activeReactionPlugin view] with:[p view]];
	}
	[[p view] setFrameTopLeftPoint:reactionMenu.frame.origin];
	
	currentPlugin = p;
	activeReactionPlugin = p;
	
	NSLog(@"%s- [%04d] %@", __PRETTY_FUNCTION__, __LINE__, name);
}
- (IBAction)	showFilterPlugin:(id)sender {
	
	NSString * name = [sender title];
	RSConditionPlugin * p  = [sender representedObject];
	
	if(activeFilterPlugin == nil) {
		[filterPanel addSubview:[p view]];
	}
	else {
		[filterPanel replaceSubview:[activeFilterPlugin view] with:[p view]];
	}
	[[p view] setFrameTopLeftPoint:filterMenu.frame.origin];	
	
	currentPlugin = p;
	activeFilterPlugin = p;
	
	NSLog(@"%s- [%04d] %@", __PRETTY_FUNCTION__, __LINE__, name);
}

- (NSURL *)		applicationSupportDirectoryURL {
    static NSURL * _asd = nil;
    if(_asd){
		return _asd;
	}
    NSFileManager * fm = [NSFileManager defaultManager];
	NSError * error = nil;
    NSURL * libraryURL = [fm URLForDirectory:NSApplicationSupportDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:&error];
    if( nil == libraryURL) {
        [NSApp presentError: error];
    }
    else 
    {
        _asd = [libraryURL URLByAppendingPathComponent:RSTRIXIE_APP_SUPPORT_DIR isDirectory:YES];
        _asd = [_asd URLByAppendingPathComponent:RSTRIXIE_WORKING_DIR isDirectory:YES];
        NSDictionary * props = [_asd resourceValuesForKeys:[NSArray arrayWithObject:NSURLIsDirectoryKey] error:&error];
        if( nil == props ) 
		{
            if(![fm createDirectoryAtURL:_asd withIntermediateDirectories:YES attributes:nil error:&error]) 
			{
                [NSApp presentError:error];
                _asd = nil;
            }
        }
    }
	NSLog(@"[%04d] %@ %@: %@",__LINE__,[self class],@"_asd",_asd);
    return _asd;
}
- (NSArray *)	userlandPluginsWithPrefix:(NSString*)prefix {
	
		// NOT YET IMPLEMENTED STUB	
	
	NSMutableArray * userPlugins = [NSMutableArray array];
	
	NSString * dir = [[self applicationSupportDirectoryURL] path];
	NSLog(@"%s- [%04d] %@", __PRETTY_FUNCTION__, __LINE__, dir);
	
	return userPlugins;
}

- (IBAction)	setActionSelectorStringValue:(id)sender {
		//	NSLog(@"%s- [%04d] %@", __PRETTY_FUNCTION__, __LINE__, sender);
	[[activeActionPlugin selectorField] setStringValue:sender];
}
- (IBAction)	setReactionSelectorStringValue:(id)sender {
		//	NSLog(@"%s- [%04d] %@", __PRETTY_FUNCTION__, __LINE__, sender);
	[[activeReactionPlugin targetField] setStringValue:sender];
}
- (IBAction)	setFilterSelectorStringValue:(id)sender {
	NSLog(@"%s- [%04d] %@", __PRETTY_FUNCTION__, __LINE__, sender);
		//	[[activefilterPlugin selectorField] setStringValue:sender];
}

- (IBAction)	addCommentToIntermediateTable:(id)sender {
	RSCommentRule * rule = [[RSCommentRule alloc] init];
	[rule setText:[[self comment] stringValue]];
	[intermediateDelegate addComment: rule];
	[[self comment] setStringValue:@""];
}
- (IBAction)	addActionToIntermediateTable:(id)sender {
	RSActionRule * actionRule = [[RSActionRule alloc] init];
	[actionRule setEvent:				[activeActionPlugin event]];
	if([activeActionPlugin hasSelectorField]) {
		[actionRule setSelector:		[[activeActionPlugin selectorField] stringValue]];
	}
	else {
		NSAlert * alert = [[NSAlert alloc] init];
		[alert setAlertStyle:NSWarningAlertStyle];
		[alert setMessageText:@"Unable to save this Trigger"];
		[alert setInformativeText:@"A Trigger must have a jQuery selector set before it can be saved."];
		[alert addButtonWithTitle:@"Return"];
		NSInteger result = [alert runModal];
		if(result == NSAlertFirstButtonReturn ) {
				// done.
		}
		return; 
	}
	if( [activeActionPlugin preventDefaultButton]) {
		[actionRule setPreventDefault:	[activeActionPlugin preventDefault]];
	}
	if( [activeActionPlugin stopBubblingButton]) {
		[actionRule setStopBubbling:	[activeActionPlugin stopBubbling]];
	}
	if([intermediateDelegate addActionRule: actionRule]) {
		[activeActionPlugin resetForm];
	}
}
- (IBAction)	addReactionToIntermediateTable:(id)sender {
	RSReactionRule * reactionRule = [[RSReactionRule alloc] init];
	NSString * script = [activeReactionPlugin emitScript];
	if(nil == script) {
		NSAlert * alert = [[NSAlert alloc] init];
		[alert setAlertStyle:NSCriticalAlertStyle];
		[alert setMessageText:@"Unable to save this Reaction"];
		[alert setInformativeText:@"The script fragment failed to save."];
		[alert addButtonWithTitle:@"Return"];
		NSInteger result = [alert runModal];
		if(result == NSAlertFirstButtonReturn ) {
				// done.
		}
		return;
	}
	[reactionRule setScript: script];
	[intermediateDelegate addReactionRule:reactionRule];
}
- (IBAction)	addFilterToIntermediateTable:(id)sender {
	RSConditionRule * filterRule = [[RSConditionRule alloc] init];
	NSString * script = [activeFilterPlugin expression];
	if(nil == script) {
		NSAlert * alert = [[NSAlert alloc] init];
		[alert setAlertStyle:NSCriticalAlertStyle];
		[alert setMessageText:@"Unable to save this Filter"];
		[alert setInformativeText:@"The script fragment failed to save."];
		[alert addButtonWithTitle:@"Return"];
		NSInteger result = [alert runModal];
		if(result == NSAlertFirstButtonReturn ) {
				// done.
		}
		return;
	}
	[filterRule setScript: script];	
	[intermediateDelegate addFilterRule:filterRule];
}

- (IBAction)	addRule:(id)sender {
	RSTrixieRule * rule = [intermediateDelegate composeRule];
	[self appendRule: rule];
}
- (IBAction)	removeRule:(id)sender {
	NSIndexSet * rows = [ruleTable selectedRowIndexes];
	[ruleTableData removeObjectsAtIndexes:rows];
	[ruleTable reloadData];
}
- (IBAction)	showExportPanel:(id)sender {
	
		// retrieve the script lines from the tableView' ruleData array
	NSString * script = [self despoolScript];
	
	NSString * page = @"<!-- ** Trixie - jQuery loader helper script [optional] ** -->\n";
	page = [page stringByAppendingString:@"<script id=\"Your Google API key\" type=\"text/javascript\""];
	page = [page stringByAppendingFormat:@" src=\"https://www.google.com/jsapi?key=%@\">", [[NSUserDefaults standardUserDefaults] valueForKey:@"googleAPIKey"]];
	page = [page stringByAppendingString:@"</script>\n"];
	page = [page stringByAppendingString:@"<script id=\"jquery-loader\" type=\"text/javascript\">"];
	page = [page stringByAppendingFormat:@"\tgoogle.load('jquery','%@');", [[NSUserDefaults standardUserDefaults] valueForKey:@"jqueryVersion"]];
	page = [page stringByAppendingString:@"</script>\n"];
	page = [page stringByAppendingString:@"<script id=\"jquery-ui-loader\">"];
	page = [page stringByAppendingFormat:@"\tgoogle.load('jquery-ui','%@');", [[NSUserDefaults standardUserDefaults] valueForKey:@"jqueryUIVersion"]];
	page = [page stringByAppendingString:@"</script>\n\n\n"];

	page = [page stringByAppendingString:@"<!-- ** Trixie generated script ** -->\n"];
	page = [page stringByAppendingString:@"<script id=\"RSTrixieScript\" type=\"text/javascript\">\njQuery().ready(function($){\n"];
	page = [page stringByAppendingString: script];
	page = [page stringByAppendingString:@"}); \n"];
	page = [page stringByAppendingString:@"</script>\n"];
	
	NSFont * font = [[NSFontManager sharedFontManager] fontWithFamily:@"Menlo" traits:NSUnboldFontMask weight:7 size:13];
	NSDictionary * attr = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontNameAttribute, nil];
	NSAttributedString * attrString = [[NSAttributedString alloc] initWithString:page attributes:attr];
	
	[[exportEditor textStorage] setAttributedString:attrString];
	
	[exportPanel orderFront:sender];
}

- (void)		placeLocator:(NSNotification*) nota {
	
	NSEvent * event = [nota object];
	NSPoint pt = [event locationInWindow];
	NSRect f = [locator frame];
	pt.x -= f.size.width + 10;
	pt.y -= f.size.height/2;
	[locator setFrameOrigin:pt];
	
		// send both the locator and the appropriate plugin set
	[panelPopoverController showPanelPopover:locator activePanel:actionPanel];
}

- (RSTokenView*) tokenForPluginWithState:(RSTrixiePlugin*)plugin {
		
	RSTokenView * token = [[RSTokenView alloc] init];
	[token setOpacity: 1.0];
	if([plugin isKindOfClass:[RSActionPlugin class]]) {
		[token setFg:[NSColor whiteColor]];
		[token setBg:[NSColor blueColor]];
		[token setText:[(RSActionPlugin*)plugin event]];
	}
	else if([plugin isKindOfClass:[RSReactionPlugin class]]) {
		[token setFg:[NSColor whiteColor]];
		[token setBg:[NSColor redColor]];
		[token setText:[(RSReactionPlugin*)plugin action]];
	}
	else if([plugin isKindOfClass:[RSConditionPlugin class]]) {
		[token setFg:[NSColor whiteColor]];
		[token setBg:[NSColor darkGrayColor]];
		[token setText:[(RSConditionPlugin*)plugin predicate]];
	}
	
	[token setRepresentedObject:plugin];

	return token;
}


- (IBAction)	activatePlugin:(id)sender {
	
	if([currentPlugin isKindOfClass:[RSTrixiePlugin class]]) {
		NSLog(@"%s- [%04d] previous plugin class: %@", __PRETTY_FUNCTION__, __LINE__, [currentPlugin className]);
			//	RSTokenView * token = [self tokenForPluginWithState:currentPlugin];
	}
	
	if([sender selectedSegment] == 0) {
			// trigger 
		[self setCurrentPlugin: [[actionMenu itemAtIndex:([actionMenu indexOfSelectedItem]? [actionMenu indexOfSelectedItem] : 0)] representedObject]];
		[panelPopoverController showPanelPopover:locator activePanel:actionPanel];
	}
	else if([sender selectedSegment] == 1) {
			// reactions
		[self setCurrentPlugin: [[reactionMenu itemAtIndex:([reactionMenu indexOfSelectedItem]? [reactionMenu indexOfSelectedItem] : 0)] representedObject]];
		[panelPopoverController showPanelPopover:locator activePanel:reactionPanel];
	}
	else if([sender selectedSegment] == 2) {
			// filters
		[self setCurrentPlugin: [[filterMenu itemAtIndex:([filterMenu indexOfSelectedItem]? [filterMenu indexOfSelectedItem] : 0)] representedObject]];
		[panelPopoverController showPanelPopover:locator activePanel:filterPanel];
	}
	else {
		NSLog(@"%s- [%04d] %@", __PRETTY_FUNCTION__, __LINE__, @"Unsupported segment selected in popover UI. (urk!?)");
	}
	NSLog(@"%s- [%04d] current plugin class: %@", __PRETTY_FUNCTION__, __LINE__, [currentPlugin className]);
} 

   

#pragma mark - Table DataSource & Delegate support methods

- (NSInteger)	numberOfRowsInTableView:(NSTableView *)tableView {
		//	NSLog(@"%s- [%04d] ruleTableData count: %lu", __PRETTY_FUNCTION__, __LINE__, [ruleTableData count]);
	return [ruleTableData count];
}
- (id)			tableView:(NSTableView*)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
		//	NSLog(@"%s- [%04d] column %@, row %lu", __PRETTY_FUNCTION__, __LINE__, [tableColumn identifier], row);
	if([[tableColumn identifier] isEqualToString:@"rowid"]) {
		return [NSNumber numberWithInteger:row];
	}
	RSTrixieRule * rule = [ruleTableData objectAtIndex:row];
	return [rule valueForKey:[tableColumn identifier]];	
}
- (void)		tableView:(NSTableView *)aTableView setObjectValue:(id)anObject forTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex {
	
	NSMutableDictionary * rowData = [ruleTableData objectAtIndex:rowIndex];
	[rowData setValue:anObject forKey:[aTableColumn identifier]];
	[ruleTableData replaceObjectAtIndex:rowIndex withObject:rowData];
	[ruleTable reloadData];
}

- (void)		appendRule:(RSTrixieRule *) rule {
	
	NSLog(@"%s- [%04d] %@", __PRETTY_FUNCTION__, __LINE__, @"");
		// add new rule
	[ruleTableData addObject:rule];
		// repaint tableView
	[ruleTable reloadData];
		// send revised script to browser content
	[self injectScript];
}
- (NSString *)	despoolScript {
	NSString * 	script = @"";
	for(RSTrixieRule * rule in ruleTableData)
	{
		script = [script stringByAppendingFormat:@"%@\n",[rule emitScript]];
	}
	return script;
}

#pragma mark - WebView Browser methods

- (IBAction)	goForwardOrBack:(id)sender {
	if( [sender selectedSegment] == 0 && [webview canGoBack] ) 
	{
		[webview goBack];
	}
	else if( [sender selectedSegment] == 1 && [webview canGoForward] ) 
	{
		[webview goForward];
	}
	[urlLocationBox setStringValue:[webview mainFrameURL]];
	
	// update history
	WebHistoryItem * item = [[webview backForwardList] currentItem];
	if( ! [history containsObject:item]) {
		[history addObject:item];
	}
}
- (BOOL)		scanCacheForResourceWithName:(NSString*)resourceName {

	for(WebResource * wr in resourceCache) {
		if( [[[wr URL] lastPathComponent] hasPrefix:resourceName] ) 
		{
			NSLog(@"%s- [%04d] identified resource: %@ in URL: %@", __PRETTY_FUNCTION__, __LINE__, resourceName, [[wr URL] path]);
			return YES;
		}
	}
	return NO;
}

- (void)		webView:(WebView *)sender didFinishLoadForFrame:(WebFrame *)frame {
	if( [sender mainFrame] == frame )
	{
			//		NSLog(@"%s- [%04d] %@", __PRETTY_FUNCTION__, __LINE__, @"");
		resourceCache = [[[sender mainFrame] dataSource] subresources];
		
		_hasJQuery = [self scanCacheForResourceWithName:@"jquery"];
		_hasJQueryUI = [self scanCacheForResourceWithName:@"jqueryui"];
		_hasJQueryUI = [self scanCacheForResourceWithName:@"jquery-ui"];
		
		NSString * urlString = [webview mainFrameURL];
		
		DOMDocument * doc = [webview mainFrameDocument];
		NSString * doctype = [self doctypeString:[doc doctype]];
		
		DOMNode * html = [(DOMNodeList *)[doc getElementsByTagName:@"html"] item:0];
		NSString * htmlTag = [self selectorForDOMNode:html];
		
		DOMNodeList * list = [doc getElementsByTagName:@"head"];
		DOMHTMLElement * head = (DOMHTMLElement*)[list item:0]; 
		NSString * headString = [head innerHTML];
		
		list = [doc getElementsByTagName:@"body"];
		DOMNode * body = (DOMHTMLElement*)[list item:0]; 
		NSString * bodyTag = [self selectorForDOMNode:body];
		NSString * bodyString = [(DOMHTMLElement *)body innerHTML];
		
		pageDict = [NSDictionary dictionaryWithObjectsAndKeys:urlString,@"url",
							   doctype,@"doctype",
							   htmlTag,@"htmlTag",
							   headString,@"head",  
							   bodyTag,@"bodyTag",
							   bodyString,@"body", 
							   nil];
		
		[[NSNotificationCenter defaultCenter] postNotificationName:nnRSWebViewFrameDidFinishLoad object:pageDict];
		
//		NSLog(@"%s- [%04d] %@", __PRETTY_FUNCTION__, __LINE__, [pageDict valueForKey:@"doctype"]);
//		NSLog(@"%s- [%04d] %@", __PRETTY_FUNCTION__, __LINE__, [pageDict valueForKey:@"htmlTag"]);
//		NSLog(@"%s- [%04d] %@", __PRETTY_FUNCTION__, __LINE__, [pageDict valueForKey:@"head"]);
//		NSLog(@"%s- [%04d] %@", __PRETTY_FUNCTION__, __LINE__, [pageDict valueForKey:@"bodyTag"]);
//		NSLog(@"%s- [%04d] %@", __PRETTY_FUNCTION__, __LINE__, [pageDict valueForKey:@"body"]);
		
		
	}
}
- (void)		webView:(WebView *)sender didReceiveTitle:(NSString *)title forFrame:(WebFrame *)frame {
	if( [[sender mainFrame] isEqual: frame] )
	{
		[[sender window] setTitle: title];
	}
}
- (void)		webView:(WebView*) sender makeFirstResponder:(NSResponder *)responder { 
	if( [responder respondsToSelector:@selector(acceptsFirstResponder:)] )
	{
		[responder becomeFirstResponder];
	}
}

- (NSString *)	doctypeString:(DOMDocumentType*)doctype {
	NSString * string = @"<!doctype";
	
	if([[doctype name] length] > 0) string = [string stringByAppendingFormat:@" %@",[doctype name]];
	if([[doctype publicId] length] > 1) string = [string stringByAppendingFormat:@" \"%@\"",[doctype publicId]];
	if([[doctype systemId] length] > 1) string = [string stringByAppendingFormat:@" \"%@\"",[doctype systemId]];
	
	string = [string stringByAppendingString:@">"];
	
	return string;
}
- (NSString *)	selectorForDOMNode:(DOMNode*)node {
	
	NSString * selector = @"";
	DOMElement * el = nil;
	if( [node nodeType] == DOM_ELEMENT_NODE) 
	{
		el = (DOMElement *)node;
	}
	else if( [node nodeType] == DOM_TEXT_NODE)  
	{
		el = [(DOMElement *)node parentElement];	
	}	
	if( el != nil ) {
		selector = [el tagName]; 
		if([el hasAttribute:@"id"]) {
			selector = [selector stringByAppendingFormat:@"#%@",[el getAttribute:@"id"]];
		}
		if( ! [[el className] isEqualToString:@""] ) {
				// classes may be multiple
			NSString * classes = [[[el className] componentsSeparatedByString:@" "] componentsJoinedByString:@"."];
			selector = [selector stringByAppendingFormat:@".%@",classes];
		}
		
			//		NSLog(@"%s- [%04d] %@", __PRETTY_FUNCTION__, __LINE__, selector );
	}
	return selector;
}
- (NSArray *)	webView:(WebView *)sender contextMenuItemsForElement:(NSDictionary *)element defaultMenuItems:(NSArray *)defaultMenuItems {
	
	NSString * nodeSelector = [self selectorForDOMNode:[element objectForKey:WebElementDOMNodeKey]];
	
		//	NSLog(@"%s- [%04d] %@", __PRETTY_FUNCTION__, __LINE__, nodeSelector);
	
	NSMenuItem * item1 = [[NSMenuItem alloc] initWithTitle:@"Set Action selector" 
													action:@selector(quickSetActionSelector:) 
											 keyEquivalent:@""];
	NSMenuItem * item2 = [[NSMenuItem alloc] initWithTitle:@"Set Reaction selector" 
													action:@selector(quickSetReactionSelector:) 
											 keyEquivalent:@""];
	NSMenuItem * item3 = [[NSMenuItem alloc] initWithTitle:@"Set filter selector" 
													action:@selector(quickSetfilterSelector:) 
											 keyEquivalent:@""];
	
	if([[self activeActionPlugin] hasSelectorField] ) {
		[item1 setTarget:self];
		[item1 setEnabled:YES];
		[item1 setRepresentedObject:nodeSelector];
	}
	else {
		[item1 setEnabled:NO];
	}
	if([[self activeReactionPlugin] hasSelectorField]) {
		[item2 setTarget:self];
		[item2 setEnabled:YES];
		[item2 setRepresentedObject:nodeSelector];
	}
	else {
		[item2 setEnabled:NO];
	}
	if([[self activeFilterPlugin] hasSelectorField]) {
		[item3 setTarget:self];
		[item3 setEnabled:YES];
		[item3 setRepresentedObject:nodeSelector];
	}
	else {
		[item3 setEnabled:NO];
	}
	
	NSMutableArray * myMenu = [NSMutableArray arrayWithObjects:item1,item2,item3,nil];
	return [myMenu arrayByAddingObjectsFromArray:defaultMenuItems];
}



#pragma mark - NSComboBox datasource methods 

- (NSInteger)	numberOfItemsInComboBox:(NSComboBox *)aComboBox {
	return [history count];
}
- (id) comboBox:(NSComboBox *)aComboBox objectValueForItemAtIndex:(NSInteger)index {
	WebHistoryItem * item = [history objectAtIndex:index];
	return [item URLString];
}

#pragma mark - relay 

- (IBAction)	quickSetActionSelector:(id)sender {
	NSLog(@"%s- [%04d] %@", __PRETTY_FUNCTION__, __LINE__, @"");
	[self setActionSelectorStringValue:[sender representedObject]];
}
- (IBAction)	quickSetReactionSelector:(id)sender {
		//	NSLog(@"%s- [%04d] %@", __PRETTY_FUNCTION__, __LINE__, @"");
	[self setReactionSelectorStringValue:[sender representedObject]];
}
- (IBAction)	quickSetFilterSelector:(id)sender {
		//	NSLog(@"%s- [%04d] %@", __PRETTY_FUNCTION__, __LINE__, @"");
	[self setFilterSelectorStringValue:[sender representedObject] ];
}

#pragma mark - Receive instruction to reload html, insert jQuery/-UI if required, and injecting the custom behaviours

- (IBAction)	reloadScriptIntoPage:(id)sender {
	[[webview mainFrame] reloadFromOrigin];
	[self injectScript];
}
- (void)		injectScript {
	
		// retrieve the script lines from the tableView' ruleData array
	NSString * script = [self despoolScript];
	
	NSString * page = [pageDict valueForKey:@"doctype"];
	page = [page stringByAppendingFormat:@"\n<%@>\n<HEAD>\n",[pageDict valueForKey:@"htmlTag"]];
	
	if( ! _hasJQuery || ! _hasJQueryUI )
	{
		page = [page stringByAppendingString:@"<script id=\"Your Google API key\" type=\"text/javascript\""];
		page = [page stringByAppendingFormat:@" src=\"https://www.google.com/jsapi?key=%@\">", [[NSUserDefaults standardUserDefaults] valueForKey:@"googleAPIKey"]];
		page = [page stringByAppendingString:@"</script>\n"];
	}
	if( ! _hasJQuery )
	{
		page = [page stringByAppendingString:@"<script id=\"jquery-loader\" type=\"text/javascript\">"];
		page = [page stringByAppendingFormat:@"\tgoogle.load('jquery','%@');", [[NSUserDefaults standardUserDefaults] valueForKey:@"jqueryVersion"]];
		page = [page stringByAppendingString:@"</script>\n"];
	}
	if( ! _hasJQueryUI )
	{
		page = [page stringByAppendingString:@"<script id=\"jquery-ui-loader\">"];
		page = [page stringByAppendingFormat:@"\tgoogle.load('jquery-ui','%@');", [[NSUserDefaults standardUserDefaults] valueForKey:@"jqueryUIVersion"]];
		page = [page stringByAppendingString:@"</script>\n"];
	}
	
	page = [page stringByAppendingFormat:@"%@\n",[pageDict valueForKey:@"head"]];
	page = [page stringByAppendingString:@"</HEAD>\n"];
	page = [page stringByAppendingFormat:@"<%@>\n",[pageDict valueForKey:@"bodyTag"]];
	page = [page stringByAppendingFormat:@"%@\n",[pageDict valueForKey:@"body"]];
	
	page = [page stringByAppendingString:@"<!-- ** Trixie generated script ** -->\n"];
	page = [page stringByAppendingString:@"<script id=\"RSTrixieScript\" type=\"text/javascript\">\njQuery().ready(function($){\n"];
	
	page = [page stringByAppendingString: script];
	
	page = [page stringByAppendingString:@"}); \n"];
	page = [page stringByAppendingString:@"</script>"];
	page = [page stringByAppendingString:@"</BODY>\n</HTML>\n"];
	
	[[webview mainFrame] loadHTMLString:page baseURL:[NSURL URLWithString:[webview mainFrameURL]]];
}

@end
