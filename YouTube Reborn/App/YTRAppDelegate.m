#import "YTRAppDelegate.h"
#import "YTRRootViewController.h"

@implementation YTRAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	_window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
	_rootViewController = [[UINavigationController alloc] initWithRootViewController:[[YTRRootViewController alloc] init]];
	_window.rootViewController = _rootViewController;
	[_window makeKeyAndVisible];
	return YES;
}

@end
