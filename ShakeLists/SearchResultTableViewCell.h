//
//  SearchResultTableViewCell.h
//  ShakeLists
//
//  Created by Software Superstar on 2/26/16.
//  Copyright © 2016 Software Superstar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchResultTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phrasesCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
