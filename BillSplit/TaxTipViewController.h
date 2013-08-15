//
//  TaxTipViewController.h
//  BillSplit
//
//  Created by Aseem Kohli on 8/7/13.


#import <UIKit/UIKit.h>

#define MAX_TIP 30;
#define MIN_TIP 0;

@interface TaxTipViewController: UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textTaxValue;
@property (nonatomic) IBOutlet UISlider *sliderTipPercentage;
@property (nonatomic) IBOutlet UILabel *labelTipPercentage;

@property (weak, nonatomic) id delegate;
@property (copy, nonatomic) NSDictionary *editedObject;
@property (copy, nonatomic) NSDictionary *object;


- (IBAction)clickedCancelButton:(UIBarButtonItem *)sender;
- (IBAction)clickedDoneButton:(UIBarButtonItem *)sender;
- (IBAction)tipPercentageSliderMoved:(UISlider *)sender;
@end
