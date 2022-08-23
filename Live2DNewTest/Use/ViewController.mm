/**
 * Copyright(c) Live2D Inc. All rights reserved.
 *
 * Use of this source code is governed by the Live2D Open Software license
 * that can be found at https://www.live2d.com/eula/live2d-open-software-license-agreement_en.html.
 */

#import "ViewController.h"
#import <math.h>
#import <QuartzCore/QuartzCore.h>
#import <QuartzCore/CAMetalLayer.h>
#import <Metal/Metal.h>
#import <string>
#import "CubismFramework.hpp"
#import "AppDelegate.h"
#import "LAppSprite.h"
#import "LAppDefine.h"
#import "LAppLive2DManager.h"
#import "LAppTextureManager.h"
#import "LAppPal.h"
#import "LAppModel.h"
#import "TouchManager.h"
#import "MetalUIView.h"
#import <Math/CubismMatrix44.hpp>
#import <Math/CubismViewMatrix.hpp>
#import "Rendering/Metal/CubismRenderingInstanceSingleton_Metal.h"

#define BUFFER_OFFSET(bytes) ((GLubyte *)NULL + (bytes))

using namespace std;
using namespace LAppDefine;

@interface ViewController ()
@property (nonatomic) LAppSprite *back; //背景画像
@property (nonatomic) LAppSprite *gear; //歯車画像
@property (nonatomic) LAppSprite *power; //電源画像
@property (nonatomic) LAppSprite *renderSprite; //用于绘制渲染目标
@property (nonatomic) TouchManager *touchManager; ///触摸管理器
@property (nonatomic) Csm::CubismMatrix44 *deviceToScreen;// 从设备到屏幕的矩阵
@property (nonatomic) Csm::CubismViewMatrix *viewMatrix;

@end

@implementation ViewController

- (void)releaseView
{
    _renderSprite = nil;
    _gear = nil;
    _back = nil;
    _power = nil;

    MetalUIView *view = (MetalUIView*)self.view;

    view = nil;

    delete(_viewMatrix);
    _viewMatrix = nil;
    delete(_deviceToScreen);
    _deviceToScreen = nil;
    _touchManager = nil;
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
    MetalUIView *metalUiView = [[MetalUIView alloc] init];
    [self setView:metalUiView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // 在Fremework层也注册为单个对象以引用MTLDevice
    CubismRenderingInstanceSingleton_Metal *single = [CubismRenderingInstanceSingleton_Metal sharedManager];
    id<MTLDevice> device = MTLCreateSystemDefaultDevice();
    [single setMTLDevice:device];

    MetalUIView *view = (MetalUIView*)self.view;

    // 设置该层的设备，以便该层可以创建可在该设备上渲染的可绘制纹理
    view.metalLayer.device = device;

    // 将此类设置为接收调整大小和渲染回调的委托
    view.delegate = self;

    view.metalLayer.pixelFormat = MTLPixelFormatBGRA8Unorm;
    [single setMetalLayer:view.metalLayer];

    _commandQueue = [device newCommandQueue];

    _anotherTarget = false;
    _clearColorR = _clearColorG = _clearColorB = 1.0f;
    _clearColorA = 0.0f;

    // 触摸事件管理
    _touchManager = [[TouchManager alloc]init];

    // 用于将设备坐标转换为屏幕坐标
    _deviceToScreen = new CubismMatrix44();

    // 进行画面的显示的放大缩小和移动的变换的行列
    _viewMatrix = new CubismViewMatrix();

    [self initializeScreen];
}

- (void)initializeScreen
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    int width = screenRect.size.width;
    int height = screenRect.size.height;

    // 以纵向尺寸为基准
    float ratio = static_cast<float>(width) / static_cast<float>(height);
    float left = -ratio;
    float right = ratio;
    float bottom = ViewLogicalLeft;
    float top = ViewLogicalRight;

    // 与设备相对应的屏幕范围
    _viewMatrix->SetScreenRect(left, right, bottom, top);
    _viewMatrix->Scale(ViewScale, ViewScale);

    _deviceToScreen->LoadIdentity(); // 尺寸变了的时候等必须复位
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
    _deviceToScreen->TranslateRelative(-width * 0.5f, -height * 0.5f);

    // 表示範囲の設定
    _viewMatrix->SetMaxScale(ViewMaxScale); // 限界拡大率
    _viewMatrix->SetMinScale(ViewMinScale); // 限界縮小率

    // 表示できる最大範囲
    _viewMatrix->SetMaxScreenRect(
                                  ViewLogicalMaxLeft,
                                  ViewLogicalMaxRight,
                                  ViewLogicalMaxBottom,
                                  ViewLogicalMaxTop
                                  );
}

