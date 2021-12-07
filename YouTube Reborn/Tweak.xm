#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <XCDYouTubeKit/XCDYouTubeKit.h>
#import <AFNetworking/AFNetworking.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaRemote/MediaRemote.h>
#import <CoreMedia/CoreMedia.h>
#import <Photos/Photos.h>
#import <AVKit/AVKit.h>
#import "Controllers/RootOptionsController.h"
#import "Tweak.h"

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

NSMutableArray *overlayButtons = [NSMutableArray array];
NSString *videoIdentifier;
NSURL *streamURL;

UIWindow *alertWindowOut;

UIColor *hexColour() {
    NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"kHexColourOptions"];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingFromData:colorData error:nil];
    [unarchiver setRequiresSecureCoding:NO];
    NSString *hexString = [unarchiver decodeObjectForKey:NSKeyedArchiveRootObjectKey];
    NSString *cleanString = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    if([cleanString length] == 3) {
        cleanString = [NSString stringWithFormat:@"%@%@%@%@%@%@", [cleanString substringWithRange:NSMakeRange(0, 1)],[cleanString substringWithRange:NSMakeRange(0, 1)], [cleanString substringWithRange:NSMakeRange(1, 1)],[cleanString substringWithRange:NSMakeRange(1, 1)], [cleanString substringWithRange:NSMakeRange(2, 1)],[cleanString substringWithRange:NSMakeRange(2, 1)]];
    }
    if([cleanString length] == 6) {
        cleanString = [cleanString stringByAppendingString:@"ff"];
    }
    
    unsigned int baseValue;
    [[NSScanner scannerWithString:cleanString] scanHexInt:&baseValue];
    
    float red = ((baseValue >> 24) & 0xFF)/255.0f;
    float green = ((baseValue >> 16) & 0xFF)/255.0f;
    float blue = ((baseValue >> 8) & 0xFF)/255.0f;
    float alpha = ((baseValue >> 0) & 0xFF)/255.0f;
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

%hook YTAppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    BOOL versionCheckResult = [self versionCheck];
    BOOL iOSCheckResult = [self iOSCheck];
    if (versionCheckResult) {
        UIWindow *alertWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        alertWindow.rootViewController = [UIViewController new];
        alertWindow.windowLevel = UIWindowLevelAlert + 1;
        alertWindowOut = alertWindow;

        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Notice" message:@"\nYour YouTube version is to low to support YouTube Reborn \n\nPlease update YouTube to version 15.47.0+ in order to use YouTube Reborn \n\nThe app will automatically close in 15 seconds \n" preferredStyle:UIAlertControllerStyleAlert];

        [alertWindow makeKeyAndVisible];
        [alertWindow.rootViewController presentViewController:alert animated:YES completion:nil];

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(15.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self closeApp];
        });
    } else if (!iOSCheckResult) {
        UIWindow *alertWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        alertWindow.rootViewController = [UIViewController new];
        alertWindow.windowLevel = UIWindowLevelAlert + 1;
        alertWindowOut = alertWindow;

        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Notice" message:@"\nYour iOS version is too low to support YouTube Reborn \n\nPlease update your iOS to version 13.0+ in order to use YouTube Reborn \n\nThe app will automatically close in 15 seconds \n" preferredStyle:UIAlertControllerStyleAlert];

        [alertWindow makeKeyAndVisible];
        [alertWindow.rootViewController presentViewController:alert animated:YES completion:nil];

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(15.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self closeApp];
        });
    }
    NSLog(@"App Loaded Successfully");
    return %orig;
}

%new
- (void)closeApp {
    UIApplication *app = [UIApplication sharedApplication];
    [app performSelector:@selector(suspend)];
    [NSThread sleepForTimeInterval:2.0];
    exit(0);
}

%new
- (BOOL)versionCheck {
    NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
    NSString *actualVersion = [info objectForKey:@"CFBundleShortVersionString"];
    NSString *requiredVersion = @"15.47.0";
    return [requiredVersion compare:actualVersion options:NSNumericSearch] == NSOrderedDescending;
}

%new
- (BOOL)iOSCheck {
    return SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"13.0");
}
%end

%hook YTNavigationBarTitleView
- (void)layoutSubviews {
	%orig();
    UIView *optionsView = MSHookIvar<YTNavigationBarTitleView *>(self, "_customView");
    [self bringSubviewToFront:optionsView];
    UIImageView *imageView = (UIImageView *)optionsView;
    imageView.contentMode = UIViewContentModeTopLeft;
    CGRect extend = imageView.frame;
    extend.size.width += 15;
    imageView.frame = extend;
    [optionsView setUserInteractionEnabled:YES];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button addTarget:self action:@selector(rootOptionsAction:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"OP" forState:UIControlStateNormal];
    button.frame = CGRectMake(112, 6.5, 33.0, 35.0);
    [optionsView addSubview:button];
}

%new;
- (void)rootOptionsAction:(id)sender {
    NSLog(@"Options Menu Pressed");
    RootOptionsController* rootOptionsController = [[RootOptionsController alloc] init];
    id rootViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
    if([rootViewController isKindOfClass:[UINavigationController class]])
    {
        rootViewController = ((UINavigationController *)rootViewController).viewControllers.firstObject;
    }
    if([rootViewController isKindOfClass:[UITabBarController class]])
    {
        rootViewController = ((UITabBarController *)rootViewController).selectedViewController;
    }
    UINavigationController* rootOptionsControllerView = [[UINavigationController alloc] initWithRootViewController:rootOptionsController];
    rootOptionsControllerView.modalPresentationStyle = UIModalPresentationFullScreen;
    [rootViewController presentViewController:rootOptionsControllerView animated:YES completion:nil];
}
%end

YTLocalPlaybackController *playingVideoID;

%hook YTLocalPlaybackController
- (NSString *)currentVideoID {
    playingVideoID = self;
    return %orig;
}
%end

YTMainAppVideoPlayerOverlayViewController *resultOut;
YTMainAppVideoPlayerOverlayViewController *layoutOut;

%hook YTMainAppVideoPlayerOverlayViewController
- (CGFloat)mediaTime {
    resultOut = self;
    return %orig;
}
- (int)playerViewLayout {
    layoutOut = self;
    return %orig;
}
%end

UIWindow *alertWindowOutMenu;
UIWindow *alertWindowOutPip;
UIWindow *alertWindowOutUrlError;
UIWindow *alertWindowOutFailed;
UIWindow *alertWindowOutDownloading;
UIWindow *alertWindowOutDownloaded;

%hook YTMainAppControlsOverlayView

%property(retain, nonatomic) UIButton *overlayButtonOne;
%property(retain, nonatomic) UIButton *overlayButtonTwo;
%property(retain, nonatomic) UIButton *overlayButtonThree;

