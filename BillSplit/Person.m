//
//  Person.m
//  BillSplit
//
//  Created by Aseem Kohli on 8/5/13.


#import "Person.h"


@implementation Person 


// default initializer
- (Person *) init
{
    self = [super init];
    
    if (self)
    {
        self = [self initWithName:@"New Person" withCardNumber:@"0000"];
    }
    
    return self;
}


// "0000" represents no card
- (Person *) initWithName: (NSString *) inputName
           withCardNumber: (NSString *) inputCardNumber
{
    self = [super init];
    
    if (self)
    {
        _name = [[NSMutableString alloc] initWithCapacity:15];
        _cardNumber = [[NSMutableString alloc] initWithCapacity:4];
        _name = (NSMutableString *)inputName;
        _cardNumber = (NSMutableString *)inputCardNumber;
        _personalTotal = 0.0;
    }
    
    return self;
}


- (void) addToTotal:(double) value
{
    _personalTotal += value;
}


- (void) subFromTotal:(double) value
{
    _personalTotal -= value;
}

- (double) getTotalwithTaxPerPerson:(double) taxPerPerson
                  withTipPercentage:(int) percentTip
{
    double total = 0.0;
    
    total = _personalTotal + taxPerPerson + (_personalTotal * (double)((double)percentTip / 100));
    return total;
}

- (id) initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if (!self)
    {
        return nil;
    }
    
    _name = [decoder decodeObjectForKey:@"personName"];
    _cardNumber = [decoder decodeObjectForKey:@"personCardNumber"];
    _personalTotal = [decoder decodeDoubleForKey:@"personTotal"];
    
    return self;
}

- (void) encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:_name forKey:@"personName"];
    [encoder encodeObject:_cardNumber forKey:@"personCardNumber"];
    [encoder encodeDouble:_personalTotal forKey:@"personTotal"];
}



@end
