

#import "Course.h"


@implementation Course 

@dynamic name;
@dynamic teacher;
@dynamic timestamp;

-(NSString*)onlyDate{
  [self willAccessValueForKey:@"timestamp"];
  NSDate *currentLastModified = [self timestamp];
  [self didAccessValueForKey:@"timestamp"];
  
  NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
  
  [dateFormat setDateStyle:NSDateFormatterMediumStyle];
  [dateFormat setTimeStyle:NSDateFormatterNoStyle];
  
  NSString *theDate = [dateFormat stringFromDate:currentLastModified];
  [dateFormat release];
  return theDate;
}

@end
