//
//  L2DCubism.h
//  Live2DNewTest
//
//  Created by 谢佳培 on 2022/8/23.
//

#import <Foundation/Foundation.h>

@class LAppTextureManager;

NS_ASSUME_NONNULL_BEGIN

/// Live2D Cubism（立体主义） SDK OC 层封装
@interface L2DCubism : NSObject

// 纹理管理器
@property (nonatomic, readonly, getter=getTextureManager) LAppTextureManager *textureManager;

+ (instancetype)sharedInstance;

/// 初始化 Cubism SDK
- (void)initializeCubism;
/// 销毁 Cubism SDK
- (void)disposeCubism;

/// 创建纹理管理器
- (void)createTextureManager;
/// 销毁纹理管理器
- (void)destroyTextureManager;

@end

NS_ASSUME_NONNULL_END
