#import "VideoOptionsController.h"

@interface VideoOptionsController ()
@end

@implementation VideoOptionsController

- (void)loadView {
	[super loadView];

    self.title = @"Video Options";
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
    return 9;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"VideoTableViewCell";
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
            cell.textLabel.text = @"Enable No Ads (Video/HomeScreen)";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UISwitch *enableNoVideoAds = [[UISwitch alloc] initWithFrame:CGRectMake(199, 8, 0, 0)];
            [enableNoVideoAds addTarget:self action:@selector(toggleEnableNoVideoAds:) forControlEvents:UIControlEventValueChanged];
            enableNoVideoAds.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"kEnableNoVideoAds"];
            cell.accessoryView = enableNoVideoAds;
        }
        if(indexPath.row == 1) {
            cell.textLabel.text = @"Enable Background Playback";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UISwitch *enableBackgroundPlayback = [[UISwitch alloc] initWithFrame:CGRectMake(199, 8, 0, 0)];
            [enableBackgroundPlayback addTarget:self action:@selector(toggleEnableBackgroundPlayback:) forControlEvents:UIControlEventValueChanged];
            enableBackgroundPlayback.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"kEnableBackgroundPlayback"];
            cell.accessoryView = enableBackgroundPlayback;
        }
        if(indexPath.row == 2) {
            cell.textLabel.text = @"Allow HD On Cellular Data";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UISwitch *allowHDOnCellularData = [[UISwitch alloc] initWithFrame:CGRectMake(199, 8, 0, 0)];
            [allowHDOnCellularData addTarget:self action:@selector(toggleAllowHDOnCellularData:) forControlEvents:UIControlEventValueChanged];
            allowHDOnCellularData.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"kAllowHDOnCellularData"];
            cell.accessoryView = allowHDOnCellularData;
        }
        if(indexPath.row == 3) {
            cell.textLabel.text = @"Disable Video Endscreen Popups";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UISwitch *disableVideoEndscreenPopups = [[UISwitch alloc] initWithFrame:CGRectMake(199, 8, 0, 0)];
            [disableVideoEndscreenPopups addTarget:self action:@selector(toggleDisableVideoEndscreenPopups:) forControlEvents:UIControlEventValueChanged];
            disableVideoEndscreenPopups.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"kDisableVideoEndscreenPopups"];
            cell.accessoryView = disableVideoEndscreenPopups;
        }
        if(indexPath.row == 4) {
            cell.textLabel.text = @"Disable Video Info Cards";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UISwitch *disableVideoInfoCards = [[UISwitch alloc] initWithFrame:CGRectMake(199, 8, 0, 0)];
            [disableVideoInfoCards addTarget:self action:@selector(toggleDisableVideoInfoCards:) forControlEvents:UIControlEventValueChanged];
            disableVideoInfoCards.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"kDisableVideoInfoCards"];
            cell.accessoryView = disableVideoInfoCards;
        }
        if(indexPath.row == 5) {
            cell.textLabel.text = @"Disable Video AutoPlay";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UISwitch *disableVideoAutoPlay = [[UISwitch alloc] initWithFrame:CGRectMake(199, 8, 0, 0)];
            [disableVideoAutoPlay addTarget:self action:@selector(toggleDisableVideoAutoPlay:) forControlEvents:UIControlEventValueChanged];
            disableVideoAutoPlay.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"kDisableVideoAutoPlay"];
            cell.accessoryView = disableVideoAutoPlay;
        }
        if(indexPath.row == 6) {
            cell.textLabel.text = @"Disable Double Tap To Skip";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UISwitch *disableDoubleTapToSkip = [[UISwitch alloc] initWithFrame:CGRectMake(199, 8, 0, 0)];
            [disableDoubleTapToSkip addTarget:self action:@selector(toggleDisableDoubleTapToSkip:) forControlEvents:UIControlEventValueChanged];
            disableDoubleTapToSkip.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"kDisableDoubleTapToSkip"];
            cell.accessoryView = disableDoubleTapToSkip;
        }
        if(indexPath.row == 7) {
            cell.textLabel.text = @"Hide Channel Watermark";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UISwitch *hideChannelWatermark = [[UISwitch alloc] initWithFrame:CGRectMake(199, 8, 0, 0)];
            [hideChannelWatermark addTarget:self action:@selector(toggleHideChannelWatermark:) forControlEvents:UIControlEventValueChanged];
            hideChannelWatermark.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"kHideChannelWatermark"];
            cell.accessoryView = hideChannelWatermark;
        }
        if(indexPath.row == 8) {
            cell.textLabel.text = @"Always Show Player Bar";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UISwitch *alwaysShowPlayerBar = [[UISwitch alloc] initWithFrame:CGRectMake(199, 8, 0, 0)];
            [alwaysShowPlayerBar addTarget:self action:@selector(toggleAlwaysShowPlayerBar:) forControlEvents:UIControlEventValueChanged];
            alwaysShowPlayerBar.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"kAlwaysShowPlayerBar"];
            cell.accessoryView = alwaysShowPlayerBar;
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

@implementation VideoOptionsController(Privates)

- (void)done {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)toggleEnableNoVideoAds:(UISwitch *)sender {
    if ([sender isOn]) {
        NSLog(@"On");
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"kEnableNoVideoAds"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        NSLog(@"Off");
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"kEnableNoVideoAds"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)toggleEnableBackgroundPlayback:(UISwitch *)sender {
    if ([sender isOn]) {
        NSLog(@"On");
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"kEnableBackgroundPlayback"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        NSLog(@"Off");
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"kEnableBackgroundPlayback"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)toggleAllowHDOnCellularData:(UISwitch *)sender {
    if ([sender isOn]) {
        NSLog(@"On");
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"kAllowHDOnCellularData"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        NSLog(@"Off");
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"kAllowHDOnCellularData"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)toggleDisableVideoEndscreenPopups:(UISwitch *)sender {
    if ([sender isOn]) {
        NSLog(@"On");
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"kDisableVideoEndscreenPopups"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        NSLog(@"Off");
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"kDisableVideoEndscreenPopups"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)toggleDisableVideoInfoCards:(UISwitch *)sender {
    if ([sender isOn]) {
        NSLog(@"On");
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"kDisableVideoInfoCards"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        NSLog(@"Off");
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"kDisableVideoInfoCards"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)toggleDisableVideoAutoPlay:(UISwitch *)sender {
    if ([sender isOn]) {
        NSLog(@"On");
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"kDisableVideoAutoPlay"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        NSLog(@"Off");
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"kDisableVideoAutoPlay"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)toggleDisableDoubleTapToSkip:(UISwitch *)sender {
    if ([sender isOn]) {
        NSLog(@"On");
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"kDisableDoubleTapToSkip"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        NSLog(@"Off");
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"kDisableDoubleTapToSkip"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)toggleHideChannelWatermark:(UISwitch *)sender {
    if ([sender isOn]) {
        NSLog(@"On");
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"kHideChannelWatermark"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        NSLog(@"Off");
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"kHideChannelWatermark"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)toggleAlwaysShowPlayerBar:(UISwitch *)sender {
    if ([sender isOn]) {
        NSLog(@"On");
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"kAlwaysShowPlayerBar"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        NSLog(@"Off");
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"kAlwaysShowPlayerBar"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

@end