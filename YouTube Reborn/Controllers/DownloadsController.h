#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>

extern NSString *currentFileName;
extern NSArray *paths;
extern NSString *documentsDirectory;
extern NSString *filePath;
extern NSURL *URL;
extern NSArray *filePathsList;
extern NSMutableArray *filePathsVideoArray;
extern NSMutableArray *filePathsAudioArray;
extern NSMutableArray *filePathsVideoArtworkArray;
extern NSMutableArray *filePathsAudioArtworkArray;
extern NSMutableArray *filePathsAudioNameArray;
extern UISegmentedControl *segmentedControl;

@interface DownloadsController : UIViewController

- (void)swap;
- (void)audioPlay;
- (void)videoPlay;

@end