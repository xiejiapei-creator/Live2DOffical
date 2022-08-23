//
//  UIColor+Live2D.m
//  Live2DNewTest
//
//  Created by 谢佳培 on 2022/8/17.
//

#import "UIColor+Live2D.h"

@implementation UIColor (Live2D)

- (RGBA)rgba {
    CGColorRef color = self.CGColor;
    RGBA rgba;

    CGColorSpaceRef colorSpaceRef = CGColorGetColorSpace(color);
    CGColorSpaceModel colorSpaceModel = CGColorSpaceGetModel(colorSpaceRef);
    const CGFloat *colorComponents = CGColorGetComponents(color);
    size_t colorComponentCount = CGColorGetNumberOfComponents(color);

    switch (colorSpaceModel) {
        case kCGColorSpaceModelMonochrome: {
            assert(colorComponentCount == 2);
            rgba = (RGBA){
                .r = colorComponents[0],
                .g = colorComponents[0],
                .b = colorComponents[0],
                .a = colorComponents[1]};
            break;
        }

        case kCGColorSpaceModelRGB: {
            assert(colorComponentCount == 4);
            rgba = (RGBA){
                .r = colorComponents[0],
                .g = colorComponents[1],
                .b = colorComponents[2],
                .a = colorComponents[3]};
            break;
        }

        default: {
            rgba = (RGBA){0, 0, 0, 0};
            break;
        }
    }

    return rgba;
}
@end
