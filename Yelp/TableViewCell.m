//
//  TableViewCell.m
//  Yelp
//
//  Created by Michael Wu on 9/17/15.
//  Copyright © 2015 codepath. All rights reserved.
//

#import "TableViewCell.h"
#import "UIImageView+AFNetworking.h"

@interface TableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *thumbImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *ratingImageView;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@end

@implementation TableViewCell

- (void)awakeFromNib {
    // Initialization code
    //[super awakeFromNib];
    self.nameLabel.preferredMaxLayoutWidth = self.nameLabel.frame.size.width;
    self.thumbImageView.layer.cornerRadius = 3;
    self.thumbImageView.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setBusiness:(Business *)business {
    _business = business;
    [self.thumbImageView setImageWithURL:[NSURL URLWithString:self.business.imageUrl]];
    self.nameLabel.text = self.business.name;
    [self.ratingImageView setImageWithURL:[NSURL URLWithString:self.business.ratingImageUrl]];
    self.ratingLabel.text = [NSString stringWithFormat:@"%ld reviews", self.business.numReviews];
    self.addressLabel.text = self.business.address;
    self.distanceLabel.text = [NSString stringWithFormat:@"%.2f mi", self.business.distance];
    self.categoryLabel.text = self.business.categories;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.nameLabel.preferredMaxLayoutWidth = self.nameLabel.frame.size.width;
}

@end