//
//  EmailRegisterViewController.h
//  ShakeLists
//
//  Created by Software Superstar on 3/2/16.
//  Copyright © 2016 Software Superstar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EmailRegisterViewController : UIViewController<UITextFieldDelegate> {
    
    __weak IBOutlet UITextField *userNameTextField;
    __weak IBOutlet UITextField *emailAddressTextField;
    __weak IBOutlet UITextField *passwordTextField;
    __weak IBOutlet UITextField *confirmPasswordField;
    
}

- (IBAction)registerAccount:(id)sender;
- (IBAction)cancelRegister:(id)sender;

@end
