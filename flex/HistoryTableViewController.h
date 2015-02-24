//
//  HistoryTableViewController.h
//  flex
//
//  Created by Andrew Brandt on 1/10/15.
//  Copyright (c) 2015 dorystudios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryTableViewController : UITableViewController

@property (nonatomic, strong) NSArray *products;
@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, assign) BOOL didCreateProduct;

@end
