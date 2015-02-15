//
//  FlexProduct.h
//  flex
//
//  Created by Andrew Brandt on 1/11/15.
//  Copyright (c) 2015 dorystudios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface FlexProduct : NSManagedObject

@property (nonatomic, retain) NSString * upc;
@property (nonatomic, retain) NSString * imageUrl;
@property (nonatomic, retain) NSString * itemName;
@property (nonatomic, retain) NSString * itemBrand;
@property (nonatomic, retain) NSString * itemDescription;

+ (instancetype)createInstanceFromManagedContext: (NSManagedObjectContext *)context;

@end
