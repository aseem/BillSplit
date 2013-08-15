//
//  ReceiptDetailViewController.m
//  BillSplit
//
//  Created by Aseem Kohli on 8/6/13.


#import "ReceiptDetailViewController.h"

@interface ReceiptDetailViewController ()

@end

@implementation ReceiptDetailViewController

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
    
    // make sure the text fields show the appropriate keyboard
    self.textItemName.keyboardType = UIKeyboardTypeAlphabet;
    self.textItemPrice.keyboardType = UIKeyboardTypeDecimalPad;
    
    self.textItemName.delegate = self;
    self.textItemPrice.delegate = self;
    
    // load the name from the calling controller
    ReceiptItem *myItem = self.selection[@"object"];
    self.textItemName.text = [myItem itemName];
    self.textItemPrice.text = [NSString stringWithFormat:@"%.02f", [myItem itemPrice]];
    
    // set the title to the person's name
    self.title = [myItem itemName];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    if ([self.delegate respondsToSelector:@selector(setEditedSelection:)])
    {
        // force editing to finish
        [self.textItemName endEditing:YES];
        [self.textItemPrice endEditing:YES];
        
        // prepare selection info and send it back to People View Controller
        NSIndexPath *indexPath = self.selection[@"indexPath"];
        
        id itemName;
        if ([self.textItemName.text length] > 15)
            itemName = [self.textItemName.text substringToIndex:15];
        else
            itemName = self.textItemName.text;
        
        
        id itemPrice;
        if ([self.textItemPrice.text length] > 10)
            itemPrice = [self.textItemPrice.text substringToIndex:10];
        else
            itemPrice = self.textItemPrice.text;
        
        if (itemName == nil)
            itemName = @"New Item";
        
        if (itemPrice   == nil)
            itemPrice = @"0.00";
        
        NSDictionary *editedSelection = @{@"indexPath" : indexPath,
                                          @"itemName" : itemName,
                                          @"itemPrice": itemPrice};
        
        [self.delegate setValue:editedSelection forKey:@"editedSelection"];
    }
    
    // Dismiss this view controller
    [self.navigationController popViewControllerAnimated:YES];
}



@end
