#import "RootOptionsController.h"
#import "VideoOptionsController.h"
#import "OverlayOptionsController.h"
#import "TabBarOptionsController.h"
#import "DownloadsController.h"
#import "CreditsController.h"
#import "ColourOptionsController.h"
#import "ShortsOptionsController.h"
#import "RebornSettingsController.h"

@interface RootOptionsController ()
@end

@implementation RootOptionsController

UIWindow *alertWindowOutDownloads;
UIWindow *alertWindowOutVideo;
UIWindow *alertWindowOutOverlay;
UIWindow *alertWindowOutTabBar;
UIWindow *alertWindowOutColour;
UIWindow *alertWindowOutShorts;
UIWindow *alertWindowOutCredits;
UIWindow *alertWindowOutRebornSettings;

- (void)loadView {
	[super loadView];

    self.title = @"Options";
    if (self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleLight) {
        self.view.backgroundColor = [UIColor colorWithRed:0.949 green:0.949 blue:0.969 alpha:1.0];
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    }
    else {
        self.view.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
        self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    }
    
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done)];
    self.navigationItem.leftBarButtonItem = doneButton;

    UIBarButtonItem* applyButton = [[UIBarButtonItem alloc] initWithTitle:@"Apply" style:UIBarButtonItemStylePlain target:self action:@selector(apply)];
    self.navigationItem.rightBarButtonItem = applyButton;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)theTableView {
    return 5;
}

