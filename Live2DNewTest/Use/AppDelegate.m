//
//  AppDelegate.m
//  Live2DNewTest
//
//  Created by 谢佳培 on 2022/8/24.
//

#import "AppDelegate.h"

#import "L2DCubism.h"
#import "L2DBridge.h"

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.viewController = [[ViewController alloc] initWithNibName:nil bundle:nil];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];

    // 初始化 Cubism SDK
    [[L2DCubism sharedInstance] initializeCubism];
    
    // 创建角色模型以外的精灵（绘图）
    [L2DBridge createSprite];

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

- (void)applicationWillTerminate:(UIApplication *)application {
    self.viewController = nil;
}

- (void)finishApplication
{
    [[L2DCubism sharedInstance] disposeCubism];

    self.viewController = nil;

    self.window = nil;
    exit(0);
}

@end
