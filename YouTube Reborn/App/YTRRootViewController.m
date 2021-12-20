#import "YTRRootViewController.h"

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
UITableViewCell *videoCell;
UITableViewCell *audioCell;

- (void)loadView {
	[super loadView];

	self.title = @"YT Reborn Downloads";
    [self setupLightDarkModeView];
    
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

    // Video View
    
    videoView = [[UIView alloc] initWithFrame:CGRectMake(0, topbarHeight, self.view.bounds.size.width, self.view.bounds.size.height - 50)];
    videoView.hidden = NO;

    UIScrollView *videoScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - topbarHeight - 50)];
    CGRect videoTableFrame = CGRectMake(0, 0, self.view.bounds.size.width, heightCell.frame.size.height * [filePathsVideoArray count]);
    UITableView *videoTableView = [[UITableView alloc] initWithFrame:videoTableFrame style:UITableViewStylePlain];
    videoTableView.tag = 100;
    videoTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, videoTableView.frame.size.width, 1)];
    videoTableView.delegate = self;
    videoTableView.dataSource = self;
    videoTableView.scrollEnabled = NO;
    [videoScrollView addSubview:videoTableView];
    videoScrollView.contentSize = CGSizeMake(self.view.bounds.size.width, heightCell.frame.size.height * [filePathsVideoArray count] + 50);
    [videoView addSubview:videoScrollView];

    [self.view addSubview:videoView];
    
    // Audio View
    
    audioView = [[UIView alloc] initWithFrame:CGRectMake(0, topbarHeight, self.view.bounds.size.width, self.view.bounds.size.height - 50)];
    audioView.hidden = YES;

    UIScrollView *audioScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - topbarHeight - 50)];
    CGRect audioTableFrame = CGRectMake(0, 0, self.view.bounds.size.width, heightCell.frame.size.height * [filePathsAudioArray count]);
    UITableView *audioTableView = [[UITableView alloc] initWithFrame:audioTableFrame style:UITableViewStylePlain];
    audioTableView.tag = 101;
    audioTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, audioTableView.frame.size.width, 1)];
    audioTableView.delegate = self;
    audioTableView.dataSource = self;
    audioTableView.scrollEnabled = NO;
    [audioScrollView addSubview:audioTableView];
    audioScrollView.contentSize = CGSizeMake(self.view.bounds.size.width, heightCell.frame.size.height * [filePathsAudioArray count] + 50);
    [audioView addSubview:audioScrollView];

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
        videoView.hidden = NO;
        audioView.hidden = YES;
    }
    if (item.tag == 1) {
        videoView.hidden = YES;
        audioView.hidden = NO;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)theTableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)theTableView numberOfRowsInSection:(NSInteger)section {
    if (theTableView.tag == 100) {
        return [filePathsVideoArray count];
    }
    if (theTableView.tag == 101) {
        return [filePathsAudioArray count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (theTableView.tag == 100) {
        static NSString *CellIdentifier = @"VideoDownloadsTableViewCell";
        videoCell = [theTableView dequeueReusableCellWithIdentifier:CellIdentifier];

        if (videoCell == nil) {
            videoCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
            videoCell.textLabel.adjustsFontSizeToFitWidth = true;
            videoCell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
            [self setupLightDarkModeCell];
        }
        videoCell.textLabel.text = [filePathsVideoArray objectAtIndex:indexPath.row];
        return videoCell;
    }
    if (theTableView.tag == 101) {
        static NSString *CellIdentifier = @"AudioDownloadsTableViewCell";
        audioCell = [theTableView dequeueReusableCellWithIdentifier:CellIdentifier];

        if (audioCell == nil) {
            audioCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
            audioCell.textLabel.adjustsFontSizeToFitWidth = true;
            audioCell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
            [self setupLightDarkModeCell];
        }
        audioCell.textLabel.text = [filePathsAudioArray objectAtIndex:indexPath.row];
        return audioCell;
    }
}

- (void)tableView:(UITableView *)theTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [theTableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *fileName;
    if (theTableView.tag == 100) {
        fileName = filePathsVideoArray[indexPath.row];
    }
    if (theTableView.tag == 101) {
        fileName = filePathsAudioArray[indexPath.row];
    }
    NSString *filePath = [NSString stringWithFormat:@"%@/%@", youtubeDocumentsPath, fileName];
    URL = [NSURL fileURLWithPath:filePath];

    if ([fileName containsString:@".m4a"]) {
        [self audioPlay];
    }
    if ([fileName containsString:@".mp4"]) {
        [self videoPlay];
    }
}

- (void)playerViewController:(AVPlayerViewController *)playerViewController restoreUserInterfaceForPictureInPictureStopWithCompletionHandler:(void (^)(BOOL restored))completionHandler{
    [self presentViewController:playerViewController animated:YES completion:nil];
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    [self setupLightDarkModeView];
    [self setupLightDarkModeCell];
}

@end

@implementation YTRRootViewController(Privates)

- (void)setupLightDarkModeView {
    if (self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleLight) {
        self.view.backgroundColor = [UIColor colorWithRed:0.949 green:0.949 blue:0.969 alpha:1.0];
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    }
    else {
        self.view.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    }
}

- (void)setupLightDarkModeCell {
    if (self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleLight) {
        videoCell.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
        videoCell.textLabel.textColor = [UIColor blackColor];
        audioCell.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
        audioCell.textLabel.textColor = [UIColor blackColor];
    }
    else {
        videoCell.backgroundColor = [UIColor colorWithRed:0.110 green:0.110 blue:0.118 alpha:1.0];
        videoCell.textLabel.textColor = [UIColor whiteColor];
        audioCell.backgroundColor = [UIColor colorWithRed:0.110 green:0.110 blue:0.118 alpha:1.0];
        audioCell.textLabel.textColor = [UIColor whiteColor];
    }
}

- (void)audioPlay {
    AVPlayerViewController *playerViewController = [AVPlayerViewController new];
    playerViewController.delegate = self;
    playerViewController.player = [AVPlayer playerWithURL:URL];
    playerViewController.allowsPictureInPicturePlayback = NO;
    if ([playerViewController respondsToSelector:@selector(setCanStartPictureInPictureAutomaticallyFromInline:)]) {
        playerViewController.canStartPictureInPictureAutomaticallyFromInline = NO;
    }
    [playerViewController.player play];

    [self presentViewController:playerViewController animated:YES completion:nil];
}

- (void)videoPlay {
    AVPlayerViewController *playerViewController = [AVPlayerViewController new];
    playerViewController.delegate = self;
    playerViewController.player = [AVPlayer playerWithURL:URL];
    playerViewController.allowsPictureInPicturePlayback = YES;
    if ([playerViewController respondsToSelector:@selector(setCanStartPictureInPictureAutomaticallyFromInline:)]) {
        playerViewController.canStartPictureInPictureAutomaticallyFromInline = YES;
    }
    [playerViewController.player play];

    [self presentViewController:playerViewController animated:YES completion:nil];
}

@end
