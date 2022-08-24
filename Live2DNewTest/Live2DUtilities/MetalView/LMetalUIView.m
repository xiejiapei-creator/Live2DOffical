//
//  LMetalUIView.m
//  Live2DNewTest
//
//  Created by 谢佳培 on 2022/8/24.
//

#import "LMetalUIView.h"
#import "LMetalConfig.h"

@implementation LMetalUIView
{
    CADisplayLink *_displayLink;

#if !RENDER_ON_MAIN_THREAD
    // 包含渲染循环的次要线程
    NSThread *_renderThread;

    // 标志，表示呈现应该在主线程中停止
    BOOL _continueRunLoop;
#endif
}

///////////////////////////////////////
#pragma mark - 初始化和设置
///////////////////////////////////////

+ (Class) layerClass
{
    return [CAMetalLayer class];
}

- (void)didMoveToWindow
{
    [super didMoveToWindow];

#if ANIMATION_RENDERING
    if(self.window == nil)
    {
        // 如果移出窗口将破坏显示链接
        [_displayLink invalidate];
        _displayLink = nil;
        return;
    }

    [self setupCADisplayLinkForScreen:self.window.screen];

#if RENDER_ON_MAIN_THREAD

    // CADisplayLink回调函数与'NSRunLoop'相关联 The currentRunLoop is the
    // currentRunLoop是主要的运行循环 因为'didMoveToWindow'总是从主线程执行。
    [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];

#else // IF !RENDER_ON_MAIN_THREAD

    // 使用' @synchronized '块来保护_continueRunLoop，因为它被单独的动画线程访问
    @synchronized(self)
    {
        // 停止动画循环，让循环完成，如果它正在进行
        _continueRunLoop = NO;
    }

    // 创建并启动一个次要NSThread，它将有另一个运行runloop
    // NSThread类会在第二个线程开始执行时调用'runThread'方法
    _renderThread =  [[NSThread alloc] initWithTarget:self selector:@selector(runThread) object:nil];
    _continueRunLoop = YES;
    [_renderThread start];

#endif // 结束 !RENDER_ON_MAIN_THREAD
#endif // 结束 ANIMATION_RENDERING

    // 执行任何需要知道绘图尺寸和比例的动作。
    // 当UIKit调用didMoveToWindow在视图初始化后，这是第一次通知的机会
    // 组件的尺寸
#if AUTOMATICALLY_RESIZE
    [self resizeDrawable:self.window.screen.nativeScale];
#else
    // 当它可以计算时通知委托默认的绘制大小
    CGSize defaultDrawableSize = self.bounds.size;
    defaultDrawableSize.width *= self.layer.contentsScale;
    defaultDrawableSize.height *= self.layer.contentsScale;
    [self.delegate drawableResize:defaultDrawableSize];
#endif
}

//////////////////////////////////
#pragma mark - 渲染循环控制
//////////////////////////////////

#if ANIMATION_RENDERING

- (void)setPaused:(BOOL)paused
{
    super.paused = paused;

    _displayLink.paused = paused;
}

- (void)setupCADisplayLinkForScreen:(UIScreen*)screen
{
    [self stopRenderLoop];

    _displayLink = [screen displayLinkWithTarget:self selector:@selector(render)];

    _displayLink.paused = self.paused;

    _displayLink.preferredFramesPerSecond = 60;
}

- (void)stopRenderLoop
{
    [_displayLink invalidate];
}

#if !RENDER_ON_MAIN_THREAD
- (void)runThread
{
    // 将display链接设置为这个线程的运行循环，以便它的回调在这个线程上发生
    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
    [_displayLink addToRunLoop:runLoop forMode:@"MetalDisplayLinkMode"];

    // '_continueRunLoop'变量设置在线程外部，因此必须同步。
    // 创建一个'continueRunLoop'本地变量
    // 可以在@ synchronized 块中的_continueRunLoop变量中设置
    BOOL continueRunLoop = YES;

    while (continueRunLoop)
    {
        // 为当前循环迭代创建自动释放池
        @autoreleasepool
        {
            // 将它与在另一个线程上设置的_continueRunLoop ivar同步
            [runLoop runMode:@"MetalDisplayLinkMode" beforeDate:[NSDate distantFuture]];
        }

        @synchronized(self)
        {
            // 在线程外访问的任何内容，例如'_continueRunLoop' ivar
            // 在同步块内部读取，以确保它完全/原子地写入
            continueRunLoop = _continueRunLoop;
        }
    }
}
#endif // 结束 !RENDER_ON_MAIN_THREAD

#endif // 结束 ANIMATION_RENDERING

///////////////////////
#pragma mark - 调整尺寸
///////////////////////

// 覆盖所有表示视图大小已经改变的方法

#if AUTOMATICALLY_RESIZE

- (void)setContentScaleFactor:(CGFloat)contentScaleFactor
{
    [super setContentScaleFactor:contentScaleFactor];
    [self resizeDrawable:self.window.screen.nativeScale];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self resizeDrawable:self.window.screen.nativeScale];
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self resizeDrawable:self.window.screen.nativeScale];
}

- (void)setBounds:(CGRect)bounds
{
    [super setBounds:bounds];
    [self resizeDrawable:self.window.screen.nativeScale];
}

#endif // 结束 AUTOMATICALLY_RESIZE

@end
