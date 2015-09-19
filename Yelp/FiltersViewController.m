//
//  FiltersViewController.m
//  Yelp
//
//  Created by Michael Wu on 9/18/15.
//  Copyright © 2015 codepath. All rights reserved.
//

#import "FiltersViewController.h"
#import "SwitchCell.h"

@interface FiltersViewController() <UITableViewDelegate, UITableViewDataSource, SwitchCellDelegate>

@property (nonatomic, readonly) NSDictionary *filters;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *categories;
@property(nonatomic, strong) NSArray *sortModes;
@property(nonatomic, strong) NSArray *distances;

@property (nonatomic, strong) NSMutableSet *selectedCategories;
@property(nonatomic, strong) NSNumber *selectedDistance;
@property(nonatomic, strong) NSNumber *selectedSortMode;
@property(nonatomic, assign) BOOL dealsOnlySelected;

typedef NS_ENUM(NSInteger, Filter) {
    FilterDistance,
    FilterSortMode,
    FilterDealsOnly,
    FilterCategories,
    FilterCount,
};

- (void)initCategories;

@end

@implementation FiltersViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super  initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        self.selectedCategories = [NSMutableSet set];
        self.selectedDistance = @0;
        self.selectedSortMode = @0;
        self.dealsOnlySelected = NO;
        [self initCategories];
        [self initDistances];
        [self initSortModes];
    }
    
    return self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(onCancel)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Apply" style:UIBarButtonItemStylePlain target:self action:@selector(onApply)];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SwitchCell" bundle:nil] forCellReuseIdentifier:@"SwitchCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"SelectionCell" bundle:nil] forCellReuseIdentifier:@"SelectionCell"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView Datasource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    switch (section) {
        case FilterDistance:
            NSLog(@"DISTANCE");
            NSLog(@"%lu", (unsigned long)self.distances.count);
            return self.distances.count;
        case FilterSortMode:
            NSLog(@"SORT");
            NSLog(@"%lu", (unsigned long)self.sortModes.count);
            return self.sortModes.count;
        case FilterDealsOnly:
            return 1;
        case FilterCategories:
            return self.categories.count;
        default:
            NSLog(@"This shouldn't happen");
            return 0;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    switch (section) {
        case FilterDistance: {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SelectionCell" forIndexPath:indexPath];
            if (row == [self.selectedDistance unsignedIntegerValue]) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;  // mark as selected
            }
            // set cell text
            cell.textLabel.text = self.distances[row][@"name"];
            
            return cell;
        }
        case FilterSortMode: {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SelectionCell" forIndexPath:indexPath];
            if (row == [self.selectedSortMode unsignedIntegerValue]) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
            cell.textLabel.text = self.sortModes[row][@"name"];
            
            return cell;
        }
            
        case FilterDealsOnly: {
            SwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SwitchCell" forIndexPath:indexPath];
            //cell.textLabel.text = @"Offering a Deal";
            cell.nameLabel.text = @"Offering a Deal";
            cell.on = self.dealsOnlySelected;
            cell.delegate = self;
            return cell;
        }
        case FilterCategories: {
            SwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SwitchCell" forIndexPath:indexPath];
            cell.nameLabel.text = self.categories[indexPath.row][@"name"];
            cell.on = [self.selectedCategories containsObject:self.categories[row]];
            cell.delegate = self;
            return cell;
        }
            
        default: {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
            return cell;
        }
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case FilterDistance:
            return @"Distance";
        case FilterSortMode:
            return @"Sort By";
        case FilterDealsOnly:
            return @"Offering Deals";
        case FilterCategories:
            return @"Categories";  // only restaurants for the moment
        default:
            return @"Categories";
    }
}

