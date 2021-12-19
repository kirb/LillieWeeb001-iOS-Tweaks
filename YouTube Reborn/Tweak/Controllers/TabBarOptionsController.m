#import "TabBarOptionsController.h"

@interface TabBarOptionsController ()
@end

@implementation TabBarOptionsController

- (void)loadView {
	[super loadView];

    self.title = @"TabBar Options";
    if (self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleLight) {
        self.view.backgroundColor = [UIColor colorWithRed:0.949 green:0.949 blue:0.969 alpha:1.0];
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    }
    else {
        self.view.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
        self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)theTableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)theTableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"TabBarTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
        cell.textLabel.adjustsFontSizeToFitWidth = true;
        if (self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleLight) {
            cell.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
            cell.textLabel.textColor = [UIColor blackColor];
        }
        else {
            cell.backgroundColor = [UIColor colorWithRed:0.110 green:0.110 blue:0.118 alpha:1.0];
            cell.textLabel.textColor = [UIColor whiteColor];
        }
        if(indexPath.row == 0) {
            cell.textLabel.text = @"Hide Tab Bar Labels";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UISwitch *hideTabBarLabels = [[UISwitch alloc] initWithFrame:CGRectZero];
            [hideTabBarLabels addTarget:self action:@selector(toggleHideTabBarLabels:) forControlEvents:UIControlEventValueChanged];
            hideTabBarLabels.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"kHideTabBarLabels"];
            cell.accessoryView = hideTabBarLabels;
        }
        if(indexPath.row == 1) {
            cell.textLabel.text = @"Hide Shorts (Explore) Tab";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UISwitch *hideExploreTab = [[UISwitch alloc] initWithFrame:CGRectZero];
            [hideExploreTab addTarget:self action:@selector(toggleHideExploreTab:) forControlEvents:UIControlEventValueChanged];
            hideExploreTab.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"kHideExploreTab"];
            cell.accessoryView = hideExploreTab;
        }
        if(indexPath.row == 2) {
            cell.textLabel.text = @"Hide Create/Upload (+) Tab";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UISwitch *hideUploadTab = [[UISwitch alloc] initWithFrame:CGRectZero];
            [hideUploadTab addTarget:self action:@selector(toggleHideUploadTab:) forControlEvents:UIControlEventValueChanged];
            hideUploadTab.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"kHideUploadTab"];
            cell.accessoryView = hideUploadTab;
        }
        if(indexPath.row == 3) {
            cell.textLabel.text = @"Hide Subscriptions Tab";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UISwitch *hideSubscriptionsTab = [[UISwitch alloc] initWithFrame:CGRectZero];
            [hideSubscriptionsTab addTarget:self action:@selector(toggleHideSubscriptionsTab:) forControlEvents:UIControlEventValueChanged];
            hideSubscriptionsTab.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"kHideSubscriptionsTab"];
            cell.accessoryView = hideSubscriptionsTab;
        }
        if(indexPath.row == 4) {
            cell.textLabel.text = @"Hide Library Tab";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UISwitch *hideLibraryTab = [[UISwitch alloc] initWithFrame:CGRectZero];
            [hideLibraryTab addTarget:self action:@selector(toggleHideLibraryTab:) forControlEvents:UIControlEventValueChanged];
            hideLibraryTab.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"kHideLibraryTab"];
            cell.accessoryView = hideLibraryTab;
        }
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {        
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

@end

@implementation TabBarOptionsController(Privates)

- (void)done {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)toggleHideTabBarLabels:(UISwitch *)sender {
    if ([sender isOn]) {
        NSLog(@"On");
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"kHideTabBarLabels"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        NSLog(@"Off");
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"kHideTabBarLabels"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)toggleHideExploreTab:(UISwitch *)sender {
    if ([sender isOn]) {
        NSLog(@"On");
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"kHideExploreTab"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        NSLog(@"Off");
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"kHideExploreTab"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)toggleHideUploadTab:(UISwitch *)sender {
    if ([sender isOn]) {
        NSLog(@"On");
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"kHideUploadTab"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        NSLog(@"Off");
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"kHideUploadTab"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)toggleHideSubscriptionsTab:(UISwitch *)sender {
    if ([sender isOn]) {
        NSLog(@"On");
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"kHideSubscriptionsTab"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        NSLog(@"Off");
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"kHideSubscriptionsTab"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)toggleHideLibraryTab:(UISwitch *)sender {
    if ([sender isOn]) {
        NSLog(@"On");
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"kHideLibraryTab"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        NSLog(@"Off");
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"kHideLibraryTab"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

@end