//
//  LAppSprite.h
//  Live2DNewTest
//
//  Created by 谢佳培 on 2022/8/24.
//

#ifndef LAppSprite_h
#define LAppSprite_h

#import <Metal/Metal.h>
#import <UIKit/UIKit.h>

@interface LAppSprite : NSObject

// 纹理
@property (nonatomic, readonly, getter=GetTextureId) id <MTLTexture> texture;

/// 精灵（图片）颜色
@property (nonatomic) float spriteColorR;
@property (nonatomic) float spriteColorG;
@property (nonatomic) float spriteColorB;
@property (nonatomic) float spriteColorA;

@property (strong, nonatomic) id <MTLRenderPipelineState> pipelineState;

/**
 * @brief Rect 构造体
 */
typedef struct
{
    float left;     ///< 左
    float right;    ///< 右
    float up;       ///< 上
    float down;     ///< 下
} SpriteRect;

/**
 * @brief 初始化
 *
 * @param[in]       x            x坐标
 * @param[in]       y            y坐标
 * @param[in]       width        宽度
 * @param[in]       height       高度
 * @param[in]       texture    纹理
 */
- (id)initWithMyVar:(float)x Y:(float)y Width:(float)width Height:(float)height Texture:(id <MTLTexture>) texture metalViewSize:(CGSize)metalViewSize;

/**
 * @brief 立刻绘制
 */
- (void)renderImmidiate:(id<MTLRenderCommandEncoder>)renderEncoder;

/**
 * @brief 画面尺寸变更处理
 *
 * @param[in]       x            x坐标
 * @param[in]       y            y坐标
 * @param[in]       width        宽度
 * @param[in]       height       高度
 */
- (void)resizeImmidiate:(float)x Y:(float)y Width:(float)width Height:(float)height  metalViewSize:(CGSize)metalViewSize;

/**
 * @brief 是否命中
 *
 * @param[in]       pointX    x坐标
 * @param[in]       pointY    y坐标
 */
- (bool)isHit:(float)pointX PointY:(float)pointY;

/**
 * @brief 设定颜色
 *
 * @param[in]       r       赤
 * @param[in]       g       緑
 * @param[in]       b       青
 * @param[in]       a       α
 */
- (void)SetColor:(float)r g:(float)g b:(float)b a:(float)a;

/**
 * @brief 设定 MTLRenderPipelineDescriptor
 */
- (void)SetMTLRenderPipelineDescriptor:(id <MTLDevice>)device vertexProgram:(id <MTLFunction>)vertexProgram fragmentProgram:(id <MTLFunction>)fragmentProgram;

@end

#endif /* LAppSprite_h */
