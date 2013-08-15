//
//  BillingEvent.m
//  BillSplit
//
//  Created by Aseem Kohli on 8/6/13.


#import "BillingEvent.h"


@implementation BillingEvent


// initializer
- (BillingEvent *) init
{
    self = [super init];
    
    if (self)
    {
        _people = [[NSMutableArray alloc] init];
        _items = [[NSMutableArray alloc] init];
        _selectedPerson= NSNotFound;
        _subTotal = 0.0;
        _grandTotal = 0.0;
        _tax = 0.0;
        _tip = 0.0;
        _percentTip = 0;
    }
    
    return self;
}


- (void) resetEvent
{
    [_people removeAllObjects];
    [_items removeAllObjects];
    _selectedPerson = NSNotFound;
    _subTotal = 0.0;
    _grandTotal = 0.0;
    _tax = 0.0;
    _tip = 0.0;
    _percentTip = 0;
}


-(BOOL) allItemsOwned
{
    for (ReceiptItem *currentItem in _items)
    {
        if ([currentItem currentOwner] == NSNotFound)
            return NO;
    }
    
    return YES;
}


// Override the synthesize getter for subTotal
-(double) subTotal
{
    _subTotal = 0.0;
    
    for (ReceiptItem *currentItem in _items)
    {
        _subTotal += [currentItem itemPrice];
    }
    
    return _subTotal;
}


// Override the synthesized getter for grandTotal
-(double) grandTotal
{
    _grandTotal = _subTotal + _tax + _tip;
    return _grandTotal;
}


// Override the synthesize getter for the tip
-(double) tip
{
    _tip = self.subTotal * (double)((double)_percentTip / 100);
    return _tip;
}

-(void) setTax:(double)tax
{
    if (tax < 0)
        _tax = 0.0;
    else
        _tax = tax;
}

-(void) setPercentTip:(int)percentTip
{
    if (percentTip < 0)
        _percentTip = 0;
    else
        _percentTip = percentTip;
}

#pragma mark - Low Memory Methods

-(void) saveState
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:_people] forKey:@"People"];
    [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:_items] forKey:@"Items"];
    [defaults setDouble:_subTotal forKey:@"subTotal"];
    [defaults setDouble:_grandTotal forKey:@"grandTotal"];
    [defaults setDouble:_tax forKey:@"tax"];
    [defaults setDouble:_tip forKey:@"tip"];
    [defaults setInteger:_percentTip forKey:@"percentTip"];
    
    [defaults synchronize];
    _people = nil;
    _items = nil;
}


- (void) loadState
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSData *dataPeople = [defaults objectForKey:@"People"];
    if (dataPeople != nil)
    {
        _people = [NSKeyedUnarchiver unarchiveObjectWithData:dataPeople];
    }
    
    NSData *dataItems = [defaults objectForKey:@"Items"];
    if (dataItems != nil)
    {
        _items = [NSKeyedUnarchiver unarchiveObjectWithData:dataItems];
    }
    
    _subTotal = [defaults doubleForKey:@"subTotal"];
    _grandTotal = [defaults doubleForKey:@"grandTotal"];
    _tax = [defaults doubleForKey:@"tax"];
    _tip = [defaults doubleForKey:@"tip"];
    _percentTip = [defaults integerForKey:@"percentTip"];
    
}


- (BOOL) stateNeedsToBeLoadedFromMemory
{
    if (_people == nil || _items == nil)
        return YES;
    else
        return NO;
}

@end
