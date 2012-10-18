
#import "AbstractPersistenceController.h"


@implementation AbstractPersistenceController

@synthesize rows;

-(id)init
{
	if ((self = [super init])) {
    rows = nil;
  }
	return self;
}

- (void) dealloc
{  
  rows.delegate = nil;
  self.rows  = nil;
  
  [super dealloc];
}

- (void)saveEntity {
  [[PersistenceManager persistenceManager] saveContext];
}

- (NSIndexPath *)getIndexPathForObject:(id) object {
  return [self.rows indexPathForObject:object];
}

-(id) getNewEntityObject:(NSString *) entityName
{
  NSManagedObjectContext *context = [[PersistenceManager persistenceManager] managedObjectContext];
  return [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:context];
}

#pragma mark code to be overide 
- (void) controllerDidChangeContentAction:(NSFetchedResultsController *)controller{}

#pragma mark -
#pragma mark NSFetchedResultsControllerDelegate methods

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self controllerDidChangeContentAction:controller];
    [self.delegate controllerDidChangeContentAction:controller];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    [self.delegate controller:controller didChangeSectionAction:sectionInfo atIndex:sectionIndex forChangeType:type];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    [self.delegate controller:controller didChangeObjectAction:anObject atIndexPath:indexPath forChangeType:type newIndexPath:newIndexPath];
}
-(void)controllerWillChangeContent:(NSFetchedResultsController *)controller{
    [self.delegate controllerWillChangeContentAction:controller];
    
}



#pragma mark -
#pragma mark methods used by table view

- (id) getEntityAtIndexPath:(NSIndexPath *) _index
{
  return [rows objectAtIndexPath:_index];
}

- (void) deleteEntityAtIndexPath:(NSIndexPath *) _index
{
  [[PersistenceManager persistenceManager] deleteEntity:[rows objectAtIndexPath:_index]];
}

- (NSArray*) getSections
{
  return [rows sections];
}

- (void) resetFetchedResultsController:(NSString *) entityName 
                              sortWith:(NSDictionary*) sortKeysAscendingOrders  //dictionary of sortKey => ascendingOrder
                         withCacheName:(NSString *)cacheName 
                    withSectionKeyPath:(NSString *)sectionNameKeyPath
    
{
	[self resetFetchedResultsControllerWithPredicate:entityName 
                                          sortWith:sortKeysAscendingOrders  
                                     withCacheName:cacheName 
                                withSectionKeyPath:sectionNameKeyPath 
                                     withPredicate:nil];
}

- (void) resetFetchedResultsControllerWithPredicate:(NSString *) entityName 
                                          sortWith:(NSDictionary*) sortKeysAscendingOrders  //dictionary of sortKey => ascendingOrder
                                     withCacheName:(NSString *)cacheName 
                                withSectionKeyPath:(NSString *)sectionNameKeyPath 
                                     withPredicate:(NSPredicate *)predicate

{
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
  NSManagedObjectContext *context = [[PersistenceManager persistenceManager] managedObjectContext];
	NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
	[fetchRequest setEntity:entity];
  if(predicate != nil){
    [fetchRequest setPredicate:predicate];
  }
  if(sortKeysAscendingOrders != nil){
    NSMutableArray *sortDescriptors = [[NSMutableArray alloc] init];
    
    [sortKeysAscendingOrders enumerateKeysAndObjectsUsingBlock:^(id ob1, id ob2, BOOL *stop) {
      NSString* sortKey = (NSString*) ob1;
      NSNumber *isAscending = (NSNumber *) ob2;
      
      NSSortDescriptor *t_sortDescriptor = [[NSSortDescriptor alloc] initWithKey:sortKey ascending:[isAscending boolValue]];
      [sortDescriptors addObject:t_sortDescriptor];
      [t_sortDescriptor release];
      
    }];
    [fetchRequest setSortDescriptors:sortDescriptors];	
    [sortDescriptors release];
  }
  NSFetchedResultsController *requestController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest 
                                                                                      managedObjectContext:context
                                                                                        sectionNameKeyPath:sectionNameKeyPath 
                                                                                                 cacheName:cacheName];
  [fetchRequest release];
  if(predicate != nil){
    //in case of predicate chnage you need this because
    //core data would confuse it with the erlier cached query and return 
    //the cached data
    [NSFetchedResultsController deleteCacheWithName:cacheName];
  }
  self.rows = requestController;
  [requestController release];
  
	rows.delegate = self;
	//fetch all the values
  NSError *error = nil;
  BOOL success = [rows performFetch:&error];
	if (!success) {
		NSLog(@"Error: %@", [error localizedDescription]);
	}
}


-(NSArray *) executeQuery:(NSString *) entityName 
                 sortWith:(NSDictionary*) sortKeysAscendingOrders  //dictionary of sortKey => ascendingOrder
            withPredicate:(NSPredicate *)predicate
               withColums:(NSArray *)columns
{
	NSError *error = nil;
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
  NSManagedObjectContext *context = [[PersistenceManager persistenceManager] managedObjectContext];
	NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
	[fetchRequest setEntity:entity];
  
  if(predicate != nil){
    [fetchRequest setPredicate:predicate];
  }  
  if(sortKeysAscendingOrders != nil){
    NSMutableArray *sortDescriptors = [[NSMutableArray alloc] init];
    
    [sortKeysAscendingOrders enumerateKeysAndObjectsUsingBlock:^(id ob1, id ob2, BOOL *stop) {
      NSString* sortKey = (NSString*) ob1;
      NSNumber *isAscending = (NSNumber *) ob2;
      
      NSSortDescriptor *t_sortDescriptor = [[NSSortDescriptor alloc] initWithKey:sortKey ascending:[isAscending boolValue]];
      [sortDescriptors addObject:t_sortDescriptor];
      [t_sortDescriptor release];
      
    }];
    [fetchRequest setSortDescriptors:sortDescriptors];	
    [sortDescriptors release];
  }
     
	[fetchRequest setPropertiesToFetch:columns];
	[fetchRequest setResultType:NSDictionaryResultType];
	[fetchRequest setReturnsDistinctResults:YES];
	
	NSArray *result = [context executeFetchRequest:fetchRequest error:&error];
	[fetchRequest release];
  return result;
}

@end
