//
//  PeopleViewController.m
//  BillSplit
//
//  Created by Aseem Kohli on 8/5/13.

#import "PeopleViewController.h"
#import "BillingEvent.h"
#import "Person.h"

@interface PeopleViewController ()
{
    BillingEvent *_myEvent;
}

@end

@implementation PeopleViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self)
    {
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
                                                                   target:self action:@selector(clickedAddButton)];
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
    // Return the number of sections in the table
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([_myEvent stateNeedsToBeLoadedFromMemory])
        [_myEvent loadState];
    
    // Return the number of rows in the section.
    return [_myEvent.people count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_myEvent stateNeedsToBeLoadedFromMemory])
        [_myEvent loadState];
    
    static NSString *CellIdentifier = @"peopleCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier
                                                            forIndexPath:indexPath];
    
    // Configure the cell...
    UILabel *cellLabel = (UILabel *)[cell viewWithTag:1];
    Person *myPerson = [_myEvent.people objectAtIndex:indexPath.row];
    cellLabel.text = [myPerson name];
    
    // Add a checkmark if this is our currently chosen user.
    if (_myEvent.selectedPerson == indexPath.row)
    {
        [cellLabel setTextColor:[UIColor redColor]];
    }
    else
    {
        [cellLabel setTextColor:[UIColor blackColor]];
    }
    
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
        // get the person to be deleted
        //Person *deletedPerson = [_myEvent.people objectAtIndex:indexPath.row];
        
        // go through all the items in the event's receipt
        for (ReceiptItem *currentItem in _myEvent.items)
        {
             // if the person to be deleted is the owner, remove them.
            if (currentItem.currentOwner == indexPath.row)
            {
                [currentItem setItemOwner:(NSMutableString *)@""];
                [currentItem setCurrentOwner:NSNotFound];
            }
            
            // if the item is owned by someone in a lower row, adjust
            // the item's pointer
            if ((currentItem.currentOwner > indexPath.row) &&
                (currentItem.currentOwner != NSNotFound))
            {
                [currentItem setCurrentOwner:(--currentItem.currentOwner)];
            }
                
        }
        
        // if the person to be deleted is the currently selected
        // person, change it to have no one selected
        if (_myEvent.selectedPerson == indexPath.row)
        {
            _myEvent.selectedPerson = NSNotFound;
        }
        
        // delete the person (this sound harsh...)
        [_myEvent.people removeObjectAtIndex:indexPath.row];
        
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_myEvent stateNeedsToBeLoadedFromMemory])
        [_myEvent loadState];
    
    if (indexPath.row != _myEvent.selectedPerson)
    {
        // reset the text color of the previous chosen cell
        if (_myEvent.selectedPerson != NSNotFound)
        {
            NSIndexPath *oldIndexPath = [NSIndexPath indexPathForRow:_myEvent.selectedPerson
                                                       inSection:0];
            UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:oldIndexPath];
            UILabel *oldCellLabel = (UILabel *)[oldCell viewWithTag:1];
            [oldCellLabel setTextColor:[UIColor blackColor]];
        }
        
        // update the text color to the currently chosen cell and update the Event state
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        UILabel *newCellLabel = (UILabel *)[cell viewWithTag:1];
        [newCellLabel setTextColor:[UIColor redColor]];
        _myEvent.selectedPerson = indexPath.row;
    }
    
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
        
        // get the person for that cell and put it in a dictionary
        id object = _myEvent.people[indexPath.row];
        NSDictionary *selection = @{@"indexPath" : indexPath,
                                    @"object" : object};
        
        // pass the dictionary using KVC 
        [destination setValue:selection forKey:@"selection"];
    }
}

// method to receive data from the detail view controller
- (void)setEditedSelection:(NSDictionary *)dict
{
    if ([_myEvent stateNeedsToBeLoadedFromMemory])
        [_myEvent loadState];
    
    if (![dict isEqual:self.editedSelection])
    {
        _editedSelection = dict;
        NSIndexPath *indexPath = dict[@"indexPath"];
        
        // update the appropriate Person object
        Person *updatedPerson = [_myEvent.people objectAtIndex:indexPath.row];
        [updatedPerson setName:dict[@"name"]];
        [updatedPerson setCardNumber:dict[@"cardNum"]];
        
        [_myEvent.people replaceObjectAtIndex:indexPath.row withObject:updatedPerson];
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                              withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}


- (void)clickedAddButton
{
    if ([_myEvent stateNeedsToBeLoadedFromMemory])
        [_myEvent loadState];
    
    // Create a new Person object
    Person *newPerson = [[Person alloc]init];
    [_myEvent.people addObject:newPerson];
    
    //[self.people addObject:@"New Person"];
    [self.tableView reloadData];
}


- (IBAction)clickedDoneButton:(UIBarButtonItem *)sender
{
    if ([_myEvent stateNeedsToBeLoadedFromMemory])
        [_myEvent loadState];
    
    if ([self.delegate respondsToSelector:@selector(setEditedObject:)])
    {
        
        NSDictionary *editedObject = @{@"object" : _myEvent};
        
        [self.delegate setValue:editedObject forKey:@"editedObject"];
    }
    
    
    // Dismiss this view controller
    [self.navigationController popViewControllerAnimated:YES];
}

@end
