//
//  Person.h
//  BillSplit
//
//  Created by Aseem Kohli on 8/5/13.


#import <Foundation/Foundation.h>

@interface Person : NSObject <NSCoding>

@property (copy, nonatomic) NSMutableString *name;
@property (copy, nonatomic) NSMutableString *cardNumber;
@property (assign, nonatomic) double personalTotal;


- (void) addToTotal:(double) value;
- (void) subFromTotal:(double) value;


- (double) getTotalwithTaxPerPerson:(double) taxPerPerson
                  withTipPercentage:(int) percentTip;


@end