- (id)initWithDelegate:(id)delegate {
    self = %orig;
    if (self) {
        BOOL iOSCheckResult = [self iOSCheck];
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kHideRebornDWNButton"] == NO) {
            [overlayButtons addObject:@"DWN"];
        }
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kHideRebornPIPButton"] == NO) {
            if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
                if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kEnableiPadStyleOniPhone"] == YES) {
                    if (iOSCheckResult) {
                        [overlayButtons addObject:@"PIP"];
                    }
                }
            } else {
                if (iOSCheckResult) {
                    [overlayButtons addObject:@"PIP"];
                }
            }
        }
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kHideRebornOPButton"] == NO) {
            [overlayButtons addObject:@"OP"];
        }
        int overlayButtonsCount = [overlayButtons count];
        if (overlayButtonsCount == 1) {
            self.overlayButtonOne = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            if (overlayButtons[0] == @"DWN") {
                [self.overlayButtonOne addTarget:self action:@selector(optionsAction:) forControlEvents:UIControlEventTouchUpInside];
            }
            if (overlayButtons[0] == @"PIP") {
                [self.overlayButtonOne addTarget:self action:@selector(pictureInPicture) forControlEvents:UIControlEventTouchUpInside];
            }
            if (overlayButtons[0] == @"OP") {
                [self.overlayButtonOne addTarget:self action:@selector(playInApp) forControlEvents:UIControlEventTouchUpInside];
            }
            [self.overlayButtonOne setTitle:overlayButtons[0] forState:UIControlStateNormal];
            if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kShowStatusBarInOverlay"] == YES) {
                if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kEnableiPadStyleOniPhone"] == YES) {
                    self.overlayButtonOne.frame = CGRectMake(40, 9, 40.0, 30.0);
                } else {
                    self.overlayButtonOne.frame = CGRectMake(40, 24, 40.0, 30.0);
                }
            } else {
                self.overlayButtonOne.frame = CGRectMake(40, 9, 40.0, 30.0);
            }
            [self addSubview:self.overlayButtonOne];
        }
        if (overlayButtonsCount == 2) {
            self.overlayButtonOne = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            self.overlayButtonTwo = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            self.overlayButtonThree = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            if (overlayButtons[0] == @"DWN") {
                [self.overlayButtonOne addTarget:self action:@selector(optionsAction:) forControlEvents:UIControlEventTouchUpInside];
            }
            if (overlayButtons[0] == @"PIP") {
                [self.overlayButtonOne addTarget:self action:@selector(pictureInPicture) forControlEvents:UIControlEventTouchUpInside];
            }
            if (overlayButtons[0] == @"OP") {
                [self.overlayButtonOne addTarget:self action:@selector(playInApp) forControlEvents:UIControlEventTouchUpInside];
            }
            if (overlayButtons[1] == @"DWN") {
                [self.overlayButtonTwo addTarget:self action:@selector(optionsAction:) forControlEvents:UIControlEventTouchUpInside];
            }
            if (overlayButtons[1] == @"PIP") {
                [self.overlayButtonTwo addTarget:self action:@selector(pictureInPicture) forControlEvents:UIControlEventTouchUpInside];
            }
            if (overlayButtons[1] == @"OP") {
                [self.overlayButtonTwo addTarget:self action:@selector(playInApp) forControlEvents:UIControlEventTouchUpInside];
            }
            [self.overlayButtonOne setTitle:overlayButtons[0] forState:UIControlStateNormal];
            [self.overlayButtonTwo setTitle:overlayButtons[1] forState:UIControlStateNormal];
            if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kShowStatusBarInOverlay"] == YES) {
                if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kEnableiPadStyleOniPhone"] == YES) {
                    self.overlayButtonOne.frame = CGRectMake(40, 9, 40.0, 30.0);
                    self.overlayButtonTwo.frame = CGRectMake(85, 9, 40.0, 30.0);
                } else {
                    self.overlayButtonOne.frame = CGRectMake(40, 24, 40.0, 30.0);
                    self.overlayButtonTwo.frame = CGRectMake(85, 24, 40.0, 30.0);
                }
            } else {
                self.overlayButtonOne.frame = CGRectMake(40, 9, 40.0, 30.0);
                self.overlayButtonTwo.frame = CGRectMake(85, 9, 40.0, 30.0);
            }
            [self addSubview:self.overlayButtonOne];
            [self addSubview:self.overlayButtonTwo];
        }
        if (overlayButtonsCount == 3) {
            self.overlayButtonOne = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            self.overlayButtonTwo = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            self.overlayButtonThree = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            if (overlayButtons[0] == @"DWN") {
                [self.overlayButtonOne addTarget:self action:@selector(optionsAction:) forControlEvents:UIControlEventTouchUpInside];
            }
            if (overlayButtons[0] == @"PIP") {
                [self.overlayButtonOne addTarget:self action:@selector(pictureInPicture) forControlEvents:UIControlEventTouchUpInside];
            }
            if (overlayButtons[0] == @"OP") {
                [self.overlayButtonOne addTarget:self action:@selector(playInApp) forControlEvents:UIControlEventTouchUpInside];
            }
            if (overlayButtons[1] == @"DWN") {
                [self.overlayButtonTwo addTarget:self action:@selector(optionsAction:) forControlEvents:UIControlEventTouchUpInside];
            }
            if (overlayButtons[1] == @"PIP") {
                [self.overlayButtonTwo addTarget:self action:@selector(pictureInPicture) forControlEvents:UIControlEventTouchUpInside];
            }
            if (overlayButtons[1] == @"OP") {
                [self.overlayButtonTwo addTarget:self action:@selector(playInApp) forControlEvents:UIControlEventTouchUpInside];
            }
            if (overlayButtons[2] == @"DWN") {
                [self.overlayButtonThree addTarget:self action:@selector(optionsAction:) forControlEvents:UIControlEventTouchUpInside];
            }
            if (overlayButtons[2] == @"PIP") {
                [self.overlayButtonThree addTarget:self action:@selector(pictureInPicture) forControlEvents:UIControlEventTouchUpInside];
            }
            if (overlayButtons[2] == @"OP") {
                [self.overlayButtonThree addTarget:self action:@selector(playInApp) forControlEvents:UIControlEventTouchUpInside];
            }
            [self.overlayButtonOne setTitle:overlayButtons[0] forState:UIControlStateNormal];
            [self.overlayButtonTwo setTitle:overlayButtons[1] forState:UIControlStateNormal];
            [self.overlayButtonThree setTitle:overlayButtons[2] forState:UIControlStateNormal];
            if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kShowStatusBarInOverlay"] == YES) {
                if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kEnableiPadStyleOniPhone"] == YES) {
                    self.overlayButtonOne.frame = CGRectMake(40, 9, 40.0, 30.0);
                    self.overlayButtonTwo.frame = CGRectMake(85, 9, 40.0, 30.0);
                    self.overlayButtonThree.frame = CGRectMake(130, 9, 40.0, 30.0);
                } else {
                    self.overlayButtonOne.frame = CGRectMake(40, 24, 40.0, 30.0);
                    self.overlayButtonTwo.frame = CGRectMake(85, 24, 40.0, 30.0);
                    self.overlayButtonThree.frame = CGRectMake(130, 24, 40.0, 30.0);
                }
            } else {
                self.overlayButtonOne.frame = CGRectMake(40, 9, 40.0, 30.0);
                self.overlayButtonTwo.frame = CGRectMake(85, 9, 40.0, 30.0);
                self.overlayButtonThree.frame = CGRectMake(130, 9, 40.0, 30.0);
            }
            [self addSubview:self.overlayButtonOne];
            [self addSubview:self.overlayButtonTwo];
            [self addSubview:self.overlayButtonThree];
        }
    }
    return self;
}

- (void)setTopOverlayVisible:(BOOL)visible isAutonavCanceledState:(BOOL)canceledState {
    int overlayButtonsCount = [overlayButtons count];
    if (canceledState) {
        if (overlayButtonsCount == 1) {
            if (!self.overlayButtonOne.hidden) {
                self.overlayButtonOne.alpha = 0.0;
            }
        }
        if (overlayButtonsCount == 2) {
            if (!self.overlayButtonOne.hidden) {
                self.overlayButtonOne.alpha = 0.0;
            }
            if (!self.overlayButtonTwo.hidden) {
                self.overlayButtonTwo.alpha = 0.0;
            }
        }
        if (overlayButtonsCount == 3) {
            if (!self.overlayButtonOne.hidden) {
                self.overlayButtonOne.alpha = 0.0;
            }
            if (!self.overlayButtonTwo.hidden) {
                self.overlayButtonTwo.alpha = 0.0;
            }
            if (!self.overlayButtonThree.hidden) {
                self.overlayButtonThree.alpha = 0.0;
            }
        }
    } else {
        if (overlayButtonsCount == 1) {
            if (!self.overlayButtonOne.hidden) {
                int rotation = [layoutOut playerViewLayout];
                if (rotation == 2) {
                    self.overlayButtonOne.alpha = visible ? 1.0 : 0.0;
                } else {
                    self.overlayButtonOne.alpha = 0.0;
                }
            }
        }
        if (overlayButtonsCount == 2) {
            if (!self.overlayButtonOne.hidden) {
                int rotation = [layoutOut playerViewLayout];
                if (rotation == 2) {
                    self.overlayButtonOne.alpha = visible ? 1.0 : 0.0;
                } else {
                    self.overlayButtonOne.alpha = 0.0;
                }
            }
            if (!self.overlayButtonTwo.hidden) {
                int rotation = [layoutOut playerViewLayout];
                if (rotation == 2) {
                    self.overlayButtonTwo.alpha = visible ? 1.0 : 0.0;
                } else {
                    self.overlayButtonTwo.alpha = 0.0;
                }
            }
        }
        if (overlayButtonsCount == 3) {
            if (!self.overlayButtonOne.hidden) {
                int rotation = [layoutOut playerViewLayout];
                if (rotation == 2) {
                    self.overlayButtonOne.alpha = visible ? 1.0 : 0.0;
                } else {
                    self.overlayButtonOne.alpha = 0.0;
                }
            }
            if (!self.overlayButtonTwo.hidden) {
                int rotation = [layoutOut playerViewLayout];
                if (rotation == 2) {
                    self.overlayButtonTwo.alpha = visible ? 1.0 : 0.0;
                } else {
                    self.overlayButtonTwo.alpha = 0.0;
                }
            }
            if (!self.overlayButtonThree.hidden) {
                int rotation = [layoutOut playerViewLayout];
                if (rotation == 2) {
                    self.overlayButtonThree.alpha = visible ? 1.0 : 0.0;
                } else {
                    self.overlayButtonThree.alpha = 0.0;
                }
            }
        }
    }
    %orig;
}

%new
- (BOOL)iOSCheck {
    return SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"14.0");
}

%new;
- (void)playInApp {
    MRMediaRemoteSendCommand(MRMediaRemoteCommandPause, 0);
    XCDYouTubeClient.innertubeApiKey = @"AIzaSyAn6rSGWtyWjsoTrtDmIQJxH42d6daE_sc";

    videoIdentifier = [playingVideoID currentVideoID];

    [[XCDYouTubeClient defaultClient] getVideoWithIdentifier:videoIdentifier completionHandler:^(XCDYouTubeVideo *video, NSError *error) {
        if (video) {
            NSDictionary *streamURLs = video.streamURLs;
            streamURL = streamURLs[XCDYouTubeVideoQualityHTTPLiveStreaming];
            NSLog(@"%@", streamURL);

            if (streamURL != NULL) {
                UIWindow *alertWindowMenu = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
                alertWindowMenu.rootViewController = [UIViewController new];
                alertWindowMenu.windowLevel = UIWindowLevelAlert + 1;
                alertWindowOutMenu = alertWindowMenu;

                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Options" message:nil preferredStyle:UIAlertControllerStyleAlert];

                [alert addAction:[UIAlertAction actionWithTitle:@"Play In Infuse" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    alertWindowMenu.hidden = YES;
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"infuse://x-callback-url/play?url=%@", streamURL]] options:@{} completionHandler:nil];
                }]];

                [alert addAction:[UIAlertAction actionWithTitle:@"Play In VLC" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    alertWindowMenu.hidden = YES;
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"vlc-x-callback://x-callback-url/stream?url=%@", streamURL]] options:@{} completionHandler:nil];
                }]];

                [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    alertWindowMenu.hidden = YES;
                }]];

                [alertWindowMenu makeKeyAndVisible];
                [alertWindowMenu.rootViewController presentViewController:alert animated:YES completion:nil];
            } else {
                UIWindow *alertWindowFailed = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
                alertWindowFailed.rootViewController = [UIViewController new];
                alertWindowFailed.windowLevel = UIWindowLevelAlert + 1;
                alertWindowOutFailed = alertWindowFailed;

                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Notice" message:@"This video is not supported by Infuse or VLC" preferredStyle:UIAlertControllerStyleAlert];

                [alert addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    alertWindowFailed.hidden = YES;
                }]];

                [alertWindowFailed makeKeyAndVisible];
                [alertWindowFailed.rootViewController presentViewController:alert animated:YES completion:nil];
            }
        } else {
            UIWindow *alertWindowUrlError = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
            alertWindowUrlError.rootViewController = [UIViewController new];
            alertWindowUrlError.windowLevel = UIWindowLevelAlert + 1;
            alertWindowOutUrlError = alertWindowUrlError;

            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Notice" message:@"Unable to fetch youtube video url from googles api" preferredStyle:UIAlertControllerStyleAlert];

            [alert addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                alertWindowUrlError.hidden = YES;
            }]];

            [alertWindowUrlError makeKeyAndVisible];
            [alertWindowUrlError.rootViewController presentViewController:alert animated:YES completion:nil];
        }
    }];
}

