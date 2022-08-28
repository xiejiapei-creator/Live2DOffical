//
//  AppDelegate.m
//  Live2DNewTest
//
//  Created by 谢佳培 on 2022/8/24.
//

#import "AppDelegate.h"
#include "ViewController.h"
#import "Live2DBridge.h"
#import "Live2DNewTest-Swift.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    Live2DARViewController *viewController = [[Live2DARViewController alloc] initWithNibName:nil bundle:nil];
    self.window.rootViewController = viewController;
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
        [defaults setFloat:0.65 forKey:@"RED_COLOR"];
        [defaults setFloat:0.65 forKey:@"GREEN_COLOR"];
        [defaults setFloat:0.65 forKey:@"BLUE_COLOR"];
        [defaults setFloat:1 forKey:@"ZOOM"];
        [defaults setFloat:0 forKey:@"X_POS"];
        [defaults setFloat:-0.8 forKey:@"Y_POS"];
    }
}

@end
