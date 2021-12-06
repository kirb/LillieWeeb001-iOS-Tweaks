@interface SBFLockScreenDateView : UIView
@end

@interface SBUILegibilityLabel : UIView
@end

@interface NCNotificationListSectionRevealHintView : UIView
@end

@interface CSFixedFooterView : UIView
@end

@interface CSPageControl : UIView
@end

@interface MRUNowPlayingView : UIView
@end

@interface MRUNowPlayingViewController : UIViewController
- (NSInteger)layout;
@end

@interface NCNotificationViewController : UIViewController
@end

@interface NCNotificationShortLookViewController : UIViewController
@end

@interface NCNotificationStructuredListViewController : UIViewController
- (BOOL)hasVisibleContent;
@end

@interface AXNView : UIView
@property (nonatomic, retain) NSMutableArray *list;
- (void)axonCheck:(NSTimer *)timer;
@end

@interface CSFixedFooterViewController : UIViewController
- (void)changeAndroidBatteryLabel:(NSTimer *)timer;
@end

@interface SBFLockScreenDateViewController : UIViewController
- (void)changeAndroidDateTimeLabel:(NSTimer *)timer;
- (void)notificationsiOS14PlusCheck:(NSTimer *)timer;
- (void)notificationsiOS13Check:(NSTimer *)timer;
- (BOOL)iOSCheck;
@end

// Preferences Variables

extern BOOL enabled;
extern BOOL zeroHourClock;
extern BOOL customClockColour;
extern BOOL customDateColour;
extern BOOL showBatteryPercent;
extern BOOL alignToBottom;
extern BOOL customBPColour;
extern BOOL hideLSPageDots;

// Tweak Variables
extern UIView *androidTimeView;
extern UILabel *androidBigTimeLabel;
extern UILabel *androidSmallTimeLabel;
extern UILabel *androidSmallDateLabel;
extern UILabel *androidBatteryLabel;
extern int playerVisible;
extern int axonVisible;