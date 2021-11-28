#import "DownloadsController.h"
#import <MediaRemote/MediaRemote.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>
#import <Photos/Photos.h>
#import <AVKit/AVKit.h>

@interface DownloadsController ()
@end

@implementation DownloadsController

NSArray *filePathsList;
NSMutableArray *filePathsVideoArray;
NSMutableArray *filePathsAudioArray;
NSMutableArray *filePathsVideoArtworkArray;
NSMutableArray *filePathsAudioArtworkArray;
NSMutableArray *filePathsAudioNameArray;
UIWindow *alertWindowOutPlayer;

NSString *currentFileName;
NSArray *paths;
NSString *documentsDirectory;
NSString *filePath;
NSURL *URL;

UITableView *tableView;
UISegmentedControl *segmentedControl;

UIWindow *alertWindowOutMenu;
UIWindow *alertWindowOutImport;
UIWindow *alertWindowOutDelete;
UIWindow *alertWindowOutSaved;
UIWindow *alertWindowOutFailed;
UIWindow *alertWindowOutDeleted;

- (void)loadView {
	[super loadView];

    self.title = @"Downloads";
    if (self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleLight) {
        self.view.backgroundColor = [UIColor colorWithRed:0.949 green:0.949 blue:0.969 alpha:1.0];
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    }
    else {
        self.view.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
        self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    }

    NSFileManager * fm = [[NSFileManager alloc] init];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];

    CGFloat topbarHeight = ([UIApplication sharedApplication].statusBarFrame.size.height + (self.navigationController.navigationBar.frame.size.height ?: 0.0));
       
    NSArray *itemArray = [NSArray arrayWithObjects:@"Video", @"Audio", nil];
    segmentedControl = [[UISegmentedControl alloc] initWithItems:itemArray];
    segmentedControl.frame = CGRectMake(0, topbarHeight, self.view.bounds.size.width, 40);
    [segmentedControl addTarget:self action:@selector(swap) forControlEvents:UIControlEventValueChanged];
    segmentedControl.selectedSegmentIndex = 0;
    [self.view addSubview:segmentedControl];

    filePathsList = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:documentsDirectory error:nil];
    filePathsVideoArray = [[NSMutableArray alloc] init];
    filePathsAudioArray = [[NSMutableArray alloc] init];
    filePathsVideoArtworkArray = [[NSMutableArray alloc] init];
    filePathsAudioArtworkArray = [[NSMutableArray alloc] init];
    filePathsAudioNameArray = [[NSMutableArray alloc] init];
    for (id object in filePathsList) {
        if ([object containsString:@".mp4"]) {
            [filePathsVideoArray addObject:object];
            NSString *cut = [object substringToIndex:[object length]-4];
            NSString *jpg = [NSString stringWithFormat:@"%@.jpg", cut];
            [filePathsVideoArtworkArray addObject:jpg];
        }
        if ([object containsString:@".m4a"]) {
            [filePathsAudioArray addObject:object];
            NSString *cut = [object substringToIndex:[object length]-4];
            NSString *jpg = [NSString stringWithFormat:@"%@.jpg", cut];
            [filePathsAudioArtworkArray addObject:jpg];
            [filePathsAudioNameArray addObject:cut];
        }
    }

    UITableViewCell *heightCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, topbarHeight + 40, self.view.bounds.size.width, self.view.bounds.size.height - topbarHeight - 40)];

    CGRect tableFrame;
    if ([filePathsVideoArray count] < [filePathsAudioArray count]) {
        tableFrame = CGRectMake(0, 0, self.view.bounds.size.width, heightCell.frame.size.height * [filePathsAudioArray count]);
    } else {
        tableFrame = CGRectMake(0, 0, self.view.bounds.size.width, heightCell.frame.size.height * [filePathsVideoArray count]);
    }
    tableView = [[UITableView alloc] initWithFrame:tableFrame style:UITableViewStylePlain];
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.scrollEnabled = NO;
    [scrollView addSubview:tableView];
    if ([filePathsVideoArray count] < [filePathsAudioArray count]) {
        scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, heightCell.frame.size.height * [filePathsAudioArray count] + 50);
    } else {
        scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, heightCell.frame.size.height * [filePathsVideoArray count] + 50);
    }
    [self.view addSubview:scrollView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)theTableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)theTableView numberOfRowsInSection:(NSInteger)section {
    if (segmentedControl.selectedSegmentIndex == 0) {
        if ([filePathsVideoArray count] > 0) {
            return [filePathsVideoArray count];
        }
        else {
            return 0;
        }
    } else {
        if ([filePathsAudioArray count] > 0) {
            return [filePathsAudioArray count];
        }
        else {
            return 0;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"DownloadsTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
        cell.textLabel.adjustsFontSizeToFitWidth = true;
        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
        if (self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleLight) {
            cell.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
            cell.textLabel.textColor = [UIColor blackColor];
        }
        else {
            cell.backgroundColor = [UIColor colorWithRed:0.110 green:0.110 blue:0.118 alpha:1.0];
            cell.textLabel.textColor = [UIColor whiteColor];
        }
    }
    if (segmentedControl.selectedSegmentIndex == 0) {
        cell.textLabel.text = [filePathsVideoArray objectAtIndex:indexPath.row];
        @try {
            NSString *artworkFileName = filePathsVideoArtworkArray[indexPath.row];
            NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDir  = [documentPaths objectAtIndex:0];
            NSString *jpgFile = [documentsDir stringByAppendingPathComponent:artworkFileName];
            cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@", jpgFile]];
        }
        @catch(id anException) {
        }
    } else {
        cell.textLabel.text = [filePathsAudioArray objectAtIndex:indexPath.row];
        @try {
            NSString *artworkFileName = filePathsAudioArtworkArray[indexPath.row];
            NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDir  = [documentPaths objectAtIndex:0];
            NSString *jpgFile = [documentsDir stringByAppendingPathComponent:artworkFileName];
            cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@", jpgFile]];
        }
        @catch(id anException) {
        }
    }
    return cell;
}

- (void)tableView:(UITableView*)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath*)indexPath {
    if (segmentedControl.selectedSegmentIndex == 0) {
        UIWindow *alertWindowMenu = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        alertWindowMenu.rootViewController = [UIViewController new];
        alertWindowMenu.windowLevel = UIWindowLevelAlert + 1;
        alertWindowOutMenu = alertWindowMenu;

        UIAlertController *alertMenu = [UIAlertController alertControllerWithTitle:@"Options" message:nil preferredStyle:UIAlertControllerStyleAlert];

        [alertMenu addAction:[UIAlertAction actionWithTitle:@"Import Video To Camera Roll" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            alertWindowMenu.hidden = YES;
            NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDir  = [documentPaths objectAtIndex:0];
            NSString *videoPath = [NSString stringWithFormat:@"%@/%@", documentsDir, [filePathsVideoArray objectAtIndex:indexPath.row]];
            NSURL *outputVidePath = [[NSURL alloc] initFileURLWithPath:videoPath];
            NSLog(@"%@", videoPath);
            if ([[filePathsVideoArray objectAtIndex:indexPath.row] containsString:@".mp4"]) {
                [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                    [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:outputVidePath];
                } completionHandler:^(BOOL success, NSError *error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (success) {
                            NSLog(@"Video Saved");
                            UIWindow *alertWindowSaved = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
                            alertWindowSaved.rootViewController = [UIViewController new];
                            alertWindowSaved.windowLevel = UIWindowLevelAlert + 1;
                            alertWindowOutSaved = alertWindowSaved;

                            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Notice" message:@"Video Saved To Camera Roll" preferredStyle:UIAlertControllerStyleAlert];
                                                
                            [alert addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                                alertWindowSaved.hidden = YES;
                            }]];

                            [alertWindowSaved makeKeyAndVisible];
                            [alertWindowSaved.rootViewController presentViewController:alert animated:YES completion:nil];
                        } else{
                            NSLog(@"%@", error.description);
                            UIWindow *alertWindowFailed = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
                            alertWindowFailed.rootViewController = [UIViewController new];
                            alertWindowFailed.windowLevel = UIWindowLevelAlert + 1;
                            alertWindowOutFailed = alertWindowFailed;

                            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Notice" message:@"Save To Camera Roll Failed \nMake Sure To Give Camera Roll Permission To YouTube In The iOS Settings App" preferredStyle:UIAlertControllerStyleAlert];
                                                
                            [alert addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                                alertWindowFailed.hidden = YES;
                            }]];

                            [alertWindowFailed makeKeyAndVisible];
                            [alertWindowFailed.rootViewController presentViewController:alert animated:YES completion:nil];
                        }
                    });
                }];
            }
        }]];

        [alertMenu addAction:[UIAlertAction actionWithTitle:@"Delete Video" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            alertWindowMenu.hidden = YES;
            NSFileManager * videofm = [[NSFileManager alloc] init];
            NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDir  = [documentPaths objectAtIndex:0];
            NSString *videoPath = [NSString stringWithFormat:@"%@/%@", documentsDir, [filePathsVideoArray objectAtIndex:indexPath.row]];
            NSString *videoArtworkPath = [NSString stringWithFormat:@"%@/%@", documentsDir, [filePathsVideoArtworkArray objectAtIndex:indexPath.row]];
            [videofm removeItemAtPath:videoPath error:nil];
            [videofm removeItemAtPath:videoArtworkPath error:nil];

            UIWindow *alertWindowDeleted = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
            alertWindowDeleted.rootViewController = [UIViewController new];
            alertWindowDeleted.windowLevel = UIWindowLevelAlert + 1;
            alertWindowOutDeleted = alertWindowDeleted;

            UIAlertController *alertDeleted = [UIAlertController alertControllerWithTitle:@"Notice" message:@"Video Successfully Deleted \nPlease Close And Reopen The Downloads List" preferredStyle:UIAlertControllerStyleAlert];

            [alertDeleted addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                alertWindowDeleted.hidden = YES;
            }]];

            [alertWindowDeleted makeKeyAndVisible];
            [alertWindowDeleted.rootViewController presentViewController:alertDeleted animated:YES completion:nil];
        }]];

        [alertMenu addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            alertWindowMenu.hidden = YES;
        }]];

        [alertWindowMenu makeKeyAndVisible];
        [alertWindowMenu.rootViewController presentViewController:alertMenu animated:YES completion:nil];
    } else {
        UIWindow *alertWindowMenu = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        alertWindowMenu.rootViewController = [UIViewController new];
        alertWindowMenu.windowLevel = UIWindowLevelAlert + 1;
        alertWindowOutMenu = alertWindowMenu;

        UIAlertController *alertMenu = [UIAlertController alertControllerWithTitle:@"Options" message:nil preferredStyle:UIAlertControllerStyleAlert];

        [alertMenu addAction:[UIAlertAction actionWithTitle:@"Delete Audio" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            alertWindowMenu.hidden = YES;
            NSFileManager * audiofm = [[NSFileManager alloc] init];
            NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDir  = [documentPaths objectAtIndex:0];
            NSString *audioPath = [NSString stringWithFormat:@"%@/%@", documentsDir, [filePathsAudioArray objectAtIndex:indexPath.row]];
            NSString *audioArtworkPath = [NSString stringWithFormat:@"%@/%@", documentsDir, [filePathsAudioArtworkArray objectAtIndex:indexPath.row]];
            [audiofm removeItemAtPath:audioPath error:nil];
            [audiofm removeItemAtPath:audioArtworkPath error:nil];

            UIWindow *alertWindowDeleted = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
            alertWindowDeleted.rootViewController = [UIViewController new];
            alertWindowDeleted.windowLevel = UIWindowLevelAlert + 1;
            alertWindowOutDeleted = alertWindowDeleted;

            UIAlertController *alertDeleted = [UIAlertController alertControllerWithTitle:@"Notice" message:@"Audio Successfully Deleted \nPlease Close And Reopen The Downloads List" preferredStyle:UIAlertControllerStyleAlert];

            [alertDeleted addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                alertWindowDeleted.hidden = YES;
            }]];

            [alertWindowDeleted makeKeyAndVisible];
            [alertWindowDeleted.rootViewController presentViewController:alertDeleted animated:YES completion:nil];
        }]];

        [alertMenu addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            alertWindowMenu.hidden = YES;
        }]];

        [alertWindowMenu makeKeyAndVisible];
        [alertWindowMenu.rootViewController presentViewController:alertMenu animated:YES completion:nil];
    }
}

