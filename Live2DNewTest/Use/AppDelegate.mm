/**
 * Copyright(c) Live2D Inc. All rights reserved.
 *
 * Use of this source code is governed by the Live2D Open Software license
 * that can be found at https://www.live2d.com/eula/live2d-open-software-license-agreement_en.html.
 */

#import "AppDelegate.h"
#import <iostream>
#import "ViewController.h"
#import "LAppAllocator.h"
#import "LAppPal.h"
#import "LAppDefine.h"
#import "LAppLive2DManager.h"
#import "LAppTextureManager.h"

#import "L2DCubism.h"

@interface AppDelegate ()


@property (nonatomic) bool captured; // 是否单击
@property (nonatomic) float mouseX; // 鼠标X坐标
@property (nonatomic) float mouseY; // 鼠标Y坐标


@property (nonatomic) Csm::csmInt32 sceneIndex;// 应用程序在后台运行时临时保存场景索引值

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.viewController = [[ViewController alloc] initWithNibName:nil bundle:nil];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];

    [[L2DCubism sharedInstance] initializeCubism];
    [self.viewController initializeSprite];

    return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[L2DCubism sharedInstance] destroyTextureManager];
    _sceneIndex = [[LAppLive2DManager getInstance] sceneIndex];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [[L2DCubism sharedInstance] createTextureManager];
    [[LAppLive2DManager getInstance] changeScene:_sceneIndex];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    self.viewController = nil;
}

- (void)finishApplication
{
    [[L2DCubism sharedInstance] disposeCubism];

    self.viewController = nil;
    [self.viewController releaseView];

    self.window = nil;
    exit(0);
}

@end