#import "AppDelegate.h"
#import "SignUpViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = [SignUpViewController new];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