- (void)resizeScreen
{
    AppDelegate* delegate = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    ViewController* view = [delegate viewController];
    int width = view.view.frame.size.width;
    int height = view.view.frame.size.height;

    // 以纵向尺寸为基准
    float ratio = static_cast<float>(width) / static_cast<float>(height);
    float left = -ratio;
    float right = ratio;
    float bottom = ViewLogicalLeft;
    float top = ViewLogicalRight;

    // 与设备相对应的屏幕范围
    _viewMatrix->SetScreenRect(left, right, bottom, top);
    _viewMatrix->Scale(ViewScale, ViewScale);

    _deviceToScreen->LoadIdentity(); // 尺寸变了的时候等必须复位
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
    _deviceToScreen->TranslateRelative(-width * 0.5f, -height * 0.5f);

    // 表示範囲の設定
    _viewMatrix->SetMaxScale(ViewMaxScale); // 限界拡大率
    _viewMatrix->SetMinScale(ViewMinScale); // 限界縮小率

    // 表示できる最大範囲
    _viewMatrix->SetMaxScreenRect(
                                  ViewLogicalMaxLeft,
                                  ViewLogicalMaxRight,
                                  ViewLogicalMaxBottom,
                                  ViewLogicalMaxTop
                                  );

#if TARGET_OS_MACCATALYST
    [self resizeSprite:width Height:height];
#endif

}

- (void)initializeSprite
{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    ViewController* view = [delegate viewController];
    float width = view.view.frame.size.width;
    float height = view.view.frame.size.height;

    LAppTextureManager* textureManager = [delegate getTextureManager];
    const string resourcesPath = ResourcesPath;

    //背景
    string imageName = BackImageName;
    TextureInfo* backgroundTexture = [textureManager createTextureFromPngFile:resourcesPath+imageName];
    float x = width * 0.5f;
    float y = height * 0.5f;
    float fWidth = static_cast<float>(backgroundTexture->width * 2.0f);
    float fHeight = static_cast<float>(height) * 0.95f;
    _back = [[LAppSprite alloc] initWithMyVar:x Y:y Width:fWidth Height:fHeight Texture:backgroundTexture->id];

    //モデル変更ボタン
    imageName = GearImageName;
    TextureInfo* gearTexture = [textureManager createTextureFromPngFile:resourcesPath+imageName];
    x = static_cast<float>(width - gearTexture->width * 0.5f);
    y = static_cast<float>(height - gearTexture->height * 0.5f);
    fWidth = static_cast<float>(gearTexture->width);
    fHeight = static_cast<float>(gearTexture->height);
    _gear = [[LAppSprite alloc] initWithMyVar:x Y:y Width:fWidth Height:fHeight Texture:gearTexture->id];

    //電源ボタン
    imageName = PowerImageName;
    TextureInfo* powerTexture = [textureManager createTextureFromPngFile:resourcesPath+imageName];
    x = static_cast<float>(width - powerTexture->width * 0.5f);
    y = static_cast<float>(powerTexture->height * 0.5f);
    fWidth = static_cast<float>(powerTexture->width);
    fHeight = static_cast<float>(powerTexture->height);
    _power = [[LAppSprite alloc] initWithMyVar:x Y:y Width:fWidth Height:fHeight Texture:powerTexture->id];
}

- (void)resizeSprite:(float)width Height:(float)height
{
    //背景
    float x = width * 0.5f;
    float y = height * 0.5f;
    float fWidth = static_cast<float>(_back.GetTextureId.width * 2.0f);
    float fHeight = static_cast<float>(height) * 0.95f;
    [_back resizeImmidiate:x Y:y Width:fWidth Height:fHeight];

    //モデル変更ボタン
    x = static_cast<float>(width - _gear.GetTextureId.width * 0.5f);
    y = static_cast<float>(height - _gear.GetTextureId.height * 0.5f);
    fWidth = static_cast<float>(_gear.GetTextureId.width);
    fHeight = static_cast<float>(_gear.GetTextureId.height);
    [_gear resizeImmidiate:x Y:y Width:fWidth Height:fHeight];

    //電源ボタン
    x = static_cast<float>(width - _power.GetTextureId.width * 0.5f);
    y = static_cast<float>(_power.GetTextureId.height * 0.5f);
    fWidth = static_cast<float>(_power.GetTextureId.width);
    fHeight = static_cast<float>(_power.GetTextureId.height);
    [_power resizeImmidiate:x Y:y Width:fWidth Height:fHeight];
}

/// 触摸开始
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];

    // 记录下触摸开始点的位置
    [_touchManager touchesBegan:point.x DeciveY:point.y];
}

/// 触摸移动
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    // 获取触摸点在视图中的坐标位置
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];// point = (x = 425.5, y = 57)

    // 获取触摸点转换为角色模型点后的坐标，再放大、缩小、移动后的值
    float viewX = [self transformViewX:[_touchManager getX]];// viewX = -0.16183567
    float viewY = [self transformViewY:[_touchManager getY]];// viewY = 0.707729459

    // 更新触摸的位置
    [_touchManager touchesMoved:point.x DeviceY:point.y];
    
    // 在人物模型的x和y轴上拖动相应坐标点
    [[LAppLive2DManager getInstance] onDrag:viewX floatY:viewY];
}

