#import "CWWidgetSelectionController.h"

static MRYIPCCenter *center;

@implementation CWWidgetSelectionController

- (void)viewDidLoad {
	[super viewDidLoad];

	center = [MRYIPCCenter centerNamed:@"com.thatmarcel.tweaks.controlwidget.ipcserver"];

    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];

	self.widgets = [center callExternalMethod:@selector(getAllIdentifiers:) withArguments:@{}];
    self.displayNames = [center callExternalMethod:@selector(getWidgetNamesForIdentifiers:) withArguments:@{@"identifiers" : self.widgets}];
    self.tableView.dataSource = self;
	self.tableView.delegate = self;
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
	return [self.widgets count];
}

- (UITableViewCell *)tableView:(UITableView *)table cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CWWidgetCell"];

	cell.textLabel.text = self.displayNames[self.widgets[indexPath.row]][@"name"];
    cell.imageView.layer.cornerRadius = 7;
	cell.imageView.clipsToBounds = YES;

	CGRect frame = cell.imageView.frame;
	frame.size.height = 30;
	frame.size.width = 30;
	cell.imageView.frame = frame;
    
	if (self.displayNames[self.widgets[indexPath.row]][@"image"]) {
		cell.imageView.image = [self rescaleImage:[UIImage imageWithData:self.displayNames[self.widgets[indexPath.row]][@"image"]] scaledToSize:CGSizeMake(30, 30)];
	} else {
		cell.imageView.image = NULL;
	}

	return cell;
}

- (UIImage *)rescaleImage:(UIImage *)image scaledToSize:(CGSize)newSize {
	UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
	[image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
	UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return newImage;
}

	// NSString *identifier = [self.widgets objectAtIndex:indexPath.row];

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *identifier = [self.widgets objectAtIndex:indexPath.row];

	HBPreferences *preferences = [[HBPreferences alloc] initWithIdentifier:@"com.thatmarcel.tweaks.controlwidget.hbprefs"];
	[preferences setObject:identifier forKey:@"cwWidgetIdentifier"];
	[self.navigationController popViewControllerAnimated:YES];
}

@end