//
//  LAppLive2DManager.m
//  Live2DNewTest
//
//  Created by 谢佳培 on 2022/8/24.
//

#import <Foundation/Foundation.h>
#import <Rendering/Metal/CubismRenderer_Metal.hpp>
#import "Rendering/Metal/CubismRenderingInstanceSingleton_Metal.h"
#import "LAppLive2DManager.h"
#import "LAppModel.h"
#import "LAppDefine.h"
#import "LAppPal.h"

@interface LAppLive2DManager()

- (id)init;
- (void)dealloc;
@end

@implementation LAppLive2DManager

static LAppLive2DManager* s_instance = nil;

void FinishedMotion(Csm::ACubismMotion* self)
{
    LAppPal::PrintLog("Motion Finished: %x", self);
}

+ (LAppLive2DManager*)getInstance
{
    @synchronized(self)
    {
        if(s_instance == nil)
        {
            s_instance = [[LAppLive2DManager alloc] init];
        }
    }
    return s_instance;
}

+ (void)releaseInstance
{
    if(s_instance != nil)
    {
        s_instance = nil;
    }
}

- (id)init
{
    self = [super init];
    if ( self ) {
        _viewMatrix = nil;
        _sceneIndex = 0;

        _viewMatrix = new Csm::CubismMatrix44();

        _renderPassDescriptor = [MTLRenderPassDescriptor renderPassDescriptor];
        _renderPassDescriptor.colorAttachments[0].storeAction = MTLStoreActionStore;
        _renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColorMake(0.f, 0.f, 0.f, 0.f);
        _renderPassDescriptor.depthAttachment.loadAction = MTLLoadActionClear;
        _renderPassDescriptor.depthAttachment.storeAction = MTLStoreActionDontCare;
        _renderPassDescriptor.depthAttachment.clearDepth = 1.0;

        [self changeScene:_sceneIndex];
    }
    return self;
}

- (void)dealloc
{
    if (_renderBuffer)
    {
        _renderBuffer->DestroyOffscreenFrame();
        delete _renderBuffer;
        _renderBuffer = NULL;
    }
    [self releaseAllModel];
}

- (void)releaseAllModel
{
    for (Csm::csmUint32 i = 0; i < _models.GetSize(); i++)
    {
        delete _models[i];
    }

    _models.Clear();
}

/// 从模型数组中获取角色模型
- (LAppModel*)getModel:(Csm::csmUint32)no
{
    if (no < _models.GetSize())
    {
        return _models[no];
    }
    return nil;
}

/// 触摸时候拖拽模型角色，使模型进行移动
- (void)onDrag:(Csm::csmFloat32)x floatY:(Csm::csmFloat32)y
{
    for (Csm::csmUint32 i = 0; i < _models.GetSize(); i++)
    {
        Csm::CubismUserModel* model = static_cast<Csm::CubismUserModel*>([self getModel:i]);
        // x = -0.108695507 y = 0.724637687
        // 设置模型角色的拖动位置
        model->SetDragging(x,y);
    }
}

- (void)onTap:(Csm::csmFloat32)x floatY:(Csm::csmFloat32)y
{
    if (LAppDefine::DebugLogEnable)
    {
        LAppPal::PrintLog("[APP]tap point: {x:%.2f y:%.2f}", x, y);
    }

    for (Csm::csmUint32 i = 0; i < _models.GetSize(); i++)
    {
        if(_models[i]->HitTest(LAppDefine::HitAreaNameHead,x,y))
        {
            // 点击了头部播放随机表情
            if (LAppDefine::DebugLogEnable)
            {
                LAppPal::PrintLog("[APP]hit area: [%s]", LAppDefine::HitAreaNameHead);
            }
            _models[i]->SetRandomExpression();
        }
        else if (_models[i]->HitTest(LAppDefine::HitAreaNameBody, x, y))
        {
            // 点击了身体播放随机动作
            if (LAppDefine::DebugLogEnable)
            {
                LAppPal::PrintLog("[APP]hit area: [%s]", LAppDefine::HitAreaNameBody);
            }
            _models[i]->StartRandomMotion(LAppDefine::MotionGroupTapBody, LAppDefine::PriorityNormal, FinishedMotion);
        }
    }
}