%new;
- (void)optionsAction:(id)sender {
    MRMediaRemoteSendCommand(MRMediaRemoteCommandPause, 0);

    UIWindow *alertWindowMenu = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    alertWindowMenu.rootViewController = [UIViewController new];
    alertWindowMenu.windowLevel = UIWindowLevelAlert + 1;
    alertWindowOutMenu = alertWindowMenu;

    UIAlertController *alertMenu = [UIAlertController alertControllerWithTitle:@"Options" message:nil preferredStyle:UIAlertControllerStyleAlert];

    [alertMenu addAction:[UIAlertAction actionWithTitle:@"Download Audio (M4A Audio)" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        alertWindowMenu.hidden = YES;
        [self audioDownloader];
    }]];

    [alertMenu addAction:[UIAlertAction actionWithTitle:@"Download Video (MP4 Video)" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        alertWindowMenu.hidden = YES;
        [self videoDownloader];
    }]];

    [alertMenu addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        alertWindowMenu.hidden = YES;
    }]];

    [alertWindowMenu makeKeyAndVisible];
    [alertWindowMenu.rootViewController presentViewController:alertMenu animated:YES completion:nil];
}

%new;
- (void)audioDownloader {
    MRMediaRemoteSendCommand(MRMediaRemoteCommandPause, 0);
    XCDYouTubeClient.innertubeApiKey = @"AIzaSyAn6rSGWtyWjsoTrtDmIQJxH42d6daE_sc";

    videoIdentifier = [playingVideoID currentVideoID];

    [[XCDYouTubeClient defaultClient] getVideoWithIdentifier:videoIdentifier completionHandler:^(XCDYouTubeVideo *video, NSError *error) {
        if (video) {
            NSDictionary *streamURLs = video.streamURLs;
            streamURL = streamURLs[@(XCDYouTubeVideoQualityHD720)] ?: streamURLs[@(XCDYouTubeVideoQualityMedium360)] ?: streamURLs[@(XCDYouTubeVideoQualitySmall240)];
            
            if (streamURL != NULL) {
                NSURLSessionConfiguration *dataConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
                AFURLSessionManager *dataManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:dataConfiguration];

                NSString *apiUrl = [NSString stringWithFormat:@"https://www.googleapis.com/youtube/v3/videos?part=snippet&id=%@&key=AIzaSyAn6rSGWtyWjsoTrtDmIQJxH42d6daE_sc", videoIdentifier];
                NSURL *dataUrl = [NSURL URLWithString:apiUrl];
                NSURLRequest *apiRequest = [NSURLRequest requestWithURL:dataUrl];

                NSURLSessionDataTask *dataTask = [dataManager dataTaskWithRequest:apiRequest uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
                    if (error) {
                        NSLog(@"Error: %@", error);
                    } else {
                        NSMutableDictionary *jsonResponse = responseObject;
                        NSArray *items = [jsonResponse objectForKey:@"items"];
                        NSString *escapedString;
                        for (NSDictionary *item in items) {
                            NSDictionary *snippet = [item objectForKey:@"snippet"];
                            NSString *title = [snippet objectForKey:@"title"];
                            NSCharacterSet *notAllowedChars = [[NSCharacterSet alphanumericCharacterSet] invertedSet];
                            escapedString = [[title componentsSeparatedByCharactersInSet:notAllowedChars] componentsJoinedByString:@""];
                        }
                        UIWindow *alertWindowDownloading = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
                        alertWindowDownloading.rootViewController = [UIViewController new];
                        alertWindowDownloading.windowLevel = UIWindowLevelAlert + 1;
                        alertWindowOutDownloading = alertWindowDownloading;

                        UIAlertController *alertDownloading = [UIAlertController alertControllerWithTitle:@"Notice" message:[NSString stringWithFormat:@"Audio Is Downloading \n\nProgress: 0.00%% \n\nDon't Exit The App"] preferredStyle:UIAlertControllerStyleAlert];

                        [alertWindowDownloading makeKeyAndVisible];
                        [alertWindowDownloading.rootViewController presentViewController:alertDownloading animated:YES completion:nil];
            
                        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
                        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
                        NSURLRequest *request = [NSURLRequest requestWithURL:streamURL];

                        NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                float downloadPercent = downloadProgress.fractionCompleted * 100;
                                alertDownloading.message = [NSString stringWithFormat:@"Audio Is Downloading \n\nProgress: %.02f%% \n\nDon't Exit The App", downloadPercent];
                            });
                        } destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
                            NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
                            return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
                        } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
                            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                            NSString *documentsDirectory = [paths objectAtIndex:0];
                            
                            NSURL *outputURL = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/videoplayback.m4a", documentsDirectory]];
                            NSURL *inputURL = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/videoplayback.mp4", documentsDirectory]];
                            AVAsset *asset = [AVAsset assetWithURL:inputURL];

                            AVAssetExportSession *session = [[AVAssetExportSession alloc] initWithAsset:asset presetName:AVAssetExportPresetPassthrough];
                            session.outputURL = outputURL;
                            session.outputFileType = AVFileTypeAppleM4A;

                            [session exportAsynchronouslyWithCompletionHandler:^{
                                if (session.status == AVAssetExportSessionStatusCompleted) {
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        NSString *oldVideoName = [NSString stringWithFormat:@"%@/videoplayback.mp4", documentsDirectory];
                                        NSString *oldName = [NSString stringWithFormat:@"%@/videoplayback.m4a", documentsDirectory];
                                        NSString *newName = [NSString stringWithFormat:@"%@/%@.m4a", documentsDirectory, escapedString];
                                        [[NSFileManager defaultManager] removeItemAtPath:oldVideoName error:nil];
                                        [[NSFileManager defaultManager] moveItemAtPath:oldName toPath:newName error:nil];
                                        alertWindowDownloading.hidden = YES;
                                        UIWindow *alertWindowDownloaded = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
                                        alertWindowDownloaded.rootViewController = [UIViewController new];
                                        alertWindowDownloaded.windowLevel = UIWindowLevelAlert + 1;
                                        alertWindowOutDownloaded = alertWindowDownloaded;

                                        UIAlertController *alertDownloaded = [UIAlertController alertControllerWithTitle:@"Notice" message:@"Audio Download Complete" preferredStyle:UIAlertControllerStyleAlert];

                                        [alertDownloaded addAction:[UIAlertAction actionWithTitle:@"Finish" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                                            alertWindowDownloaded.hidden = YES;
                                        }]];

                                        [alertWindowDownloaded makeKeyAndVisible];
                                        [alertWindowDownloaded.rootViewController presentViewController:alertDownloaded animated:YES completion:nil];
                                    });
                                }
                            }];
                        }];
                        [downloadTask resume];
                    }
                }];
                [dataTask resume];
            } else {
                UIWindow *alertWindowFailed = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
                alertWindowFailed.rootViewController = [UIViewController new];
                alertWindowFailed.windowLevel = UIWindowLevelAlert + 1;
                alertWindowOutFailed = alertWindowFailed;

                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Notice" message:@"This video is not supported by the downloader" preferredStyle:UIAlertControllerStyleAlert];

                [alert addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    alertWindowFailed.hidden = YES;
                }]];

                [alertWindowFailed makeKeyAndVisible];
                [alertWindowFailed.rootViewController presentViewController:alert animated:YES completion:nil];
            }
        } else {
            UIWindow *alertWindowUrlError = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
            alertWindowUrlError.rootViewController = [UIViewController new];
            alertWindowUrlError.windowLevel = UIWindowLevelAlert + 1;
            alertWindowOutUrlError = alertWindowUrlError;

            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Notice" message:@"Unable to fetch youtube video url from googles api" preferredStyle:UIAlertControllerStyleAlert];

            [alert addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                alertWindowUrlError.hidden = YES;
            }]];

            [alertWindowUrlError makeKeyAndVisible];
            [alertWindowUrlError.rootViewController presentViewController:alert animated:YES completion:nil];
        }
    }];
}

