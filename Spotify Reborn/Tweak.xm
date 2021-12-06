#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "RootOptionsController.h"
#import "Tweak.h"

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

%hook SPNavigationController
- (void)viewDidLoad {
    %orig();
    SPNavigationBar *t = self.view.subviews[2];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button addTarget:self action:@selector(rootOptionsAction:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"OP" forState:UIControlStateNormal];
    button.frame = CGRectMake(t.frame.size.width - 45, (t.frame.size.height - 35.0) / 2, 33.0, 35.0);
    [t setUserInteractionEnabled:YES];
    [t addSubview:button];
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

%group gColourOptions
%hook UIView
- (void)setBackgroundColor:(UIColor *)colour {
    if ([colour isEqual:[UIColor colorWithRed:0.071 green:0.071 blue:0.071 alpha:1.000]]) {
        colour = hexColour();
    }
    %orig;
}
%end
%hook SPTNowPlayingBarV2ViewController
- (void)viewDidLoad {
    %orig();
    MSHookIvar<UIView *>(self, "_contentView").backgroundColor = hexColour();
}
%end
%hook SPTYourLibraryMusicSongsTableView
- (void)setBackgroundColor:(UIColor *)colour {
    colour = hexColour();
    %orig;
}
%end
%hook FilterChipsFeatureImplFilterChipButton
- (void)setBackgroundColor:(UIColor *)colour {
    colour = hexColour();
    %orig;
}
%end
%hook SPTHomeView
- (void)setBackgroundColor:(UIColor *)colour {
    colour = hexColour();
    %orig;
}
%end
%hook UITabBarButton
- (void)setBackgroundColor:(UIColor *)colour {
    colour = hexColour();
    %orig;
}
%end
%hook SPTTableView
- (void)setBackgroundColor:(UIColor *)colour {
    colour = hexColour();
    %orig;
}
%end
%hook SPTBarGradientView
- (void)layoutSubviews {
    %orig();
    MSHookIvar<CAGradientLayer *>(self, "_gradientLayer").hidden = YES;
}
%end
%hook UITabBar
- (void)setBarTintColor:(UIColor *)colour {
    colour = hexColour();
    %orig;
}
%end
%hook SPTAdaptiveTabBarController
- (void)viewDidLoad {
    %orig();
    self.view.subviews[1].backgroundColor = hexColour();
}
%end
%hook GLUEGradientView
- (id)gradientLayer {
    return NULL;
}
%end
%hook SPTHomeGradientBackgroundView
- (void)setBackgroundColor:(UIColor *)colour {
    colour = hexColour();
    %orig;
}
%end
%hook HUBCollectionView
- (void)setBackgroundColor:(UIColor *)colour {
    colour = hexColour();
    %orig;
}
%end
%hook SPTProfileSettingsTableViewCell
- (void)setBackgroundColor:(UIColor *)colour {
    colour = hexColour();
    %orig;
}
%end
%hook SPTSettingsTableViewCell
- (void)setBackgroundColor:(UIColor *)colour {
    colour = hexColour();
    %orig;
}
%end
%hook EncoreMobileHeaderLayout
- (void)layoutSubviews {
    %orig();
    MSHookIvar<UIView *>(self, "backgroundView").hidden = YES;
}
%end
%end

%hook 

%ctor {
    @autoreleasepool {
        NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"kHexColourOptions"];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingFromData:colorData error:nil];
        [unarchiver setRequiresSecureCoding:NO];
        NSString *hexString = [unarchiver decodeObjectForKey:NSKeyedArchiveRootObjectKey];
        if(hexString != nil) {
            %init(gColourOptions, FilterChipsFeatureImplFilterChipButton = objc_getClass("FilterChipsFeatureImpl.FilterChipButton"), EncoreMobileHeaderLayout = objc_getClass("EncoreMobile.HeaderLayout"));
        }
        %init(_ungrouped);
    }
}