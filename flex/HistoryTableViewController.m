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
#import "ProductHelper.h"
#import "AppDelegate.h"

@interface HistoryTableViewController ()

@property (nonatomic, assign) BOOL didFetchProducts;
@property (nonatomic, weak) ProductHelper *helper;

@end

@implementation HistoryTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UINib *nib = [UINib nibWithNibName:@"FlexProductTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"FlexProductCell"];
    self.helper = [ProductHelper sharedHelper];
    
    self.context = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).managedObjectContext;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    NSMutableArray *all = [[self fetchAllProducts] mutableCopy];
    NSLog(@"array has %ld objects", [all count]);
    if (self.helper.hasNewProduct) {
        [all removeObject:[ProductHelper sharedHelper].latestProduct];
        self.helper.hasNewProduct = NO;
        [self performSelector:@selector(animateNewCell) withObject:nil afterDelay:0.1f];
    }
    NSLog(@"array has %ld objects", [all count]);
    
    self.products = all;
    [self.tableView reloadData];
    
}

- (void)animateNewCell {
    self.products = [self.products arrayByAddingObject:[ProductHelper sharedHelper].latestProduct];
    NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:index] withRowAnimation:UITableViewRowAnimationLeft];
    //[self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.products.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 91.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FlexProductTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FlexProductCell" forIndexPath:indexPath];
    
    NSString *nameString = [self.products[indexPath.row] itemName];
    if (nameString) {
        cell.productLabel.text = nameString;
    }
    
    NSString *brandString = [self.products[indexPath.row] itemBrand];
    if (brandString) {
        cell.brandLabel.text = brandString;
    }
    
    NSString *imagePathString = [self.products[indexPath.row] imagePath];
    if (imagePathString) {
        cell.productImage.image = [UIImage imageNamed:imagePathString];
    }
    
    //cell.product = self.products[indexPath.row];
    //cell.textLabel.text = [self.products[indexPath.row] upc];
    
    return cell;
}

#pragma mark - Navigation

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"ShowProductDetail" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ShowProductDetail"]) {
        ProductDetailViewController *controller = [segue destinationViewController];
        NSIndexPath *path = self.tableView.indexPathForSelectedRow;
        controller.product = self.products[path.row];
    }
}

#pragma mark - Fetch Request methods

- (NSArray *)fetchAllProducts {
    NSError *error;
    NSEntityDescription *nsed = [NSEntityDescription entityForName:@"FlexProduct" inManagedObjectContext:self.context];
    NSFetchRequest *request = [NSFetchRequest new];
    [request setEntity:nsed];
    self.didFetchProducts = YES;
    return [self.context executeFetchRequest:request error:&error];
}

@end
