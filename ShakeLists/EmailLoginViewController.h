//
//  EmailLoginViewController.h
//  ShakeLists
//
//  Created by Software Superstar on 2/26/16.
//  Copyright © 2016 Software Superstar. All rights reserved.
//

#import <UIKit/UIKit.h>
    
@interface EmailLoginViewController : UIViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *userNameTextView;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextView;

- (IBAction)loginUser:(id)sender;
    @end
