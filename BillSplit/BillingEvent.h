//
//  BillingEvent.h
//  BillSplit
//
//  Created by Aseem Kohli on 8/6/13.


// This class is the main data model in this program.  It represent
// an event that contains a group of people, items purchased,
// and associated metadata.

#import <Foundation/Foundation.h>
#import "Person.h"
#import "ReceiptItem.h"

@interface BillingEvent : NSObject

@property (strong, nonatomic) NSMutableArray *people;       // array of people
@property (strong, nonatomic) NSMutableArray *items;        // array of items purchased
@property (assign, nonatomic) NSUInteger selectedPerson;    // index for current person
@property (assign, nonatomic) double subTotal;              // the subtotal for the event
@property (assign, nonatomic) double grandTotal;            // the grand total (tax + tip)
@property (assign, nonatomic) double tax;                   // tax associated with the event
@property (assign, nonatomic) double tip;                   // tip associated with the event
@property (assign, nonatomic) int percentTip;               // tip percentage for the event



// clears all the data in the current event
- (void) resetEvent;


// Return YES if all receipt items in the event
// are marked with an owner.
- (BOOL) allItemsOwned;


// Helper methods to handle low memory warnings

- (void) saveState;
- (void) loadState;
- (BOOL) stateNeedsToBeLoadedFromMemory;


@end
