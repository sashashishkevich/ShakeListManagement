//
//  PhraseTableViewCell.h
//  ShakeLists
//
//  Created by Software Superstar on 2/23/16.
//  Copyright © 2016 Software Superstar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhraseTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *positionLabel;
@property (weak, nonatomic) IBOutlet UIButton *delButton;
@property (weak, nonatomic) IBOutlet UITextField *phraseText;

@end
