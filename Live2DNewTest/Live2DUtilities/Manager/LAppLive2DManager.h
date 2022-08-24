//
//  LAppLive2DManager.h
//  Live2DNewTest
//
//  Created by 谢佳培 on 2022/8/24.
//

#ifndef LAppLive2DManager_h
#define LAppLive2DManager_h

#import <CubismFramework.hpp>
#import <Math/CubismMatrix44.hpp>
#import <Type/csmVector.hpp>
#import "LAppModel.h"
#import "LAppSprite.h"

/// 模型管理器
@interface LAppLive2DManager : NSObject

typedef NS_ENUM(NSUInteger, SelectTarget)
{
    SelectTarget_None,                ///< 在默认帧缓冲器中呈现
    SelectTarget_ModelFrameBuffer,    ///< 在LAppModel各自拥有的帧缓冲器中呈现
    SelectTarget_ViewFrameBuffer,     ///< 在LAppView具有的帧缓冲器中呈现
};

@property (nonatomic) Csm::CubismMatrix44 *viewMatrix;// 用于模型绘制的View矩阵
@property (nonatomic) Csm::csmVector<LAppModel*> models;// 模型实例的容器
@property (nonatomic) Csm::csmInt32 sceneIndex;// 显示场景的索引值
@property (nonatomic) SelectTarget renderTarget;
@property (nonatomic) Csm::Rendering::CubismOffscreenFrame_Metal* renderBuffer;
@property (nonatomic) LAppSprite* sprite;
@property (nonatomic) MTLRenderPassDescriptor* renderPassDescriptor;
@property (nonatomic) float clearColorR;
@property (nonatomic) float clearColorG;
@property (nonatomic) float clearColorB;

/**
 * @brief 返回类的实例
 *        如果没有生成实例，则在内部生成实例
 */
+ (LAppLive2DManager*)getInstance;

/**
 * @brief 释放类的实例
 */
+ (void)releaseInstance;

/**
 * @brief 返回在当前场景中保持的模型
 *
 * @param[in] no 模型列表的索引值
 * @return 返回模型的实例。如果索引值不在范围内，则返回空
 */
- (LAppModel*)getModel:(Csm::csmUint32)no;

/**
 * @brief 释放当前场景中保存的所有模型
 */
- (void)releaseAllModel;

/**
 * @brief   拖动画面时的处理
 *
 * @param[in]   x   画面的X坐标
 * @param[in]   y   画面的Y坐标
 */
- (void)onDrag:(Csm::csmFloat32)x floatY:(Csm::csmFloat32)y;

/**
 * @brief   点击画面时的处理
 *
 * @param[in]   x   画面的X坐标
 * @param[in]   y   画面的Y坐标
 */
- (void)onTap:(Csm::csmFloat32)x floatY:(Csm::csmFloat32)y;

/**
 * @brief   更新画面时的处理
 *          对模型进行更新和绘制
 */
- (void)onUpdate:(id <MTLCommandBuffer>)commandBuffer currentDrawable:(id<CAMetalDrawable>)drawable depthTexture:(id<MTLTexture>)depthTarget;

/**
 * @brief   切换到下一个场景
 *          在样本应用中进行模型集的切换
 */
- (void)nextScene;

/**
 * @brief   切换场景
 *          在样本应用中进行模型集的切换
 */
- (void)changeScene:(Csm::csmInt32)index;

/**
 * @brief   得到模型个数
 * @return  持有模型个数
 */
- (Csm::csmUint32)GetModelNum;

/**
 * @brief   设置 viewMatrix
 */
- (void)SetViewMatrix:(Csm::CubismMatrix44*)m;

/**
 * @brief 切换渲染目标
 */
- (void)SwitchRenderingTarget:(SelectTarget) targetType;

/**
 * @brief 将渲染目标设置为非默认值的背景透明色
 * @param[in]   r   赤(0.0~1.0)
 * @param[in]   g   緑(0.0~1.0)
 * @param[in]   b   青(0.0~1.0)
 */
- (void)SetRenderTargetClearColor:(float)r g:(float)g b:(float)b;

@end

#endif /* LAppLive2DManager_h */
