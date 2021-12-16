@interface YTAppDelegate : UIResponder <UIApplicationDelegate>
@end

@interface YTSlimVideoScrollableDetailsActionsView : UIView
@end

@interface YTFormattedStringLabel : UILabel
@end

@interface YTQTMButton : UIButton
@end

@interface YTSlimVideoDetailsActionView : UIView
- (instancetype)initWithSlimMetadataButtonSupportedRenderer:(id)renderer;
@end

@interface YTISlimMetadataButtonSupportedRenderers : NSObject
- (int)rendererOneOfCase;
@end

@interface YTLocalPlaybackController : NSObject
- (NSString *)currentVideoID;
@end

@interface YTUserDefaults : NSObject
- (long long)appThemeSetting;
@end