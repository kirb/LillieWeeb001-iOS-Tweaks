#import "ColourOptionsController.h"

@interface ColourOptionsController ()
@end

@implementation ColourOptionsController

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
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)theTableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)theTableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 3;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"RootTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
        cell.textLabel.adjustsFontSizeToFitWidth = true;
        if (self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleLight) {
            cell.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
            cell.textLabel.textColor = [UIColor blackColor];
        }
        else {
            cell.backgroundColor = [UIColor colorWithRed:0.110 green:0.110 blue:0.118 alpha:1.0];
            cell.textLabel.textColor = [UIColor whiteColor];
        }
        if(indexPath.section == 0) {
            if(indexPath.row == 0) {
                hexTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
                hexTextField.placeholder = @"#000000";
                [cell addSubview:hexTextField];
            }
            if(indexPath.row == 1) {
                cell.textLabel.text = @"Save Colour";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            if(indexPath.row == 2) {
                cell.textLabel.text = @"Reset Colour";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)theTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [theTableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.section == 0) {
        if(indexPath.row == 1) {
            NSData *colorData = [NSKeyedArchiver archivedDataWithRootObject:[hexTextField text] requiringSecureCoding:nil error:nil];
            [[NSUserDefaults standardUserDefaults] setObject:colorData forKey:@"kHexColourOptions"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            exit(0);
        }
        if(indexPath.row == 2) {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"kHexColourOptions"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            exit(0);
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {        
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

@end

@implementation ColourOptionsController(Privates)

UIWindow *alertWindowOutSaved;

- (void)done {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end