- (NSInteger)tableView:(UITableView *)theTableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    if (section == 1) {
        return 2;
    }
    if (section == 2) {
        return 5;
    }
    if (section == 3) {
        return 11;
    }
    if (section == 4) {
        return 2;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"RootTableViewCell";
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
        if(indexPath.section == 0) {
            if(indexPath.row == 0) {
                cell.textLabel.text = @"Donate";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
        }
        if(indexPath.section == 1) {
            if(indexPath.row == 0) {
                cell.textLabel.text = @"View Downloads";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            if(indexPath.row == 1) {
                cell.textLabel.text = @"View Downloads In Filza";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
        }
        if(indexPath.section == 2) {
            if(indexPath.row == 0) {
                cell.textLabel.text = @"Video Options";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            if(indexPath.row == 1) {
                cell.textLabel.text = @"Overlay Options";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            if(indexPath.row == 2) {
                cell.textLabel.text = @"Tab Bar Options";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            if(indexPath.row == 3) {
                cell.textLabel.text = @"Colour Options";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            if(indexPath.row == 4) {
                cell.textLabel.text = @"Shorts Options";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
        }
        if(indexPath.section == 3) {
            if(indexPath.row == 0) {
                cell.textLabel.text = @"Enable iPad Style On iPhone";
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                UISwitch *enableiPadStyleOniPhone = [[UISwitch alloc] initWithFrame:CGRectMake(199, 8, 0, 0)];
                [enableiPadStyleOniPhone addTarget:self action:@selector(toggleEnableiPadStyleOniPhone:) forControlEvents:UIControlEventValueChanged];
                enableiPadStyleOniPhone.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"kEnableiPadStyleOniPhone"];
                cell.accessoryView = enableiPadStyleOniPhone;
            }
            if(indexPath.row == 1) {
                cell.textLabel.text = @"Unlock UHD Quality";
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                UISwitch *unlockUHDQuality = [[UISwitch alloc] initWithFrame:CGRectMake(199, 8, 0, 0)];
                [unlockUHDQuality addTarget:self action:@selector(toggleUnlockUHDQuality:) forControlEvents:UIControlEventValueChanged];
                unlockUHDQuality.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"kUnlockUHDQuality"];
                cell.accessoryView = unlockUHDQuality;
            }
            if(indexPath.row == 2) {
                cell.textLabel.text = @"No Download Button";
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                UISwitch *noDownloadButton = [[UISwitch alloc] initWithFrame:CGRectMake(199, 8, 0, 0)];
                [noDownloadButton addTarget:self action:@selector(toggleNoDownloadButton:) forControlEvents:UIControlEventValueChanged];
                noDownloadButton.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"kNoDownloadButton"];
                cell.accessoryView = noDownloadButton;
            }
            if(indexPath.row == 3) {
                cell.textLabel.text = @"No Comments Section";
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                UISwitch *noCommentsSection = [[UISwitch alloc] initWithFrame:CGRectMake(199, 8, 0, 0)];
                [noCommentsSection addTarget:self action:@selector(toggleNoCommentsSection:) forControlEvents:UIControlEventValueChanged];
                noCommentsSection.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"kNoCommentsSection"];
                cell.accessoryView = noCommentsSection;
            }
            if(indexPath.row == 4) {
                cell.textLabel.text = @"No Cast Button";
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                UISwitch *noCastButton = [[UISwitch alloc] initWithFrame:CGRectMake(199, 8, 0, 0)];
                [noCastButton addTarget:self action:@selector(toggleNoCastButton:) forControlEvents:UIControlEventValueChanged];
                noCastButton.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"kNoCastButton"];
                cell.accessoryView = noCastButton;
            }
            if(indexPath.row == 5) {
                cell.textLabel.text = @"No Notification Button";
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                UISwitch *noNotificationButton = [[UISwitch alloc] initWithFrame:CGRectMake(199, 8, 0, 0)];
                [noNotificationButton addTarget:self action:@selector(toggleNoNotificationButton:) forControlEvents:UIControlEventValueChanged];
                noNotificationButton.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"kNoNotificationButton"];
                cell.accessoryView = noNotificationButton;
            }
            if(indexPath.row == 6) {
                cell.textLabel.text = @"No Search Button";
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                UISwitch *noSearchButton = [[UISwitch alloc] initWithFrame:CGRectMake(199, 8, 0, 0)];
                [noSearchButton addTarget:self action:@selector(toggleNoSearchButton:) forControlEvents:UIControlEventValueChanged];
                noSearchButton.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"kNoSearchButton"];
                cell.accessoryView = noSearchButton;
            }
            if(indexPath.row == 7) {
                cell.textLabel.text = @"No Topics Section";
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                UISwitch *noTopicsSection = [[UISwitch alloc] initWithFrame:CGRectMake(199, 8, 0, 0)];
                [noTopicsSection addTarget:self action:@selector(toggleNoTopicsSection:) forControlEvents:UIControlEventValueChanged];
                noTopicsSection.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"kNoTopicsSection"];
                cell.accessoryView = noTopicsSection;
            }
            if(indexPath.row == 8) {
                cell.textLabel.text = @"Disable YouTube Kids";
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                UISwitch *disableYouTubeKidsPopup = [[UISwitch alloc] initWithFrame:CGRectMake(199, 8, 0, 0)];
                [disableYouTubeKidsPopup addTarget:self action:@selector(toggleDisableYouTubeKidsPopup:) forControlEvents:UIControlEventValueChanged];
                disableYouTubeKidsPopup.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"kDisableYouTubeKidsPopup"];
                cell.accessoryView = disableYouTubeKidsPopup;
            }
            if(indexPath.row == 9) {
                cell.textLabel.text = @"Disable Voice Search";
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                UISwitch *disableVoiceSearch = [[UISwitch alloc] initWithFrame:CGRectMake(199, 8, 0, 0)];
                [disableVoiceSearch addTarget:self action:@selector(toggleDisableVoiceSearch:) forControlEvents:UIControlEventValueChanged];
                disableVoiceSearch.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"kDisableVoiceSearch"];
                cell.accessoryView = disableVoiceSearch;
            }
            if(indexPath.row == 10) {
                cell.textLabel.text = @"Disable Hints";
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                UISwitch *disableHints = [[UISwitch alloc] initWithFrame:CGRectMake(199, 8, 0, 0)];
                [disableHints addTarget:self action:@selector(toggleDisableHints:) forControlEvents:UIControlEventValueChanged];
                disableHints.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"kDisableHints"];
                cell.accessoryView = disableHints;
            }
        }
        if(indexPath.section == 4) {
            if(indexPath.row == 0) {
                cell.textLabel.text = @"Reborn Settings";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            if(indexPath.row == 1) {
                cell.textLabel.text = @"Credits";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)theTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [theTableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.section == 0) {
        if(indexPath.row == 0) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.patreon.com/lillieweeb"] options:@{} completionHandler:nil];
        }
    }
    if(indexPath.section == 1) {
        if(indexPath.row == 0) {
            UIWindow *alertWindowDownloads = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
            alertWindowDownloads.rootViewController = [UIViewController new];
            alertWindowDownloads.windowLevel = UIWindowLevelAlert + 1;
            alertWindowOutDownloads = alertWindowDownloads;
    
            DownloadsController* downloadsController = [[DownloadsController alloc] init];
            UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(downloadsdone)];
            downloadsController.navigationItem.rightBarButtonItem = doneButton;
            UINavigationController* downloadsControllerView = [[UINavigationController alloc] initWithRootViewController:downloadsController];
            downloadsControllerView.modalPresentationStyle = UIModalPresentationFullScreen;

            [alertWindowDownloads makeKeyAndVisible];
            [alertWindowDownloads.rootViewController presentViewController:downloadsControllerView animated:YES completion:nil];
        }
        if(indexPath.row == 1) {
            NSFileManager * fm = [[NSFileManager alloc] init];
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            NSString *content = @"Filza Check";
            NSData *fileContents = [content dataUsingEncoding:NSUTF8StringEncoding];
            NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"FilzaCheck.txt"];
            [fm createFileAtPath:filePath contents:fileContents attributes:nil];
            NSString *path = [NSString stringWithFormat:@"filza://view%@/FilzaCheck.txt", documentsDirectory];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:path] options:@{} completionHandler:nil];
        }
    }
    if(indexPath.section == 2) {
        if(indexPath.row == 0) {
            UIWindow *alertWindowVideo = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
            alertWindowVideo.rootViewController = [UIViewController new];
            alertWindowVideo.windowLevel = UIWindowLevelAlert + 1;
            alertWindowOutVideo = alertWindowVideo;
    
            VideoOptionsController *videoOptionsController = [[VideoOptionsController alloc] init];
            UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(videodone)];
            videoOptionsController.navigationItem.rightBarButtonItem = doneButton;
            UINavigationController *videoOptionsControllerView = [[UINavigationController alloc] initWithRootViewController:videoOptionsController];
            videoOptionsControllerView.modalPresentationStyle = UIModalPresentationFullScreen;

            [alertWindowVideo makeKeyAndVisible];
            [alertWindowVideo.rootViewController presentViewController:videoOptionsControllerView animated:YES completion:nil];
        }
        if(indexPath.row == 1) {
            UIWindow *alertWindowOverlay = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
            alertWindowOverlay.rootViewController = [UIViewController new];
            alertWindowOverlay.windowLevel = UIWindowLevelAlert + 1;
            alertWindowOutOverlay = alertWindowOverlay;
    
            OverlayOptionsController *overlayOptionsController = [[OverlayOptionsController alloc] init];
            UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(overlaydone)];
            overlayOptionsController.navigationItem.rightBarButtonItem = doneButton;
            UINavigationController *overlayOptionsControllerView = [[UINavigationController alloc] initWithRootViewController:overlayOptionsController];
            overlayOptionsControllerView.modalPresentationStyle = UIModalPresentationFullScreen;

            [alertWindowOverlay makeKeyAndVisible];
            [alertWindowOverlay.rootViewController presentViewController:overlayOptionsControllerView animated:YES completion:nil];
        }
        if(indexPath.row == 2) {
            UIWindow *alertWindowTabBar = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
            alertWindowTabBar.rootViewController = [UIViewController new];
            alertWindowTabBar.windowLevel = UIWindowLevelAlert + 1;
            alertWindowOutTabBar = alertWindowTabBar;
    
            TabBarOptionsController *tabBarOptionsController = [[TabBarOptionsController alloc] init];
            UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(tabbardone)];
            tabBarOptionsController.navigationItem.rightBarButtonItem = doneButton;
            UINavigationController *tabBarOptionsControllerView = [[UINavigationController alloc] initWithRootViewController:tabBarOptionsController];
            tabBarOptionsControllerView.modalPresentationStyle = UIModalPresentationFullScreen;

            [alertWindowTabBar makeKeyAndVisible];
            [alertWindowTabBar.rootViewController presentViewController:tabBarOptionsControllerView animated:YES completion:nil];
        }
        if(indexPath.row == 3) {
            UIWindow *alertWindowColour = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
            alertWindowColour.rootViewController = [UIViewController new];
            alertWindowColour.windowLevel = UIWindowLevelAlert + 1;
            alertWindowOutColour = alertWindowColour;
    
            ColourOptionsController *colourOptionsController = [[ColourOptionsController alloc] init];
            UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(colourdone)];
            colourOptionsController.navigationItem.rightBarButtonItem = doneButton;
            UINavigationController *colourOptionsControllerView = [[UINavigationController alloc] initWithRootViewController:colourOptionsController];
            colourOptionsControllerView.modalPresentationStyle = UIModalPresentationFullScreen;

            [alertWindowColour makeKeyAndVisible];
            [alertWindowColour.rootViewController presentViewController:colourOptionsControllerView animated:YES completion:nil];
        }
        if(indexPath.row == 4) {
            UIWindow *alertWindowShorts = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
            alertWindowShorts.rootViewController = [UIViewController new];
            alertWindowShorts.windowLevel = UIWindowLevelAlert + 1;
            alertWindowOutShorts = alertWindowShorts;
    
            ShortsOptionsController *shortsOptionsController = [[ShortsOptionsController alloc] init];
            UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(shortsdone)];
            shortsOptionsController.navigationItem.rightBarButtonItem = doneButton;
            UINavigationController *shortsOptionsControllerView = [[UINavigationController alloc] initWithRootViewController:shortsOptionsController];
            shortsOptionsControllerView.modalPresentationStyle = UIModalPresentationFullScreen;

            [alertWindowShorts makeKeyAndVisible];
            [alertWindowShorts.rootViewController presentViewController:shortsOptionsControllerView animated:YES completion:nil];
        }
    }
    if(indexPath.section == 4) {
        if(indexPath.row == 0) {
            UIWindow *alertWindowRebornSettings = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
            alertWindowRebornSettings.rootViewController = [UIViewController new];
            alertWindowRebornSettings.windowLevel = UIWindowLevelAlert + 1;
            alertWindowOutRebornSettings = alertWindowRebornSettings;
    
            RebornSettingsController *rebornSettingsController = [[RebornSettingsController alloc] init];
            UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(rebornsettingsdone)];
            rebornSettingsController.navigationItem.rightBarButtonItem = doneButton;
            UINavigationController *rebornSettingsControllerView = [[UINavigationController alloc] initWithRootViewController:rebornSettingsController];
            rebornSettingsControllerView.modalPresentationStyle = UIModalPresentationFullScreen;

            [alertWindowRebornSettings makeKeyAndVisible];
            [alertWindowRebornSettings.rootViewController presentViewController:rebornSettingsControllerView animated:YES completion:nil];
        }
        if(indexPath.row == 1) {
            UIWindow *alertWindowCredits = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
            alertWindowCredits.rootViewController = [UIViewController new];
            alertWindowCredits.windowLevel = UIWindowLevelAlert + 1;
            alertWindowOutCredits = alertWindowCredits;
    
            CreditsController *creditsController = [[CreditsController alloc] init];
            UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(creditsdone)];
            creditsController.navigationItem.rightBarButtonItem = doneButton;
            UINavigationController *creditsControllerView = [[UINavigationController alloc] initWithRootViewController:creditsController];
            creditsControllerView.modalPresentationStyle = UIModalPresentationFullScreen;

            [alertWindowCredits makeKeyAndVisible];
            [alertWindowCredits.rootViewController presentViewController:creditsControllerView animated:YES completion:nil];
        }
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    if (section == 4) {
        return @"Version: 3.0.0 (Beta)";
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0 || section == 1 || section == 2 || section == 4) {
        return 50;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    if (self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleLight) {
        view.tintColor = [UIColor colorWithRed:0.949 green:0.949 blue:0.969 alpha:1.0];
    }
    else {
        view.tintColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
    }
    UITableViewHeaderFooterView *footer = (UITableViewHeaderFooterView *)view;
    [footer.textLabel setTextColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"tableSection"]]];
    [footer.textLabel setFont:[UIFont systemFontOfSize:14]];
    footer.textLabel.textAlignment = NSTextAlignmentCenter;
}

- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 4) {
        return 50;
    }
    return 0;
}

@end

@implementation RootOptionsController(Privates)

- (void)downloadsdone {
    alertWindowOutDownloads.hidden = YES;
}

- (void)videodone {
    alertWindowOutVideo.hidden = YES;
}

- (void)overlaydone {
    alertWindowOutOverlay.hidden = YES;
}

- (void)tabbardone {
    alertWindowOutTabBar.hidden = YES;
}

- (void)colourdone {
    alertWindowOutColour.hidden = YES;
}

- (void)shortsdone {
    alertWindowOutShorts.hidden = YES;
}

- (void)rebornsettingsdone {
    alertWindowOutRebornSettings.hidden = YES;
}

- (void)creditsdone {
    alertWindowOutCredits.hidden = YES;
}

- (void)done {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)apply {
    exit(0); 
}

- (void)toggleEnableiPadStyleOniPhone:(UISwitch *)sender {
    if ([sender isOn]) {
        NSLog(@"On");
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"kEnableiPadStyleOniPhone"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        NSLog(@"Off");
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"kEnableiPadStyleOniPhone"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)toggleUnlockUHDQuality:(UISwitch *)sender {
    if ([sender isOn]) {
        NSLog(@"On");
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"kUnlockUHDQuality"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        NSLog(@"Off");
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"kUnlockUHDQuality"];
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

- (void)toggleNoCommentsSection:(UISwitch *)sender {
    if ([sender isOn]) {
        NSLog(@"On");
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"kNoCommentsSection"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        NSLog(@"Off");
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"kNoCommentsSection"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)toggleNoCastButton:(UISwitch *)sender {
    if ([sender isOn]) {
        NSLog(@"On");
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"kNoCastButton"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        NSLog(@"Off");
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"kNoCastButton"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)toggleNoNotificationButton:(UISwitch *)sender {
    if ([sender isOn]) {
        NSLog(@"On");
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"kNoNotificationButton"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        NSLog(@"Off");
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"kNoNotificationButton"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)toggleNoSearchButton:(UISwitch *)sender {
    if ([sender isOn]) {
        NSLog(@"On");
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"kNoSearchButton"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        NSLog(@"Off");
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"kNoSearchButton"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)toggleNoTopicsSection:(UISwitch *)sender {
    if ([sender isOn]) {
        NSLog(@"On");
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"kNoTopicsSection"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        NSLog(@"Off");
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"kNoTopicsSection"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)toggleDisableYouTubeKidsPopup:(UISwitch *)sender {
    if ([sender isOn]) {
        NSLog(@"On");
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"kDisableYouTubeKidsPopup"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        NSLog(@"Off");
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"kDisableYouTubeKidsPopup"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)toggleDisableVoiceSearch:(UISwitch *)sender {
    if ([sender isOn]) {
        NSLog(@"On");
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"kDisableVoiceSearch"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        NSLog(@"Off");
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"kDisableVoiceSearch"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)toggleDisableHints:(UISwitch *)sender {
    if ([sender isOn]) {
        NSLog(@"On");
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"kDisableHints"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        NSLog(@"Off");
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"kDisableHints"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

@end