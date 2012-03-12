//
//  RSIntermediateRuleDelegate.m
//  RSTrixie
//
//  Created by Erik Stainsby on 12-03-10.
//  Copyright (c) 2012 Roaring Sky. All rights reserved.
//

#import "RSIntermediateRuleDelegate.h"

@implementation RSIntermediateRuleDelegate

@synthesize rulePartsTable;
@synthesize rulePartsData;

- (id)init
{
    self = [super init];
    if (self) {
		NSLog(@"%s- [%04d] %@", __PRETTY_FUNCTION__, __LINE__, @"");
		rulePartsData = [NSMutableArray array];
		[[self rulePartsTable] setDelegate:self];
		[[self rulePartsTable] setDataSource:self];
    }
    return self;
}

- (void) addComment: (RSCommentRule *) rule { 
	NSDictionary * rowData = [NSDictionary dictionaryWithObjectsAndKeys:@"Comment",@"label",[rule text],@"script",rule,@"rule", nil];
	[rulePartsData addObject:rowData];
	[rulePartsTable reloadData];
}
- (void) addActionRule: (RSActionRule *) rule {

	NSDictionary * rowData = [NSDictionary dictionaryWithObjectsAndKeys:@"Trigger",@"label",[rule trigger],@"script",rule,@"rule", nil];
		//	NSLog(@"%s- [%04d] %@", __PRETTY_FUNCTION__, __LINE__, [rowData description]);
	[rulePartsData addObject:rowData];
	[rulePartsTable reloadData];
}
- (void) addReactionRule: (RSReactionRule *) rule {

	NSDictionary * rowData = [NSDictionary dictionaryWithObjectsAndKeys:@"Response",@"label",[rule script],@"script",rule,@"rule", nil];
	[rulePartsData addObject:rowData];
	[rulePartsTable reloadData];
}
- (void) addConditionRule: (RSConditionRule *) rule {

	NSDictionary * rowData = [NSDictionary dictionaryWithObjectsAndKeys:@"Condition",@"label",[rule script],@"script",rule,@"rule", nil];
	[rulePartsData addObject:rowData];
	[rulePartsTable reloadData];
}


- (RSTrixieRule*) composeRule {
		// initialize and set composite rule 
	RSTrixieRule * rule = [[RSTrixieRule alloc] init];	
	NSMutableArray * reactions = [NSMutableArray array];

	for(NSDictionary * rowData in rulePartsData)
	{
			//		NSLog(@"%s- [%04d] %@", __PRETTY_FUNCTION__, __LINE__, [rowData description]);
		
		id aRule = [rowData objectForKey:@"rule"];
		
		NSString * label = [rowData valueForKey:@"label"];
		
		if([label isEqualToString:@"Comment"])
		{
			[rule setComment: [(RSCommentRule *)aRule text]];
		}
		else if([label isEqualToString:@"Trigger"])
		{
			[rule setAction:(RSActionRule*)aRule];
		}
		else {
				// buffer reactions & conditions in sequence.
				// reactions & conditions are folded into the reactions chain
				// both respond to the method call:  script
			
				[reactions addObject: aRule];
		}
	}
	[rule setReactions:	reactions];
	
		// scrub ruleTableData and reload
	[rulePartsData removeAllObjects];
	[rulePartsTable reloadData];
	
	return rule;
}


- (NSInteger) numberOfRowsInTableView:(NSTableView *)tableView {
	return [rulePartsData count];
}

- (id) tableView:(NSTableView*)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
	NSDictionary * dict = [rulePartsData objectAtIndex:row];
	NSString * item = [dict valueForKey:[tableColumn identifier]];
	return item;
}

- (void)tableView:(NSTableView *)aTableView setObjectValue:(id)anObject forTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex {
	
	NSMutableDictionary * rowData = [[rulePartsData objectAtIndex:rowIndex] mutableCopy];
	[rowData setValue:anObject forKey:[aTableColumn identifier]];
	[rulePartsData replaceObjectAtIndex:rowIndex withObject:rowData];
	[rulePartsTable reloadData];
}

- (IBAction) removeRowFromPartsTable:(id)sender {
	NSIndexSet * rows = [rulePartsTable selectedRowIndexes];
	[rulePartsData removeObjectsAtIndexes:rows];
	[rulePartsTable reloadData];
}


@end
