//
//  AppDelegate.m
//  Live2DNewTest
//
//  Created by 谢佳培 on 2022/8/24.
//

#import "AppDelegate.h"
#import "L2DCubism.h"

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    ViewController *viewController = [[ViewController alloc] initWithNibName:nil bundle:nil];
    self.window.rootViewController = viewController;
    [self.window makeKeyAndVisible];
    
    // 初始化 Cubism SDK
    [[L2DCubism sharedInstance] initializeCubism];

    return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[L2DCubism sharedInstance] destroyTextureManager];
    [[L2DCubism sharedInstance] saveRoleState];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [[L2DCubism sharedInstance] createTextureManager];
    [[L2DCubism sharedInstance] restoreRoleState];
}

- (void)finishApplication
{
    [[L2DCubism sharedInstance] disposeCubism];

    self.window = nil;
    exit(0);
}

@end
