//
//  Live2DBridge.m
//  Live2DNewTest
//
//  Created by 谢佳培 on 2022/8/25.
//

#import "Live2DBridge.h"
#import "L2DBridge.h"
#import "L2DTouch.h"
#import "L2DCubism.h"

@implementation Live2DBridge

#pragma mark - Cubism SDK

+ (void)initializeCubism {
    [[L2DCubism sharedInstance] initializeCubism];
}

+ (void)disposeCubism {
    [[L2DCubism sharedInstance] disposeCubism];
}

+ (void)createTextureManager {
    [[L2DCubism sharedInstance] createTextureManager];
}

+ (void)destroyTextureManager {
    [[L2DCubism sharedInstance] destroyTextureManager];
}

+ (void)saveRoleState {
    [[L2DCubism sharedInstance] saveRoleState];
}

+ (void)restoreRoleState {
    [[L2DCubism sharedInstance] restoreRoleState];
}

#pragma mark - 渲染视图

+ (void)createLive2DView:(LMetalUIView *)view {
    [L2DBridge createLive2DView:view];
}

+ (void)destroyLive2DView {
    [L2DBridge destroyLive2DView];
}

#pragma mark - 切换模型

+ (void)changeNextLive2DModel {
    [L2DBridge changeNextLive2DModel];
}

#pragma mark - 精灵

+ (void)createSprite:(CGSize)metalViewSize {
    [L2DBridge createSprite:metalViewSize];
}

#pragma mark - 手势触摸

/// 触摸开始
+ (void)touchesBegan:(NSSet *)touches view:(Live2DView *)view {
    [[L2DTouch sharedInstance] touchesBegan:touches view:view];
}

/// 触摸移动
+ (void)touchesMoved:(NSSet *)touches view:(Live2DView *)view {
    [[L2DTouch sharedInstance] touchesMoved:touches view:view];
}

/// 触摸结束
+ (void)touchesEnded:(NSSet *)touches view:(Live2DView *)view {
    [[L2DTouch sharedInstance] touchesEnded:touches view:view];
}

/// 销毁触摸事件管理器
+ (void)destroyTouchManager {
    [[L2DTouch sharedInstance] destroyTouchManager];
}

@end
