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

@interface ProductHelper ()

@property (nonatomic, strong) AFHTTPRequestOperationManager *manager;

@end

@implementation ProductHelper

static ProductHelper *helper;

static NSString const* URL_BASE = @"http://api.upcdatabase.org/json";

- (instancetype)init {
    self = [super init];
    
    if (self) {
        self.context = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).managedObjectContext;
        self.manager = [AFHTTPRequestOperationManager manager];
    }
    
    return self;
}

- (void)processUPC:(NSString *)upcString {
    FlexProduct *product = [FlexProduct createInstanceFromManagedContext:self.context];
    NSError *error;
    
    NSString *url = [NSString stringWithFormat:@"%@/e211badfdf61541535d3e7c4e8d4d2f6/%@", URL_BASE, upcString];
    
    [self.manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"json: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error");
    }];
    
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
