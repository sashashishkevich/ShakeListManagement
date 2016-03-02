//
//  LoginViewController.h
//  ShakeLists
//
//  Created by Software Superstar on 2/26/16.
//  Copyright © 2016 Software Superstar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EAIntroView.h"

@interface LoginViewController : UIViewController<UITextFieldDelegate, EAIntroDelegate>

@property (weak, nonatomic) IBOutlet UITextField *userNameTextView;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextView;

- (IBAction)loginUser:(id)sender;

@end