%new;
- (void)videoDownloader {
    MRMediaRemoteSendCommand(MRMediaRemoteCommandPause, 0);
    XCDYouTubeClient.innertubeApiKey = @"AIzaSyAn6rSGWtyWjsoTrtDmIQJxH42d6daE_sc";

    videoIdentifier = [playingVideoID currentVideoID];

    [[XCDYouTubeClient defaultClient] getVideoWithIdentifier:videoIdentifier completionHandler:^(XCDYouTubeVideo *video, NSError *error) {
        if (video) {
            NSDictionary *streamURLs = video.streamURLs;
            streamURL = streamURLs[@(XCDYouTubeVideoQualityHD720)] ?: streamURLs[@(XCDYouTubeVideoQualityMedium360)] ?: streamURLs[@(XCDYouTubeVideoQualitySmall240)];
            
            if (streamURL != NULL) {
                NSURLSessionConfiguration *dataConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
                AFURLSessionManager *dataManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:dataConfiguration];

                NSString *apiUrl = [NSString stringWithFormat:@"https://www.googleapis.com/youtube/v3/videos?part=snippet&id=%@&key=AIzaSyAn6rSGWtyWjsoTrtDmIQJxH42d6daE_sc", videoIdentifier];
                NSURL *dataUrl = [NSURL URLWithString:apiUrl];
                NSURLRequest *apiRequest = [NSURLRequest requestWithURL:dataUrl];

                NSURLSessionDataTask *dataTask = [dataManager dataTaskWithRequest:apiRequest uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
                    if (error) {
                        NSLog(@"Error: %@", error);
                    } else {
                        NSMutableDictionary *jsonResponse = responseObject;
                        NSArray *items = [jsonResponse objectForKey:@"items"];
                        NSString *escapedString;
                        for (NSDictionary *item in items) {
                            NSDictionary *snippet = [item objectForKey:@"snippet"];
                            NSString *title = [snippet objectForKey:@"title"];
                            NSCharacterSet *notAllowedChars = [[NSCharacterSet alphanumericCharacterSet] invertedSet];
                            escapedString = [[title componentsSeparatedByCharactersInSet:notAllowedChars] componentsJoinedByString:@""];
                        }
                        UIWindow *alertWindowDownloading = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
                        alertWindowDownloading.rootViewController = [UIViewController new];
                        alertWindowDownloading.windowLevel = UIWindowLevelAlert + 1;
                        alertWindowOutDownloading = alertWindowDownloading;

                        UIAlertController *alertDownloading = [UIAlertController alertControllerWithTitle:@"Notice" message:[NSString stringWithFormat:@"Video Is Downloading \n\nProgress: 0.00%% \n\nDon't Exit The App"] preferredStyle:UIAlertControllerStyleAlert];

                        [alertWindowDownloading makeKeyAndVisible];
                        [alertWindowDownloading.rootViewController presentViewController:alertDownloading animated:YES completion:nil];
            
                        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
                        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
                        NSURLRequest *request = [NSURLRequest requestWithURL:streamURL];

                        NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                float downloadPercent = downloadProgress.fractionCompleted * 100;
                                alertDownloading.message = [NSString stringWithFormat:@"Video Is Downloading \n\nProgress: %.02f%% \n\nDon't Exit The App", downloadPercent];
                            });
                        } destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
                            NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
                            return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
                        } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
                            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                            NSString *documentsDirectory = [paths objectAtIndex:0];
                            NSString *oldName = [NSString stringWithFormat:@"%@/videoplayback.mp4", documentsDirectory];
                            NSString *newName = [NSString stringWithFormat:@"%@/%@.mp4", documentsDirectory, escapedString];
                            [[NSFileManager defaultManager] moveItemAtPath:oldName toPath:newName error:nil];
                            alertWindowDownloading.hidden = YES;
                            UIWindow *alertWindowDownloaded = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
                            alertWindowDownloaded.rootViewController = [UIViewController new];
                            alertWindowDownloaded.windowLevel = UIWindowLevelAlert + 1;
                            alertWindowOutDownloaded = alertWindowDownloaded;

                            UIAlertController *alertDownloaded = [UIAlertController alertControllerWithTitle:@"Notice" message:@"Video Download Complete" preferredStyle:UIAlertControllerStyleAlert];

                            [alertDownloaded addAction:[UIAlertAction actionWithTitle:@"Finish" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                                alertWindowDownloaded.hidden = YES;
                            }]];

                            [alertWindowDownloaded makeKeyAndVisible];
                            [alertWindowDownloaded.rootViewController presentViewController:alertDownloaded animated:YES completion:nil];
                        }];
                        [downloadTask resume];
                    }
                }];
                [dataTask resume];
            } else {
                UIWindow *alertWindowFailed = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
                alertWindowFailed.rootViewController = [UIViewController new];
                alertWindowFailed.windowLevel = UIWindowLevelAlert + 1;
                alertWindowOutFailed = alertWindowFailed;

                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Notice" message:@"This video is not supported by the downloader" preferredStyle:UIAlertControllerStyleAlert];

                [alert addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    alertWindowFailed.hidden = YES;
                }]];

                [alertWindowFailed makeKeyAndVisible];
                [alertWindowFailed.rootViewController presentViewController:alert animated:YES completion:nil];
            }
        } else {
            UIWindow *alertWindowUrlError = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
            alertWindowUrlError.rootViewController = [UIViewController new];
            alertWindowUrlError.windowLevel = UIWindowLevelAlert + 1;
            alertWindowOutUrlError = alertWindowUrlError;

            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Notice" message:@"Unable to fetch youtube video url from googles api" preferredStyle:UIAlertControllerStyleAlert];

            [alert addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                alertWindowUrlError.hidden = YES;
            }]];

            [alertWindowUrlError makeKeyAndVisible];
            [alertWindowUrlError.rootViewController presentViewController:alert animated:YES completion:nil];
        }
    }];
}

%new;
- (void)pictureInPicture {
    MRMediaRemoteSendCommand(MRMediaRemoteCommandPause, 0);
    XCDYouTubeClient.innertubeApiKey = @"AIzaSyAn6rSGWtyWjsoTrtDmIQJxH42d6daE_sc";

    AVPlayerViewController *playerViewController = [AVPlayerViewController new];
    __weak AVPlayerViewController *weakPlayerViewController = playerViewController;

    videoIdentifier = [playingVideoID currentVideoID];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kEnableBackgroundPlayback"] == YES) {
        [[XCDYouTubeClient defaultClient] getVideoWithIdentifier:videoIdentifier completionHandler:^(XCDYouTubeVideo *video, NSError *error) {
            if (video) {
                NSDictionary *streamURLs = video.streamURLs;
                streamURL = streamURLs[@(XCDYouTubeVideoQualityHD720)] ?: streamURLs[@(XCDYouTubeVideoQualityMedium360)] ?: streamURLs[@(XCDYouTubeVideoQualitySmall240)] ?: streamURLs[XCDYouTubeVideoQualityHTTPLiveStreaming];
                
                NSString *videoTime = [NSString stringWithFormat: @"%f", [resultOut mediaTime]];
                float backToFloat = [videoTime floatValue];

                UIWindow *alertWindowPip = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
                alertWindowPip.rootViewController = [UIViewController new];
                alertWindowPip.windowLevel = UIWindowLevelAlert + 1;
                alertWindowOutPip = alertWindowPip;
        
                weakPlayerViewController.player = [AVPlayer playerWithURL:streamURL];
                int32_t timeScale = weakPlayerViewController.player.currentItem.asset.duration.timescale;
                CMTime newTime = CMTimeMakeWithSeconds(backToFloat, timeScale);
                @try {
                    weakPlayerViewController.allowsPictureInPicturePlayback = YES;
                    if ([weakPlayerViewController respondsToSelector:@selector(setCanStartPictureInPictureAutomaticallyFromInline:)]) {
                        weakPlayerViewController.canStartPictureInPictureAutomaticallyFromInline = YES;
                    }
                    [weakPlayerViewController.player seekToTime:newTime completionHandler: ^(BOOL finished) {
                        [weakPlayerViewController.player play];
                    }];
                } 
                @catch(id anException) {
                    weakPlayerViewController.allowsPictureInPicturePlayback = YES;
                    if ([weakPlayerViewController respondsToSelector:@selector(setCanStartPictureInPictureAutomaticallyFromInline:)]) {
                        weakPlayerViewController.canStartPictureInPictureAutomaticallyFromInline = YES;
                    }
                    [weakPlayerViewController.player play];
                }

                [alertWindowPip makeKeyAndVisible];
                [alertWindowPip.rootViewController presentViewController:playerViewController animated:YES completion:nil];
            } else {
                UIWindow *alertWindowUrlError = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
                alertWindowUrlError.rootViewController = [UIViewController new];
                alertWindowUrlError.windowLevel = UIWindowLevelAlert + 1;
                alertWindowOutUrlError = alertWindowUrlError;

                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Notice" message:@"Unable to fetch youtube video url from googles api" preferredStyle:UIAlertControllerStyleAlert];

                [alert addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    alertWindowUrlError.hidden = YES;
                }]];

                [alertWindowUrlError makeKeyAndVisible];
                [alertWindowUrlError.rootViewController presentViewController:alert animated:YES completion:nil];
            }
        }];
    } else {
        UIWindow *alertWindowPip = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        alertWindowPip.rootViewController = [UIViewController new];
        alertWindowPip.windowLevel = UIWindowLevelAlert + 1;
        alertWindowOutPip = alertWindowPip;

        UIAlertController *alertPip = [UIAlertController alertControllerWithTitle:@"Notice" message:@"\n You must enable 'Background Playback' in YouTube Reborn settings to use Picture-In-Picture \n" preferredStyle:UIAlertControllerStyleAlert];

        [alertPip addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            alertWindowPip.hidden = YES;
        }]];
                
        [alertWindowPip makeKeyAndVisible];
        [alertWindowPip.rootViewController presentViewController:alertPip animated:YES completion:nil];
    }
}
%end