#pragma mark - UITableView Delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"selected");
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == FilterDistance) {
        NSIndexPath *oldPath = [NSIndexPath indexPathForRow:[self.selectedDistance unsignedIntegerValue] inSection:FilterDistance];
        UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:oldPath];
        
        oldCell.accessoryType = UITableViewCellAccessoryNone;
        
        self.selectedDistance = @(indexPath.row);
        UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
        newCell.accessoryType = UITableViewCellAccessoryCheckmark;
        
        NSLog(@"%@", self.selectedDistance);
    } else if (indexPath.section == FilterSortMode) {
        
        NSIndexPath *oldPath = [NSIndexPath indexPathForRow:[self.selectedSortMode unsignedIntegerValue] inSection:FilterSortMode];
        UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:oldPath];
        
        oldCell.accessoryType = UITableViewCellAccessoryNone;
        
        self.selectedSortMode = @(indexPath.row);
        UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
        newCell.accessoryType = UITableViewCellAccessoryCheckmark;
        
        //self.selectedSortMode = @(indexPath.row);
        NSLog(@"%@", self.selectedSortMode);
    }
    
}

#pragma mark - Switch Cell delegate methods

- (void) switchCell:(SwitchCell *)cell didUpdateValue:(BOOL)value {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    if (indexPath.section == FilterDealsOnly) {
        if (value) {
            self.dealsOnlySelected = YES;
        } else {
            self.dealsOnlySelected = NO;
        }
        
    } else if (indexPath.section == FilterCategories) {
        if (value) {
            [self.selectedCategories addObject:self.categories[indexPath.row]];
        } else {
            [self.selectedCategories removeObject:self.categories[indexPath.row]];
        }
    }
}

#pragma mark - private

- (NSDictionary *) filters {
    NSMutableDictionary *filters = [NSMutableDictionary dictionary];
    
    if (self.selectedCategories.count > 0) {
        NSMutableArray *names = [NSMutableArray array];
        for (NSDictionary *category in self.selectedCategories) {
            [names addObject:category[@"code"]];
        }
        
        NSString *categoryFilter = [names componentsJoinedByString:@","];
        [filters setObject:categoryFilter forKey:@"category_filter"];
    }
    
    if (self.dealsOnlySelected) {
        filters[@"deals_filter"] = @"1";
    }
    
    // distance
    NSUInteger distanceIndex = [self.selectedDistance unsignedIntegerValue];
    if (distanceIndex != 0) {
        filters[@"radius_filter"] = self.distances[distanceIndex][@"value"];
    }
    
    // sort mode
    NSUInteger sortModeIndex = [self.selectedSortMode unsignedIntegerValue];
    filters[@"sort"] = self.sortModes[sortModeIndex][@"value"];
    return filters;
    
}

