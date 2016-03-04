//
//  EmailRegisterViewController.m
//  ShakeLists
//
//  Created by Software Superstar on 3/2/16.
//  Copyright © 2016 Software Superstar. All rights reserved.
//

#import "EmailRegisterViewController.h"
#import "UIView+Toast.h"
#import <Firebase/Firebase.h>

@interface EmailRegisterViewController ()

@end

@implementation EmailRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    userNameTextField.delegate = self;
    emailAddressTextField.delegate = self;
    passwordTextField.delegate = self;
    confirmPasswordField.delegate = self;

    // Hide the navigation bar.
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)registerAccount:(id)sender {
    
    if ([userNameTextField.text isEqualToString:@""]) {
        [self.view makeToast:@"Please fill out UserName field."];
        [userNameTextField becomeFirstResponder];
        
    } else if ([emailAddressTextField.text isEqualToString:@""]) {
        [self.view makeToast:@"Please fill out EmailAddress field."];
        [emailAddressTextField becomeFirstResponder];
        
    } else if ([passwordTextField.text isEqualToString:@""]) {
        [self.view makeToast:@"Please fill out Password field."];
        [passwordTextField becomeFirstResponder];
        
    } else if ([confirmPasswordField.text isEqualToString:@""]) {
        [self.view makeToast:@"Please input the password again."];
        [confirmPasswordField becomeFirstResponder];
        
    } else if (![passwordTextField.text isEqualToString:confirmPasswordField.text]) {
        [self.view makeToast:@"These passwords don't match."];
        
    } else {
        
        // test the duplicate account.
        Firebase *accountRef = [[Firebase alloc] initWithUrl: @"https://shakelist1.firebaseio.com/accounts"];
        [self setEnableEditing:NO];
        
        [accountRef observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
            BOOL dup_flag = NO;
            
            for (FDataSnapshot *child in snapshot.children) {
                NSMutableDictionary *userDict = child.value;
                
                if ([[userDict objectForKey:@"username"] isEqualToString:userNameTextField.text]) {
                    [self.view makeToast:@"Someone already has this User Name."];
                    [userNameTextField becomeFirstResponder];
                    [self setEnableEditing:YES];
                    dup_flag = YES;
                    
                    break;
                    
                } else if ([[userDict objectForKey:@"email"] isEqualToString:emailAddressTextField.text]) {
                    [self.view makeToast:@"Someone already has this Email Address."];
                    [emailAddressTextField becomeFirstResponder];
                    [self setEnableEditing:YES];
                    dup_flag = YES;
                    
                    break;
                }
            }
            
            if (!dup_flag) {

                // Create a new account.
                Firebase *fb = [[Firebase alloc] initWithUrl: @"https://shakelist1.firebaseio.com"];
                [fb createUser:emailAddressTextField.text password:passwordTextField.text withValueCompletionBlock:
                 ^(NSError *error, NSDictionary *result) {
                    
                    if (error) {
                        NSLog(@"result : %@", error);
                        [self.view makeToast:[NSString stringWithFormat:@"%@", [error.userInfo objectForKey:@"NSLocalizedDescription"]]];
                        [self setEnableEditing:YES];
                        
                    } else {
                        NSLog(@"register success : %@", result);
                        
                        NSDictionary *accountDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                                     userNameTextField.text, @"username",
                                                     emailAddressTextField.text, @"email",
                                                     passwordTextField.text, @"password", nil];
                        
                        Firebase *accountRef = [[Firebase alloc] initWithUrl:@"https://shakelist1.firebaseio.com/accounts"];
                        Firebase *uidRef = [accountRef childByAppendingPath:[result objectForKey:@"uid"]];
                        [uidRef setValue:accountDict withCompletionBlock:^(NSError *error, Firebase *ref) {
                            
                            if (error) {
                                [self.view makeToast:@"Data could not be saved"];
                            } else {
                                [self.view makeToast:@"Registered Successfully!"];
                                [self setEnableEditing:YES];
                                [self dismissViewControllerAnimated:YES completion:nil];
                            }
                        }];
                    }
                }];
            }
        }];
    }
}

- (void)setEnableEditing:(BOOL) flag {
    
    loadingIndicator.hidden = flag;
    userNameTextField.enabled = flag;
    emailAddressTextField.enabled = flag;
    passwordTextField.enabled = flag;
    confirmPasswordField.enabled = flag;
    registerButton.enabled = flag;
}

- (IBAction)cancelRegister:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark TextField Delegate

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
