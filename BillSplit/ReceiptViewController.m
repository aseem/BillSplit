//
//  ReceiptViewController.m
//  BillSplit
//
//  Created by Aseem Kohli on 8/6/13.


#import "ReceiptViewController.h"
#import "BillingEvent.h"
#import "ReceiptItem.h"

@interface ReceiptViewController ()
{
    NSMutableArray *_items;
    BillingEvent *_myEvent;
    
    NSMutableArray *filteredNames;
    UISearchDisplayController *searchController;
}


@end

@implementation ReceiptViewController

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
        
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                              initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                              target:self
                                              action:@selector(clickedAddButton)];

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
    
    return [_myEvent.items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_myEvent stateNeedsToBeLoadedFromMemory])
        [_myEvent loadState];
    
    static NSString *CellIdentifier = @"receiptCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier
                                                            forIndexPath:indexPath];
    
    // Configure the cell...
    UILabel *cellLabelName = (UILabel *)[cell viewWithTag:1];
    UILabel *cellLabelOwner = (UILabel *) [cell viewWithTag:2];
    UILabel *cellLabelPrice = (UILabel *) [cell viewWithTag:3];
    
    ReceiptItem *myItem = [_myEvent.items objectAtIndex:indexPath.row];
    
    cellLabelName.text = [myItem itemName];
    
    
    if ([myItem currentOwner] != NSNotFound)
    {
        cellLabelOwner.text = [[_myEvent.people objectAtIndex:[myItem currentOwner]] name];
    }
    else
    {
        cellLabelOwner.text = @"";
    }
    
    
    cellLabelPrice.text = [myItem getPriceFormatted];
    

    
    return cell;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_myEvent stateNeedsToBeLoadedFromMemory])
        [_myEvent loadState];
    
    // handle the delete case
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        // get the item
        ReceiptItem *deletedItem = [_myEvent.items objectAtIndex:indexPath.row];
        
        // if a person has claimed this item, deduct it from
        // the person's running total
        if (deletedItem.currentOwner != NSNotFound)
        {
            Person *currentPerson = [_myEvent.people objectAtIndex:[deletedItem currentOwner]];
            [currentPerson subFromTotal:deletedItem.itemPrice];
            [deletedItem setCurrentOwner:NSNotFound];
        }
        
        // remove the item
        [_myEvent.items removeObjectAtIndex:indexPath.row];
        
        
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
      
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_myEvent stateNeedsToBeLoadedFromMemory])
        [_myEvent loadState];
    
    // get the currently selected item in the receipt
    ReceiptItem *currentItem = [_myEvent.items objectAtIndex:indexPath.row];
    
    // if a person hasn't been selected, we should show an error and exit the method
    if (_myEvent.selectedPerson == NSNotFound)
    {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Error!"
                              message:@"You have not selected a person to own this item."
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    
    // get the selected cell and the owner label of that cell
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UILabel *cellLabel = (UILabel *)[cell viewWithTag:2];
        
    // get the currently selected person
    Person *currentPerson = [_myEvent.people objectAtIndex:_myEvent.selectedPerson];
        
    
    // check if a different person wants to own this item
    if (currentItem.currentOwner != _myEvent.selectedPerson)
    {
        cellLabel.text = [currentPerson name];
            
        // update the running total for that person
        [currentPerson addToTotal:[currentItem itemPrice]];
        
        // update the running total for the previous owner (if there was one)
        if (currentItem.currentOwner != NSNotFound)
        {
            Person *previousPerson = [_myEvent.people objectAtIndex:currentItem.currentOwner];
            [previousPerson subFromTotal:[currentItem itemPrice]];
        }
        
        currentItem.currentOwner = _myEvent.selectedPerson;
    }
    // otherwise the selected person wants to no longer own this item
    else
    {
        currentItem.currentOwner = NSNotFound;
        cellLabel.text = @"";
            
        // update current person's state
        [currentPerson subFromTotal:[currentItem itemPrice]];
    }
        
    // de-select the current row
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


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
    
    // send the data in the cell along with the index of the cell
    // so we know where to put the data back
    if ([destination respondsToSelector:@selector(setSelection:)])
    {
        // get the index of the selected cell
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        
        // get the task for that cell and put it in a dictionary
        id object = _myEvent.items[indexPath.row];
        NSDictionary *selection = @{@"indexPath" : indexPath,
                                    @"object" : object};
        
        // pass the dictionary using KVC
        [destination setValue:selection forKey:@"selection"];
    }
}

// receive edited data from the detail view controller
- (void)setEditedSelection:(NSDictionary *)dict
{
    if ([_myEvent stateNeedsToBeLoadedFromMemory])
        [_myEvent loadState];
    
    if (![dict isEqual:self.editedSelection])
    {
        _editedSelection = dict;
        NSIndexPath *indexPath = dict[@"indexPath"];
        
        // update the appropriate Person object
        ReceiptItem *updatedItem = [_myEvent.items objectAtIndex:indexPath.row];
        [updatedItem setItemName:dict[@"itemName"]];
        [updatedItem setItemPriceWithString:dict[@"itemPrice"]];
        
        [_myEvent.items replaceObjectAtIndex:indexPath.row withObject:updatedItem];
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                              withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}



- (void)clickedAddButton
{
    if ([_myEvent stateNeedsToBeLoadedFromMemory])
        [_myEvent loadState];
    
    // Create a new Person object
    ReceiptItem *newItem = [[ReceiptItem alloc]init];
    [_myEvent.items addObject:newItem];
    
    [self.tableView reloadData];
}


- (IBAction)clickedDoneButton:(UIBarButtonItem *)sender
{
    if ([_myEvent stateNeedsToBeLoadedFromMemory])
        [_myEvent loadState];
    
    if ([self.delegate respondsToSelector:@selector(setEditedObject:)])
    {
        //_myEvent.items = _items;
        NSDictionary *editedObject = @{@"object" : _myEvent};
        
        [self.delegate setValue:editedObject forKey:@"editedObject"];
    }
    
    
    // Dismiss this view controller
    [self.navigationController popViewControllerAnimated:YES];
}

@end
