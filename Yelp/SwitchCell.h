//
//  SwitchCell.h
//  Yelp
//
//  Created by Michael Wu on 9/18/15.
//  Copyright © 2015 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SwitchCell;

@protocol SwitchCellDelegate <NSObject>

- (void)switchCell:(SwitchCell *)cell didUpdateValue:(BOOL)value;

@end

@interface SwitchCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (nonatomic, assign) BOOL on;
@property (nonatomic, weak) id<SwitchCellDelegate> delegate;

- (void)setOn:(BOOL)on animated:(BOOL)animated;
@end
