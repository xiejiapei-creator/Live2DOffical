//
//  L2DSprite.m
//  Live2DNewTest
//
//  Created by 谢佳培 on 2022/8/24.
//

#import "L2DSprite.h"
#import "AppDelegate.h"

#import "LAppTextureManager.h"// 纹理
#import "LAppDefine.h"// SDK头文件
#import "LAppPal.h"// 文件读取 和 时刻获取
#import "LAppLive2DManager.h"// 角色模型
#import "L2DCubism.h"// SDK桥接
#import <string>// 字符串

using namespace std;
using namespace LAppDefine;

@implementation L2DSprite

+ (instancetype)sharedInstance {
    static L2DSprite *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[L2DSprite alloc] init];
    });
    return sharedInstance;
}

# pragma mark - 创建和销毁角色模型以外的精灵（绘图）

/// 创建角色模型以外的精灵（绘图）
- (void)createSprite
{
    // 获取纹理管理器
    LAppTextureManager* textureManager = [[L2DCubism sharedInstance] getTextureManager];
    
    // 获取资源路径
    const string resourcesPath = ResourcesPath;
    // 获取模型后面的背景图像文件名称
    string imageName = BackImageName;
    
    // 读取图像信息来创建纹理
    TextureInfo* backgroundTexture = [textureManager createTextureFromPngFile: resourcesPath+imageName];
    
    // 获取渲染视图的宽、高
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    ViewController* view = [delegate viewController];
    float width = view.view.frame.size.width;
    float height = view.view.frame.size.height;
    
    // 创建背景图精灵
    float x = width * 0.5f;
    float y = height * 0.5f;
    float fWidth = static_cast<float>(backgroundTexture->width * 2.0f);
    float fHeight = static_cast<float>(height) * 0.95f;
    _back = [[LAppSprite alloc] initWithMyVar:x Y:y Width:fWidth Height:fHeight Texture:backgroundTexture->id];

    // 变换模型按钮
    imageName = GearImageName;
    TextureInfo* gearTexture = [textureManager createTextureFromPngFile: resourcesPath+imageName];
    x = static_cast<float>(width - gearTexture->width * 0.5f);
    y = static_cast<float>(height - gearTexture->height * 0.5f - 50);
    fWidth = static_cast<float>(gearTexture->width);
    fHeight = static_cast<float>(gearTexture->height);
    _gear = [[LAppSprite alloc] initWithMyVar:x Y:y Width:fWidth Height:fHeight Texture:gearTexture->id];

    // 电源按钮
    imageName = PowerImageName;
    TextureInfo* powerTexture = [textureManager createTextureFromPngFile:resourcesPath+imageName];
    x = static_cast<float>(width - powerTexture->width * 0.5f);
    y = static_cast<float>(powerTexture->height * 0.5f + 50);
    fWidth = static_cast<float>(powerTexture->width);
    fHeight = static_cast<float>(powerTexture->height);
    _power = [[LAppSprite alloc] initWithMyVar:x Y:y Width:fWidth Height:fHeight Texture:powerTexture->id];
}

/// 资源回收，销毁精灵
- (void)destroySprite
{
    _gear = nil;
    _back = nil;
    _power = nil;
}

#pragma mark - 渲染视图

/// 渲染到视图上
- (void)renderToMetalLayer:(nonnull CAMetalLayer *)layer
{
    // 更新时间
    LAppPal::UpdateTime();
        
    // 创建命令缓冲区执行渲染角色模型和精灵
    [self createCommandBufferPerformRendering:layer];
}

/// 创建命令缓冲区执行渲染
- (void)createCommandBufferPerformRendering:(nonnull CAMetalLayer *)layer {
    
    // 此方法返回一个命令缓冲区，保存对对象（如纹理、采样器和状态对象）的强引用，直到它完成执行
    // 这些对象由此命令缓冲区创建的任何命令编码器引用
    id <MTLCommandBuffer> commandBuffer = [[[L2DMetal sharedInstance] commandQueue] commandBuffer];
    
    // 一个CAMetalLayer对象维护一个内部纹理池来显示图层内容
    // 每个纹理都包装在一个CAMetalLayer可绘制对象中
    // 使用此方法可从池中检索下一个可用的绘制对象
    id<CAMetalDrawable> currentDrawable = [layer nextDrawable];

    // 创建图形渲染命令编码器，立刻渲染精灵模型以外的绘图（精灵）
    [self createRenderCommandEncoder:commandBuffer currentDrawable:currentDrawable];
    
    // 对角色模型进行更新和绘制
    [self renderRole:commandBuffer currentDrawable:currentDrawable];
    
    // 注册您想要呈现的绘图让其尽快出现
    [commandBuffer presentDrawable:currentDrawable];
    
    // 提交命令缓冲区以供执行
    [commandBuffer commit];
}

