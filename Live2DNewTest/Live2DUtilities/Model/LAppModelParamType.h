//
//  LAppModelParamType.h
//  Live2DNewTest
//
//  Created by 谢佳培 on 2022/8/27.
//

#import <Foundation/Foundation.h>

/// 模型中可以产生运动动画的参数
typedef NS_ENUM(NSUInteger, ParamType)
{
    ParamType_AngleY,/// 头部围绕节点的x轴旋转(以弧度为单位)
    ParamType_AngleX,/// 头部围绕节点y轴的旋转(以弧度为单位)
    ParamType_AngleZ,/// 头部围绕节点的z轴旋转(以弧度为单位)
    
    ParamType_BodyPosition,/// 确定接收者的位置
    ParamType_BodyAngleZ,/// 身体角度Z
    ParamType_BodyAngleY,/// 身体角度Y
    
    ParamType_EyeBallX,/// 眼球位置X
    ParamType_EyeBallY,/// 眼球位置Y
    
    ParamType_BrowLY,/// 描述双眉内部部分向上运动的系数 X
    ParamType_BrowRY,/// 描述双眉内部部分向上运动的系数 Y
    ParamType_BrowLAngle,/// 描述左眉外侧部分向上运动的系数
    ParamType_BrowRAngle,/// 描述右眉外侧部分向上运动的系数
    
    ParamType_EyeLOpen,/// 左眼上眼睑的闭合系数
    ParamType_EyeROpen,/// 右眼上眼睑的闭合系数
    
    ParamType_MouthOpenY,/// 描述下颚开口的系数 Y
    ParamType_MouthForm,/// 描述双唇收缩成张开形状的系数
    
    ParamType_Cheek/// 描述双颊向外运动的系数
};


NS_ASSUME_NONNULL_BEGIN

@interface LAppModelParamType : NSObject

+ (NSString *)getParamTypeValue:(ParamType)type;

@end

NS_ASSUME_NONNULL_END

