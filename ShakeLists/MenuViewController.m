//
//  MenuViewController.m
//  REFrostedViewControllerStoryboards
//
//  Created by Roman Efimov on 10/9/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "MenuViewController.h"
#import "MyShakeListViewController.h"
#import "UIViewController+REFrostedViewController.h"
#import "REFrostedContainerViewController.h"
#import "MyNavigationViewController.h"
#import <Firebase/Firebase.h>
#import "LoginHomeViewController.h"
#import "Define.h"

@interface MenuViewController ()

@end

@implementation MenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.separatorColor = [UIColor colorWithRed:150/255.0f green:161/255.0f blue:177/255.0f alpha:1.0f];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.opaque = NO;
    self.tableView.backgroundColor = [UIColor clearColor];
}

#pragma mark -
#pragma mark UITableView Delegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor colorWithRed:62/255.0f green:68/255.0f blue:75/255.0f alpha:1.0f];
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:17];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)sectionIndex
{
    if (sectionIndex == 0)
        return 0;
    
    return 34;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MyNavigationViewController *navigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"contentController"];
    NSArray *IDs = ACTIVITIES_PER_MENU;
    
    if (indexPath.section == 0) {
        NSString *controllerID = IDs[indexPath.row];
        UIViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:controllerID];
        navigationController.viewControllers = @[controller];
        
    } else {
        NSLog(@"Logout");
        
        // Logout the account.
        [FB_REF unauth];
        
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:USER_NAME_KEY];
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:MY_SHAKE_LIST];
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:SELECTED_SHAKE_KEY];
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:SHAKE_EDIT_KEY];

        LoginHomeViewController *homeViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"loginHomeController"];
        [self.navigationController pushViewController:homeViewController animated:YES];
    }
    
    self.frostedViewController.contentViewController = navigationController;
    [self.frostedViewController hideMenuViewController];
}

#pragma mark -
#pragma mark UITableView Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    if (sectionIndex == 0) {
        return 8;
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    if (indexPath.section == 0) {
        NSArray *titles = MENU_TITLES;
        cell.textLabel.text = titles[indexPath.row];
    } else {
        cell.textLabel.text = @"Logout";
    }
    
    return cell;
}
 
@end