UIWindow *alertWindowOutPlayer;

%hook AVPlayerViewController
- (void)viewWillDisappear:(BOOL)animated {
    alertWindowOutPlayer.hidden = YES;
    alertWindowOutPip.hidden = YES;
    %orig;
}
%end

%group gNoVideoAds
%hook YTAdsInnerTubeContextDecorator
- (void)decorateContext:(id)arg1 {
}
%end
%hook YTInnerTubeContextDecorator
- (void)decorateContext:(id)arg1 {
}
%end
%end

%group gBackgroundPlayback
%hook YTIPlayerResponse
- (BOOL)isPlayableInBackground {
    return 1;
}
%end
%hook YTSingleVideo
- (BOOL)isPlayableInBackground {
    return 1;
}
%end
%hook YTSingleVideoMediaData
- (BOOL)isPlayableInBackground {
    return 1;
}
%end
%hook YTPlaybackData
- (BOOL)isPlayableInBackground {
    return 1;
}
%end
%hook YTIPlayabilityStatus
- (BOOL)isPlayableInBackground {
    return 1;
}
%end
%hook YTPlaybackBackgroundTaskController
- (BOOL)isContentPlayableInBackground {
    return 1;
}
- (void)setContentPlayableInBackground:(BOOL)arg1 {
    arg1 = 1;
	%orig;
}
%end
%hook YTBackgroundabilityPolicy
- (BOOL)isBackgroundableByUserSettings {
    return 1;
}
%end
%end

%group gNoDownloadButton
%hook YTTransferButton
- (void)setVisible:(BOOL)arg1 dimmed:(BOOL)arg2 {
    arg1 = 0;
	%orig;
}
%end
%end

%group gNoCommentsSection
%hook YTCommentSectionControllerBuilder
- (void)loadSectionController:(id)arg1 withModel:(id)arg2 {
} 
%end
%end

%group gNoCastButton
%hook YTSettings
- (BOOL)disableMDXDeviceDiscovery {
    return 1;
} 
%end
%hook YTRightNavigationButtons
- (void)layoutSubviews {
	%orig();
	if(![[self MDXButton] isHidden]) [[self MDXButton] setHidden: YES];
}
%end
%hook YTMainAppControlsOverlayView
- (void)layoutSubviews {
	%orig();
	if(![[self playbackRouteButton] isHidden]) [[self playbackRouteButton] setHidden: YES];
}
%end
%end

%group gNoNotificationButton
%hook YTNotificationPreferenceToggleButton
- (void)setHidden:(BOOL)arg1 {
    arg1 = 1;
    %orig;
}
%end
%hook YTNotificationMultiToggleButton
- (void)setHidden:(BOOL)arg1 {
    arg1 = 1;
    %orig;
}
%end
%hook YTRightNavigationButtons
- (void)layoutSubviews {
	%orig();
	if(![[self notificationButton] isHidden]) [[self notificationButton] setHidden: YES];
}
%end
%end

%group gAllowHDOnCellularData
%hook YTUserDefaults
- (BOOL)disableHDOnCellular {
	return 0;
}
- (void)setDisableHDOnCellular:(BOOL)arg1 {
    arg1 = 0;
    %orig;
}
%end
%hook YTSettings
- (BOOL)disableHDOnCellular {
	return 0;
}
- (void)setDisableHDOnCellular:(BOOL)arg1 {
    arg1 = 0;
    %orig;
}
%end
%end

%group gShowStatusBarInOverlay
%hook YTSettings
- (BOOL)showStatusBarWithOverlay {
    return 1;
}
%end
%end

%group gDisableRelatedVideosInOverlay
%hook YTRelatedVideosViewController
- (BOOL)isEnabled {
    return 0;
}
- (void)setEnabled:(BOOL)arg1 {
    arg1 = 0;
	%orig;
}
%end
%hook YTFullscreenEngagementOverlayView
- (BOOL)isEnabled {
    return 0;
} 
- (void)setEnabled:(BOOL)arg1 {
    arg1 = 0;
    %orig;
} 
%end
%hook YTFullscreenEngagementOverlayController
- (BOOL)isEnabled {
    return 0;
}
- (void)setEnabled:(BOOL)arg1 {
    arg1 = 0;
    %orig;
}
%end
%hook YTMainAppVideoPlayerOverlayView
- (void)setInfoCardButtonHidden:(BOOL)arg1 {
    arg1 = 1;
    %orig;
}
- (void)setInfoCardButtonVisible:(BOOL)arg1 {
    arg1 = 0;
    %orig;
}
%end
%hook YTMainAppVideoPlayerOverlayViewController
- (void)adjustPlayerBarPositionForRelatedVideos {
}
%end
%end

%group gDisableVideoEndscreenPopups
%hook YTCreatorEndscreenView
- (id)initWithFrame:(CGRect)arg1 {
    return NULL;
}
%end
%end

%group gDisableYouTubeKids
%hook YTWatchMetadataAppPromoCell
- (id)initWithFrame:(CGRect)arg1 {
    return NULL;
}
%end
%hook YTHUDMessageView
- (id)initWithMessage:(id)arg1 dismissHandler:(id)arg2 {
    return NULL;
}
%end
%hook YTNGWatchMiniBarViewController
- (id)miniplayerRenderer {
    return NULL;
}
%end
%hook YTWatchMiniBarViewController
- (id)miniplayerRenderer {
    return NULL;
}
%end
%end

%group gDisableVoiceSearch
%hook YTSearchTextField
- (void)setVoiceSearchEnabled:(BOOL)arg1 {
    arg1 = 0;
	%orig;
}
%end
%end

%group gDisableHints
%hook YTSettings
- (BOOL)areHintsDisabled {
	return 1;
}
- (void)setHintsDisabled:(BOOL)arg1 {
    arg1 = 1;
    %orig;
}
%end
%hook YTUserDefaults
- (BOOL)areHintsDisabled {
	return 1;
}
- (void)setHintsDisabled:(BOOL)arg1 {
    arg1 = 1;
    %orig;
}
%end
%end

%group gHideExploreTab
%hook YTPivotBarView
- (void)layoutSubviews {
	%orig();
	MSHookIvar<YTPivotBarItemView *>(self, "_itemView2").hidden = YES;
}
- (YTPivotBarItemView *)itemView2 {
	return 1 ? 0 : %orig;
}
%end
%end

%group gHideUploadTab
%hook YTPivotBarView
- (void)layoutSubviews {
	%orig();
	MSHookIvar<YTPivotBarItemView *>(self, "_itemView3").hidden = YES;
}
- (YTPivotBarItemView *)itemView3 {
	return 1 ? 0 : %orig;
}
%end
%end

%group gHideSubscriptionsTab
%hook YTPivotBarView
- (void)layoutSubviews {
	%orig();
	MSHookIvar<YTPivotBarItemView *>(self, "_itemView4").hidden = YES;
}
- (YTPivotBarItemView *)itemView4 {
	return 1 ? 0 : %orig;
}
%end
%end

%group gHideLibraryTab
%hook YTPivotBarView
- (void)layoutSubviews {
	%orig();
	MSHookIvar<YTPivotBarItemView *>(self, "_itemView5").hidden = YES;
}
- (YTPivotBarItemView *)itemView5 {
	return 1 ? 0 : %orig;
}
%end
%end

%group gDisableDoubleTapToSkip
%hook YTDoubleTapToSeekController
- (void)enableDoubleTapToSeek:(BOOL)arg1 {
    arg1 = 0;
    %orig;
}
- (void)showDoubleTapToSeekEducationView:(BOOL)arg1 {
    arg1 = 0;
    %orig;
}
%end
%hook YTSettings
- (BOOL)doubleTapToSeekEnabled {
    return 0;
}
%end
%end

%group gNoTopicsSection
%hook YTMySubsFilterHeaderViewController
- (id)loadChipFilterFromModel:(id)arg1 {
    return NULL;
}
%end
%end

%group gHideOverlayDarkBackground
%hook YTMainAppVideoPlayerOverlayView
- (void)setBackgroundVisible:(BOOL)arg1 {
    arg1 = 0;
	%orig;
}
%end
%end

%group gAlwaysShowPlayerBar
%hook YTPlayerBarController
- (void)setPlayerViewLayout:(int)arg1 {
    arg1 = 2;
    %orig;
} 
%end
%hook YTRelatedVideosViewController
- (BOOL)isEnabled {
    return 0;
}
- (void)setEnabled:(BOOL)arg1 {
    arg1 = 0;
	%orig;
}
%end
%hook YTFullscreenEngagementOverlayView
- (BOOL)isEnabled {
    return 0;
} 
- (void)setEnabled:(BOOL)arg1 {
    arg1 = 0;
    %orig;
} 
%end
%hook YTFullscreenEngagementOverlayController
- (BOOL)isEnabled {
    return 0;
}
- (void)setEnabled:(BOOL)arg1 {
    arg1 = 0;
    %orig;
}
%end
%hook YTMainAppVideoPlayerOverlayView
- (void)setInfoCardButtonHidden:(BOOL)arg1 {
    arg1 = 1;
    %orig;
}
- (void)setInfoCardButtonVisible:(BOOL)arg1 {
    arg1 = 0;
    %orig;
}
%end
%hook YTMainAppVideoPlayerOverlayViewController
- (void)adjustPlayerBarPositionForRelatedVideos {
}
%end
%end

