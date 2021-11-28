@interface YTAppDelegate : UIResponder <UIApplicationDelegate>
- (void)closeApp;
- (BOOL)versionCheck;
- (BOOL)iOSCheck;
@end

@interface YTQTMButton : UIButton
@end

@interface ABCSwitch : UISwitch
@end

@interface YTPivotBarItemView : UIView
@property(readonly, nonatomic) YTQTMButton *navigationButton;
@end

@interface YTPivotBarView : UIView
@end

@interface YTSlideForActionsView : UIView
@end

@interface YTEngagementPanelView : UIView
@end

@interface YTShareMainView : UIView
@end

@interface ELMView : UIView
@end

@interface YTTopAlignedView : UIView
@end

@interface YTRightNavigationButtons
@property(readonly, nonatomic) YTQTMButton *MDXButton;
@property(readonly, nonatomic) YTQTMButton *searchButton;
@property(readonly, nonatomic) YTQTMButton *notificationButton;
@end

@interface YTMainAppControlsOverlayView : UIView
@property(readonly, nonatomic) YTQTMButton *playbackRouteButton;
@property(readonly, nonatomic) YTQTMButton *previousButton;
@property(readonly, nonatomic) YTQTMButton *nextButton;
@property(readonly, nonatomic) ABCSwitch *autonavSwitch;
@property(readonly, nonatomic) YTQTMButton *closedCaptionsOrSubtitlesButton;
@property(retain, nonatomic) UIButton *overlayButtonOne;
@property(retain, nonatomic) UIButton *overlayButtonTwo;
@property(retain, nonatomic) UIButton *overlayButtonThree;
- (BOOL)iOSCheck;
- (void)playInApp;
- (void)optionsAction:(id)sender;
- (void)audioDownloader;
- (void)videoDownloader;
- (void)pictureInPicture;
@end

@interface YTMainAppSkipVideoButton
@property(readonly, nonatomic) UIImageView *imageView;
@end

@interface YTPlayerViewController
@end

@interface YTLocalPlaybackController : NSObject
- (NSString *)currentVideoID;
@end

@interface YTMainAppVideoPlayerOverlayViewController
- (CGFloat)mediaTime;
- (int)playerViewLayout;
@end

@interface YTCollectionView : UIView
@end

@interface YTAsyncCollectionView : UIView
@end

@interface YTNavigationBarTitleView : UIView
- (void)rootOptionsAction:(id)sender;
@end

@interface GOONavigationHeaderView : UIView
@end

@interface YTReelWatchPlaybackOverlayView : UIView
@end

extern NSMutableArray *overlayButtons;
extern NSString *videoIdentifier;
extern NSURL *streamURL;