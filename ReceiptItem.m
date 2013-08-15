//
//  ReceiptItem.m
//  BillSplit
//
//  Created by Aseem Kohli on 8/6/13.


#import "ReceiptItem.h"

@implementation ReceiptItem

// default initializer
- (ReceiptItem *) init
{
    self = [super init];
    
    if (self)
    {
        self = [self initWithName:@"New Item"
                    withItemPrice:0.00
                    withItemOwner:nil];
    }
    
    return self;
}

// special initializer
- (ReceiptItem *) initWithName: (NSString *) itemName
                 withItemPrice: (double) itemPrice
                 withItemOwner: (NSString *) itemOwner
{
    self = [super init];
    
    if (self)
    {
        _itemName = [[NSMutableString alloc] initWithCapacity:15];
        _itemName = [itemName copy];
        _itemPrice = itemPrice;
        _itemOwner = [[NSMutableString alloc] initWithCapacity:15];
        _itemOwner = [itemOwner copy];
        _currentOwner = NSNotFound;
    }
    
    return self;
}

// override the default setter
- (void) setItemPrice:(double)itemPrice
{
    _itemPrice = (100 * itemPrice) / 100;
}


// method to set the price from a string
- (void) setItemPriceWithString: (NSString *) itemPrice
{
    double price = [itemPrice doubleValue];
    NSString *formattedPrice = [NSString stringWithFormat:@"%.02f", price];
    _itemPrice = [formattedPrice doubleValue];
    if (_itemPrice < 0.0)
        _itemPrice = 0.0;
}


// format with a $ sign
- (NSString *) getPriceFormatted
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
    NSString *numberFormatted = [NSString stringWithFormat:@"$%.02f", _itemPrice];
    
    return numberFormatted;
}


- (id) initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if (!self)
    {
        return nil;
    }
    
    _itemName = [decoder decodeObjectForKey:@"itemName"];
    _itemPrice = [decoder decodeDoubleForKey:@"itemPrice"];
    _itemOwner = [decoder decodeObjectForKey:@"itemOwner"];
    _currentOwner = [[decoder decodeObjectForKey:@"currentOwner"] unsignedIntegerValue];
    
    return self;
}


- (void) encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:_itemName forKey:@"itemName"];
    [encoder encodeDouble:_itemPrice forKey:@"itemPrice"];
    [encoder encodeObject:_itemOwner forKey:@"itemOwner"];
    [encoder encodeObject:[NSNumber numberWithUnsignedInteger:_currentOwner] forKey:@"currentOwner"];
    
}
@end
