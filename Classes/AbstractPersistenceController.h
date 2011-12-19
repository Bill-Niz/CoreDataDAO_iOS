
#import "PersistenceManager.h"

@interface AbstractPersistenceController : NSObject <NSFetchedResultsControllerDelegate> {
  NSFetchedResultsController *rows;
}

@property (nonatomic, retain) NSFetchedResultsController *rows;

- (void) saveEntity;
- (id) getNewEntityObject:(NSString *) entityName;
- (NSIndexPath *)getIndexPathForObject:(id) object;
- (void) controllerDidChangeContentAction:(NSFetchedResultsController *)controller;
- (id) getEntityAtIndexPath:(NSIndexPath *) _index;
- (void) deleteEntityAtIndexPath:(NSIndexPath *) _index;
- (NSArray*) getSections;
- (void) resetFetchedResultsController:(NSString *) entityName 
                              sortWith:(NSDictionary*) sortKeysAscendingOrders  //dictionary of sortKey => ascendingOrder
                         withCacheName:(NSString *)cacheName 
                    withSectionKeyPath:(NSString *)sectionNameKeyPath;

- (void) resetFetchedResultsControllerWithPredicate:(NSString *) entityName 
                                           sortWith:(NSDictionary*) sortKeysAscendingOrders  //dictionary of sortKey => ascendingOrder
                                      withCacheName:(NSString *)cacheName 
                                 withSectionKeyPath:(NSString *)sectionNameKeyPath 
                                      withPredicate:(NSPredicate *)predicate;

//return array of dictionary
-(NSArray *) executeQuery:(NSString *) entityName 
                 sortWith:(NSDictionary*) sortKeysAscendingOrders  //dictionary of sortKey => ascendingOrder
            withPredicate:(NSPredicate *)predicate
               withColums:(NSArray *)columns;

@end
