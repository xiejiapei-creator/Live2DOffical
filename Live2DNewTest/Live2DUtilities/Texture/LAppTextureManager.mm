//
//  LAppTextureManager.m
//  Live2DNewTest
//
//  Created by 谢佳培 on 2022/8/24.
//

#import "LAppTextureManager.h"
#import <Foundation/Foundation.h>
#import <Metal/Metal.h>
#import <iostream>
#define STBI_NO_STDIO
#define STBI_ONLY_PNG
#define STB_IMAGE_IMPLEMENTATION
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wcomma"
#pragma clang diagnostic ignored "-Wunused-function"
#import "stb_image.h"
#pragma clang diagnostic pop
#import "LAppPal.h"
#import "Rendering/Metal/CubismRenderingInstanceSingleton_Metal.h"

@interface LAppTextureManager()

@property (nonatomic) Csm::csmVector<TextureInfo*> textures;

@end

@implementation LAppTextureManager

- (id)init
{
    self = [super init];
    return self;
}

- (void)dealloc
{
    [self releaseTextures];
}


- (TextureInfo*)createTextureFromPngFile:(std::string)fileName needReloadTexture:(BOOL)needReloadTexture
{
    Csm::csmInt32 removeIndex = 0;
    for (Csm::csmUint32 i = 0; i < _textures.GetSize(); i++)
    {
        if (_textures[i]->fileName == fileName)
        {
            if (needReloadTexture) {
                // 换装必须重新加载纹理，需要删除旧纹理
                removeIndex = i;
                break;
            } else {
                // 切换模型不一定需要重新加载纹理，倘若纹理已经加载则直接返回
                return _textures[i];
            }
        }
    }
    if (needReloadTexture) {
        _textures.Remove(removeIndex);
    }

    int width, height, channels;
    unsigned int size;
    unsigned char* png;
    unsigned char* address;

    address = LAppPal::LoadFileAsBytes(fileName, &size);

    // 获取png信息
    png = stbi_load_from_memory(
                                address,
                                static_cast<int>(size),
                                &width,
                                &height,
                                &channels,
                                STBI_rgb_alpha);

    {
#ifdef PREMULTIPLIED_ALPHA_ENABLE
        unsigned int* fourBytes = reinterpret_cast<unsigned int*>(png);
        for (int i = 0; i < width * height; i++)
        {
            unsigned char* p = png + i * 4;
            int tes = [self premultiply:p[0] Green:p[1] Blue:p[2] Alpha:p[3]];
            fourBytes[i] = tes;
        }
#endif
    }

    MTLTextureDescriptor *textureDescriptor = [[MTLTextureDescriptor alloc] init];

    // 指示每个像素有一个蓝色、绿色、红色和alpha通道，其中每个通道是一个8位无符号规范化值(即0映射到0.0,255映射到1.0)
    textureDescriptor.pixelFormat = MTLPixelFormatRGBA8Unorm;

    // 设置纹理的像素尺寸
    textureDescriptor.width = width;
    textureDescriptor.height = height;

    CubismRenderingInstanceSingleton_Metal *single = [CubismRenderingInstanceSingleton_Metal sharedManager];
    id <MTLDevice> device = [single getMTLDevice];

    // 通过使用描述符从设备创建纹理
    id<MTLTexture> texture = [device newTextureWithDescriptor:textureDescriptor];

    // 计算图像中每行的字节数
    NSUInteger bytesPerRow = 4 * width;

    MTLRegion region = {
        { 0, 0, 0 },                   // MTLOrigin
        {(NSUInteger)width, (NSUInteger)height, 1} // MTLSize
    };

    // 将数据对象中的字节复制到纹理中
    [texture replaceRegion:region
                mipmapLevel:0
                  withBytes:png
                bytesPerRow:bytesPerRow];

    // 释放处理
    stbi_image_free(png);
    LAppPal::ReleaseBytes(address);

    TextureInfo* textureInfo = new TextureInfo;
    textureInfo->fileName = fileName;
    textureInfo->width = width;
    textureInfo->height = height;
    textureInfo->id = texture;
    _textures.PushBack(textureInfo);

    return textureInfo;
}

- (id<MTLTexture>)loadTextureUsingMetalKit: (NSURL *) url device: (id<MTLDevice>) device {
    MTKTextureLoader *loader = [[MTKTextureLoader alloc] initWithDevice: device];

    NSError *error;
    id<MTLTexture> texture = [loader newTextureWithContentsOfURL:url options:nil error:&error];

    if(!texture)
    {
        NSLog(@"Failed to create the texture from %@", url.absoluteString);
        return nil;
    }
    return texture;
}

- (unsigned int)premultiply:(unsigned char)red Green:(unsigned char)green Blue:(unsigned char)blue Alpha:(unsigned char) alpha
{
    return static_cast<unsigned>(\
                                 (red * (alpha + 1) >> 8) | \
                                 ((green * (alpha + 1) >> 8) << 8) | \
                                 ((blue * (alpha + 1) >> 8) << 16) | \
                                 (((alpha)) << 24)   \
                                 );
}
- (void)releaseTextures
{
    for (Csm::csmUint32 i = 0; i < _textures.GetSize(); i++)
    {
        delete _textures[i];
    }

    _textures.Clear();
}

- (void)releaseTextureWithId:(id <MTLTexture>) textureId
{
    for (Csm::csmUint32 i = 0; i < _textures.GetSize(); i++)
    {
        if (_textures[i]->id != textureId)
        {
            continue;
        }
        delete _textures[i];
        _textures.Remove(i);
        break;
    }
}

- (void)releaseTextureByName:(std::string)fileName;
{
    for (Csm::csmUint32 i = 0; i < _textures.GetSize(); i++)
    {
        if (_textures[i]->fileName == fileName)
        {
            delete _textures[i];
            _textures.Remove(i);
            break;
        }
    }
}

@end
