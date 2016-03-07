//
//  SearchShakeListViewController.m
//  ShakeLists
//
//  Created by Software Superstar on 2/26/16.
//  Copyright © 2016 Software Superstar. All rights reserved.
//

#import "SearchShakeListViewController.h"
#import "SearchResultTableViewCell.h"
#import "PreviewModalViewController.h"
#import "UIView+Toast.h"
#import <Firebase/Firebase.h>
#import "Define.h"

@interface SearchShakeListViewController ()
@end

@implementation SearchShakeListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    nfsw_checked = NO;
    rating_checked = NO;
    g_rated_checked = NO;
    result_item_count = 0;
    self.ratingView.hidden = YES;
    self.loadingIndicator.hidden = YES;
    
    userName = [[NSUserDefaults standardUserDefaults] objectForKey:USER_NAME_KEY];
    
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

- (IBAction)ratingCheckClicked:(id)sender {
    rating_checked = !rating_checked;
    
    if (rating_checked) {
        [self.ratingCheck setImage:[UIImage imageNamed:@"checkbox_on.png"] forState:UIControlStateNormal];
        self.ratingView.hidden = NO;
        
    } else {
        [self.ratingCheck setImage:[UIImage imageNamed:@"checkbox_off.png"] forState:UIControlStateNormal];
        self.ratingView.hidden = YES;
    }
}

- (IBAction)nfswButtonClicked:(id)sender {
    
    nfsw_checked = !nfsw_checked;
    
    if (nfsw_checked) {
        [self.nfswCheck setImage:[UIImage imageNamed:@"checkbox_on.png"] forState:UIControlStateNormal];
        
    } else {
        [self.nfswCheck setImage:[UIImage imageNamed:@"checkbox_off.png"] forState:UIControlStateNormal];
    }
}

- (IBAction)gRatedButtonClicked:(id)sender {
    
    g_rated_checked = !g_rated_checked;
    
    if (g_rated_checked) {
        [self.gRatedCheck setImage:[UIImage imageNamed:@"checkbox_on.png"] forState:UIControlStateNormal];
        
    } else {
        [self.gRatedCheck setImage:[UIImage imageNamed:@"checkbox_off.png"] forState:UIControlStateNormal];
    }
}

