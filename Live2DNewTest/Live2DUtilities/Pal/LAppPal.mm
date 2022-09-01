//
//  LAppPal.m
//  Live2DNewTest
//
//  Created by 谢佳培 on 2022/8/24.
//

#import "LAppPal.h"
#import <Foundation/Foundation.h>
#import <stdio.h>
#import <stdlib.h>
#import <stdarg.h>
#import <sys/stat.h>
#import <iostream>
#import <fstream>
#import "LAppDefine.h"

using std::endl;
using namespace Csm;
using namespace std;
using namespace LAppDefine;

double LAppPal::s_currentFrame = 0.0;
double LAppPal::s_lastFrame = 0.0;
double LAppPal::s_deltaTime = 0.0;

csmByte* LAppPal::LoadFileAsBytes(const string filePath, csmSizeInt* outSize)
{
    int path_i = static_cast<int>(filePath.find_last_of("/")+1);
    int ext_i = static_cast<int>(filePath.find_last_of("."));
    std::string pathname = filePath.substr(0,path_i);
    std::string extname = filePath.substr(ext_i,filePath.size()-ext_i);
    std::string filename = filePath.substr(path_i,ext_i-path_i);
    NSString* castFilePath = [[NSBundle mainBundle]
                              pathForResource:[NSString stringWithUTF8String:filename.c_str()]
                              ofType:[NSString stringWithUTF8String:extname.c_str()]
                              inDirectory:[NSString stringWithUTF8String:pathname.c_str()]];
    
    NSString *filePathOCStr = [NSString stringWithUTF8String:filePath.c_str()];
    NSString *fileNameWithExt = [filePathOCStr lastPathComponent];
    NSString *folderName = [filePathOCStr stringByReplacingOccurrencesOfString: fileNameWithExt withString:@""] ;
    NSString *documentDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *folderPath = [NSString stringWithFormat:@"%@/%@", documentDirectory, folderName];
    
    // 创建目录
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL folderPathIsDir = NO;
    BOOL folderExisted = [fileManager fileExistsAtPath:folderPath isDirectory:&folderPathIsDir];
    if (!(folderPathIsDir == YES && folderExisted == YES)) {
        [fileManager createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    // 创建文件夹
    NSString *filePathFullStr = [folderPath stringByAppendingString:fileNameWithExt];
    NSData *bundleData = [NSData dataWithContentsOfFile:castFilePath];
    BOOL filePathFullStrIsDir = NO;
    BOOL fileExisted = [fileManager fileExistsAtPath:filePathFullStr isDirectory:&filePathFullStrIsDir];
    if ((filePathFullStrIsDir == NO && fileExisted == NO)) {
        [fileManager createFileAtPath:filePathFullStr contents:bundleData attributes:nil];
    }
    
    NSArray *pathList = [fileManager subpathsAtPath:folderPath];
    NSMutableArray *modelPNGPathList = [NSMutableArray array];
    for (NSString *path in pathList)
    {
        if ([path containsString:@".png"])
        {
            [modelPNGPathList addObject:path];

        }
    }
    NSLog(@"谢佳培：%@",modelPNGPathList);

//    NSData *data;
    NSData *data = [NSData dataWithContentsOfFile:filePathFullStr];
//    if (sandboxData == nil || sandboxData.length == 0) {
//        data = bundleData;
//    } else {
//        data = sandboxData;
//    }
    
    NSUInteger len = [data length];
    Byte *byteData = (Byte*)malloc(len);
    memcpy(byteData, [data bytes], len);

    *outSize = static_cast<Csm::csmSizeInt>(len);
    return static_cast<Csm::csmByte*>(byteData);
}

void LAppPal::ReleaseBytes(csmByte* byteData)
{
    free(byteData);
}

void LAppPal::UpdateTime()
{
    NSDate *now = [NSDate date];
    double unixtime = [now timeIntervalSince1970];
    s_currentFrame = unixtime;
    s_deltaTime = s_currentFrame - s_lastFrame;
    s_lastFrame = s_currentFrame;
}

void LAppPal::PrintLog(const csmChar* format, ...)
{
    va_list args;
    Csm::csmChar buf[256];
    va_start(args, format);
    vsnprintf(buf, sizeof(buf), format, args); // 标准输出渲染
    NSLog(@"%@",[NSString stringWithCString:buf encoding:NSUTF8StringEncoding]);
    va_end(args);
}

void LAppPal::PrintMessage(const csmChar* message)
{
    PrintLog("%s", message);
}
