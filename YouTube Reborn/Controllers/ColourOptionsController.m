#import "ColourOptionsController.h"

@interface ColourOptionsController ()
@end

@implementation ColourOptionsController

UISegmentedControl *colourSegmentedControl;
UITextField *hexTextField;

- (void)loadView {
	[super loadView];

    self.title = @"Colour Options";
    if (self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleLight) {
        self.view.backgroundColor = [UIColor colorWithRed:0.949 green:0.949 blue:0.969 alpha:1.0];
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    }
    else {
        self.view.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
        self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    }

    NSFileManager *fm = [[NSFileManager alloc] init];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];

    CGFloat topbarHeight = ([UIApplication sharedApplication].statusBarFrame.size.height + (self.navigationController.navigationBar.frame.size.height ?: 0.0));
       
    NSArray *colourItemArray = [NSArray arrayWithObjects:@"Hex", @"RGB", @"Presets", nil];
    colourSegmentedControl = [[UISegmentedControl alloc] initWithItems:colourItemArray];
    colourSegmentedControl.frame = CGRectMake(0, topbarHeight, self.view.bounds.size.width, 40);
    [colourSegmentedControl addTarget:self action:@selector(colourSwap) forControlEvents:UIControlEventValueChanged];
    colourSegmentedControl.selectedSegmentIndex = 0;
    [self.view addSubview:colourSegmentedControl];
    
    hexTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, topbarHeight + 40 + 30, 300, 40)];
    hexTextField.placeholder = @"#000000";
    [self.view addSubview:hexTextField];

    UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveButton addTarget:self action:@selector(hexSave) forControlEvents:UIControlEventTouchUpInside];
    [saveButton setTitle:@"Save Colour" forState:UIControlStateNormal];
    saveButton.frame = CGRectMake(0, topbarHeight + 40 + 60, 160, 40);
    [saveButton setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin];
    [self.view addSubview:saveButton];
}
@end

@implementation ColourOptionsController(Privates)

UIWindow *alertWindowOutSaved;

- (void)done {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)colourSwap {
    // [tableView reloadData];
}

- (void)hexSave {
    NSData *colorData = [NSKeyedArchiver archivedDataWithRootObject:[hexTextField text] requiringSecureCoding:nil error:nil];
    [[NSUserDefaults standardUserDefaults] setObject:colorData forKey:@"kHexColourOptions"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSLog(@"Saved Colour");
    UIWindow *alertWindowSaved = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    alertWindowSaved.rootViewController = [UIViewController new];
    alertWindowSaved.windowLevel = UIWindowLevelAlert + 1;
    alertWindowOutSaved = alertWindowSaved;

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"Colour Saved: %@", [hexTextField text]] message:nil preferredStyle:UIAlertControllerStyleAlert];

    [alert addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        alertWindowSaved.hidden = YES;
    }]];

    [alertWindowSaved makeKeyAndVisible];
    [alertWindowSaved.rootViewController presentViewController:alert animated:YES completion:nil];
    NSLog(@"Popup Appeared");
}

@end