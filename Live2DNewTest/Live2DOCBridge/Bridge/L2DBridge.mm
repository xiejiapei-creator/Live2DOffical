//
//  L2DBridge.m
//  Live2DNewTest
//
//  Created by 谢佳培 on 2022/8/24.
//

#import "L2DBridge.h"
#import "L2DSprite.h"
#import "L2DMetal.h"
#import "LAppLive2DManager.h"

@implementation L2DBridge

#pragma mark - Metal 渲染视图

// 创建 Metal 渲染视图
+ (void)createLive2DView:(LMetalUIView *)view {
    [[L2DMetal sharedInstance] createMetalView:view];
}

+ (void)destroyLive2DView {
    [[L2DMetal sharedInstance] deleteMatrix];
    [[L2DSprite sharedInstance] destroySprite];
}

#pragma mark - 切换模型

/// 切换下一个人物模型
+ (NSString *)nextLive2DModelName {
    return [[LAppLive2DManager getInstance] nextSceneName];
}

/// 切换到指定人物
+ (void)changeLive2DModelWithName:(NSString *)name needReloadTexture:(BOOL)needReloadTexture {
    if (name == nil || [name isEqualToString:@""]) {
        return;
    }

    Csm::csmInt32 modelSize = LAppDefine::ModelDirSize;
    for (Csm::csmInt32 index = 0; index < modelSize; index++) {
        const csmChar* modelJsonName = LAppDefine::ModelDir[index];
        NSString *modelName = [NSString stringWithUTF8String:modelJsonName];
        if ([name isEqualToString:modelName]) {
            [[LAppLive2DManager getInstance] changeScene:index needReloadTexture:needReloadTexture];
            break;
        }
    }
}

#pragma mark - Sprite

// 创建角色模型以外的精灵（绘图）
+ (void)createSprite:(CGSize)metalViewSize {
    [[L2DSprite sharedInstance] createSprite:metalViewSize];
}

@end
