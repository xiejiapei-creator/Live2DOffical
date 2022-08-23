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

@interface AppDelegate ()

@property (nonatomic) LAppAllocator cubismAllocator; // Cubism SDK 分配器
@property (nonatomic) Csm::CubismFramework::Option cubismOption; // 立体主义 Cubism SDK 选项
@property (nonatomic) bool captured; // 是否单击
@property (nonatomic) float mouseX; // 鼠标X坐标
@property (nonatomic) float mouseY; // 鼠标Y坐标
@property (nonatomic) bool isEnd; // 是否终止APP
@property (nonatomic, readwrite) LAppTextureManager *textureManager;// 纹理管理器
@property (nonatomic) Csm::csmInt32 sceneIndex;// 应用程序在后台运行时临时保存场景索引值

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    _textureManager = [[LAppTextureManager alloc]init];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.viewController = [[ViewController alloc] initWithNibName:nil bundle:nil];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];

    [self initializeCubism];

    [self.viewController initializeSprite];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    _textureManager = nil;

    _sceneIndex = [[LAppLive2DManager getInstance] sceneIndex];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    _textureManager = [[LAppTextureManager alloc]init];

    [[LAppLive2DManager getInstance] changeScene:_sceneIndex];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{

}

- (void)applicationWillTerminate:(UIApplication *)application {
    self.viewController = nil;
}

- (void)initializeCubism
{
    _cubismOption.LogFunction = LAppPal::PrintMessage;
    _cubismOption.LoggingLevel = LAppDefine::CubismLoggingLevel;

    Csm::CubismFramework::StartUp(&_cubismAllocator,&_cubismOption);

    Csm::CubismFramework::Initialize();

    [LAppLive2DManager getInstance];

    Csm::CubismMatrix44 projection;

    LAppPal::UpdateTime();

}

- (bool)getIsEnd
{
    return _isEnd;
}

- (void)finishApplication
{
    [self.viewController releaseView];

    _textureManager = nil;

    [LAppLive2DManager releaseInstance];

    Csm::CubismFramework::Dispose();

    self.window = nil;

    self.viewController = nil;

    _isEnd = true;

    exit(0);
}

@end
