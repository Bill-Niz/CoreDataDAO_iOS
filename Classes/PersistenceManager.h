#import <CoreData/CoreData.h>

@interface PersistenceManager : NSObject{
  NSManagedObjectModel *managedObjectModel;
  NSManagedObjectContext *managedObjectContext;	    
  NSPersistentStoreCoordinator *persistenceStoreCoordinator;
}

@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistenceStoreCoordinator;


+ (PersistenceManager *) persistenceManager;

- (NSPersistentStoreCoordinator *)persistenceStoreCoordinator;
- (NSManagedObjectModel *)managedObjectModel;
- (NSManagedObjectContext *) managedObjectContext;

- (void)saveContext;
- (void)deleteEntity:(id)entity;
@end
