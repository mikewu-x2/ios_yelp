//
//  MainViewController.m
//  Yelp
//
//  Created by Timothy Lee on 3/21/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "MainViewController.h"
#import "YelpClient.h"
#import "Business.h"
#import "TableViewCell.h"
#import "FiltersViewController.h"

NSString * const kYelpConsumerKey = @"vxKwwcR_NMQ7WaEiQBK_CA";
NSString * const kYelpConsumerSecret = @"33QCvh5bIF5jIHR5klQr7RtBDhQ";
NSString * const kYelpToken = @"uRcRswHFYa1VkDrGV6LAW2F8clGh5JHV";
NSString * const kYelpTokenSecret = @"mqtKIxMIR4iBtBPZCmCLEb-Dz3Y";

@interface MainViewController ()

@property (nonatomic, strong) YelpClient *client;
@property (strong, nonatomic) NSArray *businesses;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

//- (void)fetchBusinessesWithQuery:(NSString *)query params:(NSDictionary *)params;

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        // You can register for Yelp API keys here: http://www.yelp.com/developers/manage_api_keys
        self.client = [[YelpClient alloc] initWithConsumerKey:kYelpConsumerKey consumerSecret:kYelpConsumerSecret accessToken:kYelpToken accessSecret:kYelpTokenSecret];
        
        [self fetchBusinessesWithQuery:@"Restaurants" params:nil];
        
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //UISearchBar *bar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 200, 44.0)];
    UISearchBar *bar = [[UISearchBar alloc] init];
    bar.text = @"Restuarants";
    self.navigationItem.titleView = bar;

    UIBarButtonItem *filterButton = [[UIBarButtonItem alloc] initWithTitle:@"Filter" style:UIBarButtonItemStylePlain target:self action:@selector(showFilterView)];
    self.navigationItem.leftBarButtonItem = filterButton;
    
    bar.delegate = self;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"TableViewCell" bundle:nil] forCellReuseIdentifier:@"TableViewCell"];
    //[self.tableView registerNib:[UINib nibWithNibName:@"BusinessCell" bundle:nil] forCellReuseIdentifier:@"BusinessCell"];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 120;

}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    NSLog(@"%@", searchText);
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.businesses.count;

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TableViewCell"];
    cell.business =  self.businesses[indexPath.row];
    
    return cell;
}

#pragma mark - filterView

- (void)filtersViewController:(FiltersViewController *)filtersViewController didChangeFilters:(NSDictionary *)filters {
    NSLog(@"changed filters %@", filters);
    [self fetchBusinessesWithQuery:@"Restaurants" params:filters];
}

- (void)showFilterView {
    
    NSLog(@"Filter view");
    FiltersViewController *vc = [[FiltersViewController alloc] init];
    
    vc.delegate = self;
    
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nvc animated:YES completion:nil];
    
}

-(void) fetchBusinessesWithQuery:(NSString *)query params:(NSDictionary *)params {
    [self.client searchWithTerm:query
                         params:params
                        success:^(AFHTTPRequestOperation *operation, id response) {
                            
                            NSArray *businesses = response[@"businesses"];
                            self.businesses = [Business businessesWithDictionaries:businesses];
                            [self.tableView reloadData];
                            
                        }
                        failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            NSLog(@"error: %@", [error description]);
                        }];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
