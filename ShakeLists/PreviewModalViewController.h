//
//  PreviewModalViewController.h
//  ShakeLists
//
//  Created by Software Superstar on 2/27/16.
//  Copyright © 2016 Software Superstar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PreviewModalViewController : UIViewController {
    NSDictionary *selectedShake;
}

@property (weak, nonatomic) IBOutlet UIImageView *nfswCheckImageView;
@property (weak, nonatomic) IBOutlet UIImageView *gRatedCheckImageView;
@property (weak, nonatomic) IBOutlet UILabel *tagLabel;
@property (weak, nonatomic) IBOutlet UILabel *phraseSelectionLabel;
@property (weak, nonatomic) IBOutlet UITableView *phraseTableView;
@property (nonatomic, strong) NSArray* phraseArray;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *rightBarItem;

- (IBAction)downloadShakeList:(id)sender;

@end