%group gEnableiPadStyleOniPhone
%hook UIDevice
- (long long)userInterfaceIdiom {
    return 1;
} 
%end
%hook UIStatusBarStyleAttributes
- (long long)idiom {
    return 0;
} 
%end
%hook UIKBTree
- (long long)nativeIdiom {
    return 0;
} 
%end
%hook UIKBRenderer
- (long long)assetIdiom {
    return 0;
} 
%end
%end

%group gHidePreviousAndNextButtonInOverlay
%hook YTMainAppSkipVideoButton
- (void)layoutSubviews {
	%orig();
	if(![[self imageView] isHidden]) [[self imageView] setHidden: YES];
}
- (BOOL)isHidden {
	return 1;
}
%end
%hook YTMainAppControlsOverlayView
- (void)layoutSubviews {
	%orig();
	MSHookIvar<YTMainAppControlsOverlayView *>(self, "_previousButton").hidden = YES;
	MSHookIvar<YTMainAppControlsOverlayView *>(self, "_nextButton").hidden = YES;
}
%end
%end

%group gDisableVideoAutoPlay
%hook YTPlaybackConfig
- (void)setStartPlayback:(BOOL)arg1 {
	arg1 = 0;
	%orig;
}
%end
%end

%group gHideAutoPlaySwitchInOverlay
%hook YTMainAppControlsOverlayView
- (void)layoutSubviews {
	%orig();
	if(![[self autonavSwitch] isHidden]) [[self autonavSwitch] setHidden: YES];
}
%end
%end

%group gHideCaptionsSubtitlesButtonInOverlay
%hook YTMainAppControlsOverlayView
- (void)layoutSubviews {
	%orig();
    if(![[self closedCaptionsOrSubtitlesButton] isHidden]) [[self closedCaptionsOrSubtitlesButton] setHidden: YES];
}
%end
%end

%group gDisableVideoInfoCards
%hook YTInfoCardDarkTeaserContainerView
- (id)initWithFrame:(CGRect)arg1 {
    return NULL;
}
- (BOOL)isVisible {
    return 0;
}
%end
%hook YTInfoCardTeaserContainerView
- (id)initWithFrame:(CGRect)arg1 {
    return NULL;
}
- (BOOL)isVisible {
    return 0;
}
%end
%hook YTSimpleInfoCardDarkTeaserView
- (id)initWithFrame:(CGRect)arg1 {
    return NULL;
}
%end
%hook YTSimpleInfoCardTeaserView
- (id)initWithFrame:(CGRect)arg1 {
    return NULL;
}
%end
%hook YTPaidContentOverlayView
- (id)initWithParentResponder:(id)arg1 paidContentRenderer:(id)arg2 enableNewPaidProductDisclosure:(BOOL)arg3 {
    arg2 = NULL;
    arg3 = 0;
    return %orig;
}
%end
%end

%group gNoSearchButton
%hook YTRightNavigationButtons
- (void)layoutSubviews {
	%orig();
	if(![[self searchButton] isHidden]) [[self searchButton] setHidden: YES];
}
%end
%end

%group gHideTabBarLabels
%hook YTPivotBarItemView
- (void)layoutSubviews {
    %orig();
    [[self navigationButton] setTitle:@"" forState:UIControlStateNormal];
    [[self navigationButton] setTitle:@"" forState:UIControlStateSelected];
}
%end
%end

%group gHideChannelWatermark
%hook YTAnnotationsViewController
- (void)loadFeaturedChannelWatermark {
}
%end
%end

%group gUnlockUHDQuality
%hook YTSettings
- (BOOL)isWebMEnabled {
    return YES;
}
%end
%hook YTUserDefaults
- (int)manualQualitySelectionChosenResolution {
    return 2160;
}
- (int)ml_manualQualitySelectionChosenResolution {
    return 2160;
}
- (int)manualQualitySelectionPrecedingResolution {
    return 2160;
}
- (int)ml_manualQualitySelectionPrecedingResolution {
    return 2160;
}
%end
%hook MLManualFormatSelectionMetadata
- (int)stickyCeilingResolution {
    return 2160;
}
%end
%hook YTIHamplayerStreamFilter
- (BOOL)enableVideoCodecSplicing {
    return YES;
}
- (BOOL)hasVp9 {
    return YES;
}
%end
%hook YTIHamplayerSoftwareStreamFilter
- (int)maxFps {
    return 60;
}
- (int)maxArea {
    return 8294400;
}
%end
%end

%group gHideShortsCameraButton
%hook YTReelWatchPlaybackOverlayView
- (void)layoutSubviews {
	%orig();
	MSHookIvar<YTQTMButton *>(self, "_cameraOrSearchButton").hidden = YES;
}
%end
%end

%group gHideShortsMoreActionsButton
%hook YTReelWatchPlaybackOverlayView
- (void)layoutSubviews {
	%orig();
	MSHookIvar<YTQTMButton *>(self, "_overflowButton").hidden = YES;
}
%end
%end

%group gHideShortsLikeButton
%hook YTReelWatchPlaybackOverlayView
- (void)layoutSubviews {
	%orig();
	MSHookIvar<YTQTMButton *>(self, "_reelLikeButton").hidden = YES;
}
%end
%end

%group gHideShortsDislikeButton
%hook YTReelWatchPlaybackOverlayView
- (void)layoutSubviews {
	%orig();
	MSHookIvar<YTQTMButton *>(self, "_reelDislikeButton").hidden = YES;
}
%end
%end

%group gHideShortsCommentsButton
%hook YTReelWatchPlaybackOverlayView
- (void)layoutSubviews {
	%orig();
	MSHookIvar<YTQTMButton *>(self, "_viewCommentButton").hidden = YES;
}
%end
%end

%group gHideShortsShareButton
%hook YTReelWatchPlaybackOverlayView
- (void)layoutSubviews {
	%orig();
	MSHookIvar<YTQTMButton *>(self, "_shareButton").hidden = YES;
}
%end
%end

