//
//  MyShakeListViewController.m
//  ShakeLists
//
//  Created by Software Superstar on 2/23/16.
//  Copyright © 2016 Software Superstar. All rights reserved.
//

#import "MyShakeListViewController.h"
#import "ShakeListTableViewCell.h"
#import <Firebase/Firebase.h>
#import "LMContainsLMComboxScrollView.h"

@interface MyShakeListViewController ()
{
    IBOutlet LMContainsLMComboxScrollView *bgScrollView;
    NSMutableDictionary *addressDict;
}

@end

@implementation MyShakeListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    
//    [self.view bringSubviewToFront:self.shakeListTableView];
    self.loadingIndicator.hidden = NO;
    list_count = 0;
    userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"USER_NAME_KEY"];

    // Set up the sort-by combo box
    NSLog(@"sortby label position : %f", self.view.frame.size.width);
    bgScrollView = [[LMContainsLMComboxScrollView alloc] initWithFrame:CGRectMake(0, 0, 100, 200)];
    bgScrollView.backgroundColor = [UIColor clearColor];
    bgScrollView.showsVerticalScrollIndicator = NO;
    bgScrollView.showsHorizontalScrollIndicator = NO;
    [self.comboxView addSubview:bgScrollView];
    self.shakeListTableView.layer.zPosition = 0;

    [self setUpBgScrollView];

    // Get the my shakelist result.
    NSMutableArray *myShakeMutableAry = [[NSUserDefaults standardUserDefaults] objectForKey:@"MY_SHAKE_LIST"];
    
    if (myShakeMutableAry == NULL) {

        // Get the sakelist data from the firebse.
        Firebase *fb = [[Firebase alloc] initWithUrl: @"https://shakelist1.firebaseio.com/shake-lists"];
        Firebase *ref = [fb childByAppendingPath:userName];
        
        [ref observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
            // do some stuff once
            NSLog(@"single result : %@", snapshot.value);
            self.listMutableArray = [NSMutableArray array];

            for ( FDataSnapshot *child in snapshot.children) {
                
                NSDictionary *dict = child.value; //or craft an object instead of dict
                
                [dict setValue:userName forKey:@"username"];
                [self.listMutableArray addObject:dict];
            }
            
            NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"author" ascending:YES]; //sort by date key, descending
            NSArray *arrayOfDescriptors = [NSArray arrayWithObject:sortDescriptor];
            
            [self.listMutableArray sortUsingDescriptors: arrayOfDescriptors];
            self.loadingIndicator.hidden = YES;
            
            NSLog(@"MyShakeList array : %@", self.listMutableArray);
            
            list_count = self.listMutableArray.count;
            
            // Reload the shake list table.
            [self.shakeListTableView reloadData];

            // Save the result list to default.
            [[NSUserDefaults standardUserDefaults] setObject:self.listMutableArray forKey:@"MY_SHAKE_LIST"];
            
        }];
        
    } else {
        self.listMutableArray = myShakeMutableAry;
        self.loadingIndicator.hidden = YES;
        NSLog(@"MyShakeList array : %@", self.listMutableArray);
        
        list_count = self.listMutableArray.count;
        
        // Reload the shake list table.
        [self.shakeListTableView reloadData];
    }
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setUpBgScrollView {
    LMComBoxView *comBox = [[LMComBoxView alloc]initWithFrame:CGRectMake(10, 8, 80, 30)];
    comBox.backgroundColor = [UIColor whiteColor];
    comBox.arrowImgName = @"down_dark0.png";
    NSMutableArray *itemsArray = [NSMutableArray array];
    [itemsArray addObject:@"user"];
    [itemsArray addObject:@"title"];
    comBox.titlesList = itemsArray;
    comBox.delegate = self;
    comBox.supView = bgScrollView;
    [comBox defaultSettings];
    [bgScrollView addSubview:comBox];
}

#pragma mark - Phrase tabel view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return list_count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *simpleTableIdentifier = @"ListCell";
    
    ShakeListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[ShakeListTableViewCell
                 alloc] initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.shakeImageView.image = [UIImage imageNamed:@"profile_icon.png"];
    cell.shakeImageView.layer.cornerRadius = 12;
    cell.shakeImageView.clipsToBounds = YES;
    cell.titleLabel.text = [[self.listMutableArray objectAtIndex:indexPath.row] objectForKey:@"title"];
    cell.userNameLabel.text = [[self.listMutableArray objectAtIndex:indexPath.row] objectForKey:@"username"];
    NSMutableArray *phraseArray = [[self.listMutableArray objectAtIndex:indexPath.row] objectForKey:@"phrases"];
    NSInteger phrase_count = phraseArray.count;
    if (phraseArray == nil) {
        phrase_count = 0;
    }
    cell.phrasesCountLabel.text = [NSString stringWithFormat:@"%ld phrases", (long)phrase_count];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[NSUserDefaults standardUserDefaults] setValue:@"update" forKey:@"SHAKE_EDIT_KEY"];
    
    NSMutableDictionary *selectedDict = [self.listMutableArray objectAtIndex:indexPath.row];
    if ([[selectedDict objectForKey:@"username"] isEqualToString:userName]) {
        [[NSUserDefaults standardUserDefaults] setObject:selectedDict forKey:@"SELECTED_SHAKE_KEY"];
        
        UIViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"NewShakeListController"];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 800; // or any number based on your estimation
}

#pragma mark -LMComBoxViewDelegate
-(void)selectAtIndex:(int)index inCombox:(LMComBoxView *)_combox {
    NSLog(@"combox index : %d", index);
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)testSetting:(id)sender {
}

- (IBAction)createNewShakeList:(id)sender {
    [[NSUserDefaults standardUserDefaults] setValue:@"create" forKey:@"SHAKE_EDIT_KEY"];
}

@end
