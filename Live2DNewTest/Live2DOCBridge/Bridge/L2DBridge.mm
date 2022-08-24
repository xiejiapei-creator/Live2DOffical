//
//  L2DBridge.m
//  Live2DNewTest
//
//  Created by 谢佳培 on 2022/8/24.
//

#import "L2DBridge.h"
#import "L2DSprite.h"
#import "L2DMetal.h"

@implementation L2DBridge

// 创建 Metal 渲染视图
+ (void)createLive2DView:(MetalUIView *)view {
    [[L2DMetal sharedInstance] createMetalView:view];
}

+ (void)destroyLive2DView {
    [[L2DMetal sharedInstance] deleteMatrix];
    [[L2DSprite sharedInstance] destroySprite];
}

@end
