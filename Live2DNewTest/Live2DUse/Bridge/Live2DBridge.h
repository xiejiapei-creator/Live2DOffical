//
//  Live2DBridge.h
//  Live2DNewTest
//
//  Created by 谢佳培 on 2022/8/25.
//

#import <Foundation/Foundation.h>
#import "LMetalUIView.h"
#import "Live2DView.h"

NS_ASSUME_NONNULL_BEGIN

@interface Live2DBridge : NSObject

/// 初始化 Cubism SDK
+ (void)initializeCubism;
/// 销毁 Cubism SDK
+ (void)disposeCubism;

/// 创建纹理管理器
+ (void)createTextureManager;
/// 销毁纹理管理器
+ (void)destroyTextureManager;

/// 保存角色状态
+ (void)saveRoleState;
/// 恢复角色状态
+ (void)restoreRoleState;

/// 创建 Live2D 视图
+ (void)createLive2DView:(LMetalUIView *)view;
/// 销毁 Live2D 视图
+ (void)destroyLive2DView;

/// 切换下一个人物模型
+ (void)changeNextLive2DModel;
// 创建角色模型以外的精灵（绘图）
+ (void)createSprite:(CGSize)metalViewSize;

/// 触摸开始
+ (void)touchesBegan:(NSSet *)touches view:(Live2DView *)view;
/// 触摸移动
+ (void)touchesMoved:(NSSet *)touches view:(Live2DView *)view;
/// 触摸结束
+ (void)touchesEnded:(NSSet *)touches view:(Live2DView *)view;
/// 销毁触摸事件管理器
+ (void)destroyTouchManager;

@end

NS_ASSUME_NONNULL_END