%group gColourOptions
%hook UIView
- (void)setBackgroundColor:(UIColor *)color {
    if([self.nextResponder isKindOfClass:NSClassFromString(@"YTPivotBarView")]) {
        color = hexColour();
    }
	if([self.nextResponder isKindOfClass:NSClassFromString(@"YTLinkCell")]) {
        color = hexColour();
    }
    if([self.nextResponder isKindOfClass:NSClassFromString(@"YCHLiveChatTextCell")]) {
        color = hexColour();
    }
    if([self.nextResponder isKindOfClass:NSClassFromString(@"YTVideoDismissedView")]) {
        color = hexColour();
    }
	if([self.nextResponder isKindOfClass:NSClassFromString(@"YTAccountHeaderView")]) {
        color = [[UIColor blackColor] colorWithAlphaComponent:0.0];
    }
	if([self.nextResponder isKindOfClass:NSClassFromString(@"YTFeedHeaderView")]) {
        color = hexColour();
    }
	if([self.nextResponder isKindOfClass:NSClassFromString(@"YTSearchView")]) {
        color = hexColour();
    }
    if([self.nextResponder isKindOfClass:NSClassFromString(@"YTPlaylistHeaderView")]) {
        color = hexColour();
    }
    if([self.nextResponder isKindOfClass:NSClassFromString(@"YTSlideForActionsView")]) {
        color = hexColour();
    }
    if([self.nextResponder isKindOfClass:NSClassFromString(@"YTCollectionView")]) {
        color = hexColour();
    }
    if([self.nextResponder isKindOfClass:NSClassFromString(@"YTAsyncCollectionView")]) {
        color = hexColour();
    }
    if([self.nextResponder isKindOfClass:NSClassFromString(@"YTCollectionSeparatorView")]) {
        color = hexColour();
    }
    if([self.nextResponder isKindOfClass:NSClassFromString(@"YTDrawerAvatarCell")]) {
        color = hexColour();
    }
    if([self.nextResponder isKindOfClass:NSClassFromString(@"YTChipCloudCell")]) {
        color = hexColour();
    }
    if([self.nextResponder isKindOfClass:NSClassFromString(@"YTEditSheetControllerHeader")]) {
        color = hexColour();
    }
    if([self.nextResponder isKindOfClass:NSClassFromString(@"YTCommentsHeaderView")]) {
        color = hexColour();
    }
    if([self.nextResponder isKindOfClass:NSClassFromString(@"YTEngagementPanelView")]) {
        color = hexColour();
    }
    if([self.nextResponder isKindOfClass:NSClassFromString(@"YCHLiveChatTickerViewController")]) {
        color = hexColour();
    }
    if([self.nextResponder isKindOfClass:NSClassFromString(@"YCHLiveChatViewerEngagementCell")]) {
        color = hexColour();
    }
    if([self.nextResponder isKindOfClass:NSClassFromString(@"YTDonationCompanionCell")]) {
        color = hexColour();
    }
    if([self.nextResponder isKindOfClass:NSClassFromString(@"YTPlaylistPanelProminentThumbnailVideoCell")]) {
        color = hexColour();
    }
    %orig;
}
- (void)layoutSubviews {
    %orig();
    if([self.nextResponder isKindOfClass:NSClassFromString(@"_ASDisplayView")]) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
    }
}
%end
%hook YTCollectionView
- (void)setBackgroundColor:(UIColor *)color {
    if([self.nextResponder isKindOfClass:NSClassFromString(@"YCHLiveChatTickerCollectionViewController")]) {
        color = [[UIColor blackColor] colorWithAlphaComponent:0.0];
    } else {
        color = hexColour();
    }
    %orig;
}
%end
%hook YTWatchMiniBarView
- (void)setBackgroundColor:(UIColor *)color {
    UIColor *selectedColour = hexColour();
    color = selectedColour;
    %orig;
}
%end
%hook YTAsyncCollectionView
- (void)setBackgroundColor:(UIColor *)color {
    UIColor *selectedColour = hexColour();

    if([self.nextResponder isKindOfClass:NSClassFromString(@"YTCollectionViewController")]) {
        color = selectedColour;
    }
    if([self.nextResponder isKindOfClass:NSClassFromString(@"YTInnerTubeCollectionViewController")]) {
        color = selectedColour;
    }
    if([self.nextResponder isKindOfClass:NSClassFromString(@"YTRelatedVideosCollectionViewController")]) {
        color = [[UIColor blackColor] colorWithAlphaComponent:0.0];
    }
    if([self.nextResponder isKindOfClass:NSClassFromString(@"YTFullscreenMetadataHighlightsCollectionViewController")]) {
        color = [[UIColor blackColor] colorWithAlphaComponent:0.0];
    }
    if([self.nextResponder isKindOfClass:NSClassFromString(@"YCHAsyncLiveChatCollectionViewController")]) {
        color = [[UIColor blackColor] colorWithAlphaComponent:0.0];
    }
    if([self.nextResponder isKindOfClass:NSClassFromString(@"YTAppCollectionViewController")]) {
        color = selectedColour;
    }
    if([self.nextResponder isKindOfClass:NSClassFromString(@"YTWatchNextResultsViewController")]) {
        color = selectedColour;
    }
    %orig;
} 
%end
%hook YTVideoView
- (void)setBackgroundColor:(UIColor *)color {
    UIColor *selectedColour = hexColour();
    color = selectedColour;
    %orig;
}
%end
%hook YTCollectionSeparatorView
- (void)setBackgroundColor:(UIColor *)color {
    UIColor *selectedColour = hexColour();
    color = selectedColour;
    %orig;
} 
%end
%hook YTHeaderView
- (void)setBackgroundColor:(UIColor *)color {
    UIColor *selectedColour = hexColour();
    color = selectedColour;
    %orig;
} 
%end
%hook YTChannelListSubMenuView
- (void)setBackgroundColor:(UIColor *)color {
    UIColor *selectedColour = hexColour();
    color = selectedColour;
    %orig;
} 
%end
%hook YTHorizontalCardListView
- (void)setBackgroundColor:(UIColor *)color {
    UIColor *selectedColour = hexColour();
    color = selectedColour;
    %orig;
} 
%end
%hook YTPrivacyTosFooterView
- (void)setBackgroundColor:(UIColor *)color {
    UIColor *selectedColour = hexColour();
    color = selectedColour;
    %orig;
} 
%end
%hook YTNavigationBar
- (void)setBackgroundColor:(UIColor *)color {
    UIColor *selectedColour = hexColour();
    color = selectedColour;
    %orig;
}
- (void)setBarTintColor:(UIColor *)color {
    UIColor *selectedColour = hexColour();
    color = selectedColour;
    %orig;
}
%end
%hook YTSettingsCell
- (void)setBackgroundColor:(UIColor *)color {
    UIColor *selectedColour = hexColour();
    color = selectedColour;
    %orig;
} 
%end
%hook YTSearchBoxView
- (void)setBackgroundColor:(UIColor *)color {
    UIColor *selectedColour = hexColour();
    color = selectedColour;
    %orig;
}
%end
%hook YTSearchView
- (void)setBackgroundColor:(UIColor *)color {
    UIColor *selectedColour = hexColour();
    color = selectedColour;
    %orig;
}
%end
%hook YTReelShelfView
- (void)setBackgroundColor:(UIColor *)color {
    UIColor *selectedColour = hexColour();
    color = selectedColour;
    %orig;
}
%end
%hook YTReelShortsShelfItem
- (void)setBackgroundColor:(UIColor *)color {
    UIColor *selectedColour = hexColour();
    color = selectedColour;
    %orig;
}
%end
%hook YTNGWatchMiniBarView
- (void)setBackgroundColor:(UIColor *)color {
    UIColor *selectedColour = hexColour();
    color = selectedColour;
    %orig;
}
%end
%hook YTChannelSubMenuView
- (void)setBackgroundColor:(UIColor *)color {
    UIColor *selectedColour = hexColour();
    color = selectedColour;
    %orig;
}
%end
%hook YTC4TabbedHeaderView
- (void)setBackgroundColor:(UIColor *)color {
    UIColor *selectedColour = hexColour();
    color = selectedColour;
    %orig;
}
%end
%hook YTTabTitlesView
- (void)setBackgroundColor:(UIColor *)color {
    UIColor *selectedColour = hexColour();
    color = selectedColour;
    %orig;
}
%end
%hook YTPlaylistPanelView
- (void)setBackgroundColor:(UIColor *)color {
    UIColor *selectedColour = hexColour();
    color = selectedColour;
    %orig;
}
%end
%hook YTFeedChannelFilterHeaderView
- (void)setBackgroundColor:(UIColor *)color {
    UIColor *selectedColour = hexColour();
    color = selectedColour;
    %orig;
}
%end
%hook GOODialogView
- (void)setBackgroundColor:(UIColor *)color {
    UIColor *selectedColour = hexColour();
    color = selectedColour;
    %orig;
}
%end
%hook YTInlineSignInView
- (void)setBackgroundColor:(UIColor *)color {
    UIColor *selectedColour = hexColour();
    color = selectedColour;
    %orig;
}
%end
%hook GOOTransitionableView
- (void)setBackgroundColor:(UIColor *)color {
    UIColor *selectedColour = hexColour();
    color = selectedColour;
    %orig;
}
%end
%hook YTSlideForActionsView
- (void)layoutSubviews {
    %orig();
    UIColor *selectedColour = hexColour();
    MSHookIvar<YTSlideForActionsView *>(self, "_contentView").backgroundColor = selectedColour;
}
%end
%hook YTShareMainView
- (void)layoutSubviews {
    %orig();
    UIColor *selectedColour = hexColour();
    MSHookIvar<YTShareMainView *>(self, "_cancelButton").backgroundColor = selectedColour;
}
%end
%hook YTShareTitleView
- (void)setBackgroundColor:(UIColor *)color {
    UIColor *selectedColour = hexColour();
    color = selectedColour;
    %orig;
}
%end
%hook YTEngagementPanelHeaderView
- (void)setBackgroundColor:(UIColor *)color {
    UIColor *selectedColour = hexColour();
    color = selectedColour;
    %orig;
}
%end
%hook YTPermissionsView
- (void)setBackgroundColor:(UIColor *)color {
    UIColor *selectedColour = hexColour();
    color = selectedColour;
    %orig;
}
%end
%hook ELMView
- (void)layoutSubviews {
    %orig();
    UIColor *selectedColour = hexColour();
    self.backgroundColor = selectedColour;
}
%end
%hook YTTopAlignedView
- (void)setBackgroundColor:(UIColor *)color {
    UIColor *selectedColour = hexColour();
    color = selectedColour;
    %orig;
}
- (void)layoutSubviews {
    %orig();
    UIColor *selectedColour = hexColour();
    MSHookIvar<YTTopAlignedView *>(self, "_contentView").backgroundColor = selectedColour;
}
%end
%hook YTReelShelfItemView
- (void)setBackgroundColor:(UIColor *)color {
    UIColor *selectedColour = hexColour();
    color = selectedColour;
    %orig;
}
%end
%hook YTDialogContainerScrollView
- (void)setBackgroundColor:(UIColor *)color {
    UIColor *selectedColour = hexColour();
    color = selectedColour;
    %orig;
}
%end
%hook YTSubheaderContainerView
- (void)setBackgroundColor:(UIColor *)color {
    UIColor *selectedColour = hexColour();
    color = selectedColour;
    %orig;
}
%end
%hook YTCreateCommentAccessoryView
- (void)setBackgroundColor:(UIColor *)color {
    UIColor *selectedColour = hexColour();
    color = selectedColour;
    %orig;
}
%end
%hook YTCreateCommentTextView
- (void)setBackgroundColor:(UIColor *)color {
    UIColor *selectedColour = hexColour();
    color = selectedColour;
    %orig;
}
%end
%hook YTChannelListSubMenuAvatarView
- (void)setBackgroundColor:(UIColor *)color {
    UIColor *selectedColour = hexColour();
    color = selectedColour;
    %orig;
}
%end
%hook YTCommentView
- (void)setBackgroundColor:(UIColor *)color {
    UIColor *selectedColour = hexColour();
    color = selectedColour;
    %orig;
}
%end
%hook YCHLiveChatView
- (void)setBackgroundColor:(UIColor *)color {
    UIColor *selectedColour = hexColour();
    color = selectedColour;
    %orig;
}
%end
%hook YTMoviesAndShowsCompactMultiOfferView
- (void)setBackgroundColor:(UIColor *)color {
    UIColor *selectedColour = hexColour();
    color = selectedColour;
    %orig;
}
%end
%hook YTShelfHeaderView
- (void)setBackgroundColor:(UIColor *)color {
    UIColor *selectedColour = hexColour();
    color = selectedColour;
    %orig;
}
%end
%hook YTUniversalWatchCardBannerView
- (void)setBackgroundColor:(UIColor *)color {
    UIColor *selectedColour = hexColour();
    color = selectedColour;
    %orig;
}
%end
%hook YTEmojiTextView
- (void)setBackgroundColor:(UIColor *)color {
    UIColor *selectedColour = hexColour();
    color = selectedColour;
    %orig;
}
%end
%hook YCHLiveChatActionPanelView
- (void)setBackgroundColor:(UIColor *)color {
    UIColor *selectedColour = hexColour();
    color = selectedColour;
    %orig;
}
%end
%hook YTPlaylistMiniBarView
- (void)setBackgroundColor:(UIColor *)color {
    UIColor *selectedColour = hexColour();
    color = selectedColour;
    %orig;
}
%end
%hook YTDonationEngagementView
- (void)setBackgroundColor:(UIColor *)color {
    UIColor *selectedColour = hexColour();
    color = selectedColour;
    %orig;
}
%end
%hook GOONavigationHeaderView
- (void)layoutSubviews {
    %orig();
    UIColor *selectedColour = hexColour();
    MSHookIvar<GOONavigationHeaderView *>(self, "_statusBarBackgroundView").backgroundColor = selectedColour;
}
%end
%hook NIAttributedLabel
- (void)setBackgroundColor:(UIColor *)color {
    color = [[UIColor blackColor] colorWithAlphaComponent:0.0];
    %orig;
}
%end
%hook YTSearchSuggestionCollectionViewCell
- (void)updateColors {
}
%end
%end

