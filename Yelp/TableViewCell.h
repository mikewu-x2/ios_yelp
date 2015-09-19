//
//  TableViewCell.h
//  Yelp
//
//  Created by Michael Wu on 9/17/15.
//  Copyright © 2015 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Business.h"

@interface TableViewCell : UITableViewCell
@property (strong, nonatomic) Business *business;

@end
