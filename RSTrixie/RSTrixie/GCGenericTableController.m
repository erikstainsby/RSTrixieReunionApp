//
//  GCGenericTableController.m
//  Erasmus
//
//  Created by Graham on 6/05/11.
//  Copyright 2011 Mapdiva, LLC. All rights reserved.
//

#import "GCGenericTableController.h"


NSString*	GCGenericTableControllerDragPrivateType = @"GCGenericTableControllerDragPrivateType";


@interface GCGenericTableController (PrivateMethods)

- (void)		reloadTable;

@end


#pragma mark -


@implementation GCGenericTableController


// setting the content:

- (void)		setContent:(NSMutableArray*) array
{
	// this method does not copy the content, so the controller will reference & edit the content directly. 
	// If you want the controller to leave the original data untouched, you should copy it, or use -setContentWithObjectsInArray:
	
	mContent = nil;
	mContent = array;
	[self reloadTable];
}


- (void)		setContentWithObjectsInArray:(NSArray*) array
{
	NSMutableArray* cont = [array mutableCopy];
	[self setContent:cont];
	cont = nil;
}



- (NSArray*)	content
{
	return mContent;
}

// changing the content:

- (void)		insertObject:(id) object inContentAtIndex:(NSUInteger) indx
{
	[mContent insertObject:object atIndex:indx];
	[self reloadTable];
}


- (void)		insertContent:(NSArray*) objects atIndexes:(NSIndexSet*) indexes
{
	[mContent insertObjects:objects atIndexes:indexes];
	[self reloadTable];
}



- (void)		removeObjectFromContentAtIndex:(NSUInteger) indx
{
	[mContent removeObjectAtIndex:indx];
	[self reloadTable];
}


- (void)		removeContentAtIndexes:(NSIndexSet*) indexes
{
	[mContent removeObjectsAtIndexes:indexes];
	[self reloadTable];
}


- (void)		replaceObjectInContentAtIndex:(NSUInteger) indx withObject:(id) object
{
	[mContent replaceObjectAtIndex:indx withObject:object];
	[self reloadTable];
}


- (void)		replaceContentAtIndexes:(NSIndexSet*) indexes withContent:(NSArray*) objects
{
	[mContent replaceObjectsAtIndexes:indexes withObjects:objects];
	[self reloadTable];
}


- (void)		addObjectToContent:(id) object
{
	[self insertObject:object inContentAtIndex:[mContent count]];
}
 

- (void)		sortContentUsingDescriptors:(NSArray*) descriptors
{
	[mContent sortUsingDescriptors:descriptors];
	[self reloadTable];
}

// getting items from the content:

- (id)			objectInContentAtIndex:(NSUInteger) indx
{
	return [mContent objectAtIndex:indx];
}


- (NSArray*)	contentAtIndexes:(NSIndexSet*) indexes
{
	return [mContent objectsAtIndexes:indexes];
}



- (NSUInteger)	countOfContent
{
	return [mContent count];
}


- (NSIndexSet*)	selectedRows
{
	return [mTable selectedRowIndexes];
}


- (NSArray*)	selectedObjects
{
	return [self contentAtIndexes:[self selectedRows]];
}


// delegate:

- (void)		setDelegate:(id) del
{
	mDelegateRef = del;
	
	if([mDelegateRef respondsToSelector:@selector(draggingTypesForTableController:)])
		[mTable registerForDraggedTypes:[mDelegateRef draggingTypesForTableController:self]];
	else
		[mTable registerForDraggedTypes:nil];
}



- (id)			delegate
{
	return mDelegateRef;
}


- (id)			newObject
{
	// this controller does not know what sort of objects the content contains, so it simply defers to the delegate to
	// make a new object when the action -addNewItem: is invoked.
	
	if([mDelegateRef respondsToSelector:@selector(newContentObjectForTableController:)])
		return [mDelegateRef newContentObjectForTableController:self];
	
	return nil;
}


// selection changes:

- (void)		selectionDidChange:(NSIndexSet*) selection
{
	// inform the delegate, if there is one, and it implements the informal protocol:
	
	if([mDelegateRef respondsToSelector:@selector(tableController:selectionDidChange:)])
		[mDelegateRef tableController:self selectionDidChange:selection];
	
	// this can also be overridden to respond to changes directly
}



- (void)		setSelection:(NSIndexSet*) selection
{
	[mTable selectRowIndexes:selection byExtendingSelection:NO];
}



- (void)		selectRowAtIndex:(NSUInteger) indx extendingSelection:(BOOL) extendIt
{
	NSIndexSet* is = [NSIndexSet indexSetWithIndex:indx];
	[mTable selectRowIndexes:is byExtendingSelection:extendIt];
}



- (void)		selectAll
{
	[mTable selectAll:self];
}



- (void)		selectNone
{
	[mTable deselectAll:self];
}


- (NSTableView*)tableView
{
	return mTable;
}


// private:

- (void)		reloadTable
{
	[mTable reloadData];
}


// directly wirable actions:

- (IBAction)	addNewItem:(id) sender
{
#pragma unused(sender)

	id newObject = [self newObject];
	
	if( newObject )
		[self addObjectToContent:newObject];
}


- (IBAction)	deleteSelectedItems:(id) sender
{
#pragma unused(sender)
	
	[self removeContentAtIndexes:[self selectedRows]];
}


