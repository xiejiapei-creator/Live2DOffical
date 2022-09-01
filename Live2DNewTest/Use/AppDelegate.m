//
//  AppDelegate.m
//  Live2DNewTest
//
//  Created by 谢佳培 on 2022/8/24.
//

#import "AppDelegate.h"
#include "ViewController.h"
#import "Live2DBridge.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *live2DResourcesPath = [NSString stringWithFormat:@"%@/%@", documentDirectory, @"Live2DResources"];
    NSArray *pathList = [fileManager subpathsAtPath:live2DResourcesPath];

    for (NSString *path in pathList)
    {
        NSString *fullPath = [NSString stringWithFormat:@"%@/Live2DResources/%@", documentDirectory, path];
        [fileManager removeItemAtPath:fullPath error:nil];
    }
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    ViewController *viewController = [[ViewController alloc] initWithNibName:nil bundle:nil];
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

@end
