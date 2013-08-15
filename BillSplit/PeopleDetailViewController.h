//
//  PeopleDetailViewController.h
//  BillSplit
//
//  Created by Aseem Kohli on 8/5/13.


#import <UIKit/UIKit.h>

@interface PeopleDetailViewController : UIViewController <UITextFieldDelegate>

// UI Properties
@property (weak, nonatomic) IBOutlet UITextField *textName;
@property (weak, nonatomic) IBOutlet UITextField *textCardNumber;

// properties to send/receive data between controllers
@property (copy, nonatomic) NSDictionary *selection;
@property (weak, nonatomic) id delegate;


// UI methods
- (IBAction)clickedCancelButton:(UIBarButtonItem *)sender;
- (IBAction)clickedDoneButton:(UIBarButtonItem *)sender;


@end
