//
//  SummaryViewController.h
//  BillSplit
//
//  Created by Aseem Kohli on 8/7/13.


#import <UIKit/UIKit.h>

@interface SummaryViewController : UITableViewController

@property (copy, nonatomic) NSDictionary *editedObject;
@property (copy, nonatomic) NSDictionary *object;
@property (weak, nonatomic) id delegate;




@end
