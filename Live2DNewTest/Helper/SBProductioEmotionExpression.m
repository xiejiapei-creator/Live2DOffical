//
//  SBProductioEmotionExpression.m
//  Live2DNewTest
//
//  Created by 谢佳培 on 2022/8/17.
//

#import "SBProductioEmotionExpression.h"

@implementation SBProductioEmotionExpressionActionParameter

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
        @"paramId": @"Id",
        @"value": @"Value",
        @"blendDesc": @"Blend"
    };
}

- (void)setBlendDesc:(SBLive2DActionBlendMode)blendDesc {
    _blendDesc = blendDesc;

    if ([blendDesc isEqualToString:SBLive2DActionBlendModeNormal]) {
        _blendType = L2DBlendModeNormal;
    } else if ([blendDesc isEqualToString:SBLive2DActionBlendModeAdditive]) {
        _blendType = L2DBlendModeAdditive;
    } else if ([blendDesc isEqualToString:SBLive2DActionBlendModeMultiplicative]) {
        _blendType = L2DBlendModeMultiplicative;
    }
}
@end

@implementation SBProductioEmotionExpressionAction

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
        @"type": @"Type",
        @"parameters": @"Parameters"
    };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"parameters": SBProductioEmotionExpressionActionParameter.class,
    };
}

@end

@implementation SBProductioEmotionExpression

@end
