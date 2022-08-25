//
//  L2DMetal.m
//  Live2DNewTest
//
//  Created by 谢佳培 on 2022/8/23.
//

#import "L2DMetal.h"
#import "Rendering/Metal/CubismRenderingInstanceSingleton_Metal.h"// 必须在 Metal 框架端保留的值
#import <Math/CubismMatrix44.hpp>// 从设备到屏幕的矩阵
#import "L2DRender.h"// 渲染

@implementation L2DMetal

+ (instancetype)sharedInstance {
    static L2DMetal *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[L2DMetal alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        // 用于将设备坐标转换为屏幕坐标
        _deviceToScreen = new CubismMatrix44();

        // 对显示画面进行放大、缩小、移动的变换矩阵
        _viewMatrix = new CubismViewMatrix();
    }
    return self;
}

#pragma mark - 创建渲染视图

- (void)createMetalView:(LMetalUIView *)roleView {
    // 为 Metal 设置渲染图层的设备和显示在屏幕上的渲染图层
    [self configMetalSingletonInstance:roleView];

    // 初始化渲染视图的尺寸为屏幕宽高
    [self initRenderViewSize];
}

/// 为 Metal 设置渲染图层的设备和显示在屏幕上的渲染图层
- (void)configMetalSingletonInstance:(LMetalUIView *)roleView {
    // 为 Metal 设置渲染图层的设备
    CubismRenderingInstanceSingleton_Metal *single = [CubismRenderingInstanceSingleton_Metal sharedManager];
    id<MTLDevice> device = MTLCreateSystemDefaultDevice();
    [single setMTLDevice:device];

    // 将此类设置为接收调整大小和渲染回调的委托
    roleView.delegate = self;

    // 图层纹理的像素格式
    roleView.metalLayer.pixelFormat = MTLPixelFormatBGRA8Unorm;
    roleView.metalLayer.device = device;
    
    // 为 Metal 设置显示在屏幕上的渲染图层
    [single setMetalLayer:roleView.metalLayer];

    // 命令队列对象与设备相关联
    // 通常，在应用程序启动时创建一个或多个命令队列，然后在应用程序的整个生命周期中保留这些队列
    _commandQueue = [device newCommandQueue];
}

/// 初始化渲染视图的尺寸为屏幕宽高
- (void)initRenderViewSize
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    int width = screenRect.size.width;
    int height = screenRect.size.height;
    
    [self configViewMatrix:width height:height];
    [self configDeviceToScreenMatrix:width height:height];
}

#pragma mark - 调整渲染视图的大小

/// 调整大小回调
- (void)drawableResize:(CGSize)size
{
    // 创建纹理图像
    [self createTexture:size];

    // 调整为渲染视图的实际宽高
    CGSize metalSize = CGSizeMake(size.width/2, size.height/2);
    [self resizeForRenderView:metalSize];
}

// 重新绘制回调
- (void)renderToMetalLayer:(nonnull CAMetalLayer *)metalLayer {
    [L2DRender renderToMetalLayer:metalLayer];
}

/// 创建纹理图像
- (void)createTexture:(CGSize)size {
    // 要创建一个新的纹理，首先创建一个MTLTextureDescriptor对象并设置它的属性值：纹理图像的像素存储格式  纹理图像的宽度和高度
    MTLTextureDescriptor* depthTextureDescriptor = [MTLTextureDescriptor texture2DDescriptorWithPixelFormat:MTLPixelFormatDepth32Float width:size.width height:size.height mipmapped:false];
    
    // 如果给定的纹理在你的应用中有多个用途，你可以为该纹理组合多个使用选项：渲染目标 + 着色器读取
    // Metal 可以根据其预期用途，优化给定纹理的操作
    depthTextureDescriptor.usage = MTLTextureUsageRenderTarget | MTLTextureUsageShaderRead;
    depthTextureDescriptor.storageMode = MTLStorageModePrivate;

    // 获取 Metal 渲染图层的设备
    CubismRenderingInstanceSingleton_Metal *single = [CubismRenderingInstanceSingleton_Metal sharedManager];
    id <MTLDevice> device = [single getMTLDevice];
    
    // 创建一个MTLTextureDescriptor对象来描述纹理的属性，然后调用MTLDevice协议的newTextureWithDescriptor:方法来创建纹理
    _depthTexture = [device newTextureWithDescriptor:depthTextureDescriptor];
}

/// 调整为渲染视图的实际宽高
- (void)resizeForRenderView:(CGSize)metalSize
{
    int width = metalSize.width;
    int height = metalSize.height;

    [self configViewMatrix:width height:height];
    [self configDeviceToScreenMatrix:width height:height];
}

/// 设定用于模型绘制的视图矩阵
- (void)configViewMatrix:(CGFloat)width height:(CGFloat)height {
    
    // 以纵向尺寸为基准，上下为1，左右按照比例设置
    float ratio = static_cast<float>(width) / static_cast<float>(height);
    float left = -ratio;
    float right = ratio;
    float bottom = ViewLogicalLeft;
    float top = ViewLogicalRight;
    
    // 设置 用于模型绘制的视图矩阵 与设备相对应的屏幕范围
    _viewMatrix->SetScreenRect(left, right, bottom, top);
    // 将 用于模型绘制的视图矩阵 的放大率设定为指定的倍率
    _viewMatrix->Scale(ViewScale, ViewScale);

    // 设定 用于模型绘制的视图矩阵 的缩放范围
    _viewMatrix->SetMaxScale(ViewMaxScale); // 临界放大率
    _viewMatrix->SetMinScale(ViewMinScale); // 临界缩小率

    // 设定 用于模型绘制的视图矩阵 能显示的最大范围
    _viewMatrix->SetMaxScreenRect(
                                  ViewLogicalMaxLeft,
                                  ViewLogicalMaxRight,
                                  ViewLogicalMaxBottom,
                                  ViewLogicalMaxTop
                                  );
}

/// 设置从设备到屏幕的转换矩阵
- (void)configDeviceToScreenMatrix:(CGFloat)width height:(CGFloat)height {
    // 以纵向尺寸为基准，上下为1，左右按照比例设置
    float ratio = static_cast<float>(width) / static_cast<float>(height);
    float left = -ratio;
    float right = ratio;
    float bottom = ViewLogicalLeft;
    float top = ViewLogicalRight;
    
    // 将从 从设备到屏幕的转换矩阵 初始化为单位矩阵
    _deviceToScreen->LoadIdentity();
    
    // 设定 从设备到屏幕的转换矩阵 相对于屏幕的放大率
    if (width > height)
    {
        float screenW = fabsf(right - left);
        _deviceToScreen->ScaleRelative(screenW / width, -screenW / width);
    }
    else
    {
        float screenH = fabsf(top - bottom);
        _deviceToScreen->ScaleRelative(screenH / height, -screenH / height);
    }
    
    // 以 从设备到屏幕的转换矩阵 的位置为起点进行相对移动
    _deviceToScreen->TranslateRelative(-width * 0.5f, -height * 0.5f);
}

#pragma mark - 删除矩阵

- (void)deleteMatrix {
    delete(_viewMatrix);
    _viewMatrix = nil;
    delete(_deviceToScreen);
    _deviceToScreen = nil;
}

@end
