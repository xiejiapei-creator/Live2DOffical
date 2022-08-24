//
//  LMetalView.h
//  Live2DNewTest
//
//  Created by 谢佳培 on 2022/8/24.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/CAMetalLayer.h>
#import <Metal/Metal.h>
#import "LMetalConfig.h"

// 为委托提供调整大小和重新绘制回调的协议
@protocol MetalViewDelegate <NSObject>

/// 调整大小回调
- (void)drawableResize:(CGSize)size;

/// 重新绘制回调
- (void)renderToMetalLayer:(nonnull CAMetalLayer *)metalLayer;

@end

// Metal 的视图基类
@interface LMetalView : UIView <CALayerDelegate>

/// 显示在屏幕上的 Metal 渲染图层
@property (nonatomic, nonnull, readonly) CAMetalLayer *metalLayer;

@property (nonatomic, getter=isPaused) BOOL paused;

@property (nonatomic, nullable) id<MetalViewDelegate> delegate;

- (void)initCommon;

#if AUTOMATICALLY_RESIZE
- (void)resizeDrawable:(CGFloat)scaleFactor;
#endif

#if ANIMATION_RENDERING
- (void)stopRenderLoop;
#endif

@end
