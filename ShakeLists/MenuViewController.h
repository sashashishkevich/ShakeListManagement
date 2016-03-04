//
//  MenuViewController.h
//  REFrostedViewControllerStoryboards
//
//  Created by Roman Efimov on 10/9/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "REFrostedViewController.h"
#import "REFrostedContainerViewController.h"

@interface MenuViewController : UITableViewController

@property (strong, readwrite, nonatomic) REFrostedContainerViewController *containerViewController;

@end
