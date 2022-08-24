//
//  L2DSprite.h
//  Live2DNewTest
//
//  Created by 谢佳培 on 2022/8/24.
//

#import <Foundation/Foundation.h>
#import "LAppSprite.h"// 精灵
#import "L2DMetal.h"// Metal

NS_ASSUME_NONNULL_BEGIN

@interface L2DSprite : NSObject

@property (nonatomic) LAppSprite *back;// 背景图
@property (nonatomic) LAppSprite *gear;// 齿轮图
@property (nonatomic) LAppSprite *power;// 电源图

+ (instancetype)sharedInstance;

/// 创建角色模型以外的精灵（绘图）
- (void)createSprite;

/// 销毁角色模型以外的精灵（绘图）
- (void)destroySprite;

/// 渲染到视图上
- (void)renderToMetalLayer:(nonnull CAMetalLayer *)layer;

@end

NS_ASSUME_NONNULL_END