- (IBAction)	selectAll:(id) sender
{
#pragma unused(sender)
	
	[self selectAll];
}


- (IBAction)	deselectAll:(id) sender
{
#pragma unused(sender)
	
	[self selectNone];
}


#pragma mark -
#pragma mark - as a NSObject

- (id)			init
{
	self = [super init];
	if( self )
	{
		mContent = [[NSMutableArray alloc] init];
	}
	
	return self;
}


- (void)		dealloc
{
	[mTable setDataSource:nil];
	[mTable setDelegate:nil];
	mContent = nil;

}


- (void)		awakeFromNib
{
	// these may be set in IB, but set them directly in case they're not, or wired incorrectly.
	
	[mTable setDelegate:self];
	[mTable setDataSource:self];
	
	// n.b. you'll usually have to set up the initial sort descriptors at this point if your table implements
	// sorting. This can't be done generically because who knows what your default sorting might be.
	// So, this is left to your subclass (if any) or client to implement.
	
	// ensure that we are registered for drag drop if the delegate wants it
	
	if([mDelegateRef respondsToSelector:@selector(draggingTypesForTableController:)])
		[mTable registerForDraggedTypes:[mDelegateRef draggingTypesForTableController:self]];
}

#pragma mark -
#pragma mark - as a NSTableViewDatasource

- (NSInteger)	numberOfRowsInTableView:(NSTableView*) aTableView
{
#pragma unused(aTableView)

	return [self countOfContent];
}


- (id)			tableView:(NSTableView*) aTableView objectValueForTableColumn:(NSTableColumn*) aTableColumn row:(NSInteger) rowIndex
{
#pragma unused(aTableView)
	
	id object = [self objectInContentAtIndex:rowIndex];
	return [object valueForKey:[aTableColumn identifier]];
}


- (void)		tableView:(NSTableView*) aTableView setObjectValue:(id) anObject forTableColumn:(NSTableColumn*) aTableColumn row:(NSInteger) rowIndex
{
#pragma unused(aTableView)

	id object = [self objectInContentAtIndex:rowIndex];
	[object setValue:anObject forKey:[aTableColumn identifier]];
}


- (void)		tableView:(NSTableView*) aTableView sortDescriptorsDidChange:(NSArray*) oldDescriptors
{
#pragma unused(aTableView, oldDescriptors)
	
	// preserve the old selection after sorting the items:
	
	NSArray* oldSelection = [self selectedObjects];
	[self sortContentUsingDescriptors:[mTable sortDescriptors]];
	
	// work out where the selection ended up after sorting (n.b. this might be slow if content is large):
	
	if([oldSelection count] > 0 )
	{
		NSMutableIndexSet * is = [NSMutableIndexSet indexSet];
		
		for( id obj in oldSelection )
		{
			NSUInteger indx = [mContent indexOfObject:obj];
			
			if( indx != NSNotFound )
				[is addIndex:indx];
		}
		
		[mTable selectRowIndexes:is byExtendingSelection:NO];
	}
}


- (BOOL)		tableView:(NSTableView*) aTableView writeRowsWithIndexes:(NSIndexSet*) rowIndexes toPasteboard:(NSPasteboard*) pboard
{
#pragma unused(aTableView)

	if([mDelegateRef respondsToSelector:@selector(tableController:writeRowsAtIndexes:toPasteboard:)])
		return [mDelegateRef tableController:self writeRowsAtIndexes:rowIndexes toPasteboard:pboard];
	
	return NO;
}


- (NSDragOperation)tableView:(NSTableView*) aTableView validateDrop:(id<NSDraggingInfo>) info proposedRow:(NSInteger) row proposedDropOperation:(NSTableViewDropOperation) op
{
#pragma unused(aTableView)

	if([mDelegateRef respondsToSelector:@selector(tableController:validateDrop:proposedRow:proposedDropOperation:)])
		return [mDelegateRef tableController:self validateDrop:info proposedRow:row proposedDropOperation:op];
	
	return NSDragOperationNone;
}


- (BOOL)	tableView:(NSTableView*) aTableView acceptDrop:(id<NSDraggingInfo>) info row:(NSInteger)row dropOperation:(NSTableViewDropOperation) op
{
#pragma unused(aTableView)

	if([mDelegateRef respondsToSelector:@selector(tableController:acceptDrop:row:dropOperation:)])
		return [mDelegateRef tableController:self acceptDrop:info row:row dropOperation:op]; 
	
	return NO;
}



#pragma mark -
#pragma mark - as a NSTableViewDelegate

- (void)		tableViewSelectionDidChange:(NSNotification*) aNotification
{
#pragma unused(aNotification)
	
	[self selectionDidChange:[mTable selectedRowIndexes]];
}


#pragma mark -
#pragma mark - as part of NSUserInterfaceValidation protocol

- (BOOL)		validateUserInterfaceItem:(id<NSValidatedUserInterfaceItem>) item
{
	SEL action = [item action];
	
	if( action == @selector( addNewItem: ))
		return [mDelegateRef respondsToSelector:@selector(newContentObjectForTableController:)];
	
	if( action == @selector( deleteSelectedItems: ))
	   return [[self selectedRows] count] > 0;
	   
	if( action == @selector( selectAll: ))
		return [[self selectedRows] count] < [self countOfContent];
	
	if( action == @selector( deselectAll: ))
		return [[self selectedRows] count] > 0;
	
	return [self respondsToSelector:action];
}



@end