- (void)onUpdate:(id <MTLCommandBuffer>)commandBuffer currentDrawable:(id<CAMetalDrawable>)drawable depthTexture:(id<MTLTexture>)depthTarget metalLayerSize:(CGSize)metalLayerSize
{
    float width = metalLayerSize.width;
    float height = metalLayerSize.height;

    Csm::CubismMatrix44 projection;
    Csm::csmUint32 modelCount = _models.GetSize();

    CubismRenderingInstanceSingleton_Metal *single = [CubismRenderingInstanceSingleton_Metal sharedManager];
    id<MTLDevice> device = [single getMTLDevice];

    _renderPassDescriptor.colorAttachments[0].texture = drawable.texture;
    _renderPassDescriptor.colorAttachments[0].loadAction = MTLLoadActionLoad;
    _renderPassDescriptor.depthAttachment.texture = depthTarget;

    if (_renderTarget != SelectTarget_None)
    {
        if(!_renderBuffer)
        {
            _renderBuffer = new Csm::Rendering::CubismOffscreenFrame_Metal;
            _renderBuffer->SetMTLPixelFormat(MTLPixelFormatBGRA8Unorm);
            _renderBuffer->SetClearColor(0.0, 0.0, 0.0, 0.0);
            _renderBuffer->CreateOffscreenFrame(width, height, nil);

            if (_renderTarget == SelectTarget_ViewFrameBuffer)
            {
                _sprite = [[LAppSprite alloc] initWithMyVar:width * 0.5f Y:height * 0.5f Width:width Height:height Texture:_renderBuffer->GetColorBuffer() metalViewSize:metalLayerSize];
            }
        }

        if (_renderTarget == SelectTarget_ViewFrameBuffer)
        {
            _renderPassDescriptor.colorAttachments[0].texture = _renderBuffer->GetColorBuffer();
            _renderPassDescriptor.colorAttachments[0].loadAction = MTLLoadActionClear;
        }

        // 画面清晰
        id<MTLRenderCommandEncoder> renderEncoder = [commandBuffer renderCommandEncoderWithDescriptor:_renderBuffer->GetRenderPassDescriptor()];
        [renderEncoder endEncoding];
    }

    Csm::Rendering::CubismRenderer_Metal::StartFrame(device, commandBuffer, _renderPassDescriptor);

    for (Csm::csmUint32 i = 0; i < modelCount; ++i)
    {
        LAppModel* model = [self getModel:i];
        if (model->GetModel()->GetCanvasWidth() > 1.0f && width < height)
        {
            // 在纵长窗口上显示横向长的模型时，用模型的横向尺寸计算scale
            model->GetModelMatrix()->SetWidth(2.0f);
            projection.Scale(1.0f, static_cast<float>(width) / static_cast<float>(height));
        }
        else
        {
            projection.Scale(static_cast<float>(height) / static_cast<float>(width), 1.0f);
        }

        // 如果有需要，在这里相乘
        if (_viewMatrix != NULL)
        {
            projection.MultiplyByMatrix(_viewMatrix);
        }

        if (_renderTarget == SelectTarget_ModelFrameBuffer)
        {
            Csm::Rendering::CubismOffscreenFrame_Metal& useTarget = model->GetRenderBuffer();

            if (!useTarget.IsValid())
            {// 绘图目标在这里创建
                useTarget.SetMTLPixelFormat(MTLPixelFormatBGRA8Unorm);
                useTarget.CreateOffscreenFrame(static_cast<LAppDefine::csmUint32>(width), static_cast<LAppDefine::csmUint32>(height));
            }
            _renderPassDescriptor.colorAttachments[0].texture = useTarget.GetColorBuffer();
            _renderPassDescriptor.colorAttachments[0].loadAction = MTLLoadActionClear;

            Csm::Rendering::CubismRenderer_Metal::StartFrame(device, commandBuffer, _renderPassDescriptor);
        }

        model->Update();
        model->Draw(projection);/// 因为是参考传递，projection会变质

        if (_renderTarget == SelectTarget_ViewFrameBuffer && _renderBuffer && _sprite)
        {
            MTLRenderPassDescriptor *renderPassDescriptor = [MTLRenderPassDescriptor renderPassDescriptor];
            renderPassDescriptor.colorAttachments[0].texture = drawable.texture;
            renderPassDescriptor.colorAttachments[0].loadAction = MTLLoadActionLoad;
            renderPassDescriptor.colorAttachments[0].storeAction = MTLStoreActionStore;
            renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColorMake(0, 0, 0, 1);
            id<MTLRenderCommandEncoder> renderEncoder = [commandBuffer renderCommandEncoderWithDescriptor:renderPassDescriptor];
            [_sprite SetColor:1.0f g:1.0f b:1.0f a:0.25f + (float)i * 0.5f];
            [_sprite renderImmidiate:renderEncoder];
            [renderEncoder endEncoding];
        }

        // 如果每个模型的绘制目标是纹理
        if (_renderTarget == SelectTarget_ModelFrameBuffer)
        {
            if (!model)
            {
                return;
            }

            MTLRenderPassDescriptor *renderPassDescriptor = [MTLRenderPassDescriptor renderPassDescriptor];
            renderPassDescriptor.colorAttachments[0].texture = drawable.texture;
            renderPassDescriptor.colorAttachments[0].loadAction = MTLLoadActionLoad;
            renderPassDescriptor.colorAttachments[0].storeAction = MTLStoreActionStore;
            renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColorMake(0, 0, 0, 1);
            id<MTLRenderCommandEncoder> renderEncoder = [commandBuffer renderCommandEncoderWithDescriptor:renderPassDescriptor];

            Csm::Rendering::CubismOffscreenFrame_Metal& useTarget = model->GetRenderBuffer();
            LAppSprite* depthSprite = [[LAppSprite alloc] initWithMyVar:width * 0.5f Y:height * 0.5f Width:width Height:height Texture:useTarget.GetColorBuffer() metalViewSize:metalLayerSize];
            [depthSprite SetColor:1.0f g:1.0f b:1.0f a:0.25f + (float)i * 0.5f];
            [depthSprite renderImmidiate:renderEncoder];
            [renderEncoder endEncoding];
        }
    }
}

