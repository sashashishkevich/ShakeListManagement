//
//  LoginHomeViewController.m
//  ShakeLists
//
//  Created by Software Superstar on 3/2/16.
//  Copyright © 2016 Software Superstar. All rights reserved.
//

#import "LoginHomeViewController.h"

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
    
    // Set the intro view
//    [self setIntroView];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setIntroView {
    EAIntroPage *page1 = [EAIntroPage page];
    page1.title = @"Welcome to ....";
    page1.titleColor = [UIColor whiteColor];
    page1.desc = @"Pellentesque vel aliquet sem, at suscipit nisi. Donec at nibh. Curabitur placerat mi eu mauris pellentesque conque.";
    page1.titlePositionY = self.view.frame.size.height/3;
    page1.descPositionY = page1.titlePositionY-50;
    
    EAIntroPage *page2 = [EAIntroPage page];
    page2.title = @"Make A List!";
    page2.desc = @"Creating a new list is simple...";
    page2.titlePositionY = self.view.frame.size.height/3;
    page2.descPositionY = page1.titlePositionY-50;
    
    EAIntroPage *page3 = [EAIntroPage page];
    page3.title = @"Take A List!";
    page3.desc =@"It's a big world! See what others are shaking!";
    page3.titlePositionY = self.view.frame.size.height/3;
    page3.descPositionY = page1.titlePositionY-50;
    
    EAIntroPage *page4 = [EAIntroPage page];
    page4.title = @"Shake A List!";
    page4.desc = @"Pair a ... and get shaking!";
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

@end
