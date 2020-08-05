#import <UIKit/UIKit.h>
#import <Cephei/HBPreferences.h>
#import <MRYIPCCenter.h>

@interface CWWidgetSelectionController: UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray *widgets;
@property (strong, nonatomic) NSMutableDictionary *displayNames;

@end