/// 对角色模型进行更新和绘制
- (void)renderRole:(id <MTLCommandBuffer>)commandBuffer currentDrawable:(id<CAMetalDrawable>)currentDrawable {
    // 获取模型管理器
    LAppLive2DManager* Live2DManager = [LAppLive2DManager getInstance];
    
    // 设置用于模型绘制的视图矩阵
    [Live2DManager SetViewMatrix:[[L2DMetal sharedInstance] viewMatrix]];
    
    // 对模型进行更新和绘制
    [Live2DManager onUpdate:commandBuffer currentDrawable:currentDrawable depthTexture:[[L2DMetal sharedInstance] depthTexture]];
}

/// 立刻渲染角色模型以外的绘图（精灵）
- (void)renderSprite:(id<MTLRenderCommandEncoder>)renderEncoder
{
    [_back renderImmidiate:renderEncoder];
    [_gear renderImmidiate:renderEncoder];
    [_power renderImmidiate:renderEncoder];
}

// 创建图形渲染命令编码器，立刻渲染精灵模型以外的绘图（精灵）
- (void)createRenderCommandEncoder:(id <MTLCommandBuffer>)commandBuffer currentDrawable:(id<CAMetalDrawable>)currentDrawable  {
    // 生成渲染过程描述符
    MTLRenderPassDescriptor *renderPassDescriptor = [self createRenderPassDescriptor:currentDrawable];

    // 从描述符创建图形渲染命令编码器对象，以将渲染过程编码到命令缓冲区
    // MTLRenderCommandEncoder 图形渲染命令编码器对象提供了设置和执行单个图形渲染过程的方法
    // 命令缓冲区创建此渲染命令编码器后，在调用MTLRenderCommandEncoder对象的endEncoding方法之前
    // 无法为此命令缓冲区生成其他命令编码器
    id<MTLRenderCommandEncoder> renderEncoder = [commandBuffer renderCommandEncoderWithDescriptor:renderPassDescriptor];

    // 立刻渲染角色模型以外的绘图（精灵）
    [self renderSprite:renderEncoder];

    // 声明编码器的所有命令生成都已完成
    // 调用结束编码后，命令编码器不再使用
    [renderEncoder endEncoding];
}

// 创建渲染过程描述符
- (MTLRenderPassDescriptor *)createRenderPassDescriptor:(id<CAMetalDrawable>)currentDrawable {
    // 一个完全没有附件的新的渲染过程描述符
    MTLRenderPassDescriptor *renderPassDescriptor
                                   = [MTLRenderPassDescriptor renderPassDescriptor];
    
    // 存储颜色数据的附件的状态信息数组
    // 使用colorAttachments属性的setObject:atIndexedSubscript:方法设置所需的颜色附件
    
    // 与此附件相关联的纹理对象
    renderPassDescriptor.colorAttachments[0].texture = currentDrawable.texture;
    
    // 此附件在渲染命令编码器的渲染过程开始时执行的操作
    // 使用MTLLoadActionClear操作来清除渲染目标的以前的内容
    renderPassDescriptor.colorAttachments[0].loadAction = MTLLoadActionClear;
    
    // 此附件在渲染命令编码器的渲染过程结束时执行的操作
    // 如果应用程序在完成渲染过程后不需要纹理中的数据，请使用MTLStoreActionDontCare操作
    // 否则，如果纹理是直接存储的，则使用MTLStoreActionStore操作
    renderPassDescriptor.colorAttachments[0].storeAction = MTLStoreActionStore;
    
    // 清除颜色附件时要使用的颜色
    // 如果附件的loadAction属性设置为MTLLoadActionClear
    // 则在渲染过程开始时，GPU将使用clearColor属性中存储的值填充纹理
    // 否则，GPU将忽略clearColor属性
    // clearColor属性表示一组RGBA组件 默认值为（0.0，0.0、0.0和1.0）（黑色）
    renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColorMake(0, 0, 0, 1);
    
    return renderPassDescriptor;
}

@end
