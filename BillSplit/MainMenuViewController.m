//
//  MainMenuViewController.m
//  BillSplit
//
//  Created by Aseem Kohli on 8/6/13.


#import "MainMenuViewController.h"

#define LOAD_SAMPLE_INDEX 4

@interface MainMenuViewController ()
{
    BillingEvent *_myEvent;         // object that represents the event
                                    // this is passed to the other view controllers
}
@end

@implementation MainMenuViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self)
    {
        _loadedAnotherController = false;
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _myEvent = [[BillingEvent alloc] init];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    // store the object to disk
    if (_loadedAnotherController == NO)
        [_myEvent saveState];
}


// This method is used to handle the event of a specific row
// in the static table being selected
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_myEvent stateNeedsToBeLoadedFromMemory])
        [_myEvent loadState];
    
    
    // if the "Load Sample Data" row is selecte
    if (indexPath.row == LOAD_SAMPLE_INDEX)
    {
        
        NSArray *personNames = @[@"Bill", @"Hillary", @"Barack", @"Michelle"];
        NSArray *personNums = @[@"1234", @"5678", @"1984", @"3569"];
        
        NSArray *itemNames = @[@"Salmon", @"Steak", @"Salad", @"Fondue",
                               @"Chicken", @"Wine", @"Cheese", @"Biscuits", @"Beer",
                               @"Chocolate Cake", @"Port Wine", @"Champagne", @"Cake Cutting Fee"];
        
        NSArray *itemPrices = @[@"14.99", @"23.99", @"9.99", @"29.99",
                               @"12.99", @"150.00", @"19.95", @"4.99", @"48.50",
                               @"12.99", @"37.68", @"67.50", @"20.00"];
        
        // clear any existing data
        [_myEvent resetEvent];
        
        // load sample data
        for (int i = 0; i < [personNames count]; i++)
        {
            [_myEvent.people addObject:[[Person alloc] init]];
            Person *currentPerson = [_myEvent.people objectAtIndex:i];
            [currentPerson setName:[personNames objectAtIndex:i]];
            [currentPerson setCardNumber:[personNums objectAtIndex:i]];
        }
        
        for (int i = 0; i < [itemNames count]; i++)
        {
            [_myEvent.items addObject:[[ReceiptItem alloc] init]];
            ReceiptItem *currentItem = [_myEvent.items objectAtIndex:i];
            [currentItem setItemName:[itemNames objectAtIndex:i]];
            [currentItem setItemPriceWithString:[itemPrices objectAtIndex:i]];
            [currentItem setCurrentOwner:(i%[personNames count])];
            
            Person *currentPerson = [_myEvent.people objectAtIndex:[currentItem currentOwner]];
            [currentPerson addToTotal:currentItem.itemPrice];
        }
        
        [_myEvent setTax:45.95];
        [_myEvent setPercentTip:15];
      
        _myEvent.selectedPerson = 0;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


// prepare to send the event object to the destination controller
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([_myEvent stateNeedsToBeLoadedFromMemory])
        [_myEvent loadState];
    
    // grab the destination controller
    UIViewController *destination = segue.destinationViewController;
    
    // set ourselves as the delegate of the destination controller
    // so we can get data back
    if ([destination respondsToSelector:@selector(setDelegate:)])
    {
        [destination setValue:self forKey:@"delegate"];
    }
    
    
    if ([destination respondsToSelector:@selector(setObject:)])
    {
        // send the object
        NSDictionary *object = @{@"object" : _myEvent};
        
        // pass the dictionary using KVC
        [destination setValue:object forKey:@"object"];
        
        _loadedAnotherController = YES;
    }
}


// this method is used to receive data back from called controllers
- (void)setEditedObject:(NSDictionary *)dict
{
    if ([_myEvent stateNeedsToBeLoadedFromMemory])
        [_myEvent loadState];
    
    if (![dict isEqual:self.editedObject])
    {
        _editedObject = dict;
        
        // update the appropriate People object
        _myEvent = dict[@"object"];
        
    }
    
    _loadedAnotherController = NO;
}


// This method will reset the state of the application
- (IBAction)clickedResetButton:(UIBarButtonItem *)sender
{
    if ([_myEvent stateNeedsToBeLoadedFromMemory])
        [_myEvent loadState];
    
    [_myEvent resetEvent];
    
}

@end
