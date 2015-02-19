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

static NSString const* EXTERNAL_URL_BASE = @"http://api.upcdatabase.org/json";
static NSString const* URL_BASE = @"http://10.2.14.247:3000";
//static NSString const* URL_BASE = @"http://flex-server-001.herokuapp.com";
static NSString const* PRODUCT_ENDPOINT_V1 = @"v1/product";

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
    
    //NSString *url = [NSString stringWithFormat:@"%@/e211badfdf61541535d3e7c4e8d4d2f6/%@", URL_BASE, upcString];
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@", URL_BASE, PRODUCT_ENDPOINT_V1, upcString];
    
    [self.manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"json: %@", responseObject);
        NSError *error;

        [product setUpc:upcString];
        [self.context save:&error];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error");
    }];
}

+ (instancetype)sharedHelper {
    if (!helper) {
        helper = [[ProductHelper alloc] init];
    }
    return helper;
}

@end
