//
//  HomeScreenViewController.h
//  ShakeLists
//
//  Created by Software Superstar on 3/7/16.
//  Copyright © 2016 Software Superstar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeScreenViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *circleView;

- (IBAction)createButtonClicked:(id)sender;
- (IBAction)takeButtonClicked:(id)sender;
- (IBAction)inviteButtonClicked:(id)sender;

@end