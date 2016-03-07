//
//  NewShakeListViewController.h
//  ShakeLists
//
//  Created by Software Superstar on 2/21/16.
//  Copyright © 2016 Software Superstar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewShakeListViewController : UIViewController <UITextFieldDelegate> {
    NSInteger cellNumber;
    NSIndexPath* cellIndexPath;
    NSString *userName;
    BOOL nfsw_checked;
    BOOL g_rated_checked;
}

@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveBarButtonItem;
@property (weak, nonatomic) IBOutlet UITableView *phraseTableView;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UITextField *shakeListTitleTextField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *listSaveTypeSegment;
@property (weak, nonatomic) IBOutlet UISegmentedControl *phraseSelectionSegment;
@property (weak, nonatomic) IBOutlet UILabel *phrasesLabel;
@property (weak, nonatomic) IBOutlet UIButton *nfswCheckbox;
@property (weak, nonatomic) IBOutlet UIButton *gRatedCheckbox;
@property (nonatomic, strong) NSMutableArray *phraseArray;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;
@property (weak, nonatomic) IBOutlet UINavigationItem *titleNavigationItem;

- (IBAction)createNewShakeList:(id)sender;
- (IBAction)cancelButtonClicked:(id)sender;
- (IBAction)nfswButtonClicked:(id)sender;
- (IBAction)gRatedButtonClicked:(id)sender;
- (IBAction)nfswCheckboxClicked:(id)sender;
- (IBAction)gRatedCheckboxClicked:(id)sender;

@end

