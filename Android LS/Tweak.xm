#import <LocalAuthentication/LocalAuthentication.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MediaRemote/MediaRemote.h>
#import "SparkColourPickerUtils.h"
#import "Tweak.h"

#define PreferencesFilePath [NSString stringWithFormat:@"/var/mobile/Library/Preferences/weeb.lillie.androidlsprefs.plist"]

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

// Preferences Variables

BOOL enabled;
BOOL zeroHourClock;
BOOL customClockColour;
BOOL customDateColour;
BOOL showBatteryPercent;
BOOL alignToBottom;
BOOL customBPColour;
BOOL hideLSPageDots;

// Tweak Variables

UIView *androidTimeView;
UILabel *androidBigTimeLabel;
UILabel *androidSmallTimeLabel;
UILabel *androidSmallDateLabel;
UILabel *androidBatteryLabel;
int playerVisible;
int axonVisible;

static BOOL hasDeviceNotch() {
	if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
		return NO;
	} else {
		LAContext* context = [[LAContext alloc] init];
		[context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:nil];
		return [context biometryType] == LABiometryTypeFaceID;
	}
}

static BOOL has24HourClock() {
	NSDateFormatter *df = [[NSDateFormatter alloc] init];
	[df setLocale:[NSLocale currentLocale]];
	[df setDateStyle:NSDateFormatterNoStyle];
	[df setTimeStyle:NSDateFormatterShortStyle];
	NSString *dateString = [df stringFromDate:[NSDate date]];
	NSRange amRange = [dateString rangeOfString:[df AMSymbol]];
	NSRange pmRange = [dateString rangeOfString:[df PMSymbol]];
	return (amRange.location == NSNotFound && pmRange.location == NSNotFound);
}

void setDict() {
    NSDictionary *preferences = [[NSDictionary alloc] initWithContentsOfFile:PreferencesFilePath];

    if (!preferences) {
        enabled = 1;
        zeroHourClock = 0;
        customClockColour = 0;
        customDateColour = 0;
        showBatteryPercent = 1;
        alignToBottom = 0;
        customBPColour = 0;
        hideLSPageDots = 0;
    }
    if (preferences) {
        if ([preferences objectForKey:@"enabled"] != nil) {
            enabled = [[preferences valueForKey:@"enabled"] boolValue];
        } else {
            enabled = 1;
        }
        if ([preferences objectForKey:@"zeroHourClock"] != nil) {
            zeroHourClock = [[preferences valueForKey:@"zeroHourClock"] boolValue];
        } else {
            zeroHourClock = 0;
        }
        if ([preferences objectForKey:@"customClockColour"] != nil) {
            customClockColour = [[preferences valueForKey:@"customClockColour"] boolValue];
        } else {
            customClockColour = 0;
        }
        if ([preferences objectForKey:@"customDateColour"] != nil) {
            customDateColour = [[preferences valueForKey:@"customDateColour"] boolValue];
        } else {
            customDateColour = 0;
        }
        if ([preferences objectForKey:@"showBatteryPercent"] != nil) {
            showBatteryPercent = [[preferences valueForKey:@"showBatteryPercent"] boolValue];
        } else {
            showBatteryPercent = 1;
        }
        if ([preferences objectForKey:@"alignToBottom"] != nil) {
            alignToBottom = [[preferences valueForKey:@"alignToBottom"] boolValue];
        } else {
            alignToBottom = 0;
        }
        if ([preferences objectForKey:@"customBPColour"] != nil) {
            customBPColour = [[preferences valueForKey:@"customBPColour"] boolValue];
        } else {
            customBPColour = 0;
        }
        if ([preferences objectForKey:@"hideLSPageDots"] != nil) {
            hideLSPageDots = [[preferences valueForKey:@"hideLSPageDots"] boolValue];
        } else {
            hideLSPageDots = 0;
        }
    }
}

NCNotificationStructuredListViewController *resultOut;

%hook NCNotificationStructuredListViewController
- (BOOL)hasVisibleContent {
    resultOut = self;
    return %orig;
}
%end

%hook AXNView
- (id)initWithFrame:(CGRect)frame {
    [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(axonCheck:) userInfo:nil repeats:YES];
    return %orig;
}

%new
- (void)axonCheck:(NSTimer *)timer {
    if ([self.list count] == 0) {
        axonVisible = 0;
    } else {
        axonVisible = 1;
    }
}
%end

%group gEnabled
%hook SBFLockScreenDateView
- (void)layoutSubviews {
    %orig();
    MSHookIvar<SBUILegibilityLabel *>(self, "_timeLabel").hidden = YES;
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    self.frame = CGRectMake(0, 0, screenRect.size.width, screenRect.size.height);
}
%end

