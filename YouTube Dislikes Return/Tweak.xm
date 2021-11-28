#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AFNetworking/AFNetworking.h>
#import "Tweak.h"

NSString *videoIdentifier;

YTLocalPlaybackController *playingVideoID;

%hook YTLocalPlaybackController
- (NSString *)currentVideoID {
    playingVideoID = self;
    return %orig;
}
%end

%hook YTSlimVideoScrollableDetailsActionsView
- (void)layoutSubviews {
	%orig();
    videoIdentifier = [playingVideoID currentVideoID];
    NSMutableArray *dislikesActionsViews = MSHookIvar<NSMutableArray *>(self, "_actionViews");
    if (dislikesActionsViews.count > 1) {
        YTSlimDetailsActionView *testa = dislikesActionsViews[1];
        if (testa.subviews.count > 1) {
            YTFormattedStringLabel *dislikeText = testa.subviews[1];

            NSURLSessionConfiguration *dataConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
            AFURLSessionManager *dataManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:dataConfiguration];

            NSString *apiUrl = [NSString stringWithFormat:@"https://return-youtube-dislike-api.azurewebsites.net/votes?videoId=%@", videoIdentifier];
            NSURL *dataUrl = [NSURL URLWithString:apiUrl];
            NSURLRequest *apiRequest = [NSURLRequest requestWithURL:dataUrl];

            NSURLSessionDataTask *dataTask = [dataManager dataTaskWithRequest:apiRequest uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
                if (error) {
                    NSLog(@"Error: %@", error);
                } else {
                    NSMutableDictionary *jsonResponse = responseObject;
                    NSString *dislikeCount = [NSString stringWithFormat:@"%@", [jsonResponse objectForKey:@"dislikes"]];
                    NSMutableParagraphStyle *dislikesAttributedStyle = [[NSMutableParagraphStyle alloc] init];
                    [dislikesAttributedStyle setAlignment:NSTextAlignmentCenter];
                    NSMutableAttributedString *dislikesAttributedString = [[NSMutableAttributedString alloc] initWithString:dislikeCount];
                    [dislikesAttributedString addAttribute:NSParagraphStyleAttributeName value:dislikesAttributedStyle range:NSMakeRange(0, dislikesAttributedString.length)];
                    if (self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleLight) {
                        [dislikesAttributedString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, dislikesAttributedString.length)];
                    } else {
                        [dislikesAttributedString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, dislikesAttributedString.length)];
                    }
                    [dislikesAttributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Roboto-Regular" size:12.00] range:NSMakeRange(0, dislikesAttributedString.length)];
                    dislikeText.attributedText = dislikesAttributedString;
                }
            }];
            [dataTask resume];
        }
    }
}
%end