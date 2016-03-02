//
//  EmailRegisterViewController.m
//  ShakeLists
//
//  Created by Software Superstar on 3/2/16.
//  Copyright © 2016 Software Superstar. All rights reserved.
//

#import "EmailRegisterViewController.h"
#import "UIView+Toast.h"

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
        // Please here code for register.
    }
    
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
