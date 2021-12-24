#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Tweak.h"

static NSMutableDictionary <NSString *, NSNumber *> *dislikesCache = [NSMutableDictionary dictionary];

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

    YTSlimVideoDetailsActionView *dislikesActionsViews = MSHookIvar<YTSlimVideoDetailsActionView *>(self, "_dislikeActionView");
    YTFormattedStringLabel *dislikeText = MSHookIvar<YTFormattedStringLabel *>(dislikesActionsViews, "_label");

    void (^completion)(NSNumber *) = ^(NSNumber *dislikes) {
        NSString *result = @"Error";
        if (dislikes != nil) {
            // Format into a string that looks like “123”, “1.2K”, “1.2M”, or “1.2B”.
            double dislikesCount = dislikes.doubleValue;
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
            formatter.numberStyle = NSNumberFormatterDecimalStyle;
            formatter.allowsFloats = YES;
            formatter.minimumIntegerDigits = 1;
            formatter.minimumFractionDigits = 0;
            formatter.maximumFractionDigits = 1;
            if (dislikesCount >= 1e9) { // Billions
                dislikesCount = dislikesCount / 1e9;
                formatter.positiveSuffix = @"B";
            } else if (dislikesCount >= 1e6) { // Millions
                dislikesCount = dislikesCount / 1e6;
                formatter.positiveSuffix = @"M";
            } else if (dislikesCount >= 1e3) { // Thousands
                dislikesCount = dislikesCount / 1e3;
                formatter.positiveSuffix = @"K";
            }
            result = [formatter stringFromNumber:@(dislikesCount)];
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            dislikesCache[videoIdentifier] = dislikes;

            // Trick to get the text centered without needing to reposition the view.
            NSMutableParagraphStyle *dislikesAttributedStyle = [[NSMutableParagraphStyle alloc] init];
            dislikesAttributedStyle.alignment = NSTextAlignmentCenter;

            NSMutableAttributedString *dislikesAttributedString = [dislikeText.attributedText mutableCopy];
            dislikesAttributedString.mutableString.string = result;
            [dislikesAttributedString addAttribute:NSParagraphStyleAttributeName value:dislikesAttributedStyle range:NSMakeRange(0, dislikesAttributedString.length)];
            dislikeText.attributedText = dislikesAttributedString;
            [dislikesActionsViews setNeedsLayout];
        });
    };

    if (dislikesCache[videoIdentifier]) {
        completion(dislikesCache[videoIdentifier]);
    } else {
        NSString *apiUrl = [NSString stringWithFormat:@"https://returnyoutubedislikeapi.com/votes?videoId=%@", videoIdentifier];
        NSURL *dataUrl = [NSURL URLWithString:apiUrl];
        NSURLRequest *apiRequest = [NSURLRequest requestWithURL:dataUrl];

        NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:apiRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (error != nil) {
                NSLog(@"Dislikes API returned error: %@", error);
                return;
            }
            NSMutableDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            NSNumber *dislikes = jsonResponse[@"dislikes"];
            completion(dislikes);
        }];
        [dataTask resume];
    }
}
%end
