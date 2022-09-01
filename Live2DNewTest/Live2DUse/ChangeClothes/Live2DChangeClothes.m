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

    NSMutableArray *modelPNGList = [NSMutableArray array];
    for (NSString *path in pathList)
    {
        if ([path containsString:@".png"] && [path containsString:modelName])
        {
            NSString *fullPath = [NSString stringWithFormat:@"%@/Live2DResources/%@", documentDirectory, path];
            [modelPNGList addObject:fullPath];
        }
    }

    return [modelPNGList copy];
}

/// 找到要替换的纹理图片路径
+ (NSString *)getReplaceModelPNGFilePath:(NSString *)modelName pngIndexStr:(NSString *)pngIndexStr {
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
    
    return modelPNGPath;
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
    
    // 删除要换装的图片
    NSString *modelPNGPath = [self getReplaceModelPNGFilePath:modelName pngIndexStr:pngIndexStr];
    if (modelPNGPath == nil || [modelPNGPath isEqualToString:@""]) {
        return;
    }
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:modelPNGPath error:nil];
    
    // 根据新纹理图片的数据和原来的纹理图片名称创建新的换装后的图片
    BOOL filePathIsDir = NO;
    BOOL fileExisted = [fileManager fileExistsAtPath:modelPNGPath isDirectory:&filePathIsDir];
    if ((filePathIsDir == NO && fileExisted == NO)) {
        [fileManager createFileAtPath:modelPNGPath contents:newPNGData attributes:nil];
    }
    
    // 重新渲染模型
    [Live2DBridge changeLive2DModelWithName:modelName needReloadTexture:YES];
}

+ (void)resetModelPNG:(NSString *)modelName pngIndexStr:(NSString *)pngIndexStr {
    if (modelName == nil || [modelName isEqualToString:@""]) {
        return;
    }
    if (pngIndexStr == nil || [pngIndexStr isEqualToString:@""]) {
        return;
    }

    // 获取要换装的图片删除之
    NSString *modelPNGFullPath = [self getReplaceModelPNGFilePath:modelName pngIndexStr:pngIndexStr];
    if (modelPNGFullPath == nil || [modelPNGFullPath isEqualToString:@""]) {
        return;
    }
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:modelPNGFullPath error:nil];
    
    // 渲染模型
    [Live2DBridge changeLive2DModelWithName:modelName needReloadTexture:YES];
}

+ (void)clearSandBoxModelFiles {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *live2DResourcesPath = [NSString stringWithFormat:@"%@/%@", documentDirectory, @"Live2DResources"];
    NSArray *pathList = [fileManager subpathsAtPath:live2DResourcesPath];

    for (NSString *path in pathList)
    {
        NSString *fullPath = [NSString stringWithFormat:@"%@/Live2DResources/%@", documentDirectory, path];
        [fileManager removeItemAtPath:fullPath error:nil];
    }
}

@end
