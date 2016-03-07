//
//  LoginHomeViewController.m
//  ShakeLists
//
//  Created by Software Superstar on 3/2/16.
//  Copyright © 2016 Software Superstar. All rights reserved.
//

#import "LoginHomeViewController.h"
#import "TwitterAuthHelper.h"
#import <Firebase/Firebase.h>
#import "UIView+Toast.h"
#import "Define.h"

@interface LoginHomeViewController () {
    UIView *rootView;
}

@end

@implementation LoginHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Hide the navigation bar.
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    
    rootView = self.navigationController.view;
    
    NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:USER_NAME_KEY];
    if (username != nil && FB_REF != NULL) {
        UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"homeViewController"];
        [self.navigationController pushViewController:viewController animated:YES];
        
    } else {
        [self setIntroView];
    }

    NSLog(@"firebase ref result : %@", FB_REF.authData);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark introduction page.

- (void)setIntroView {
    EAIntroPage *page1 = [EAIntroPage page];
    page1.title = PAGE_1_TITLE;
    page1.titleColor = [UIColor whiteColor];
    page1.desc = PAGE_1_DESC;
    page1.titlePositionY = self.view.frame.size.height/3;
    page1.descPositionY = page1.titlePositionY-50;
    
    EAIntroPage *page2 = [EAIntroPage page];
    page2.title = PAGE_2_TITLE;
    page2.desc = PAGE_2_DESC;
    page2.titlePositionY = self.view.frame.size.height/3;
    page2.descPositionY = page1.titlePositionY-50;
    
    EAIntroPage *page3 = [EAIntroPage page];
    page3.title = PAGE_3_TITLE;
    page3.desc = PAGE_3_DESC;
    page3.titlePositionY = self.view.frame.size.height/3;
    page3.descPositionY = page1.titlePositionY-50;
    
    EAIntroPage *page4 = [EAIntroPage page];
    page4.title = PAGE_4_TITLE;
    page4.desc = PAGE_4_DESC;
    page4.titlePositionY = self.view.frame.size.height/3;
    page4.descPositionY = page1.titlePositionY-50;
    
    EAIntroView *intro = [[EAIntroView alloc] initWithFrame:rootView.bounds andPages:@[page1,page2,page3,page4]];
    intro.bgImage = [UIImage imageNamed:@"bg1"];
    [intro setDelegate:self];
    
    UIImageView *titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"intro_profile"]];
    titleView.frame = CGRectMake(titleView.frame.origin.x,
                                 titleView.frame.origin.y,
                                 self.view.frame.size.width/3*2,
                                 self.view.frame.size.width/3*2);
    intro.titleView = titleView;
    intro.titleViewY = 90;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn setFrame:CGRectMake(0, 0, 150, 40)];
    [btn setTitle:@"Let's Go!" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.layer.cornerRadius = 10;
    btn.layer.backgroundColor = [[UIColor redColor] CGColor];
    intro.skipButton = btn;
    intro.skipButtonY = page4.descPositionY - 60;
    intro.skipButtonAlignment = EAViewAlignmentCenter;
    intro.skipButton.alpha = 0.f;
    intro.skipButton.enabled = NO;
    page4.onPageDidAppear = ^{
        [intro limitScrollingToPage:intro.visiblePageIndex];
        intro.skipButton.enabled = YES;
        [UIView animateWithDuration:0.1f animations:^{
            intro.skipButton.alpha = 1.f;
        }];
    };
    page4.onPageDidDisappear = ^{
        intro.skipButton.enabled = NO;
        [UIView animateWithDuration:0.1f animations:^{
            intro.skipButton.alpha = 0.f;
        }];
    };
    
    [intro showInView:rootView animateDuration:0.3];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark facebook login.

// Login with facebook.
- (IBAction)loginWithFacebook:(id)sender {

    [self setLoadingStatus:NO];
    
    FBSDKLoginManager *facebookLogin = [[FBSDKLoginManager alloc] init];
    
    [facebookLogin logInWithReadPermissions:@[@"email"]
                         fromViewController:self
                                    handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
                                        if (error) {
                                            NSLog(@"Facebook login failed. Error: %@", error);
                                            [self.navigationController.view makeToast:@"Facebook login failed."];
                                            [self setLoadingStatus:YES];
                                        } else if (result.isCancelled) {
                                            NSLog(@"Facebook login got cancelled.");
                                            [self.navigationController.view makeToast:@"Facebook login got cancelled."];
                                            [self setLoadingStatus:YES];
                                        } else {
                                            NSString *accessToken = [[FBSDKAccessToken currentAccessToken] tokenString];
                                            [FB_REF authWithOAuthProvider:@"facebook" token:accessToken
                                                   withCompletionBlock:^(NSError *error, FAuthData *authData) {
                                                       if (error) {
                                                           NSLog(@"Login failed. %@", error);
                                                       } else {
                                                           NSLog(@"Logged in! %@", authData);
                                                           NSLog(@"UserName : %@", [authData.providerData objectForKey:@"displayName"]);
                                                           [self.navigationController.view makeToast:@"Logged in successfully!"];
                                                           [self setLoadingStatus:YES];
                                                           
                                                           NSString *userName = [authData.providerData objectForKey:@"displayName"];
                                                           [[NSUserDefaults standardUserDefaults] setObject:userName forKey:USER_NAME_KEY];
                                                           
                                                           UIViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"homeViewController"];
                                                           [self.navigationController pushViewController:controller animated:YES];
                                                       }
                                                   }];
                                        }
                                    }];
}

