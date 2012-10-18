#import "PersistenceManager.h"

#define DB_NAME @"student"

@implementation PersistenceManager

static PersistenceManager* persistenceManager = nil;

+ (PersistenceManager *) persistenceManager {
  return persistenceManager;
}

+ (void) initialize {
  [[self alloc] init];
}

+ (id)allocWithZone:(NSZone *)zone {
  @synchronized(self) {
    if (persistenceManager == nil) {
      persistenceManager = [super allocWithZone:zone];
      return persistenceManager;
    }
  }
  return nil;
}

- (id)copyWithZone:(NSZone *)zone
{
  return self;	
}

-(id)init
{
	if ((self = [super init])) {
    managedObjectContext = nil;
    managedObjectModel = nil;
    persistenceStoreCoordinator = nil;
  }
	return self;
}

- (void) dealloc
{  
  [managedObjectContext release];
  [managedObjectModel release];
  [persistenceStoreCoordinator release];

  [super dealloc];
}

- (void) destroy
{
  NSError *error;
  if (managedObjectContext != nil) {
    if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
			// Handle error. 
      
			NSLog(@"Unresolved error %@", [error localizedDescription]);
			//exit(-1);  // Fail
    } 
  }
}
#pragma mark -
#pragma mark Core Data stack
/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *) managedObjectContext {
  if (managedObjectContext != nil)
    return managedObjectContext;
	
  NSPersistentStoreCoordinator *coordinator = [self persistenceStoreCoordinator];
  if (coordinator != nil) {
    managedObjectContext = [[NSManagedObjectContext alloc] init];
    [managedObjectContext setPersistentStoreCoordinator: coordinator];
  }
  return managedObjectContext;
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistenceStoreCoordinator {
  if (persistenceStoreCoordinator != nil)
    return persistenceStoreCoordinator;
  NSString *applicationDocumentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:  @"Documents"];
  NSString *dbFilename = [DB_NAME stringByAppendingPathExtension:@"sqlite"];
  NSString *storePath = [applicationDocumentsDirectory stringByAppendingPathComponent:dbFilename];
  NSURL *storeUrl = [NSURL fileURLWithPath:storePath ];
  
  NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                           [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                           [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
  NSError *error = nil;
  persistenceStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: [self managedObjectModel]];
  if (![persistenceStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType 
                                                configuration:nil 
                                                          URL:storeUrl 
                                                      options:options 
                                                        error:&error]) {
    NSLog(@"ERROR: failed to create persistentStoreCoordinator");
  }    
  
  NSDictionary *fileAttributes = [NSDictionary dictionaryWithObject:NSFileProtectionComplete forKey:NSFileProtectionKey];
  
  if(![[NSFileManager defaultManager] setAttributes:fileAttributes ofItemAtPath:storePath error: &error]){
    NSLog(@"ERROR: failed to add NSFileProtectionComplete option in persistentStoreCoordinator");
  }  
  return persistenceStoreCoordinator;
}

/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created by merging all of the models found in the application bundle.
 */
- (NSManagedObjectModel *)managedObjectModel {
  if (managedObjectModel != nil)
    return managedObjectModel;
	
  NSString *path = [[NSBundle mainBundle] pathForResource:DB_NAME ofType:@"momd"];
  NSURL *momURL = [NSURL fileURLWithPath:path];
  managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:momURL];
  return managedObjectModel;
}


#pragma mark -
#pragma mark data manipulation methods

- (void)saveContext {
  @try {
    NSError *error = nil;
    if (![[self managedObjectContext] save:&error]) {
      NSLog(@"Unresolved error when saving context: %@", [error localizedDescription]);
    }
  }
  @catch (NSException * e) {
    NSLog(@"EXCEPTION: Caught exception: %@:%@", e.name, e.reason);
  }
}
//the entity should be taken from the fetchedResultsController and passed to this method
- (void)deleteEntity:(id)entity{
  [[self managedObjectContext] deleteObject:entity];
  [self saveContext];
}
@end
