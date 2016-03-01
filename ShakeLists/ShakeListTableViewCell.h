//
//  ShakeListTableViewCell.h
//  ShakeLists
//
//  Created by Software Superstar on 2/23/16.
//  Copyright © 2016 Software Superstar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShakeListTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *shakeImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phrasesCountLabel;

@end
