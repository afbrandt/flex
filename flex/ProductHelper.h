//
//  ProductHelper.h
//  flex
//
//  Created by Andrew Brandt on 1/11/15.
//  Copyright (c) 2015 dorystudios. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FlexProduct;

@interface ProductHelper : NSObject

@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) FlexProduct *latestProduct;
@property (nonatomic, assign) BOOL hasNewProduct;

+ (instancetype)sharedHelper;

- (void)processUPC: (NSString *)upcString;

@end
