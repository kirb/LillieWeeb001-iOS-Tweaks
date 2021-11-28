#import "OverlayOptionsController.h"

@interface OverlayOptionsController ()
@end

@implementation OverlayOptionsController

- (void)loadView {
	[super loadView];

    self.title = @"Overlay Options";
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
    static NSString *CellIdentifier = @"OverlayTableViewCell";
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
            cell.textLabel.text = @"Show Status Bar In Overlay (Portrait Only)";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UISwitch *showStatusBarInOverlay = [[UISwitch alloc] initWithFrame:CGRectMake(199, 8, 0, 0)];
            [showStatusBarInOverlay addTarget:self action:@selector(toggleShowStatusBarInOverlay:) forControlEvents:UIControlEventValueChanged];
            showStatusBarInOverlay.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"kShowStatusBarInOverlay"];
            cell.accessoryView = showStatusBarInOverlay;
        }
        if(indexPath.row == 1) {
            cell.textLabel.text = @"Hide Previous & Next Button In Overlay";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UISwitch *hidePreviousAndNextButtonInOverlay = [[UISwitch alloc] initWithFrame:CGRectMake(199, 8, 0, 0)];
            [hidePreviousAndNextButtonInOverlay addTarget:self action:@selector(toggleHidePreviousAndNextButtonInOverlay:) forControlEvents:UIControlEventValueChanged];
            hidePreviousAndNextButtonInOverlay.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"kHidePreviousAndNextButtonInOverlay"];
            cell.accessoryView = hidePreviousAndNextButtonInOverlay;
        }
        if(indexPath.row == 2) {
            cell.textLabel.text = @"Hide AutoPlay Switch In Overlay";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UISwitch *hideAutoPlaySwitchInOverlay = [[UISwitch alloc] initWithFrame:CGRectMake(199, 8, 0, 0)];
            [hideAutoPlaySwitchInOverlay addTarget:self action:@selector(toggleHideAutoPlaySwitchInOverlay:) forControlEvents:UIControlEventValueChanged];
            hideAutoPlaySwitchInOverlay.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"kHideAutoPlaySwitchInOverlay"];
            cell.accessoryView = hideAutoPlaySwitchInOverlay;
        }
        if(indexPath.row == 3) {
            cell.textLabel.text = @"Hide Captions/Subtitles Button In Overlay";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UISwitch *hideCaptionsSubtitlesButtonInOverlay = [[UISwitch alloc] initWithFrame:CGRectMake(199, 8, 0, 0)];
            [hideCaptionsSubtitlesButtonInOverlay addTarget:self action:@selector(toggleHideCaptionsSubtitlesButtonInOverlay:) forControlEvents:UIControlEventValueChanged];
            hideCaptionsSubtitlesButtonInOverlay.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"kHideCaptionsSubtitlesButtonInOverlay"];
            cell.accessoryView = hideCaptionsSubtitlesButtonInOverlay;
        }
        if(indexPath.row == 4) {
            cell.textLabel.text = @"Disable Related Videos In Overlay";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UISwitch *disableRelatedVideosInOverlay = [[UISwitch alloc] initWithFrame:CGRectMake(199, 8, 0, 0)];
            [disableRelatedVideosInOverlay addTarget:self action:@selector(toggleDisableRelatedVideosInOverlay:) forControlEvents:UIControlEventValueChanged];
            disableRelatedVideosInOverlay.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"kDisableRelatedVideosInOverlay"];
            cell.accessoryView = disableRelatedVideosInOverlay;
        }
        if(indexPath.row == 5) {
            cell.textLabel.text = @"Hide Overlay Dark Background";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UISwitch *hideOverlayDarkBackground = [[UISwitch alloc] initWithFrame:CGRectMake(199, 8, 0, 0)];
            [hideOverlayDarkBackground addTarget:self action:@selector(toggleHideOverlayDarkBackground:) forControlEvents:UIControlEventValueChanged];
            hideOverlayDarkBackground.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"kHideOverlayDarkBackground"];
            cell.accessoryView = hideOverlayDarkBackground;
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

@implementation OverlayOptionsController(Privates)

- (void)done {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)toggleShowStatusBarInOverlay:(UISwitch *)sender {
    if ([sender isOn]) {
        NSLog(@"On");
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"kShowStatusBarInOverlay"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        NSLog(@"Off");
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"kShowStatusBarInOverlay"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)toggleHidePreviousAndNextButtonInOverlay:(UISwitch *)sender {
    if ([sender isOn]) {
        NSLog(@"On");
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"kHidePreviousAndNextButtonInOverlay"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        NSLog(@"Off");
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"kHidePreviousAndNextButtonInOverlay"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)toggleHideAutoPlaySwitchInOverlay:(UISwitch *)sender {
    if ([sender isOn]) {
        NSLog(@"On");
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"kHideAutoPlaySwitchInOverlay"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        NSLog(@"Off");
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"kHideAutoPlaySwitchInOverlay"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)toggleHideCaptionsSubtitlesButtonInOverlay:(UISwitch *)sender {
    if ([sender isOn]) {
        NSLog(@"On");
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"kHideCaptionsSubtitlesButtonInOverlay"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        NSLog(@"Off");
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"kHideCaptionsSubtitlesButtonInOverlay"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)toggleDisableRelatedVideosInOverlay:(UISwitch *)sender {
    if ([sender isOn]) {
        NSLog(@"On");
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"kDisableRelatedVideosInOverlay"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        NSLog(@"Off");
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"kDisableRelatedVideosInOverlay"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)toggleHideOverlayDarkBackground:(UISwitch *)sender {
    if ([sender isOn]) {
        NSLog(@"On");
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"kHideOverlayDarkBackground"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        NSLog(@"Off");
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"kHideOverlayDarkBackground"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

@end