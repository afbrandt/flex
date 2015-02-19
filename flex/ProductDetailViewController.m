//
//  ProductDetailViewController.m
//  flex
//
//  Created by Andrew Brandt on 1/11/15.
//  Copyright (c) 2015 dorystudios. All rights reserved.
//

#import "ProductDetailViewController.h"
#import "FlexProduct.h"

@interface ProductDetailViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *productImage;
@property (weak, nonatomic) IBOutlet UILabel *productLabel;
@property (weak, nonatomic) IBOutlet UILabel *brandLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@end

@implementation ProductDetailViewController

- (void)viewDidLoad {

    self.productImage.image = [UIImage imageWithContentsOfFile:[self.product imagePath]];
    
}

@end
