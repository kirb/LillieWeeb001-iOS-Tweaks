#import "UnderVideoOptionsController.h"

@interface UnderVideoOptionsController ()
@end

@implementation UnderVideoOptionsController

- (void)loadView {
	[super loadView];

    self.title = @"Under-Video Options";
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
    static NSString *CellIdentifier = @"UnderVideoTableViewCell";
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
            cell.textLabel.text = @"Hide Like Button";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UISwitch *noLikeButton = [[UISwitch alloc] initWithFrame:CGRectZero];
            [noLikeButton addTarget:self action:@selector(toggleNoLikeButton:) forControlEvents:UIControlEventValueChanged];
            noLikeButton.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"kNoLikeButton"];
            cell.accessoryView = noLikeButton;
            cell.userInteractionEnabled = NO;
            cell.textLabel.enabled = NO;
            cell.detailTextLabel.enabled = NO;
        }
        if(indexPath.row == 1) {
            cell.textLabel.text = @"Hide Dislike Button";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UISwitch *noDislikeButton = [[UISwitch alloc] initWithFrame:CGRectZero];
            [noDislikeButton addTarget:self action:@selector(toggleNoDislikeButton:) forControlEvents:UIControlEventValueChanged];
            noDislikeButton.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"kNoDislikeButton"];
            cell.accessoryView = noDislikeButton;
        }
        if(indexPath.row == 2) {
            cell.textLabel.text = @"Hide Download Button";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UISwitch *noDownloadButton = [[UISwitch alloc] initWithFrame:CGRectZero];
            [noDownloadButton addTarget:self action:@selector(toggleNoDownloadButton:) forControlEvents:UIControlEventValueChanged];
            noDownloadButton.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"kNoDownloadButton"];
            cell.accessoryView = noDownloadButton;
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

@implementation UnderVideoOptionsController(Privates)

- (void)done {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)toggleNoLikeButton:(UISwitch *)sender {
    if ([sender isOn]) {
        NSLog(@"On");
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"kNoLikeButton"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        NSLog(@"Off");
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"kNoLikeButton"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)toggleNoDislikeButton:(UISwitch *)sender {
    if ([sender isOn]) {
        NSLog(@"On");
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"kNoDislikeButton"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        NSLog(@"Off");
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"kNoDislikeButton"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)toggleNoDownloadButton:(UISwitch *)sender {
    if ([sender isOn]) {
        NSLog(@"On");
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"kNoDownloadButton"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        NSLog(@"Off");
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"kNoDownloadButton"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

@end