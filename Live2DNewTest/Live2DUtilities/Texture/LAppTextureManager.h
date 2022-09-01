//
//  LAppTextureManager.h
//  Live2DNewTest
//
//  Created by 谢佳培 on 2022/8/24.
//

#ifndef LAppTextureManager_h
#define LAppTextureManager_h

#import <string>
#import <MetalKit/MetalKit.h>
#import <Type/csmVector.hpp>


@interface LAppTextureManager : NSObject

/**
 * @brief 图像信息结构
 */
typedef struct
{
    id <MTLTexture> id;              ///< 纹理ID
    int width;              ///< 宽度
    int height;             ///< 高度
    std::string fileName;       ///< 文件名称
}TextureInfo;

/**
 * @brief 初始化
 */
- (id)init;

/**
 * @brief 释放
 *
 */
- (void)dealloc;


/**
 * @brief 预复用处理
 *
 * @param[in] red  图像的Red值
 * @param[in] green  图像的Green值
 * @param[in] blue  图像的Blue值
 * @param[in] alpha  图像的Alpha值
 *
 * @return 预复用处理后的颜色值
 */
- (unsigned int)premultiply:(unsigned char)red Green:(unsigned char)green Blue:(unsigned char)blue Alpha:(unsigned char) alpha;


/**
 * @brief 图像读取
 *
 * @param[in] fileName  读取的图像文件路径名
 * @return 图像信息。读入失败时返回空
 */
- (TextureInfo*)createTextureFromPngFile:(std::string)fileName needReloadTexture:(BOOL)needReloadTexture;

/**
 * @brief 释放纹理图像
 *
 * 释放序列中的所有图像
 */
- (void)releaseTextures;

/**
 * @brief 释放纹理图像
 *
 * 释放具有指定纹理ID的图像
 * @param[in] textureId  纹理ID
 **/
- (void)releaseTextureWithId:(id <MTLTexture>)textureId;

/**
 * @brief 释放纹理图像
 *
 * 释放指定名称的图像
 * @param[in] fileName  释放的图像文件路径名
 **/
- (void)releaseTextureByName:(std::string)fileName;

@end
#endif /* LAppTextureManager_h */
