//
//  PeopleViewController.h
//  BillSplit
//
//  Created by Aseem Kohli on 8/5/13.


#import <UIKit/UIKit.h>


@interface PeopleViewController : UITableViewController <UITextFieldDelegate>


// properties for sending/receiving data between controllers
@property (copy, nonatomic) NSDictionary *editedSelection;
@property (copy, nonatomic) NSDictionary *selection;
@property (weak, nonatomic) id delegate;
@property (copy, nonatomic) NSDictionary *editedObject;
@property (copy, nonatomic) NSDictionary *object;

// UI methods
- (IBAction)clickedDoneButton:(UIBarButtonItem *)sender;
- (void)clickedAddButton;

@end