- (void) initCategories {

    self.categories =
    @[
      @{@"name" : @"Afghan", @"code" : @"afghani"},
      @{@"name" : @"African", @"code" : @"african"},
      @{@"name" : @"Senegalese", @"code" : @"senegalese"},
      @{@"name" : @"South African", @"code" : @"southafrican"},
      @{@"name" : @"American, New", @"code" : @"newamerican"},
      @{@"name" : @"American, Traditional", @"code" : @"tradamerican"},
      @{@"name" : @"Arabian", @"code" : @"arabian"},
      @{@"name" : @"Argentine", @"code" : @"argentine"},
      @{@"name" : @"Armenian", @"code" : @"armenian"},
      @{@"name" : @"Asian Fusion", @"code" : @"asianfusion"},
      @{@"name" : @"Australian", @"code" : @"australian"},
      @{@"name" : @"Austrian", @"code" : @"austrian"},
      @{@"name" : @"Bangladeshi", @"code" : @"bangladeshi"},
      @{@"name" : @"Barbeque", @"code" : @"bbq"},
      @{@"name" : @"Basque", @"code" : @"basque"},
      @{@"name" : @"Belgian", @"code" : @"belgian"},
      @{@"name" : @"Brasseries", @"code" : @"brasseries"},
      @{@"name" : @"Brazilian", @"code" : @"brazilian"},
      @{@"name" : @"Breakfast & Brunch", @"code" : @"breakfast_brunch"},
      @{@"name" : @"British", @"code" : @"british"},
      @{@"name" : @"Buffets", @"code" : @"buffets"},
      @{@"name" : @"Burgers", @"code" : @"burgers"},
      @{@"name" : @"Burmese", @"code" : @"burmese"},
      @{@"name" : @"Cafes", @"code" : @"cafes"},
      @{@"name" : @"Cafeteria", @"code" : @"cafeteria"},
      @{@"name" : @"Cajun/Creole", @"code" : @"cajun"},
      @{@"name" : @"Cambodian", @"code" : @"cambodian"},
      @{@"name" : @"Caribbean", @"code" : @"caribbean"},
      @{@"name" : @"Dominican", @"code" : @"dominican"},
      @{@"name" : @"Haitian", @"code" : @"haitian"},
      @{@"name" : @"Puerto Rican", @"code" : @"puertorican"},
      @{@"name" : @"Trinidadian", @"code" : @"trinidadian"},
      @{@"name" : @"Catalan", @"code" : @"catalan"},
      @{@"name" : @"Cheesesteaks", @"code" : @"cheesesteaks"},
      @{@"name" : @"Chicken Shop", @"code" : @"chickenshop"},
      @{@"name" : @"Chicken Wings", @"code" : @"chicken_wings"},
      @{@"name" : @"Chinese", @"code" : @"chinese"},
      @{@"name" : @"Cantonese", @"code" : @"cantonese"},
      @{@"name" : @"Dim Sum", @"code" : @"dimsum"},
      @{@"name" : @"Shanghainese", @"code" : @"shanghainese"},
      @{@"name" : @"Szechuan", @"code" : @"szechuan"},
      @{@"name" : @"Comfort Food", @"code" : @"comfortfood"},
      @{@"name" : @"Corsican", @"code" : @"corsican"},
      @{@"name" : @"Creperies", @"code" : @"creperies"},
      @{@"name" : @"Cuban", @"code" : @"cuban"},
      @{@"name" : @"Czech", @"code" : @"czech"},
      @{@"name" : @"Delis", @"code" : @"delis"},
      @{@"name" : @"Diners", @"code" : @"diners"},
      @{@"name" : @"Fast Food", @"code" : @"hotdogs"},
      @{@"name" : @"Filipino", @"code" : @"filipino"},
      @{@"name" : @"Fish & Chips", @"code" : @"fishnchips"},
      @{@"name" : @"Fondue", @"code" : @"fondue"},
      @{@"name" : @"Food Court", @"code" : @"food_court"},
      @{@"name" : @"Food Stands", @"code" : @"foodstands"},
      @{@"name" : @"French", @"code" : @"french"},
      @{@"name" : @"Gastropubs", @"code" : @"gastropubs"},
      @{@"name" : @"German", @"code" : @"german"},
      @{@"name" : @"Gluten-Free", @"code" : @"gluten_free"},
      @{@"name" : @"Greek", @"code" : @"greek"},
      @{@"name" : @"Halal", @"code" : @"halal"},
      @{@"name" : @"Hawaiian", @"code" : @"hawaiian"},
      @{@"name" : @"Himalayan/Nepalese", @"code" : @"himalayan"},
      @{@"name" : @"Hong Kong Style Cafe", @"code" : @"hkcafe"},
      @{@"name" : @"Hot Dogs", @"code" : @"hotdog"},
      @{@"name" : @"Hot Pot", @"code" : @"hotpot"},
      @{@"name" : @"Hungarian", @"code" : @"hungarian"},
      @{@"name" : @"Iberian", @"code" : @"iberian"},
      @{@"name" : @"Indian", @"code" : @"indpak"},
      @{@"name" : @"Indonesian", @"code" : @"indonesian"},
      @{@"name" : @"Irish", @"code" : @"irish"},
      @{@"name" : @"Italian", @"code" : @"italian"},
      @{@"name" : @"Japanese", @"code" : @"japanese"},
      @{@"name" : @"Ramen", @"code" : @"ramen"},
      @{@"name" : @"Teppanyaki", @"code" : @"teppanyaki"},
      @{@"name" : @"Korean", @"code" : @"korean"},
      @{@"name" : @"Kosher", @"code" : @"kosher"},
      @{@"name" : @"Laotian", @"code" : @"laotian"},
      @{@"name" : @"Latin American", @"code" : @"latin"},
      @{@"name" : @"Colombian", @"code" : @"colombian"},
      @{@"name" : @"Salvadorean", @"code" : @"salvadorean"},
      @{@"name" : @"Venezuelan", @"code" : @"venezuelan"},
      @{@"name" : @"Live/Raw Food", @"code" : @"raw_food"},
      @{@"name" : @"Malaysian", @"code" : @"malaysian"},
      @{@"name" : @"Mediterranean", @"code" : @"mediterranean"},
      @{@"name" : @"Falafel", @"code" : @"falafel"},
      @{@"name" : @"Mexican", @"code" : @"mexican"},
      @{@"name" : @"Middle Eastern", @"code" : @"mideastern"},
      @{@"name" : @"Egyptian", @"code" : @"egyptian"},
      @{@"name" : @"Lebanese", @"code" : @"lebanese"},
      @{@"name" : @"Modern European", @"code" : @"modern_european"},
      @{@"name" : @"Mongolian", @"code" : @"mongolian"},
      @{@"name" : @"Moroccan", @"code" : @"moroccan"},
      @{@"name" : @"Pakistani", @"code" : @"pakistani"},
      @{@"name" : @"Persian/Iranian", @"code" : @"persian"},
      @{@"name" : @"Peruvian", @"code" : @"peruvian"},
      @{@"name" : @"Pizza", @"code" : @"pizza"},
      @{@"name" : @"Polish", @"code" : @"polish"},
      @{@"name" : @"Portuguese", @"code" : @"portuguese"},
      @{@"name" : @"Poutineries", @"code" : @"poutineries"},
      @{@"name" : @"Russian", @"code" : @"russian"},
      @{@"name" : @"Salad", @"code" : @"salad"},
      @{@"name" : @"Sandwiches", @"code" : @"sandwiches"},
      @{@"name" : @"Scandinavian", @"code" : @"scandinavian"},
      @{@"name" : @"Scottish", @"code" : @"scottish"},
      @{@"name" : @"Seafood", @"code" : @"seafood"},
      @{@"name" : @"Singaporean", @"code" : @"singaporean"},
      @{@"name" : @"Slovakian", @"code" : @"slovakian"},
      @{@"name" : @"Soul Food", @"code" : @"soulfood"},
      @{@"name" : @"Soup", @"code" : @"soup"},
      @{@"name" : @"Southern", @"code" : @"southern"},
      @{@"name" : @"Spanish", @"code" : @"spanish"},
      @{@"name" : @"Sri Lankan", @"code" : @"srilankan"},
      @{@"name" : @"Steakhouses", @"code" : @"steak"},
      @{@"name" : @"Sushi Bars", @"code" : @"sushi"},
      @{@"name" : @"Taiwanese", @"code" : @"taiwanese"},
      @{@"name" : @"Tapas Bars", @"code" : @"tapas"},
      @{@"name" : @"Tapas/Small Plates", @"code" : @"tapasmallplates"},
      @{@"name" : @"Tex-Mex", @"code" : @"tex-mex"},
      @{@"name" : @"Thai", @"code" : @"thai"},
      @{@"name" : @"Turkish", @"code" : @"turkish"},
      @{@"name" : @"Ukrainian", @"code" : @"ukrainian"},
      @{@"name" : @"Uzbek", @"code" : @"uzbek"},
      @{@"name" : @"Vegan", @"code" : @"vegan"},
      @{@"name" : @"Vegetarian", @"code" : @"vegetarian"},
      @{@"name" : @"Vietnamese", @"code" : @"vietnamese"}
      ];
}

- (void)initSortModes {
    self.sortModes =
    @[
      @{@"name" : @"Best Match", @"value" : @0},
      @{@"name" : @"Closest", @"value" : @1},
      @{@"name" : @"Highest rated", @"value" : @2}
      ];
    
}


- (void)initDistances {
    self.distances =
    @[
      @{@"name" : @"Auto", @"value" : @0},
      @{@"name" : @"100 m", @"value" : @100},
      @{@"name" : @"1 km", @"value" : @1000},
      @{@"name" : @"5 kms", @"value" : @5000},
      @{@"name" : @"10 kms", @"value" : @10000},
      ];
}

#pragma mark - button methods

- (void) onCancel {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) onApply {
    [self.delegate filtersViewController:self didChangeFilters:self.filters];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
