
#import <UIKit/UIKit.h>

@interface CoreDataDAOAppDelegate : NSObject <UIApplicationDelegate> {
    UINavigationController *navigationController;
    UIWindow *window;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) UINavigationController *navigationController;

- (void) populateDataCourse;

@end

