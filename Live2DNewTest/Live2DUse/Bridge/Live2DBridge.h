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
+ (NSString *)nextLive2DModelName;

/// 切换到指定人物，并指定是否必须要重新渲染纹理
/// 切换模型：如果之前已经加载过纹理则不需要重新加载，所以非必需重新加载 needReloadTexture 为 NO
/// 换装：不管之前有没有加载过纹理都必须要重新加载
+ (void)changeLive2DModelWithName:(NSString *)name needReloadTexture:(BOOL)needReloadTexture;

/// 创建角色模型以外的精灵（绘图）
/// 必须保证精灵在初始化 Cubism SDK 和视图呈现之后创建，因为顺序颠倒会崩溃，可以放在viewDidAppear中
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
