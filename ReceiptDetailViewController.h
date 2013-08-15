//
//  ReceiptDetailViewController.h
//  BillSplit
//
//  Created by Aseem Kohli on 8/6/13.


#import <UIKit/UIKit.h>
#import "ReceiptItem.h"

@interface ReceiptDetailViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textItemName;
@property (weak, nonatomic) IBOutlet UITextField *textItemPrice;

// used for sending/receiving data between controllers
@property (copy, nonatomic) NSDictionary *selection;
@property (weak, nonatomic) id delegate;


// methods for nav buttons
- (IBAction)clickedCancelButton:(UIBarButtonItem *)sender;
- (IBAction)clickedDoneButton:(UIBarButtonItem *)sender;


@end
