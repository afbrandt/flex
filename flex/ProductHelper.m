//
//  ProductHelper.m
//  flex
//
//  Created by Andrew Brandt on 1/11/15.
//  Copyright (c) 2015 dorystudios. All rights reserved.
//

#import <AFNetworking.h>
#import "ProductHelper.h"
#import "AppDelegate.h"
#import "FlexProduct.h"

@implementation ProductHelper

static ProductHelper *helper;

- (instancetype)init {
    self = [super init];
    
    if (self) {
        self.context = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).managedObjectContext;
    }
    
    return self;
}

- (void)processUPC:(NSString *)upcString {
    FlexProduct *product = [FlexProduct createInstanceFromManagedContext:self.context];
    NSError *error;
    
    [product setUpc:upcString];
    [self.context save:&error];
}

+ (instancetype)sharedHelper {
    if (!helper) {
        helper = [[ProductHelper alloc] init];
    }
    return helper;
}

@end
