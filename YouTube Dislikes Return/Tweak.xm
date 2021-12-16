#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AFNetworking/AFNetworking.h>
#import "Tweak.h"

%hook YTAppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSLog(@"YouTube Dislikes Return Loaded Successfully");
    return %orig;
}
%end

%hook YTColdConfig
- (BOOL)shouldUseAppThemeSetting {
    return 1;
}
%end

YTLocalPlaybackController *playingVideoID;

%hook YTLocalPlaybackController
- (NSString *)currentVideoID {
    playingVideoID = self;
    return %orig;
}
%end

YTUserDefaults *ytThemeSettings;

%hook YTUserDefaults
- (long long)appThemeSetting {
    ytThemeSettings = self;
    return %orig;
}
%end

%hook YTSlimVideoDetailsActionView
+ (YTSlimVideoDetailsActionView *)actionViewWithSlimMetadataButtonSupportedRenderer:(YTISlimMetadataButtonSupportedRenderers *)renderer withElementsContextBlock:(id)block {
    if ([renderer rendererOneOfCase] == 153515154) {
        return [[%c(YTSlimVideoDetailsActionView) alloc] initWithSlimMetadataButtonSupportedRenderer:renderer];
    }
    return %orig;
}
%end

%hook YTSlimVideoScrollableDetailsActionsView
- (void)layoutSubviews {
	%orig();
    NSString *videoIdentifier = [playingVideoID currentVideoID];
    long long ytDarkModeCheck = [ytThemeSettings appThemeSetting];
    
    YTSlimVideoDetailsActionView *dislikesActionsViews = MSHookIvar<YTSlimVideoDetailsActionView *>(self, "_dislikeActionView");
    YTFormattedStringLabel *dislikeText = MSHookIvar<YTFormattedStringLabel *>(dislikesActionsViews, "_label");
    
    NSMutableParagraphStyle *dislikesAttributedStyle = [[NSMutableParagraphStyle alloc] init];
    [dislikesAttributedStyle setAlignment:NSTextAlignmentCenter];
    NSMutableAttributedString *dislikesAttributedString = [[NSMutableAttributedString alloc] initWithString:@"Fetching"];
    [dislikesAttributedString addAttribute:NSParagraphStyleAttributeName value:dislikesAttributedStyle range:NSMakeRange(0, dislikesAttributedString.length)];
    if (ytDarkModeCheck == 0 || ytDarkModeCheck == 1) {
        if (UIScreen.mainScreen.traitCollection.userInterfaceStyle == UIUserInterfaceStyleLight) {
            [dislikesAttributedString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, dislikesAttributedString.length)];
        } else {
            [dislikesAttributedString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, dislikesAttributedString.length)];
        }
    }
    if (ytDarkModeCheck == 2) {
        [dislikesAttributedString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, dislikesAttributedString.length)];
    }
    if (ytDarkModeCheck == 3) {
        [dislikesAttributedString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, dislikesAttributedString.length)];
    }
    [dislikesAttributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Roboto-Regular" size:12.00] range:NSMakeRange(0, dislikesAttributedString.length)];
    dislikeText.attributedText = dislikesAttributedString;

    NSURLSessionConfiguration *dataConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *dataManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:dataConfiguration];

    NSString *apiUrl = [NSString stringWithFormat:@"https://returnyoutubedislikeapi.com/votes?videoId=%@", videoIdentifier];
    NSURL *dataUrl = [NSURL URLWithString:apiUrl];
    NSURLRequest *apiRequest = [NSURLRequest requestWithURL:dataUrl];

    NSURLSessionDataTask *dataTask = [dataManager dataTaskWithRequest:apiRequest uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            [dislikesAttributedString.mutableString setString:@"Failed"];
            dislikeText.attributedText = dislikesAttributedString;
        } else {
            NSMutableDictionary *jsonResponse = responseObject;
            NSString *dislikeCount = [NSString stringWithFormat:@"%@", [jsonResponse objectForKey:@"dislikes"]];
            if (dislikeCount != NULL) {
                NSString *dislikeCountShort;
                if ([dislikeCount length] == 1 || [dislikeCount length] == 2 || [dislikeCount length] == 3) {
                    dislikeCountShort = dislikeCount;
                }
                if ([dislikeCount length] == 4) {
                    NSString *firstInt = [dislikeCount substringWithRange:NSMakeRange(0,1)];
                    NSString *secondInt = [dislikeCount substringWithRange:NSMakeRange(1,1)];
                    dislikeCountShort = [NSString stringWithFormat:@"%@.%@K", firstInt, secondInt];
                }
                if ([dislikeCount length] == 5) {
                    dislikeCountShort = [NSString stringWithFormat:@"%@K", [dislikeCount substringToIndex:2]];
                }
                if ([dislikeCount length] == 6) {
                    dislikeCountShort = [NSString stringWithFormat:@"%@K", [dislikeCount substringToIndex:3]];
                }
                if ([dislikeCount length] == 7) {
                    dislikeCountShort = [NSString stringWithFormat:@"%@M", [dislikeCount substringToIndex:1]];
                }
                if ([dislikeCount length] == 8) {
                    dislikeCountShort = [NSString stringWithFormat:@"%@M", [dislikeCount substringToIndex:2]];
                }
                if ([dislikeCount length] == 9) {
                    dislikeCountShort = [NSString stringWithFormat:@"%@B", [dislikeCount substringToIndex:1]];
                }
                if ([dislikeCount length] == 10) {
                    dislikeCountShort = [NSString stringWithFormat:@"%@B", [dislikeCount substringToIndex:2]];
                }
                [dislikesAttributedString.mutableString setString:dislikeCountShort];
                dislikeText.attributedText = dislikesAttributedString;
            } else {
                [dislikesAttributedString.mutableString setString:@"Failed"];                        
                dislikeText.attributedText = dislikesAttributedString;
            }
        }
    }];
    [dataTask resume];
}
%end