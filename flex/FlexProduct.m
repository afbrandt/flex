//
//  FlexProduct.m
//  flex
//
//  Created by Andrew Brandt on 1/11/15.
//  Copyright (c) 2015 dorystudios. All rights reserved.
//

#import "FlexProduct.h"


@implementation FlexProduct

@dynamic upc;
@dynamic itemName;
@dynamic itemBrand;
@dynamic itemDescription;

+ (instancetype)createInstanceFromManagedContext:(NSManagedObjectContext *)context {
    FlexProduct *product = [NSEntityDescription insertNewObjectForEntityForName:@"FlexProduct" inManagedObjectContext:context];
    return product;
}

@end
