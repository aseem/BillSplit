//
//  PeopleDetailViewController.m
//  BillSplit
//
//  Created by Aseem Kohli on 8/5/13.


#import "PeopleDetailViewController.h"
#import "Person.h"

@interface PeopleDetailViewController ()

@end

@implementation PeopleDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // make sure the text fields show the appropriate keyboard
    self.textName.keyboardType = UIKeyboardTypeAlphabet;
    self.textCardNumber.keyboardType = UIKeyboardTypeNumberPad;
    
    self.textName.delegate = self;
    self.textCardNumber.delegate = self;
    
    // load the name from the calling controller 
    Person *myPerson = self.selection[@"object"];
    self.textName.text = [myPerson name];
    self.textCardNumber.text = [myPerson cardNumber];
    
    // set the title to the person's name
    self.title = [myPerson name];
}



- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}


- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [textField selectAll:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        [self.textName endEditing:YES];
        [self.textCardNumber endEditing:YES];
        
        // prepare selection info and send it back to People View Controller
        NSIndexPath *indexPath = self.selection[@"indexPath"];
        
        id name;
        if ([self.textName.text length] > 15)
            name = [self.textName.text substringToIndex:15];
        else
            name = self.textName.text;
      
        // allowing card number length <= 4 for now...
        id cardNum;
        if ([self.textCardNumber.text length] > 4)
            cardNum = [self.textCardNumber.text substringToIndex:4];
        else
            cardNum = self.textCardNumber.text;
        
        
        
        if (name == nil)
            name = @"New Person";
        
        if (cardNum == nil)
            cardNum = @"0000";
        
        NSDictionary *editedSelection = @{@"indexPath" : indexPath,
                                          @"name" : name,
                                          @"cardNum": cardNum};
        
        [self.delegate setValue:editedSelection forKey:@"editedSelection"];
    }
    
    
    // Dismiss this view controller
    [self.navigationController popViewControllerAnimated:YES];
}

@end
