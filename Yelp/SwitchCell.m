//
//  SwitchCell.m
//  Yelp
//
//  Created by Michael Wu on 9/18/15.
//  Copyright © 2015 codepath. All rights reserved.
//

#import "SwitchCell.h"

@interface SwitchCell()
@property (weak, nonatomic) IBOutlet UISwitch *toggleSwitch;
- (IBAction)switchValueChanged:(UISwitch *)sender;

@end

@implementation SwitchCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)switchValueChanged:(UISwitch *)sender {
    [self.delegate switchCell:self didUpdateValue:self.toggleSwitch.on];
}

- (void)setOn:(BOOL)on {
    [self setOn:on animated:NO];
}
- (void)setOn:(BOOL)on animated:(BOOL)animated {
    _on = on;
    self.toggleSwitch.on = on;
    [self.toggleSwitch setOn:on animated:animated];
    
}

@end
