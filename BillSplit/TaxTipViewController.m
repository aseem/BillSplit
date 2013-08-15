//
//  TaxTipViewController.m
//  BillSplit
//
//  Created by Aseem Kohli on 8/7/13.


#import "TaxTipViewController.h"
#import "BillingEvent.h"

@interface TaxTipViewController ()
{
    BillingEvent *_myEvent;
}

@end

@implementation TaxTipViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    // Grab the object from the calling controller
    _myEvent = self.object[@"object"];
    
    // make sure the text field shows the appropriate keyboard and is initialized
    self.textTaxValue.keyboardType = UIKeyboardTypeDecimalPad;
    self.textTaxValue.delegate = self;
    self.textTaxValue.text = [NSString stringWithFormat:@"%.02f", _myEvent.tax];
    
    // setup the tip % slider
    self.sliderTipPercentage.maximumValue = MAX_TIP;
    self.sliderTipPercentage.minimumValue = MIN_TIP;
    self.sliderTipPercentage.value = _myEvent.percentTip;
    self.labelTipPercentage.text = [NSString stringWithFormat:@"Tip: %d",
                                    (int)self.sliderTipPercentage.value];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    [_myEvent saveState];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [textField selectAll:self];
}

- (IBAction)clickedCancelButton:(UIBarButtonItem *)sender
{
    // Dismiss this view controller
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)clickedDoneButton:(UIBarButtonItem *)sender
{
    if ([_myEvent stateNeedsToBeLoadedFromMemory])
        [_myEvent loadState];
    
    // force editing to end
    [self.textTaxValue endEditing:YES];
    
    // capture the information on the screen into our Event object
    [_myEvent setTax:[self.textTaxValue.text doubleValue]];
    [_myEvent setPercentTip:(int)self.sliderTipPercentage.value];
    
    if ([self.delegate respondsToSelector:@selector(setEditedObject:)])
    {
        NSDictionary *editedObject = @{@"object" : _myEvent};
        [self.delegate setValue:editedObject forKey:@"editedObject"];
    }
    
    // Dismiss this view controller
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)tipPercentageSliderMoved:(UISlider *)sender
{
    self.labelTipPercentage.text = [NSString stringWithFormat:@"Tip: %d",
                                    (int)self.sliderTipPercentage.value];
}
@end
