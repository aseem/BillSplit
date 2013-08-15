//
//  ReceiptItem.h
//  BillSplit
//
//  Created by Aseem Kohli on 8/6/13.


#import <Foundation/Foundation.h>

@interface ReceiptItem : NSObject <NSCoding>

@property (copy, nonatomic) NSMutableString *itemName;

@property (assign, nonatomic) double itemPrice;

@property (copy, nonatomic) NSMutableString *itemOwner;

@property (assign, nonatomic) NSUInteger currentOwner;    // index of owner

- (NSString *) getPriceFormatted;
- (void) setItemPriceWithString: (NSString *) itemPrice;

@end
