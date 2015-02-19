//
//  FlexProductTableViewCell.m
//  flex
//
//  Created by Andrew Brandt on 2/14/15.
//  Copyright (c) 2015 dorystudios. All rights reserved.
//

#import "FlexProductTableViewCell.h"
#import "FlexProduct.h"

@interface FlexProductTableViewCell ()

@end

@implementation FlexProductTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    [self.product addObserver:self forKeyPath:@"imagePath" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    NSLog(@"Noticed a change");
    if ([keyPath isEqualToString:@"imagePath"]) {
        NSString *new = change[NSKeyValueChangeNewKey];
        self.imageView.image = [UIImage imageWithContentsOfFile:new];
    }
}

@end
