
#import "CoursePersistenceController.h"

@implementation CoursePersistenceController

-(void) sortTable
{
  NSMutableDictionary* sortKeysAscendingOrders = [[NSMutableDictionary alloc] init];
  [sortKeysAscendingOrders setObject:[NSNumber numberWithBool:NO] forKey:@"timestamp"];
  
  [self resetFetchedResultsController:@"Course" 
                             sortWith:sortKeysAscendingOrders
                        withCacheName:@"Course_timestamp" 
                   withSectionKeyPath:@"onlyDate"];
  [sortKeysAscendingOrders release];
}
@end
