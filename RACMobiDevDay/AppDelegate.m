#import "AppDelegate.h"
#import "SignUpViewController.h"
#import <AFNetworking/UIKit+AFNetworking.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Enable the network indicator management
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = [SignUpViewController new];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
