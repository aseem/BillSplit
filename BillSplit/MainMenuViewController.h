//
//  MainMenuViewController.h
//  BillSplit
//
//  Created by Aseem Kohli on 8/6/13.



#import <UIKit/UIKit.h>
#import "BillingEvent.h"

@interface MainMenuViewController : UITableViewController

@property (copy, nonatomic) NSDictionary *editedObject;     //object used to return data to
                                                            // this controller

@property (assign, nonatomic) BOOL loadedAnotherController;

- (IBAction)clickedResetButton:(UIBarButtonItem *)sender;   // reset button method

@end