%hook SBFLockScreenDateViewController
- (void)loadView {
    %orig();
    BOOL iOSCheckResult = [self iOSCheck];
    // Start View
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    androidTimeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenRect.size.width, screenRect.size.height)];
    // Big Time Label
    androidBigTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, androidTimeView.frame.size.width, androidTimeView.frame.size.height)];
    androidBigTimeLabel.font = [androidBigTimeLabel.font fontWithSize:150];
    androidBigTimeLabel.numberOfLines = 2;
    androidBigTimeLabel.adjustsFontSizeToFitWidth = YES;
    if (customClockColour == 1) {
        NSString *colourString = NULL;
        NSDictionary *preferencesDictionary = [NSDictionary dictionaryWithContentsOfFile:PreferencesFilePath];
        if (preferencesDictionary)
        {
            colourString = [preferencesDictionary objectForKey:@"colourClockSpark"];
        }

        UIColor *colour = [SparkColourPickerUtils colourWithString:colourString withFallback:@"#ffffff"];
        androidBigTimeLabel.textColor = colour;
    }
    [androidTimeView addSubview:androidBigTimeLabel];
    // Small Time Label
    if (hasDeviceNotch()) {
        androidSmallTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, androidTimeView.frame.size.width - 20, 120)];
    } else {
        androidSmallTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 95, androidTimeView.frame.size.width - 20, 120)];
    }
    androidSmallTimeLabel.font = [androidSmallTimeLabel.font fontWithSize:50];
    androidSmallTimeLabel.numberOfLines = 2;
    androidSmallTimeLabel.adjustsFontSizeToFitWidth = YES;
    androidSmallTimeLabel.hidden = YES;
    if (customClockColour == 1) {
        NSString *colourString = NULL;
        NSDictionary *preferencesDictionary = [NSDictionary dictionaryWithContentsOfFile:PreferencesFilePath];
        if (preferencesDictionary)
        {
            colourString = [preferencesDictionary objectForKey:@"colourClockSpark"];
        }

        UIColor *colour = [SparkColourPickerUtils colourWithString:colourString withFallback:@"#ffffff"];
        androidSmallTimeLabel.textColor = colour;
    }
    [androidTimeView addSubview:androidSmallTimeLabel];
    // Small Date Label
    if (hasDeviceNotch()) {
        androidSmallDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, androidTimeView.frame.size.width, 120)];
    } else {
        androidSmallDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 95, androidTimeView.frame.size.width, 120)];
    }
    androidSmallDateLabel.font = [androidSmallTimeLabel.font fontWithSize:20];
    androidSmallDateLabel.numberOfLines = 1;
    androidSmallDateLabel.adjustsFontSizeToFitWidth = YES;
    if (customDateColour == 1) {
        NSString *colourString = NULL;
        NSDictionary *preferencesDictionary = [NSDictionary dictionaryWithContentsOfFile:PreferencesFilePath];
        if (preferencesDictionary)
        {
            colourString = [preferencesDictionary objectForKey:@"colourDateSpark"];
        }

        UIColor *colour = [SparkColourPickerUtils colourWithString:colourString withFallback:@"#ffffff"];
        androidSmallDateLabel.textColor = colour;
    }
    [androidTimeView addSubview:androidSmallDateLabel];
    // End View
    [self.view addSubview:androidTimeView];
    [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(changeAndroidDateTimeLabel:) userInfo:nil repeats:YES];
    if (iOSCheckResult) {
        [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(notificationsiOS14PlusCheck:) userInfo:nil repeats:YES];
    } else {
        [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(notificationsiOS13Check:) userInfo:nil repeats:YES];
    }
}

%new
- (void)changeAndroidDateTimeLabel:(NSTimer *)timer {
    NSDate *current = [NSDate date];
    NSDateFormatter *outputFormatDate = [[NSDateFormatter alloc] init];
    NSDateFormatter *outputFormatTime = [[NSDateFormatter alloc] init];
    if (has24HourClock()) {
        if (zeroHourClock) {
            [outputFormatTime setDateFormat:@"HH\nmm"];
        } else {
            [outputFormatTime setDateFormat:@"H\nmm"];
        }
    } else {
        if (zeroHourClock) {
            [outputFormatTime setDateFormat:@"hh\nmm"];
        } else {
            [outputFormatTime setDateFormat:@"h\nmm"];
        }
    }
    [outputFormatDate setDateFormat:@"EE, MMM dd"];
    NSString *time = [outputFormatTime stringFromDate:current];
    // Date Label
    androidSmallDateLabel.text = [outputFormatDate stringFromDate:current];
    // Big Time Label
    NSMutableParagraphStyle *bigStyle  = [[NSMutableParagraphStyle alloc] init];
    [bigStyle setAlignment:NSTextAlignmentCenter];
    bigStyle.minimumLineHeight = 150.f;
    bigStyle.maximumLineHeight = 150.f;
    NSDictionary *bigAttributtes = @{NSParagraphStyleAttributeName : bigStyle,};
    androidBigTimeLabel.attributedText = [[NSAttributedString alloc] initWithString:time attributes:bigAttributtes];
    // Small Time Label
    NSMutableParagraphStyle *style  = [[NSMutableParagraphStyle alloc] init];
    [style setAlignment:NSTextAlignmentRight];
    style.minimumLineHeight = 55.f;
    style.maximumLineHeight = 55.f;
    NSDictionary *attributtes = @{NSParagraphStyleAttributeName : style,};
    androidSmallTimeLabel.attributedText = [[NSAttributedString alloc] initWithString:time attributes:attributtes];
}

