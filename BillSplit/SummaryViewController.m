//
//  SummaryViewController.m
//  BillSplit
//
//  Created by Aseem Kohli on 8/7/13.


#import "SummaryViewController.h"
#import "BillingEvent.h"
#import "ReceiptItem.h"
#import "Person.h"

#define SUBTOTAL_ROW    0
#define TAX_ROW         1
#define TIP_ROW         2
#define GRANDTOTAL_ROW  3

@interface SummaryViewController ()
{
    BillingEvent *_myEvent;
}

@end

@implementation SummaryViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
     _myEvent = self.object[@"object"];
    
    // check if all the items have owners
    // if not, throw a warning
    if ([_myEvent allItemsOwned] == NO)
    {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Warning!"
                              message:@"You have not assigned owners to all your items!"
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    [_myEvent saveState];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([_myEvent stateNeedsToBeLoadedFromMemory])
        [_myEvent loadState];
    
    // We need 4 rows for line items + the number of people
    return ([_myEvent.people count] + 4);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_myEvent stateNeedsToBeLoadedFromMemory])
        [_myEvent loadState];
    
    NSString *CellIdentifier;
    
    // determine the cell reuse identifier required
    if (indexPath.row > 3)
    {
        CellIdentifier = @"peopleCell";
    }
    else
    {
        CellIdentifier = @"lineItemCell";
    }
    
    // dequeue the appropriate cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    
    // Configure the cell appropriately...
    if ([CellIdentifier isEqual: @"peopleCell"])
    {
        UILabel *nameLabel = (UILabel *)[cell viewWithTag:1];
        UILabel *cardLabel = (UILabel *)[cell viewWithTag:2];
        UILabel *totalLabel = (UILabel *)[cell viewWithTag:3];
        
        // determine the total for the person, including tax & tip
        
        // get the person that belongs in this cell
        Person *currentPerson = [_myEvent.people objectAtIndex:(indexPath.row - 4)];
        
        // determine exactly what the person owes
        double taxPerPerson = _myEvent.tax / (double)[_myEvent.people count];
        double total = [currentPerson getTotalwithTaxPerPerson:taxPerPerson
                                             withTipPercentage:_myEvent.percentTip];
        
        
        // update the output
        nameLabel.text = currentPerson.name;
        cardLabel.text = currentPerson.cardNumber;
        totalLabel.text = [NSString stringWithFormat:@"$%.02f", total];
    }
    else    // CellIdentifer == "lineItemCell"
    {
        UILabel *lineItemLabel = (UILabel *)[cell viewWithTag:1];
        UILabel *valueLabel = (UILabel *)[cell viewWithTag:2];
        
        switch (indexPath.row)
        {
            case SUBTOTAL_ROW:
            {
                lineItemLabel.text = @"Sub Total";
                valueLabel.text = [NSString stringWithFormat:@"$%.02f", _myEvent.subTotal];
                break;
            }
            
            case TAX_ROW:
            {
                lineItemLabel.text = @"Tax";
                valueLabel.text = [NSString stringWithFormat:@"$%.02f", _myEvent.tax];
                break;
            }
               
            case TIP_ROW:
            {
                lineItemLabel.text = [NSString stringWithFormat:@"Tip (%d%%)",
                                      _myEvent.percentTip];
                valueLabel.text = [NSString stringWithFormat:@"$%.02f", _myEvent.tip];                break;
            }
                
            case GRANDTOTAL_ROW:
            {
                lineItemLabel.text = @"Grand Total";
                valueLabel.text = [NSString stringWithFormat:@"$%.02f", _myEvent.grandTotal];
                break;
            }
                
            default:
                break;
        }
    }
    
    return cell;
}


#pragma mark - Table view delegate




@end
