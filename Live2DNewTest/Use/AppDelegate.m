//
//  AppDelegate.m
//  Live2DNewTest
//
//  Created by 谢佳培 on 2022/8/24.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "Live2DBridge.h"
#import "Live2DNewTest-Swift.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
//    ViewController *viewController = [[ViewController alloc] initWithNibName:nil bundle:nil];
    Live2DARViewController *viewController = [[Live2DARViewController alloc] initWithNibName:nil bundle:nil];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    
    self.window.rootViewController = navigationController;
    [self.window makeKeyAndVisible];

    [Live2DBridge initializeCubism];

    return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [Live2DBridge destroyTextureManager];
    [Live2DBridge saveRoleState];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [Live2DBridge createTextureManager];
    [Live2DBridge restoreRoleState];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [Live2DBridge disposeCubism];
}

- (void)defaultSetting {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL isFirstRun = [defaults boolForKey:@"FIRST_RUN"];
    if (isFirstRun) {
        [defaults setBool:NO forKey: @"FIRST_RUN"];
        [defaults setFloat:1 forKey:@"ZOOM"];
        [defaults setFloat:0 forKey:@"X_POS"];
        [defaults setFloat:-0.8 forKey:@"Y_POS"];
    }
}

@end
