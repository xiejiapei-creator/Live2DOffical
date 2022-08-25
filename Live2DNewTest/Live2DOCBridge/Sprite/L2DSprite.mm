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

#pragma mark - 渲染精灵

/// 立刻渲染角色模型以外的绘图（精灵）
- (void)renderSprite:(id<MTLRenderCommandEncoder>)renderEncoder
{
    [_back renderImmidiate:renderEncoder];
    [_gear renderImmidiate:renderEncoder];
    [_power renderImmidiate:renderEncoder];
}

@end
