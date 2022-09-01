//
//  Live2DChangeClothes.m
//  Live2DNewTest
//
//  Created by 谢佳培 on 2022/9/1.
//

#import "Live2DChangeClothes.h"
#import "Live2DBridge.h"

@implementation Live2DChangeClothes

/// 根据模型名称获取对应png纹理图片列表
+ (NSArray *)getModelPNGList:(NSString *)modelName {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *live2DResourcesPath = [NSString stringWithFormat:@"%@/%@", documentDirectory, @"Live2DResources"];
    NSArray *pathList = [fileManager subpathsAtPath:live2DResourcesPath];

    NSMutableArray *modelPNGPathList = [NSMutableArray array];
    for (NSString *path in pathList)
    {
        if ([path containsString:@".png"] && [path containsString:modelName])
        {
            NSString *fullPath = [NSString stringWithFormat:@"%@/Live2DResources/%@", documentDirectory, path];
            [modelPNGPathList addObject:fullPath];
        }
    }

    return [modelPNGPathList copy];
}

+ (void)replaceModelPNG:(NSString *)modelName pngIndexStr:(NSString *)pngIndexStr newPNGData:(NSData *)newPNGData {
    // 判空处理
    if (modelName == nil || [modelName isEqualToString:@""]) {
        return;
    }
    if (pngIndexStr == nil || [pngIndexStr isEqualToString:@""]) {
        return;
    }
    if (newPNGData == nil || newPNGData.length == 0) {
        return;
    }
    
    // 获取模型的PNG图片列表
    NSArray *modelPNGPathList = [Live2DChangeClothes getModelPNGList:modelName];
    
    // 找到要替换的纹理图片
    NSString *modelPNGPath;
    for (NSString *pngPath in modelPNGPathList) {
        NSString *pngName = [pngPath lastPathComponent];
        NSArray *nameComponent = [pngName componentsSeparatedByString:@"_"];
        NSString *nameIndexStr = [nameComponent lastObject];
        nameIndexStr = [nameIndexStr stringByReplacingOccurrencesOfString:@".png" withString:@""];
        
        if ([nameIndexStr isEqualToString:pngIndexStr]) {
            modelPNGPath = pngPath;
            break;
        }
    }
    if (modelPNGPath == nil || [modelPNGPath isEqualToString:@""]) {
        return;
    }
    
    // 修改原来的纹理图片名称
    NSString *pngName = [modelPNGPath lastPathComponent];
    NSString *modifyPNGFilePath = [modelPNGPath stringByReplacingOccurrencesOfString:pngName withString:@"texture_origin.png"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager moveItemAtPath:modelPNGPath toPath:modifyPNGFilePath error:nil];
    
    // 根据新纹理图片的数据和原来的纹理图片名称创建新的换装后的图片
    BOOL filePathIsDir = NO;
    BOOL fileExisted = [fileManager fileExistsAtPath:modelPNGPath isDirectory:&filePathIsDir];
    if ((filePathIsDir == NO && fileExisted == NO)) {
        [fileManager createFileAtPath:modelPNGPath contents:newPNGData attributes:nil];
    }
    
    // 重新渲染模型
    [Live2DBridge changeLive2DModelWithName:modelName needReloadTexture:YES];
}


@end
