//
//  L2DRender.h
//  Live2DNewTest
//
//  Created by 谢佳培 on 2022/8/25.
//

#import <Foundation/Foundation.h>
#import "L2DMetal.h"// Metal

NS_ASSUME_NONNULL_BEGIN

@interface L2DRender : NSObject

/// 渲染到视图上
+ (void)renderToMetalLayer:(nonnull CAMetalLayer *)layer;

@end

NS_ASSUME_NONNULL_END
