#import "ShortsOptionsController.h"

@interface ShortsOptionsController ()
@end

@implementation ShortsOptionsController

- (void)loadView {
	[super loadView];

    self.title = @"Shorts Options";
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
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"ShortsTableViewCell";
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
            cell.textLabel.text = @"Hide Camera Buton";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UISwitch *hideShortsCameraButton = [[UISwitch alloc] initWithFrame:CGRectMake(199, 8, 0, 0)];
            [hideShortsCameraButton addTarget:self action:@selector(toggleHideShortsCameraButton:) forControlEvents:UIControlEventValueChanged];
            hideShortsCameraButton.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"kHideShortsCameraButton"];
            cell.accessoryView = hideShortsCameraButton;
        }
        if(indexPath.row == 1) {
            cell.textLabel.text = @"Hide More Actions Button";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UISwitch *hideShortsMoreActionsButton = [[UISwitch alloc] initWithFrame:CGRectMake(199, 8, 0, 0)];
            [hideShortsMoreActionsButton addTarget:self action:@selector(toggleHideShortsMoreActionsButton:) forControlEvents:UIControlEventValueChanged];
            hideShortsMoreActionsButton.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"kHideShortsMoreActionsButton"];
            cell.accessoryView = hideShortsMoreActionsButton;
        }
        if(indexPath.row == 2) {
            cell.textLabel.text = @"Hide Like Button";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UISwitch *hideShortsLikeButton = [[UISwitch alloc] initWithFrame:CGRectMake(199, 8, 0, 0)];
            [hideShortsLikeButton addTarget:self action:@selector(toggleHideShortsLikeButton:) forControlEvents:UIControlEventValueChanged];
            hideShortsLikeButton.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"kHideShortsLikeButton"];
            cell.accessoryView = hideShortsLikeButton;
        }
        if(indexPath.row == 3) {
            cell.textLabel.text = @"Hide Dislike Button";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UISwitch *hideShortsDislikeButton = [[UISwitch alloc] initWithFrame:CGRectMake(199, 8, 0, 0)];
            [hideShortsDislikeButton addTarget:self action:@selector(toggleHideShortsDislikeButton:) forControlEvents:UIControlEventValueChanged];
            hideShortsDislikeButton.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"kHideShortsDislikeButton"];
            cell.accessoryView = hideShortsDislikeButton;
        }
        if(indexPath.row == 4) {
            cell.textLabel.text = @"Hide Comments Button";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UISwitch *hideShortsCommentsButton = [[UISwitch alloc] initWithFrame:CGRectMake(199, 8, 0, 0)];
            [hideShortsCommentsButton addTarget:self action:@selector(toggleHideShortsCommentsButton:) forControlEvents:UIControlEventValueChanged];
            hideShortsCommentsButton.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"kHideShortsCommentsButton"];
            cell.accessoryView = hideShortsCommentsButton;
        }
        if(indexPath.row == 5) {
            cell.textLabel.text = @"Hide Share Button";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UISwitch *hideShortsShareButton = [[UISwitch alloc] initWithFrame:CGRectMake(199, 8, 0, 0)];
            [hideShortsShareButton addTarget:self action:@selector(toggleHideShortsShareButton:) forControlEvents:UIControlEventValueChanged];
            hideShortsShareButton.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"kHideShortsShareButton"];
            cell.accessoryView = hideShortsShareButton;
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

@implementation ShortsOptionsController(Privates)

- (void)done {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)toggleHideShortsCameraButton:(UISwitch *)sender {
    if ([sender isOn]) {
        NSLog(@"On");
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"kHideShortsCameraButton"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        NSLog(@"Off");
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"kHideShortsCameraButton"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)toggleHideShortsMoreActionsButton:(UISwitch *)sender {
    if ([sender isOn]) {
        NSLog(@"On");
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"kHideShortsMoreActionsButton"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        NSLog(@"Off");
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"kHideShortsMoreActionsButton"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)toggleHideShortsLikeButton:(UISwitch *)sender {
    if ([sender isOn]) {
        NSLog(@"On");
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"kHideShortsLikeButton"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        NSLog(@"Off");
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"kHideShortsLikeButton"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)toggleHideShortsDislikeButton:(UISwitch *)sender {
    if ([sender isOn]) {
        NSLog(@"On");
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"kHideShortsDislikeButton"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        NSLog(@"Off");
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"kHideShortsDislikeButton"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)toggleHideShortsCommentsButton:(UISwitch *)sender {
    if ([sender isOn]) {
        NSLog(@"On");
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"kHideShortsCommentsButton"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        NSLog(@"Off");
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"kHideShortsCommentsButton"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)toggleHideShortsShareButton:(UISwitch *)sender {
    if ([sender isOn]) {
        NSLog(@"On");
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"kHideShortsShareButton"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        NSLog(@"Off");
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"kHideShortsShareButton"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

@end