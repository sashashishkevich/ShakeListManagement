//
//  PhraseTableViewCell.m
//  ShakeLists
//
//  Created by Software Superstar on 2/23/16.
//  Copyright © 2016 Software Superstar. All rights reserved.
//

#import "PhraseTableViewCell.h"

@implementation PhraseTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    NSLog(@"selected1");
    
    // Configure the view for the selected state
}

@end
