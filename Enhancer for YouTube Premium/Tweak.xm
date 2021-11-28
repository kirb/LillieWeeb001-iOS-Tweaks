#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Tweak.h"

%hook EnhancerforYouTubePremiumOptionsController
- (void)loadView {
	%orig();
	/* UITableView *test = self.view.subviews[0].subviews[0];
	[self numberOfSectionsInTableView:test] == 5; */
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}
- (NSInteger)tableView:(UITableView *)theTableView numberOfRowsInSection:(NSInteger)section {
    if (section == 5) {
		return 1;
	}
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    %orig();
	if (indexPath.section == 5) {
		if (indexPath.row == 0) {
			cell.label.text = @"test";
		}
	}
}
%end