//
//  HistoryTableViewController.m
//  flex
//
//  Created by Andrew Brandt on 1/10/15.
//  Copyright (c) 2015 dorystudios. All rights reserved.
//

#import "HistoryTableViewController.h"
#import "ProductDetailViewController.h"
#import "FlexProductTableViewCell.h"
#import "FlexProduct.h"
#import "AppDelegate.h"

@interface HistoryTableViewController ()

@end

@implementation HistoryTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UINib *nib = [UINib nibWithNibName:@"FlexProductTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"FlexProductCell"];
    
    self.context = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).managedObjectContext;
}

- (void)viewDidAppear:(BOOL)animated {
    self.products = [self fetchAllProducts];
    [super viewDidAppear:animated];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.products.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FlexProductTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FlexCell" forIndexPath:indexPath];
    
    NSString *nameString = [self.products[indexPath.row] itemName];
    if (nameString) {
        cell.productLabel.text = nameString;
    }
    
    NSString *brandString = [self.products[indexPath.row] itemBrand];
    if (brandString) {
        cell.brandLabel.text = brandString;
    }
    
    NSString *imagePath = [self.products[indexPath.row] imageUrl];
    if (imagePath) {
        cell.productImage.image = [UIImage imageWithContentsOfFile:imagePath];
    }
    
    //cell.textLabel.text = [self.products[indexPath.row] upc];
    
    return cell;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    ProductDetailViewController *controller = [segue destinationViewController];
    NSIndexPath *path = self.tableView.indexPathForSelectedRow;
    controller.product = self.products[path.row];
}

#pragma mark - Fetch Request methods

- (NSArray *)fetchAllProducts {
    NSError *error;
    NSEntityDescription *nsed = [NSEntityDescription entityForName:@"FlexProduct" inManagedObjectContext:self.context];
    NSFetchRequest *request = [NSFetchRequest new];
    [request setEntity:nsed];
    return [self.context executeFetchRequest:request error:&error];
}

@end
