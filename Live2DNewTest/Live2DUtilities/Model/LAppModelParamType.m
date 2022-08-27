//
//  LAppModelParamType.m
//  Live2DNewTest
//
//  Created by 谢佳培 on 2022/8/27.
//

#import "LAppModelParamType.h"

@implementation LAppModelParamType

+ (NSString *)getParamTypeValue:(ParamType)type {
    switch (type) {
        case ParamType_AngleY:
            return @"ParamAngleY";
        case ParamType_AngleX:
            return @"ParamAngleX";
        case ParamType_AngleZ:
            return @"ParamAngleZ";
        case ParamType_BodyPosition:
            return @"ParamBodyPosition";
        case ParamType_BodyAngleZ:
            return @"ParamBodyAngleZ";
        case ParamType_BodyAngleY:
            return @"ParamBodyAngleY";
        case ParamType_EyeBallX:
            return @"ParamEyeBallX";
        case ParamType_EyeBallY:
            return @"ParamEyeBallY";
        case ParamType_BrowLY:
            return @"ParamBrowLY";
        case ParamType_BrowRY:
            return @"ParamBrowRY";
        case ParamType_BrowLAngle:
            return @"ParamBrowLAngle";
        case ParamType_BrowRAngle:
            return @"ParamBrowRAngle";
        case ParamType_EyeLOpen:
            return @"ParamEyeLOpen";
        case ParamType_EyeROpen:
            return @"ParamEyeROpen";
        case ParamType_MouthOpenY:
            return @"ParamMouthOpenY";
        case ParamType_MouthForm:
            return @"ParamMouthForm";
        case ParamType_Cheek:
            return @"ParamCheek";
        default:
            break;
    }
}

@end