- (void)tableView:(UITableView *)theTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [theTableView deselectRowAtIndexPath:indexPath animated:YES];
    if (segmentedControl.selectedSegmentIndex == 0) {
        currentFileName = filePathsVideoArray[indexPath.row];
    } else {
        currentFileName = filePathsAudioArray[indexPath.row];
    }
    paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDirectory = [paths objectAtIndex:0];
    filePath = [documentsDirectory stringByAppendingPathComponent:currentFileName];
    URL = [NSURL fileURLWithPath:filePath];

    if ([currentFileName containsString:@".m4a"]) {
        [self audioPlay];
    }
    if ([currentFileName containsString:@".mp4"]) {
        [self videoPlay];
    }
}

@end

@implementation DownloadsController(Privates)

- (void)swap {
    [tableView reloadData];
}

- (void)audioPlay {
    MRMediaRemoteSendCommand(MRMediaRemoteCommandPause, 0);

    UIWindow *alertWindowPlayer = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    alertWindowPlayer.rootViewController = [UIViewController new];
    alertWindowPlayer.windowLevel = UIWindowLevelAlert + 1;
    alertWindowOutPlayer = alertWindowPlayer;

    AVPlayerViewController *playerViewController = [AVPlayerViewController new];
    playerViewController.player = [AVPlayer playerWithURL:URL];
    playerViewController.allowsPictureInPicturePlayback = NO;
    if ([playerViewController respondsToSelector:@selector(setCanStartPictureInPictureAutomaticallyFromInline:)]) {
        playerViewController.canStartPictureInPictureAutomaticallyFromInline = NO;
    }
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [playerViewController.player play];

    [alertWindowPlayer makeKeyAndVisible];
    [alertWindowPlayer.rootViewController presentViewController:playerViewController animated:YES completion:nil];
}

- (void)videoPlay {
    MRMediaRemoteSendCommand(MRMediaRemoteCommandPause, 0);
        
    UIWindow *alertWindowPlayer = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    alertWindowPlayer.rootViewController = [UIViewController new];
    alertWindowPlayer.windowLevel = UIWindowLevelAlert + 1;
    alertWindowOutPlayer = alertWindowPlayer;

    AVPlayerViewController *playerViewController = [AVPlayerViewController new];
    playerViewController.player = [AVPlayer playerWithURL:URL];
    playerViewController.allowsPictureInPicturePlayback = NO;
    if ([playerViewController respondsToSelector:@selector(setCanStartPictureInPictureAutomaticallyFromInline:)]) {
        playerViewController.canStartPictureInPictureAutomaticallyFromInline = NO;
    }
    [playerViewController.player play];

    [alertWindowPlayer makeKeyAndVisible];
    [alertWindowPlayer.rootViewController presentViewController:playerViewController animated:YES completion:nil];
}

@end