/// 触摸结束
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    NSLog(@"谢佳培 触摸结束：%@", touch.view);

    CGPoint point = [touch locationInView:self.view];// point = (x = 474.5, y = 81.5)
    float pointY = [self transformTapY:point.y];// pointY = 332.5

    // 人物模型移动结束，x和y轴上拖动的坐标点重置为0，眼睛回归到坐标原点
    LAppLive2DManager* live2DManager = [LAppLive2DManager getInstance];
    [live2DManager onDrag:0.0f floatY:0.0f];
    {
        // 获取触摸点转换为角色模型点后的坐标，再放大、缩小、移动后的值
        float getX = [_touchManager getX];// getX = 476
        float getY = [_touchManager getY];// getY = 79.5
        float x = _deviceToScreen->TransformX(getX);// x = 0.1352
        float y = _deviceToScreen->TransformY(getY);// y = 0.615942001

        if (DebugTouchLogEnable)
        {
            LAppPal::PrintLog("[谢佳培] 触摸结束 获取逻辑坐标转换后的坐标 x:%.2f y:%.2f", x, y);
        }

        [live2DManager onTap:x floatY:y];

        // 点击了齿轮则切换到下一个人物模型
        if ([_gear isHit:point.x PointY:pointY])
        {
            [live2DManager nextScene];
        }

        // 点击电源按钮则让APP结束运行
        if ([_power isHit:point.x PointY:pointY])
        {
            AppDelegate *delegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
            [delegate finishApplication];
        }
    }
}

- (float)transformViewX:(float)deviceX
{
    // deviceX = 425.5 ——> screenX = -0.108695507
    float screenX = _deviceToScreen->TransformX(deviceX); // 获取逻辑坐标转换后的坐标
    return _viewMatrix->InvertTransformX(screenX); // 放大、缩小、移动后的值
}

- (float)transformViewY:(float)deviceY
{
    float screenY = _deviceToScreen->TransformY(deviceY); // 获取逻辑坐标转换后的坐标
    return _viewMatrix->InvertTransformY(screenY); // 放大、缩小、移动后的值
}

- (float)transformScreenX:(float)deviceX
{
    return _deviceToScreen->TransformX(deviceX);
}

- (float)transformScreenY:(float)deviceY
{
    return _deviceToScreen->TransformY(deviceY);
}

/// 转换单击Y坐标
- (float)transformTapY:(float)deviceY
{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    ViewController* view = [delegate viewController];
    float height = view.view.frame.size.height;
    return deviceY * -1 + height;
}

- (void)drawableResize:(CGSize)size
{
    MTLTextureDescriptor* depthTextureDescriptor = [MTLTextureDescriptor texture2DDescriptorWithPixelFormat:MTLPixelFormatDepth32Float width:size.width height:size.height mipmapped:false];
    depthTextureDescriptor.usage = MTLTextureUsageRenderTarget | MTLTextureUsageShaderRead;
    depthTextureDescriptor.storageMode = MTLStorageModePrivate;

    CubismRenderingInstanceSingleton_Metal *single = [CubismRenderingInstanceSingleton_Metal sharedManager];
    id <MTLDevice> device = [single getMTLDevice];
    _depthTexture = [device newTextureWithDescriptor:depthTextureDescriptor];

    [self resizeScreen];
}


- (void)renderSprite:(id<MTLRenderCommandEncoder>)renderEncoder
{
    [_back renderImmidiate:renderEncoder];

    [_gear renderImmidiate:renderEncoder];

    [_power renderImmidiate:renderEncoder];
}

- (void)renderToMetalLayer:(nonnull CAMetalLayer *)layer
{
    LAppPal::UpdateTime();

    id <MTLCommandBuffer> commandBuffer = [_commandQueue commandBuffer];
    id<CAMetalDrawable> currentDrawable = [layer nextDrawable];

    MTLRenderPassDescriptor *renderPassDescriptor
                                   = [MTLRenderPassDescriptor renderPassDescriptor];

    renderPassDescriptor.colorAttachments[0].texture = currentDrawable.texture;
    renderPassDescriptor.colorAttachments[0].loadAction = MTLLoadActionClear;
    renderPassDescriptor.colorAttachments[0].storeAction = MTLStoreActionStore;
    renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColorMake(0, 0, 0, 1);

    id<MTLRenderCommandEncoder> renderEncoder = [commandBuffer renderCommandEncoderWithDescriptor:renderPassDescriptor];

    //モデル以外の描画
    [self renderSprite:renderEncoder];

    [renderEncoder endEncoding];

    LAppLive2DManager* Live2DManager = [LAppLive2DManager getInstance];
    [Live2DManager SetViewMatrix:_viewMatrix];
    [Live2DManager onUpdate:commandBuffer currentDrawable:currentDrawable depthTexture:_depthTexture];

    [commandBuffer presentDrawable:currentDrawable];
    [commandBuffer commit];
}

@end
