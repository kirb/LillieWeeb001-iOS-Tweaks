#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import <UIKit/UIKit.h>

extern NSString *youtubeDocumentsPath;
extern NSMutableArray *filePathsVideoArray;
extern NSMutableArray *filePathsAudioArray;
extern NSMutableArray *filePathsVideoArtworkArray;
extern NSMutableArray *filePathsAudioArtworkArray;
extern NSMutableArray *filePathsVideoNameArray;
extern NSMutableArray *filePathsAudioNameArray;
extern NSURL *URL;

@interface YTRRootViewController : UIViewController <AVPlayerViewControllerDelegate>

- (void)audioPlay;
- (void)videoPlay;

@end

@interface LSApplicationProxy

+ (LSApplicationProxy *)applicationProxyForIdentifier:(NSString *)bundleId;
- (NSURL *)containerURL;

@end
