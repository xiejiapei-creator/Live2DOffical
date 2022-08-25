//
//  L2DSprite.h
//  Live2DNewTest
//
//  Created by 谢佳培 on 2022/8/24.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "LAppSprite.h"// 精灵

NS_ASSUME_NONNULL_BEGIN

@interface L2DSprite : NSObject

@property (nonatomic, assign) BOOL existSprite;// 是否存在精灵
@property (nonatomic, strong) LAppSprite *back;// 背景图
@property (nonatomic, strong) LAppSprite *gear;// 齿轮图
@property (nonatomic, strong) LAppSprite *power;// 电源图

+ (instancetype)sharedInstance;

/// 创建角色模型以外的精灵（绘图）
- (void)createSprite:(CGSize)metalViewSize;

/// 销毁角色模型以外的精灵（绘图）
- (void)destroySprite;

/// 立刻渲染角色模型以外的绘图（精灵）
- (void)renderSprite:(id<MTLRenderCommandEncoder>)renderEncoder;

@end

NS_ASSUME_NONNULL_END
