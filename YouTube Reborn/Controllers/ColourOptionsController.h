#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

extern UISegmentedControl *colourSegmentedControl;
extern UITextField *hexTextField;

@interface ColourOptionsController : UIViewController

- (void)colourSwap;

@end