- (void)nextScene
{
    Csm::csmInt32 no = (_sceneIndex + 1) % LAppDefine::ModelDirSize;
    [self changeScene:no];
}

- (void)changeScene:(Csm::csmInt32)index
{
    _sceneIndex = index;
    if (LAppDefine::DebugLogEnable)
    {
        LAppPal::PrintLog("[APP]model index: %d", _sceneIndex);
    }

    // ModelDir[]中保存的目录名称
    // model3.json的路径
    // 目录名和model3.json的名字要一致
    std::string model = LAppDefine::ModelDir[index];
    std::string modelPath = LAppDefine::ResourcesPath + model + "/";
    std::string modelJsonName = LAppDefine::ModelDir[index];
    modelJsonName += ".model3.json";

    [self releaseAllModel];
    _models.PushBack(new LAppModel());
    _models[0]->LoadAssets(modelPath.c_str(), modelJsonName.c_str());

    /*
     * 提供进行模型半透明显示的样本。
     * 在另一个渲染目标上绘制模型，并将绘制结果作为纹理粘贴到另一个上。
     */
    {
#if defined(USE_RENDER_TARGET)
        // 对LAppView的目标进行绘图时，选择这里
        SelectTarget useRenderTarget = SelectTarget_ViewFrameBuffer;
#elif defined(USE_MODEL_RENDER_TARGET)
        // 在每个LAppModel的目标上绘图时，选择这里
        SelectTarget useRenderTarget = SelectTarget_ModelFrameBuffer;
#else
        // 渲染到默认的主框架缓冲器(通常)
        SelectTarget useRenderTarget = SelectTarget_None;
#endif

#if defined(USE_RENDER_TARGET) || defined(USE_MODEL_RENDER_TARGET)
        // 给模型单独添加α作为样本，制作另一个模型，稍微移开位置
        _models.PushBack(new LAppModel());
        _models[1]->LoadAssets(modelPath.c_str(), modelJsonName.c_str());
        _models[1]->GetModelMatrix()->TranslateX(0.2f);
#endif

        float clearColorR = 1.0f;
        float clearColorG = 1.0f;
        float clearColorB = 1.0f;

        [self SwitchRenderingTarget:useRenderTarget];
        [self SetRenderTargetClearColor:clearColorR g:clearColorG b:clearColorB];
    }
}

- (Csm::csmUint32)GetModelNum
{
    return _models.GetSize();
}

- (void)SetViewMatrix:(Csm::CubismMatrix44*)m
{
    for (int i = 0; i < 16; i++) {
        _viewMatrix->GetArray()[i] = m->GetArray()[i];
    }
}

- (void)SwitchRenderingTarget:(SelectTarget)targetType
{
    _renderTarget = targetType;
}

- (void)SetRenderTargetClearColor:(float)r g:(float)g b:(float)b
{
    _clearColorR = r;
    _clearColorG = g;
    _clearColorB = b;
}
@end