- (IBAction)searchShakeList:(id)sender {
    
    if ([self.titleTextField.text isEqualToString:@""]
        && [self.tagTextField.text isEqualToString:@""]) {
        
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@"Input Error"
                                     message:@"Please fill out the field."
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
        
    } else {
        
        self.loadingIndicator.hidden = NO;
        
        if (![self.titleTextField.text isEqualToString:@""]
            && ![self.tagTextField.text isEqualToString:@""]) {
            
            INPUT_TAG = 0;
            
        } else {
            if ([self.tagTextField.text isEqualToString:@""]) {
                INPUT_TAG = 1;
                
            } else if ([self.titleTextField.text isEqualToString:@""]) {
                INPUT_TAG = 2;
            }
        }
        
        // Get the sakelist data from the firebse.
        Firebase *ref = [FB_REF childByAppendingPath:@"shake-lists"];
        
        [ref observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
            // do some stuff once
            NSLog(@"single result : %@", snapshot.value);
            
            self.searchResultMutableArray = [NSMutableArray array];
            result_item_count = 0;
            
            for (FDataSnapshot *child in snapshot.children) {
                
                NSLog(@"child key : %@", child.key);
                
                if (![child.key isEqualToString:userName]) {
                    
                    NSMutableDictionary *userResultDict = child.value;
                   
                    NSLog(@"child result dictionary : %@", userResultDict);
                    
                    for (FDataSnapshot *childUser in child.children) {
                        
                        NSDictionary *dict = childUser.value; //or craft an object instead of dict
                        NSArray *tagArray = [dict objectForKey:@"tags"];
                        NSString *titleStr = [dict objectForKey:@"title"];
                        
                        switch (INPUT_TAG) {
                            case 0:
                                for (NSString *tagStr in tagArray) {
                                    
                                    if (rating_checked) {
                                        if ([tagStr rangeOfString:self.tagTextField.text].location != NSNotFound
                                            && [titleStr rangeOfString:self.titleTextField.text].location != NSNotFound
                                            && [[dict objectForKey:@"nfsw"] intValue] == nfsw_checked
                                            && [[dict objectForKey:@"g-rated"] intValue] == g_rated_checked) {
                                            
                                            [dict setValue:child.key forKey:@"username"];
                                            [self.searchResultMutableArray addObject:dict];
                                            break;
                                        }
                                        
                                    } else {
                                        if ([tagStr rangeOfString:self.tagTextField.text].location != NSNotFound
                                            && [titleStr rangeOfString:self.titleTextField.text].location != NSNotFound) {
                                            
                                            [dict setValue:child.key forKey:@"username"];
                                            [self.searchResultMutableArray addObject:dict];
                                            break;
                                        }
                                    }
                                }
                                break;
                                
                            case 1:
                                
                                if (rating_checked) {
                                    if ([titleStr rangeOfString:self.titleTextField.text].location != NSNotFound
                                        && [[dict objectForKey:@"nfsw"] intValue] == nfsw_checked
                                        && [[dict objectForKey:@"g-rated"] intValue] == g_rated_checked) {
                                        
                                        [dict setValue:child.key forKey:@"username"];
                                        [self.searchResultMutableArray addObject:dict];
                                    }

                                } else {
                                    if ([titleStr rangeOfString:self.titleTextField.text].location != NSNotFound) {
                                        
                                        [dict setValue:child.key forKey:@"username"];
                                        [self.searchResultMutableArray addObject:dict];
                                    }
                                }
                                break;
                                
                            case 2:
                                for (NSString *tagStr in tagArray) {
                                    
                                    if (rating_checked) {
                                        if ([tagStr rangeOfString:self.tagTextField.text].location != NSNotFound
                                            && [[dict objectForKey:@"nfsw"] intValue] == nfsw_checked
                                            && [[dict objectForKey:@"g-rated"] intValue] == g_rated_checked) {
                                            
                                            [dict setValue:child.key forKey:@"username"];
                                            [self.searchResultMutableArray addObject:dict];
                                            break;
                                        }
                                    } else {
                                        if ([tagStr rangeOfString:self.tagTextField.text].location != NSNotFound) {
                                            
                                            [dict setValue:child.key forKey:@"username"];
                                            [self.searchResultMutableArray addObject:dict];
                                            break;
                                        }
                                    }
                                }
                                break;
                                
                                
                            default:
                                break;
                        }
                    }
                }
            }
            
            result_item_count = self.searchResultMutableArray.count;
            self.loadingIndicator.hidden = YES;
            
            if (result_item_count == 0) {
                [self.navigationController.view makeToast:@"Could not find the items."];
            }

            // Reload the shake list table.
            [self.resultTableView reloadData];

        }];
    }
}

- (IBAction)cancelButtonClicked:(id)sender {
    UIViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"homeViewController"];
    [self.navigationController pushViewController:controller animated:YES];
}


#pragma mark - Phrase tabel view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return result_item_count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *simpleTableIdentifier = @"ResultListCell";
    
    SearchResultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[SearchResultTableViewCell
                 alloc] initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:simpleTableIdentifier];
    }
    NSMutableDictionary *cellDict = [self.searchResultMutableArray objectAtIndex:indexPath.row];
    
    cell.profileImage.image = [UIImage imageNamed:@"profile_icon.png"];
    cell.profileImage.layer.cornerRadius = 12;
    cell.profileImage.clipsToBounds = YES;
    cell.titleLabel.text = [cellDict objectForKey:@"title"];
    cell.userNameLabel.text = [cellDict objectForKey:@"username"];
    NSMutableArray *phraseArray = [cellDict objectForKey:@"phrases"];
    NSInteger phrase_count = phraseArray.count;
    if (phraseArray == nil) {
        phrase_count = 0;
    }
    cell.phrasesCountLabel.text = [NSString stringWithFormat:@"%ld phrases", (long)phrase_count];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"cell index : %ld", indexPath.row);
    NSMutableDictionary *selectedDict = [self.searchResultMutableArray objectAtIndex:indexPath.row];
    [[NSUserDefaults standardUserDefaults] setObject:selectedDict forKey:SELECTED_SHAKE_KEY];
    
    UIViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"PreviewModalViewController"];
    [self.navigationController pushViewController:controller animated:YES];
}

@end
