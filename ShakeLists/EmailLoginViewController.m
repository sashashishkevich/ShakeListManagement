//
//  EmailLoginViewController.m
//  ShakeLists
//
//  Created by Software Superstar on 2/26/16.
//  Copyright © 2016 Software Superstar. All rights reserved.
//

#import "EmailLoginViewController.h"

@interface EmailLoginViewController () {
}

@end

@implementation EmailLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Hide navigation bar.
    [[self navigationController] setNavigationBarHidden:YES animated:YES];

    NSString* userNameStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"USER_NAME_KEY"];
    self.view.hidden = NO;
    
    self.userNameTextView.delegate = self;
    self.passwordTextView.delegate = self;

    if (userNameStr != nil) {

//        self.view.hidden = YES;
//        UIViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"MyShakeListController"];
//        [self.navigationController pushViewController:controller animated:YES];
    }

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
    if ([self.userNameTextView.text isEqualToString:@""]) {
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@"Input Error"
                                     message:@"Please fill out the UserName Field."
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
        
        [self.userNameTextView becomeFirstResponder];
        
    } else {
        
        [[NSUserDefaults standardUserDefaults] setObject:self.userNameTextView.text forKey:@"USER_NAME_KEY"];
        NSLog(@"UserName : %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"USER_NAME_KEY"]);
    }
}

@end
