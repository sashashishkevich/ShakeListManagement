//
//  EmailLoginViewController.m
//  ShakeLists
//
//  Created by Software Superstar on 2/26/16.
//  Copyright © 2016 Software Superstar. All rights reserved.
//

#import "EmailLoginViewController.h"
#import <Firebase/Firebase.h>
#import "UIView+Toast.h"
#import "Define.h"

@interface EmailLoginViewController () {
}

@end

@implementation EmailLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Hide navigation bar.
    [[self navigationController] setNavigationBarHidden:YES animated:YES];

    NSString* userNameStr = [[NSUserDefaults standardUserDefaults] objectForKey:USER_NAME_KEY];
    self.view.hidden = NO;
    
    self.userNameTextView.delegate = self;
    self.passwordTextView.delegate = self;
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

#pragma mark Textfield delegate.

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)loginUser:(id)sender {
    
//    UIViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"MyShakeListController"];
//    [self.navigationController pushViewController:controller animated:YES];
    
    if ([self.userNameTextView.text isEqualToString:@""]) {
        
        [self showAlert:@"Please fill out UserName field."];
        [self.userNameTextView becomeFirstResponder];
        
    } else if ([self.passwordTextView.text isEqualToString:@""]) {
        
        [self showAlert:@"Plese fill out Password field."];
        [self.passwordTextView becomeFirstResponder];
        
    } else {
        
        [self setLoadingIndicatorStatus:NO];
        
        [FB_REF authUser:self.userNameTextView.text password:self.passwordTextView.text withCompletionBlock:
         ^(NSError *error, FAuthData *authData) {
             
             if (error) {
                 NSLog(@"login result : %@", error);
                 [self.view makeToast:[error.userInfo objectForKey:@"NSLocalizedDescription"]];
                 [self setLoadingIndicatorStatus:YES];
                 
             } else {
                 NSLog(@"Login Result : %@", authData);
                 
                 
                 Firebase *accountRef = [FB_REF childByAppendingPath:@"accounts"];
                 Firebase *uidRef = [accountRef childByAppendingPath:authData.uid];
                 
                 [uidRef observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
                     
                     NSDictionary *userDict = snapshot.value;
                     
                     [[NSUserDefaults standardUserDefaults] setObject:[userDict objectForKey:@"username"]
                                                                forKey:USER_NAME_KEY];
                     NSLog(@"UserName : %@", [userDict objectForKey:@"username"]);
                     
                     [self setLoadingIndicatorStatus:YES];
                     
                     UIViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"MyShakeListController"];
                     [self.navigationController pushViewController:controller animated:YES];

                 }];
             }
         }];
    }
}

// Set the loading indicator when login.
- (void) setLoadingIndicatorStatus:(BOOL)flag {
    
    self.loadingIndicator.hidden = flag;
    self.userNameTextView.enabled = flag;
    self.passwordTextView.enabled = flag;
    self.loginButton.enabled = flag;
    
}

- (void)showAlert:(NSString *)messageStr {
    
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"Input Error"
                                 message:messageStr
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* okButton = [UIAlertAction
                               actionWithTitle:@"OK"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action)
                               {
                                   //Handel your yes please button action here
                               }];
    [alert addAction:okButton];
    
    [self presentViewController:alert animated:YES completion:nil];
}

@end
