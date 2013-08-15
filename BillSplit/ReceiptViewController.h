//
//  ReceiptViewController.h
//  BillSplit
//
//  Created by Aseem Kohli on 8/6/13.


#import <UIKit/UIKit.h>

@interface ReceiptViewController : UITableViewController <UISearchDisplayDelegate>

// properties for sending data between controllers
@property (copy, nonatomic) NSDictionary *editedSelection;
@property (copy, nonatomic) NSDictionary *selection;
@property (weak, nonatomic) id delegate;
@property (copy, nonatomic) NSDictionary *editedObject;
@property (copy, nonatomic) NSDictionary *object;

// method to for nav button
- (IBAction)clickedDoneButton:(UIBarButtonItem *)sender;
- (void)clickedAddButton;

@end
