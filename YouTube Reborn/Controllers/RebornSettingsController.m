#import "RebornSettingsController.h"

@interface RebornSettingsController ()
@end

@implementation RebornSettingsController

- (void)loadView {
	[super loadView];

    self.title = @"Reborn Options";
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
    return 3;
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
            cell.textLabel.text = @"Hide Overlay 'DWN' Button";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UISwitch *hideRebornDWNButton = [[UISwitch alloc] initWithFrame:CGRectMake(199, 8, 0, 0)];
            [hideRebornDWNButton addTarget:self action:@selector(toggleHideRebornDWNButton:) forControlEvents:UIControlEventValueChanged];
            hideRebornDWNButton.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"kHideRebornDWNButton"];
            cell.accessoryView = hideRebornDWNButton;
        }
        if(indexPath.row == 1) {
            cell.textLabel.text = @"Hide Overlay 'PIP' Button";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UISwitch *hideRebornPIPButton = [[UISwitch alloc] initWithFrame:CGRectMake(199, 8, 0, 0)];
            [hideRebornPIPButton addTarget:self action:@selector(toggleHideRebornPIPButton:) forControlEvents:UIControlEventValueChanged];
            hideRebornPIPButton.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"kHideRebornPIPButton"];
            cell.accessoryView = hideRebornPIPButton;
        }
        if(indexPath.row == 2) {
            cell.textLabel.text = @"Hide Overlay 'OP' Button";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UISwitch *hideRebornOPButton = [[UISwitch alloc] initWithFrame:CGRectMake(199, 8, 0, 0)];
            [hideRebornOPButton addTarget:self action:@selector(toggleHideRebornOPButton:) forControlEvents:UIControlEventValueChanged];
            hideRebornOPButton.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"kHideRebornOPButton"];
            cell.accessoryView = hideRebornOPButton;
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

@implementation RebornSettingsController(Privates)

- (void)done {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)toggleHideRebornDWNButton:(UISwitch *)sender {
    if ([sender isOn]) {
        NSLog(@"On");
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"kHideRebornDWNButton"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        NSLog(@"Off");
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"kHideRebornDWNButton"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)toggleHideRebornPIPButton:(UISwitch *)sender {
    if ([sender isOn]) {
        NSLog(@"On");
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"kHideRebornPIPButton"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        NSLog(@"Off");
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"kHideRebornPIPButton"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)toggleHideRebornOPButton:(UISwitch *)sender {
    if ([sender isOn]) {
        NSLog(@"On");
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"kHideRebornOPButton"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        NSLog(@"Off");
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"kHideRebornOPButton"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

@end