//
//  RSIntermediateRuleDelegate.h
//  RSTrixie
//
//  Created by Erik Stainsby on 12-03-10.
//  Copyright (c) 2012 Roaring Sky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RSTrixiePlugin/RSTrixiePlugin.h>

@interface RSIntermediateRuleDelegate : NSObject < NSTableViewDelegate, NSTableViewDataSource >

@property (retain) IBOutlet NSTableView * rulePartsTable;
@property (retain) IBOutlet NSMutableArray * rulePartsData;

- (void) addComment: (RSCommentRule *) rule;
- (BOOL) addActionRule: (RSActionRule *) rule;
- (BOOL) addReactionRule: (RSReactionRule *) rule;
- (BOOL) addFilterRule: (RSConditionRule *) rule;

- (RSTrixieRule *) composeRule;

- (NSInteger) numberOfRowsInTableView:(NSTableView *)tableView;
- (id) tableView:(NSTableView*)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row;
- (void)tableView:(NSTableView *)aTableView setObjectValue:(id)anObject forTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex;
- (IBAction) removeRowFromPartsTable:(id)sender;

@end