#pragma mark twitter login.

// login with Twitter.
- (IBAction)loginWithTwitter:(id)sender {
    
    [self setLoadingStatus:NO];
    
    self.twitterAuthHelper = [[TwitterAuthHelper alloc] initWithFirebaseRef:FB_REF apiKey:TWITTER_API_KEY];
    [self.twitterAuthHelper selectTwitterAccountWithCallback:^(NSError *error, NSArray *accounts) {
        if (error) {
            NSString *message = [NSString stringWithFormat:@"There was an error logging into Twitter: %@", [error localizedDescription]];
            NSLog(@"%@", message);
            [self.navigationController.view makeToast:message];
            
            [self setLoadingStatus:YES];

        } else {
//            [self.twitterAuthHelper authenticateAccount:[accounts firstObject]
//                                           withCallback:[self loginBlockForProviderName:@"Twitter"]];
            
            // If you wanted something more complicated, comment the above line out, and use the below line instead.
            [self twitterHandleAccounts:accounts];
        }
    }];
}

// ADV TWITTER STUFF
- (void)twitterHandleAccounts:(NSArray *)accounts
{
    // Handle the case based on how many twitter accounts are registered with the phone.
    switch ([accounts count]) {
        case 0:
            // There is currently no Twitter account on the device.
            break;
        case 1:
            // Single user system, go straight to login
            [self.twitterAuthHelper authenticateAccount:[accounts firstObject]
                                           withCallback:[self loginBlockForProviderName:@"Twitter"]];
            break;
        default:
            // Handle multiple users by showing action sheet
            [self twitterShowAccountsSheet:accounts];
            break;
    }
}

// For this, you'll need to make sure that your ViewController is a UIActionSheetDelegate.
- (void)twitterShowAccountsSheet:(NSArray *)accounts
{
    UIAlertController *selectUserActions = [UIAlertController
                                            alertControllerWithTitle:@"Select Twitter Account"
                                            message:nil
                                            preferredStyle:UIAlertControllerStyleAlert];
    
    for (ACAccount *account in accounts) {
        
        [selectUserActions addAction:[UIAlertAction
                                     actionWithTitle:[account username]
                                     style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction * _Nonnull action) {
                                         NSLog(@"Twitter Account username : %@", [account username]);
                                         
                                         for (ACAccount *authHelperAccount in self.twitterAuthHelper.accounts) {
                                             if ([[account username] isEqualToString:[authHelperAccount username]]) {
                                                 [self.twitterAuthHelper authenticateAccount:account
                                                                                withCallback:[self loginBlockForProviderName:@"Twitter"]];
                                             }
                                         }
                                     }]];
    }
    UIAlertAction *cancelButton = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             [selectUserActions dismissViewControllerAnimated:YES completion:nil];
                                                         }];
    [selectUserActions addAction:cancelButton];
    
    [self presentViewController:selectUserActions animated:YES completion:nil];
}

- (void(^)(NSError *, FAuthData *))loginBlockForProviderName:(NSString *)providerName
{
    // this callback block can be used for every login method
    return ^(NSError *error, FAuthData *authData) {
        if (error != nil) {
            // there was an error authenticating with Firebase
            NSLog(@"Error logging in to Firebase: %@", error);
            // display an alert showing the error message
            NSString *message = [NSString stringWithFormat:@"There was an error logging into Firebase using %@: %@",
                                 providerName,
                                 [error localizedDescription]];
            [self.navigationController.view makeToast:message];
            [self setLoadingStatus:YES];
            
        } else {
            // all is fine, set the current user and update UI
            NSLog(@"Logged in! %@", authData);
            NSLog(@"UserName : %@", [authData.providerData objectForKey:@"username"]);
            [self.navigationController.view makeToast:@"Logged in successfully!"];
            [self setLoadingStatus:YES];
            
            NSString *userName = [authData.providerData objectForKey:@"username"];
            [[NSUserDefaults standardUserDefaults] setObject:userName forKey:USER_NAME_KEY];
            
            UIViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"homeViewController"];
            [self.navigationController pushViewController:controller animated:YES];
        }
    };
}

// Set the loading status
- (void)setLoadingStatus:(BOOL) flag {
    
    self.loadingIndicator.hidden = flag;
    self.facebookButton.enabled = flag;
    self.twitterButton.enabled = flag;
    self.emailButton.enabled = flag;
    self.tutorialButton.enabled = flag;
    
    if (flag) {
        self.view1.alpha = 1.0f;
        self.view2.alpha = 1.0f;
    } else {
        self.view1.alpha = .9f;
        self.view2.alpha = .9f;
    }
}

@end
