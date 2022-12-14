//
//  L2DMetal.h
//  Live2DNewTest
//
//  Created by 谢佳培 on 2022/8/23.
//

#import <Foundation/Foundation.h>

#import <Math/CubismViewMatrix.hpp>// 显示视图的变换矩阵
#import "LMetalView.h"// 提供命令队列
#import "LAppDefine.h"// SDK头文件
#import "LMetalUIView.h"// Metal视图

using namespace LAppDefine;// 逻辑视图frame相关属性

NS_ASSUME_NONNULL_BEGIN

@interface L2DMetal : NSObject <MetalViewDelegate>

/// 组织命令缓冲区供GPU执行的队列
@property (nonatomic, strong) id<MTLCommandQueue> commandQueue;
/// 图像纹理
@property (nonatomic, strong) id<MTLTexture> depthTexture;

/// 用于模型绘制的视图矩阵
@property (nonatomic) Csm::CubismViewMatrix *viewMatrix;
/// 从设备到屏幕的转换矩阵
@property (nonatomic) Csm::CubismMatrix44 *deviceToScreen;

+ (instancetype)sharedInstance;

/// 创建 Metal 渲染视图
- (void)createMetalView:(LMetalUIView *)roleView;

/// 资源回收，删除矩阵
- (void)deleteMatrix;

@end

NS_ASSUME_NONNULL_END
