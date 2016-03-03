//
//  PreviewModalViewController.m
//  ShakeLists
//
//  Created by Software Superstar on 2/27/16.
//  Copyright © 2016 Software Superstar. All rights reserved.
//

#import "PreviewModalViewController.h"
#import "MyShakeListViewController.h"
#import "UIView+Toast.h"

@interface PreviewModalViewController ()

@end

@implementation PreviewModalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIToolbar *toolbarBackground = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 44, 300, 400)];
    [self.view addSubview:toolbarBackground];
    [self.view sendSubviewToBack:toolbarBackground];
    
    selectedShake = [[NSUserDefaults standardUserDefaults] objectForKey:@"SELECTED_SHAKE_KEY"];
    NSLog(@"result : %@", selectedShake);
    
    self.title = [selectedShake objectForKey:@"title"];

    if ([[selectedShake objectForKey:@"nfsw"] isEqualToString:@"1"]) {
        self.nfswCheckImageView.image = [UIImage imageNamed:@"checkbox_on.png"];
    } else {
        self.nfswCheckImageView.image = [UIImage imageNamed:@"checkbox_off.png"];
    }
    
    if ([[selectedShake objectForKey:@"g-rated"] isEqualToString:@"1"]) {
        self.gRatedCheckImageView.image = [UIImage imageNamed:@"checkbox_on.png"];
    } else {
        self.gRatedCheckImageView.image = [UIImage imageNamed:@"checkbox_off.png"];
    }

    NSArray *tagArray = [selectedShake objectForKey:@"tags"];
    NSString *tagStr = @"Tags  ";
    for (NSString *str in tagArray) {
        tagStr = [NSString stringWithFormat:@"%@ : %@", tagStr, str];
    }
    self.tagLabel.text = tagStr;
    
    NSArray *selectionArray = [NSArray arrayWithObjects:@"Cycle",
                               @"Random",
                               @"Cycle-Random",
                               @"Weighted", nil];
    NSString *selectionStr = [selectionArray objectAtIndex:[[selectedShake objectForKey:@"phrase-selection"] intValue]];
    self.phraseSelectionLabel.text = [NSString stringWithFormat:@"Phrases Selection : %@", selectionStr];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Phrase TableView Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *phraseArray = [selectedShake objectForKey:@"phrases"];
    if (phraseArray.count > 5) {
        return 5;
    } else {
        return phraseArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PhraseCell"];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                      reuseIdentifier:@"PhraseCell"];
        
        [cell setBackgroundColor:[UIColor colorWithRed:247.0f green:247.0f blue:247.0f alpha:1.0f]];
        [[cell textLabel] setNumberOfLines:0]; // unlimited number of lines
        [[cell textLabel] setLineBreakMode:NSLineBreakByWordWrapping];
        [[cell textLabel] setFont:[UIFont systemFontOfSize: 14.0]];
    }
    
    NSArray *phraseArray = [selectedShake objectForKey:@"phrases"];
    [cell.textLabel setText:[phraseArray objectAtIndex:indexPath.row]];
    
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)downloadShakeList:(id)sender {

    NSMutableArray *myShakeListMutableAry = [NSMutableArray array];
    
    NSMutableArray *prevMyShakeListMutableAry = [[NSUserDefaults standardUserDefaults] objectForKey:@"MY_SHAKE_LIST"];

    for (NSDictionary *dict in prevMyShakeListMutableAry) {
        [myShakeListMutableAry addObject:dict];
    }
    
    [myShakeListMutableAry addObject:selectedShake];
    
    // Add the selected shake list to my shake list.
    [[NSUserDefaults standardUserDefaults] setObject:myShakeListMutableAry forKey:@"MY_SHAKE_LIST"];
    
    [self.navigationController.view makeToast:@"Downloading Success!!!"];
    
    MyShakeListViewController *myShakeListController;
    [myShakeListController.shakeListTableView reloadData];

    [self.navigationController popViewControllerAnimated:YES];
}

@end
