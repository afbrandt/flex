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
    self.latestProduct = [FlexProduct createInstanceFromManagedContext:self.context];
    self.manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //NSString *url = [NSString stringWithFormat:@"%@/e211badfdf61541535d3e7c4e8d4d2f6/%@", URL_BASE, upcString];
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@", URL_BASE, PRODUCT_ENDPOINT_V1, upcString];
    
    [self.manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"json: %@", responseObject);
        NSError *error;
        NSDictionary *json = (NSDictionary *)responseObject;
        
        [self.latestProduct setUpc:upcString];
        [self.latestProduct setImageUrl:json[@"imgURL"]];
        [self.latestProduct setItemName:json[@"name"]];
        [self.latestProduct setItemBrand:json[@"brand"]];
        [self.latestProduct setItemDescription:@"description"];
        
        [self.context save:&error];
        [self getImageForProduct: self.latestProduct];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error");
    }];
}

- (void)getImageForProduct:(FlexProduct *)product {
    NSString *url = [product imageUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    op.responseSerializer = [AFImageResponseSerializer serializer];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSArray *tokens = [url componentsSeparatedByString:@"/"];
    NSString *token = tokens[tokens.count-1];
    token = [[token componentsSeparatedByCharactersInSet:[NSCharacterSet illegalCharacterSet]] componentsJoinedByString:@""];
    __block NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:token];
    
    
    op.outputStream = [NSOutputStream outputStreamToFileAtPath:path append:NO];
    NSLog(@"%@",tokens[tokens.count-1]);
    
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error;
        [product setImagePath:path];
        [self.context save:&error];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //do something
    }];
    
    [op start];
}

+ (instancetype)sharedHelper {
    if (!helper) {
        helper = [[ProductHelper alloc] init];
    }
    return helper;
}

@end
