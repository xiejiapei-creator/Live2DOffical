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
+ (void)changeNextLive2DModel {
    [[LAppLive2DManager getInstance] nextScene];
}

#pragma mark - 模型运动

+ (void)setParameterValue:(ParamType)type value:(float)value {
    [[LAppLive2DManager getInstance] SetParameterValue:type value:value];
}

+ (void)isLiveBroadcast:(BOOL)isLive {
    [LAppLive2DManager getInstance].isLiveBroadcast = isLive;
}

#pragma mark - Sprite

// 创建角色模型以外的精灵（绘图）
+ (void)createSprite:(CGSize)metalViewSize {
    [[L2DSprite sharedInstance] createSprite:metalViewSize];
}

@end
