//
//  L2DCubism.m
//  Live2DNewTest
//
//  Created by 谢佳培 on 2022/8/23.
//

#import "L2DCubism.h"

#import "LAppAllocator.h"// 分配器
#import "LAppLive2DManager.h"// 管理者
#import "LAppPal.h"// 协助者
#import "LAppTextureManager.h"// 纹理
#import "LAppDefine.h"// SDK头文件

@interface L2DCubism ()

// Cubism SDK 分配器
@property (nonatomic) LAppAllocator cubismAllocator;
// Cubism SDK 选项
@property (nonatomic) Csm::CubismFramework::Option cubismOption;

// 纹理管理器
@property (nonatomic, readwrite) LAppTextureManager *textureManager;

// 应用程序在后台运行时临时保存角色模型索引值
@property (nonatomic) Csm::csmInt32 roleIndex;

@end

@implementation L2DCubism

+ (instancetype)sharedInstance {
    static L2DCubism *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[L2DCubism alloc] init];
    });
    return sharedInstance;
}

#pragma mark - Cubism SDK

- (void)initializeCubism {
    _cubismOption.LogFunction = LAppPal::PrintMessage;
    _cubismOption.LoggingLevel = LAppDefine::CubismLoggingLevel;
    _textureManager = [[LAppTextureManager alloc] init];

    Csm::CubismFramework::StartUp(&_cubismAllocator,&_cubismOption);
    Csm::CubismFramework::Initialize();

    LAppPal::UpdateTime();
}

- (void)disposeCubism {
    _textureManager = nil;
    
    [LAppLive2DManager releaseInstance];

    Csm::CubismFramework::Dispose();
}

#pragma mark - 纹理管理器

- (void)createTextureManager {
    _textureManager = [[LAppTextureManager alloc] init];
}

- (void)destroyTextureManager {
    _textureManager = nil;
}

#pragma mark - 角色模型

- (void)saveRoleState {
    _roleIndex = [[LAppLive2DManager getInstance] sceneIndex];
}

- (void)restoreRoleState {
    [[LAppLive2DManager getInstance] changeScene:_roleIndex];
}

@end
