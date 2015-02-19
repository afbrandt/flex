//
//  FlexProductTableViewCell.h
//  flex
//
//  Created by Andrew Brandt on 2/14/15.
//  Copyright (c) 2015 dorystudios. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FlexProduct;

@interface FlexProductTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *productImage;
@property (weak, nonatomic) IBOutlet UILabel *productLabel;
@property (weak, nonatomic) IBOutlet UILabel *brandLabel;

@property (weak, nonatomic) FlexProduct *product;

@end
