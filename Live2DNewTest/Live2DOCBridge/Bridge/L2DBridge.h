//
//  L2DBridge.h
//  Live2DNewTest
//
//  Created by 谢佳培 on 2022/8/24.
//

#import "LMetalUIView.h"// Metal视图

NS_ASSUME_NONNULL_BEGIN

@interface L2DBridge : NSObject

/// 创建 Live2D 视图
+ (void)createLive2DView:(LMetalUIView *)view;

/// 销毁 Live2D 视图
+ (void)destroyLive2DView;

/// 切换下一个人物模型
+ (void)changeNextLive2DModel;

// 创建角色模型以外的精灵（绘图）
+ (void)createSprite:(CGSize)metalViewSize;

@end

NS_ASSUME_NONNULL_END
