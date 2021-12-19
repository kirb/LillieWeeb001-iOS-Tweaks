#import "YTRRootViewController.h"
#import <MediaRemote/MediaRemote.h>
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>

@interface YTRRootViewController ()
@end

@implementation YTRRootViewController

NSString *youtubeDocumentsPath;
NSMutableArray *filePathsVideoArray;
NSMutableArray *filePathsAudioArray;
NSMutableArray *filePathsVideoArtworkArray;
NSMutableArray *filePathsAudioArtworkArray;
NSMutableArray *filePathsVideoNameArray;
NSMutableArray *filePathsAudioNameArray;
NSURL *URL;

UIView *videoView;
UIView *audioView;
UIWindow *alertWindowOutPlayer;

- (void)loadView {
	[super loadView];

	self.title = @"YT Reborn Downloads";
	if (self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleLight) {
        self.view.backgroundColor = [UIColor colorWithRed:0.949 green:0.949 blue:0.969 alpha:1.0];
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    }
    else {
        self.view.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
        self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    }
    
    LSApplicationProxy *proxy = [LSApplicationProxy applicationProxyForIdentifier:@"com.google.ios.youtube"];
    youtubeDocumentsPath = [NSString stringWithFormat:@"%@/Documents", [[proxy containerURL] path]];

    NSArray *filePathsList = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:youtubeDocumentsPath error:nil];
    filePathsVideoArray = [[NSMutableArray alloc] init];
    filePathsAudioArray = [[NSMutableArray alloc] init];
    filePathsVideoArtworkArray = [[NSMutableArray alloc] init];
    filePathsAudioArtworkArray = [[NSMutableArray alloc] init];
    filePathsVideoNameArray = [[NSMutableArray alloc] init];
    filePathsAudioNameArray = [[NSMutableArray alloc] init];
    for (id object in filePathsList) {
        if ([object containsString:@".mp4"]) {
            [filePathsVideoArray addObject:object];
            NSString *cut = [object substringToIndex:[object length]-4];
            NSString *jpg = [NSString stringWithFormat:@"%@.jpg", cut];
            [filePathsVideoArtworkArray addObject:jpg];
            [filePathsVideoNameArray addObject:cut];
        }
        if ([object containsString:@".m4a"]) {
            [filePathsAudioArray addObject:object];
            NSString *cut = [object substringToIndex:[object length]-4];
            NSString *jpg = [NSString stringWithFormat:@"%@.jpg", cut];
            [filePathsAudioArtworkArray addObject:jpg];
            [filePathsAudioNameArray addObject:cut];
        }
    }

    CGFloat topbarHeight = ([UIApplication sharedApplication].statusBarFrame.size.height + (self.navigationController.navigationBar.frame.size.height ?: 0.0));
    UITableViewCell *heightCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];

    // Audio View
    
    audioView = [[UIView alloc] initWithFrame:CGRectMake(0, topbarHeight, self.view.bounds.size.width, self.view.bounds.size.height - 50)];
    audioView.hidden = YES;

    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - topbarHeight - 50)];
    CGRect tableFrame = CGRectMake(0, 0, self.view.bounds.size.width, heightCell.frame.size.height * [filePathsAudioArray count]);
    UITableView *tableView = [[UITableView alloc] initWithFrame:tableFrame style:UITableViewStylePlain];
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.scrollEnabled = NO;
    [scrollView addSubview:tableView];
    scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, heightCell.frame.size.height * [filePathsAudioArray count] + 50);
    [audioView addSubview:scrollView];

    [self.view addSubview:audioView];

    // Tab Bar

    UITabBar *tabBar = [[UITabBar alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 50, self.view.bounds.size.width, 50)];
    tabBar.delegate = self;

    NSMutableArray *tabBarItems = [[NSMutableArray alloc] init];

    UITabBarItem *videoTabBarItem = [[UITabBarItem alloc] initWithTitle:@"Video" image:nil tag:0];
    videoTabBarItem.titlePositionAdjustment = UIOffsetMake(0, -16);
    UITabBarItem *audioTabBarItem = [[UITabBarItem alloc] initWithTitle:@"Audio" image:nil tag:1];
    audioTabBarItem.titlePositionAdjustment = UIOffsetMake(0, -16);

    [tabBarItems addObject:videoTabBarItem];
    [tabBarItems addObject:audioTabBarItem];

    tabBar.items = tabBarItems;
    tabBar.selectedItem = [tabBarItems objectAtIndex:0];

    [self.view addSubview:tabBar];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    if (item.tag == 0) {
        audioView.hidden = YES;
    }
    if (item.tag == 1) {
        audioView.hidden = NO;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)theTableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)theTableView numberOfRowsInSection:(NSInteger)section {
    return [filePathsAudioArray count];
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
    cell.textLabel.text = [filePathsAudioArray objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)theTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [theTableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *fileName = filePathsAudioArray[indexPath.row];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@", youtubeDocumentsPath, fileName];
    URL = [NSURL fileURLWithPath:filePath];

    if ([fileName containsString:@".m4a"]) {
        [self audioPlay];
    }
    if ([fileName containsString:@".mp4"]) {
        [self videoPlay];
    }
}

@end

@implementation YTRRootViewController(Privates)

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
    playerViewController.allowsPictureInPicturePlayback = YES;
    if ([playerViewController respondsToSelector:@selector(setCanStartPictureInPictureAutomaticallyFromInline:)]) {
        playerViewController.canStartPictureInPictureAutomaticallyFromInline = YES;
    }
    [playerViewController.player play];

    [alertWindowPlayer makeKeyAndVisible];
    [alertWindowPlayer.rootViewController presentViewController:playerViewController animated:YES completion:nil];
}

@end
