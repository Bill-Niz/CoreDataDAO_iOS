

#import "CoreDataDAOAppDelegate.h"
#import "CourseTableViewController.h"


@implementation CoreDataDAOAppDelegate

@synthesize window, navigationController;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after application launch.
    [self populateDataCourse];
    CourseTableViewController *tableViewController = [[CourseTableViewController alloc] init];
  
    UINavigationController *aNavigationController = [[UINavigationController alloc]
                                                   
                                                   initWithRootViewController:tableViewController];
    [tableViewController release];
  
    self.navigationController = aNavigationController;
    [aNavigationController release];
  
    [window addSubview:[navigationController view]];
  
    [self.window makeKeyAndVisible];
  
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void) populateDataCourse
{
  /////populate data
  CoursePersistenceController *persistenceController = [[CoursePersistenceController alloc] init];
  NSDate *date = [NSDate date];
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  
  [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
  
  Course *course = (Course *)[persistenceController getNewEntityObject:@"Course"];
  course.name = @"dummy5";
  course.timestamp = date;
  course.teacher = [dateFormatter stringFromDate:date];
  
  
  course = (Course *)[persistenceController getNewEntityObject:@"Course"];
  course.name = @"dummy4";
  course.timestamp = [date dateByAddingTimeInterval:120];
  course.teacher = [dateFormatter stringFromDate:date];
  
  
  course = (Course *)[persistenceController getNewEntityObject:@"Course"];
  course.name = @"dummy3";
  course.timestamp = [date dateByAddingTimeInterval:120];
  course.teacher = [dateFormatter stringFromDate:date];
  
  
  
  course = (Course *)[persistenceController getNewEntityObject:@"Course"];
  course.name = @"dummy2";
  course.timestamp = [date dateByAddingTimeInterval:24*60*60];
  course.teacher = [dateFormatter stringFromDate:date];
  
  
  course = (Course *)[persistenceController getNewEntityObject:@"Course"];
  course.name = @"dummy1";
  course.timestamp = [date dateByAddingTimeInterval:2*24*60*60];
  course.teacher = [dateFormatter stringFromDate:date];
  
  
  [persistenceController saveEntity];
  
  [dateFormatter release];
  [persistenceController release];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
    [window release];
    [super dealloc];
}


@end
