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

@end

NS_ASSUME_NONNULL_END
