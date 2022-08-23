//
//  L2DMatrix44Bridge.h
//  Live2DNewTest
//
//  Created by 谢佳培 on 2022/8/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 桥接文件，解决编译问题
@interface L2DMatrix44Bridge : NSObject
+ (void)multiplyA:(float *)a b:(float *)b dst:(float *)dst;
- (float *)getArray;
- (void)setMatrix:(float *)tr;
- (float)getScaleX;
- (float)getScaleY;
- (float)getTranslateX;
- (float)getTranslateY;
- (float)transformX:(float)src;
- (float)transformY:(float)src;
- (float)invertTransformX:(float)src;
- (float)invertTransformY:(float)src;
- (void)translateRelativeX:(float)x y:(float)y;
- (void)translateX:(float)x y:(float)y;
- (void)translateX:(float)x;
- (void)translateY:(float)y;
- (void)scaleRelativeX:(float)x y:(float)y;
- (void)scaleX:(float)x y:(float)y;
- (void)multiplyByMatrix:(L2DMatrix44Bridge *)matrix;
@end

NS_ASSUME_NONNULL_END
