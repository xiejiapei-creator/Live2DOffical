/**
 * Copyright(c) Live2D Inc. All rights reserved.
 *
 * Use of this source code is governed by the Live2D Open Software license
 * that can be found at https://www.live2d.com/eula/live2d-open-software-license-agreement_en.html.
 */

#import <UIKit/UIKit.h>
#import <MetalKit/MetalKit.h>

/// 必须在 Metal 框架端保留的值
@interface CubismRenderingInstanceSingleton_Metal : NSObject {
    id <MTLDevice> mtlDevice;
    CAMetalLayer* metalLayer;
}

+ (id)sharedManager;

/// 设置 Metal 渲染图层的设备 可在该设备上渲染可绘制纹理
- (void)setMTLDevice:(id <MTLDevice>)param;
/// 获取 Metal 渲染图层的设备
- (id <MTLDevice>)getMTLDevice;

/// 设置显示在屏幕上的 Metal 渲染图层
- (void)setMetalLayer:(CAMetalLayer*)param;
/// 获取显示在屏幕上的 Metal 渲染图层
- (CAMetalLayer*)getMetalLayer;

@end