%new
- (void)notificationsiOS14PlusCheck:(NSTimer *)timer {
    BOOL visibleNotifs = [resultOut hasVisibleContent];
    if (visibleNotifs) {
        androidBigTimeLabel.hidden = YES;
        androidSmallTimeLabel.hidden = NO;
    } else {
        if (axonVisible == 1) {
            androidBigTimeLabel.hidden = YES;
            androidSmallTimeLabel.hidden = NO;
        }
        else {
            if (playerVisible == 1) {
                androidBigTimeLabel.hidden = YES;
                androidSmallTimeLabel.hidden = NO;
            } else {
                androidSmallTimeLabel.hidden = YES;
                androidBigTimeLabel.hidden = NO;
            }
        }
    }
}

%new
- (void)notificationsiOS13Check:(NSTimer *)timer {
    BOOL visibleNotifs = [resultOut hasVisibleContent];
    if (visibleNotifs) {
        androidBigTimeLabel.hidden = YES;
        androidSmallTimeLabel.hidden = NO;
    } else {
        if (axonVisible == 1) {
            androidBigTimeLabel.hidden = YES;
            androidSmallTimeLabel.hidden = NO;
        }
        else {
            MRMediaRemoteGetNowPlayingInfo(dispatch_get_main_queue(), ^(CFDictionaryRef information) {
                if (information != NULL) {
                    androidBigTimeLabel.hidden = YES;
                    androidSmallTimeLabel.hidden = NO;
                } else {
                    androidSmallTimeLabel.hidden = YES;
                    androidBigTimeLabel.hidden = NO;
                }
            });
        }
    }
}

%new
- (BOOL)iOSCheck {
    return SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"14.0");
}
%end

%hook MRUNowPlayingViewController
- (void)viewDidAppear:(BOOL)arg1 {
    %orig();
    if (self.layout != 0) {
        playerVisible = 1;
    }
}
- (void)viewDidDisappear:(BOOL)arg1 {
    %orig();
    if (self.layout != 0) {
        playerVisible = 0;
    }
}
%end

%hook CSFixedFooterView
- (void)layoutSubviews {
    %orig();
    MSHookIvar<UILabel *>(self, "_callToActionLabel").hidden = YES;
}
%end

%hook CSFixedFooterViewController
- (void)loadView {
    %orig();
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    if (alignToBottom == 1) {
        androidBatteryLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, (screenRect.size.height / 2) - 8.5, self.view.frame.size.width, self.view.frame.size.height)];
    } else {
        androidBatteryLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, (screenRect.size.height / 2) - 40, self.view.frame.size.width, self.view.frame.size.height)];
    }
    androidBatteryLabel.textAlignment = NSTextAlignmentCenter;
    androidBatteryLabel.font = [androidSmallTimeLabel.font fontWithSize:17];
    androidBatteryLabel.numberOfLines = 1;
    androidBatteryLabel.adjustsFontSizeToFitWidth = YES;
    if (customBPColour == 1) {
        NSString *colourString = NULL;
        NSDictionary *preferencesDictionary = [NSDictionary dictionaryWithContentsOfFile:PreferencesFilePath];
        if (preferencesDictionary)
        {
            colourString = [preferencesDictionary objectForKey:@"colourBPSpark"];
        }

        UIColor *colour = [SparkColourPickerUtils colourWithString:colourString withFallback:@"#ffffff"];
        androidBatteryLabel.textColor = colour;
    }
    if (showBatteryPercent == 1) {
        [self.view addSubview:androidBatteryLabel];
    }
    [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(changeAndroidBatteryLabel:) userInfo:nil repeats:YES];
}

%new
- (void)changeAndroidBatteryLabel:(NSTimer *)timer {
    UIDevice *myDevice = [UIDevice currentDevice];
    [myDevice setBatteryMonitoringEnabled:YES];
    double batteryLevel = (float)[myDevice batteryLevel] * 100;
    NSString *batteryPercent = [NSString stringWithFormat:@"%.0f%%", batteryLevel];
    androidBatteryLabel.text = batteryPercent;
}
%end

%hook NCNotificationListSectionRevealHintView
- (void)layoutSubviews {
}
%end

%hook SBFLockScreenDateSubtitleDateView
- (void)layoutSubviews {
}
%end

%hook SBFLockScreenDateSubtitleView
- (void)layoutSubviews {
}
%end
%end

%group gHideLSPageDots
%hook CSPageControl
- (void)layoutSubviews {
}
%end
%end

%ctor {
    @autoreleasepool {
        setDict();
        if (enabled == 1) {
            %init(gEnabled)
        }
        if (hideLSPageDots == 1) {
            %init(gHideLSPageDots)
        }
        %init(_ungrouped);
    }
}