//
//  UIColor+Live2D.h
//  Live2DNewTest
//
//  Created by 谢佳培 on 2022/8/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef struct {
    CGFloat r;
    CGFloat g;
    CGFloat b;
    CGFloat a;
} RGBA;

@interface UIColor (Live2D)
///< rgba 值
@property (nonatomic, assign, readonly) RGBA rgba;
@end

NS_ASSUME_NONNULL_END
