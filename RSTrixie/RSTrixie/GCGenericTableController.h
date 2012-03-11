//
//  GCGenericTableController.h
//  Erasmus
//
//  Created by Graham on 6/05/11.
//  Copyright 2011 Mapdiva, LLC. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface GCGenericTableController : NSObject <NSTableViewDataSource, NSTableViewDelegate>
{
	IBOutlet NSTableView*		mTable;
	IBOutlet id					mDelegateRef;
	NSMutableArray*				mContent;
}

// setting the content:

- (void)		setContent:(NSMutableArray*) array;
- (void)		setContentWithObjectsInArray:(NSArray*) array;
- (NSArray*)	content;

// changing the content (KVO compliant):

- (void)		insertObject:(id) object inContentAtIndex:(NSUInteger) indx;
- (void)		insertContent:(NSArray*) objects atIndexes:(NSIndexSet*) indexes;
- (void)		addObjectToContent:(id) object;

- (void)		removeObjectFromContentAtIndex:(NSUInteger) indx;
- (void)		removeContentAtIndexes:(NSIndexSet*) indexes;

- (void)		replaceObjectInContentAtIndex:(NSUInteger) indx withObject:(id) object;
- (void)		replaceContentAtIndexes:(NSIndexSet*) indexes withContent:(NSArray*) objects;

- (void)		sortContentUsingDescriptors:(NSArray*) descriptors;

// getting items from the content (KVO compliant):

- (id)			objectInContentAtIndex:(NSUInteger) indx;
- (NSArray*)	contentAtIndexes:(NSIndexSet*) indexes;
- (NSUInteger)	countOfContent;

- (NSIndexSet*)	selectedRows;
- (NSArray*)	selectedObjects;

// delegate:

- (void)		setDelegate:(id) del;
- (id)			delegate;

- (id)			newObject;

// selection changes:

- (void)		selectionDidChange:(NSIndexSet*) selection;
- (void)		setSelection:(NSIndexSet*) selection;
- (void)		selectRowAtIndex:(NSUInteger) indx extendingSelection:(BOOL) extendIt;
- (void)		selectAll;
- (void)		selectNone;

// properties:

- (NSTableView*)tableView;

// directly wirable actions:

- (IBAction)	addNewItem:(id) sender;
- (IBAction)	deleteSelectedItems:(id) sender; 
- (IBAction)	selectAll:(id) sender;
- (IBAction)	deselectAll:(id) sender;

@end

// informal delegate protocol for responding to selection changes, creating new objects and drag/drop. All optional.

@interface NSObject (GCGenericTableControllerDelegate)

// selection change:

- (void)			tableController:(GCGenericTableController*) cllr selectionDidChange:(NSIndexSet*) selection;

// adding new items:

- (id)				newContentObjectForTableController:(GCGenericTableController*) cllr;

// drag and drop support (allows drag/drop between tables or reordering within tables)

- (NSArray*)		draggingTypesForTableController:(GCGenericTableController*) cllr;
- (BOOL)			tableController:(GCGenericTableController*) cllr writeRowsAtIndexes:(NSIndexSet*) indexes toPasteboard:(NSPasteboard*) pb;
- (NSDragOperation) tableController:(GCGenericTableController*) cllr validateDrop:(id<NSDraggingInfo>) info proposedRow:(NSInteger) indx proposedDropOperation:(NSDragOperation) op;
- (BOOL)			tableController:(GCGenericTableController*) cllr acceptDrop:(id<NSDraggingInfo>) info row:(NSInteger) row dropOperation:(NSDragOperation) op;

@end

extern NSString*	GCGenericTableControllerDragPrivateType;


/*

This class implements a very generic table view controller, which connects some arbitrary array-based content to
 a table view. Adding and removing objects from content via the interface here keeps the table up to date.
 
 As the selection in the table changes, any delegate that implements the informal method shown is informed.


*/