/* %group gPictureInPicture
%hook YTBackgroundabilityPolicy
- (BOOL)isPlayableInPictureInPictureByUserSettings {
    return 1;
}
%end
%hook YTPlayerPIPController
- (BOOL)isPictureInPicturePossible {
    return 1;
}
- (BOOL)canEnablePictureInPicture {
    return 1;
}
- (BOOL)isPictureInPictureForceDisabled {
    return 0;
}
- (void)setPictureInPictureForceDisabled:(BOOL)arg1 {
    arg1 = 0;
    %orig;
}
%end
%hook YTPlayerResponse
- (BOOL)isPlayableInPictureInPicture {
    return 1;
}
%end
%hook MLPIPController
- (BOOL)pictureInPictureSupported {
    return 1;
}
- (BOOL)isPictureInPictureSupported {
    return 1;
}
%end
%hook AVPictureInPictureController
+ (BOOL)isPictureInPictureSupported {
    return 1;
}
- (void)setCanStartPictureInPictureAutomaticallyFromInline:(BOOL)canStartFromInline {
    canStartFromInline = 1;
    %orig;
}
%end
%hook YTIPlayabilityStatus
- (BOOL)isPlayableInPictureInPicture {
    return 1;
}
%end
%end */

/* %group gEnableAgeRestrictionBypass
%hook YTUserProfile
- (BOOL)hasLegalAge {
    return 1;
}
%end
%hook YTVideo
- (BOOL)isAdultContent {
    return 0;
} 
%end
%hook YTSettings
- (BOOL)isAdultContentConfirmed {
    return 1;
}
- (void)setAdultContentConfirmed:(BOOL)arg1 {
    arg1 = 1;
    %orig;
}
%end
%hook YTUserDefaults
- (BOOL)isAdultContentConfirmed {
    return 1;
}
- (void)setAdultContentConfirmed:(BOOL)arg1 {
    arg1 = 1;
    %orig;
}
%end
%hook YTPlayerRequestFactory
- (BOOL)adultContentConfirmed {
    return 1;
}
%end
%hook YTIdentityState
- (BOOL)isChild {
    return 0;
}
- (BOOL)isAdult {
    return 1;
}
%end
%hook YTIAccountItemRenderer
- (BOOL)isChild {
    return 0;
}
- (BOOL)isAdult {
    return 1;
}
%end
%hook YTIGaiaAuthenticatedIdentity
- (BOOL)isChild {
    return 0;
}
- (BOOL)isAdult {
    return 1;
}
%end
%hook YTIPlayabilityStatus
- (BOOL)isKoreanAgeVerificationRequired {
    return 0;
}
- (BOOL)isAgeCheckRequired {
    return 0;
}
- (BOOL)isContentCheckRequired {
    return 0;
}
- (BOOL)isMatureContentAgeVerificationRequired {
    return 0;
}
- (BOOL)isConfirmationRequired {
    return 0;
}
%end
%end */

%hook YTColdConfig
- (BOOL)shouldUseAppThemeSetting {
    return 1;
}
- (BOOL)enableYouthereCommandsOnIos {
    return 0;
}
%end

%hook YTYouThereController
- (BOOL)shouldShowYouTherePrompt {
    return 0;
}
%end

%hook YTCommerceEventGroupHandler
- (void)addEventHandlers {
}
%end

%hook YTInterstitialPromoEventGroupHandler
- (void)addEventHandlers {
}
%end

%hook YTIShowFullscreenInterstitialCommand
- (BOOL)shouldThrottleInterstitial {
    return 1;
}
%end

%hook YTSettingsSectionItemManager
- (void)updatePremiumEarlyAccessSectionWithEntry:(id)arg1 {
}
%end

%hook YTSettings
- (BOOL)allowAudioOnlyManualQualitySelection {
    return 1;
}
%end

%hook YTUpsell
- (BOOL)isCounterfactual {
    return 1;
}
%end

%ctor {
    @autoreleasepool {
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"kEnableNoVideoAds"] == nil) {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"kEnableNoVideoAds"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kEnableNoVideoAds"] == YES) %init(gNoVideoAds);
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kEnableBackgroundPlayback"] == YES) {
            %init(gBackgroundPlayback);
            // %init(gPictureInPicture);
        }
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kNoDownloadButton"] == YES) %init(gNoDownloadButton);
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kNoCommentsSection"] == YES) %init(gNoCommentsSection);
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kNoCastButton"] == YES) %init(gNoCastButton);
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kNoNotificationButton"] == YES) %init(gNoNotificationButton);
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kAllowHDOnCellularData"] == YES) %init(gAllowHDOnCellularData);
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kDisableVideoEndscreenPopups"] == YES) %init(gDisableVideoEndscreenPopups);
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kDisableYouTubeKidsPopup"] == YES) %init(gDisableYouTubeKids);
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kDisableVoiceSearch"] == YES) %init(gDisableVoiceSearch);
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kDisableHints"] == YES) %init(gDisableHints);
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kHideTabBarLabels"] == YES) %init(gHideTabBarLabels);
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kHideExploreTab"] == YES) %init(gHideExploreTab);
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kHideUploadTab"] == YES) %init(gHideUploadTab);
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kHideSubscriptionsTab"] == YES) %init(gHideSubscriptionsTab);
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kHideLibraryTab"] == YES) %init(gHideLibraryTab);
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kDisableDoubleTapToSkip"] == YES) %init(gDisableDoubleTapToSkip);
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kNoTopicsSection"] == YES) %init(gNoTopicsSection);
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kHideOverlayDarkBackground"] == YES) %init(gHideOverlayDarkBackground);
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kHidePreviousAndNextButtonInOverlay"] == YES) %init(gHidePreviousAndNextButtonInOverlay);
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kDisableVideoAutoPlay"] == YES) %init(gDisableVideoAutoPlay);
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kHideAutoPlaySwitchInOverlay"] == YES) %init(gHideAutoPlaySwitchInOverlay);
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kHideCaptionsSubtitlesButtonInOverlay"] == YES) %init(gHideCaptionsSubtitlesButtonInOverlay);
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kDisableVideoInfoCards"] == YES) %init(gDisableVideoInfoCards);
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kNoSearchButton"] == YES) %init(gNoSearchButton);
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kHideChannelWatermark"] == YES) %init(gHideChannelWatermark);
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kUnlockUHDQuality"] == YES) %init(gUnlockUHDQuality);
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kHideShortsCameraButton"] == YES) %init(gHideShortsCameraButton);
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kHideShortsMoreActionsButton"] == YES) %init(gHideShortsMoreActionsButton);
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kHideShortsLikeButton"] == YES) %init(gHideShortsLikeButton);
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kHideShortsDislikeButton"] == YES) %init(gHideShortsDislikeButton);
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kHideShortsCommentsButton"] == YES) %init(gHideShortsCommentsButton);
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kHideShortsShareButton"] == YES) %init(gHideShortsShareButton);
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kEnableiPadStyleOniPhone"] == NO & [[NSUserDefaults standardUserDefaults] boolForKey:@"kShowStatusBarInOverlay"] == YES) {
            %init(gShowStatusBarInOverlay);
        }
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kShowStatusBarInOverlay"] == YES & [[NSUserDefaults standardUserDefaults] boolForKey:@"kEnableiPadStyleOniPhone"] == YES or [[NSUserDefaults standardUserDefaults] boolForKey:@"kEnableiPadStyleOniPhone"] == YES & [[NSUserDefaults standardUserDefaults] boolForKey:@"kShowStatusBarInOverlay"] == NO) {
            %init(gEnableiPadStyleOniPhone);
        }
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kAlwaysShowPlayerBar"] == NO & [[NSUserDefaults standardUserDefaults] boolForKey:@"kDisableRelatedVideosInOverlay"] == YES) {
            %init(gDisableRelatedVideosInOverlay);
        }
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kAlwaysShowPlayerBar"] == YES & [[NSUserDefaults standardUserDefaults] boolForKey:@"kDisableRelatedVideosInOverlay"] == YES or [[NSUserDefaults standardUserDefaults] boolForKey:@"kAlwaysShowPlayerBar"] == YES & [[NSUserDefaults standardUserDefaults] boolForKey:@"kDisableRelatedVideosInOverlay"] == NO) {
            %init(gAlwaysShowPlayerBar);
        }
        NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"kHexColourOptions"];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingFromData:colorData error:nil];
        [unarchiver setRequiresSecureCoding:NO];
        NSString *hexString = [unarchiver decodeObjectForKey:NSKeyedArchiveRootObjectKey];
        if(hexString != nil) {
            %init(gColourOptions);
        }
        %init(_ungrouped);
    }
}