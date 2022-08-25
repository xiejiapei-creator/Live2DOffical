//
//  LMetalView.m
//  Live2DNewTest
//
//  Created by 谢佳培 on 2022/8/24.
//

#import "LMetalView.h"

@implementation LMetalView

///////////////////////////////////////
#pragma mark - Initialization and Setup
///////////////////////////////////////

- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        [self initCommon];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self initCommon];
    }
    return self;
}

- (void)initCommon
{
    _metalLayer = (CAMetalLayer*) self.layer;
    self.layer.delegate = self;
}

//////////////////////////////////
#pragma mark - Render Loop Control
//////////////////////////////////

#if ANIMATION_RENDERING

- (void)stopRenderLoop
{
    // 子类需要实现这个方法
}

- (void)dealloc
{
    [self stopRenderLoop];
}

#else // IF !ANIMATION_RENDERING

#endif // END !ANIMAITON_RENDERING
///////////////////////
#pragma mark - Resizing
///////////////////////

#if AUTOMATICALLY_RESIZE

- (void)resizeDrawable:(CGFloat)scaleFactor
{
    CGSize newSize = self.bounds.size;
    newSize.width *= scaleFactor;
    newSize.height *= scaleFactor;

    if(newSize.width <= 0 || newSize.width <= 0)
    {
        return;
    }

#if RENDER_ON_MAIN_THREAD

    if(newSize.width == _metalLayer.drawableSize.width &&
       newSize.height == _metalLayer.drawableSize.height)
    {
        return;
    }

    _metalLayer.drawableSize = newSize;

    [_delegate drawableResize:newSize];

#else
    // 所有通知调整大小的AppKit和UIKit调用都是在主线程上调用的
    // 使用同步块确保委托上的调整大小通知是原子的
    @synchronized(_metalLayer)
    {
        if(newSize.width == _metalLayer.drawableSize.width &&
           newSize.height == _metalLayer.drawableSize.height)
        {
            return;
        }

        _metalLayer.drawableSize = newSize;

        [_delegate drawableResize:newSize];
    }
#endif
}

#endif

//////////////////////
#pragma mark - Drawing
//////////////////////

- (void)render
{
#if RENDER_ON_MAIN_THREAD
    [_delegate renderToMetalLayer:_metalLayer];
#else
    // 必须同步如果渲染在后台线程，以确保从主线程的调整操作在渲染之前完成，这取决于发生的大小。
    @synchronized(_metalLayer)
    {
        [_delegate renderToMetalLayer:_metalLayer];
    }
#endif
}

@end
