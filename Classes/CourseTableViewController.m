
#import "CourseTableViewController.h"


@implementation CourseTableViewController


#pragma Coursemark -
#pragma mark Initialization

- (id)init
{
  self = [super init];
  if (self) {
    self.title = @"Course";
    
    persistenceController = [[CoursePersistenceController alloc] init];
    [persistenceController sortTable];
	}
	return self;
}

- (void) dealloc
{  
  [persistenceController release];
  [super dealloc];
}

/*
 - (id)initWithStyle:(UITableViewStyle)style {
 // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
 self = [super initWithStyle:style];
 if (self) {
 // Custom initialization.
 }
 return self;
 }
 */


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
  [super viewDidLoad];
  
  // Uncomment the following line to preserve selection between presentations.
  self.clearsSelectionOnViewWillAppear = NO;
  
  // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
  self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


/*
 - (void)viewWillAppear:(BOOL)animated {
 [super viewWillAppear:animated];
 }
 */
/*
 - (void)viewDidAppear:(BOOL)animated {
 [super viewDidAppear:animated];
 }
 */
/*
 - (void)viewWillDisappear:(BOOL)animated {
 [super viewWillDisappear:animated];
 }
 */
/*
 - (void)viewDidDisappear:(BOOL)animated {
 [super viewDidDisappear:animated];
 }
 */


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  // Override to allow orientations other than the default portrait orientation.
  return YES;
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  // Return the number of sections.
  NSUInteger count = [[persistenceController getSections] count];
  if(count == 0) count = 1;
  return count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  // Return the number of rows in the section.
  NSArray *sections = [persistenceController getSections];
  
  NSUInteger count = 0;
  if ([sections count] > 0) {
    id <NSFetchedResultsSectionInfo> sectionInfo = [sections objectAtIndex:section];
    count = [sectionInfo numberOfObjects];
  }
  return count;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  static NSString *CellIdentifier = @"Cell";
  
  NSInteger TITLE_TAG = 1;
  UILabel *titleLabel;
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    titleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 205.0f, 55.0f)] autorelease];
    titleLabel.tag = TITLE_TAG;
    titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.contentMode = UIViewContentModeScaleAspectFit;
    titleLabel.numberOfLines = 4;
    titleLabel.lineBreakMode = NSLineBreakByTruncatingMiddle ;
    titleLabel.backgroundColor = [UIColor clearColor];
    
    [cell.contentView addSubview:titleLabel];
    
  }else{
    titleLabel = (UILabel *)[cell.contentView viewWithTag:TITLE_TAG];
  }
  
  cell.selectionStyle = UITableViewCellSelectionStyleNone;
  cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  
  Course *course = (Course*)[persistenceController getEntityAtIndexPath:indexPath];
  
  titleLabel.text = course.name;
  
  return cell;
}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
  
  if (editingStyle == UITableViewCellEditingStyleDelete) {
    // Delete the row from the data source.
    [persistenceController deleteEntityAtIndexPath:indexPath];
    [self.tableView reloadData];
  }   
}



/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */


/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  // Navigation logic may go here. Create and push another view controller.
  /*
   <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
   // ...
   // Pass the selected object to the new view controller.
   [self.navigationController pushViewController:detailViewController animated:YES];
   [detailViewController release];
	 */
  Course *course = (Course*)[persistenceController getEntityAtIndexPath:indexPath];
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Timestamp" 
                                                  message:course.teacher 
                                                 delegate:self 
                                        cancelButtonTitle:nil 
                                        otherButtonTitles:@"OK", nil];
	[alert show];
	[alert release];
}

- (UIView *) tableView:(UITableView *)_tableView viewForHeaderInSection:(NSInteger)section 
{
	UIView *headerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, _tableView.bounds.size.width, 40)] autorelease];
	[headerView setBackgroundColor:[UIColor colorWithRed:0.364705882f green:0.364705882f blue:0.364705882f alpha:0.9f]];
	NSString *titleStr = @"";
  NSArray *sections = [persistenceController getSections];
	if ([sections count] > 0) {
    id <NSFetchedResultsSectionInfo> sectionInfo = [sections objectAtIndex:section];
    NSString* item_var = ([sectionInfo numberOfObjects]==1) ? @"Item" : @"Items";
    titleStr = [NSString stringWithFormat:@"%@ (%d %@)",[sectionInfo name],[sectionInfo numberOfObjects],item_var];
  } else {
    titleStr = @"NO ITEM";
	}
	
	UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(10, 3, _tableView.bounds.size.width - 10, 18)] autorelease];
	label.text = [NSString stringWithString:titleStr];
	label.textColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0f];
	label.backgroundColor = [UIColor clearColor];
	[headerView addSubview:label];
	
	return headerView;
}



#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
  // Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];
  
  // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
  // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
  // For example: self.myOutlet = nil;
}

@end

