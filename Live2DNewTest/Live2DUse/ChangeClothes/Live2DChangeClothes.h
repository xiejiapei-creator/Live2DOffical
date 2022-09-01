//
//  Live2DChangeClothes.h
//  Live2DNewTest
//
//  Created by 谢佳培 on 2022/9/1.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Live2DChangeClothes : NSObject

/// 根据模型名称、要替换的纹理图片索引以及新的纹理图片数据进行换装
+ (void)replaceModelPNG:(NSString *)modelName pngIndexStr:(NSString *)pngIndexStr newPNGData:(NSData *)newPNGData;

/// 清空沙盒中的模型文件
+ (void)clearSandBoxModelFiles;

/// 重置为原始纹理图片
+ (void)resetModelPNG:(NSString *)modelName pngIndexStr:(NSString *)pngIndexStr;

@end

NS_ASSUME_NONNULL_END
