//
//  Live2DView.m
//  Live2DNewTest
//
//  Created by 谢佳培 on 2022/8/24.
//

#import "LAppDefine.h"
#import <Foundation/Foundation.h>

namespace LAppDefine {

    using namespace Csm;

    // 逻辑视图frame相关属性
    const csmFloat32 ViewScale = 1.0f;
    const csmFloat32 ViewMaxScale = 2.0f;
    const csmFloat32 ViewMinScale = 0.8f;

    const csmFloat32 ViewLogicalLeft = -1.0f;
    const csmFloat32 ViewLogicalRight = 1.0f;
    const csmFloat32 ViewLogicalBottom = -1.0f;
    const csmFloat32 ViewLogicalTop = 1.0f;

    const csmFloat32 ViewLogicalMaxLeft = -2.0f;
    const csmFloat32 ViewLogicalMaxRight = 2.0f;
    const csmFloat32 ViewLogicalMaxBottom = -2.0f;
    const csmFloat32 ViewLogicalMaxTop = 2.0f;


    const csmChar* ResourcesPath = "Live2DResources/";
    const csmChar* BackImageName = "back_class_normal.png";
    const csmChar* GearImageName = "icon_gear.png";
    const csmChar* PowerImageName = "close.png";

    // 放置模型的目录名数组
    const csmChar* ModelDir[] = {
        "Haru",
        "Hiyori"
    };

    const csmInt32 ModelDirSize = sizeof(ModelDir) / sizeof(const csmChar*);

    const csmChar* MotionGroupIdle = "Idle"; // 发呆
    const csmChar* MotionGroupTapBody = "TapBody"; // 点击身体的时候

    const csmChar* HitAreaNameHead = "Head";
    const csmChar* HitAreaNameBody = "Body";

    // 运动优先级常数
    const csmInt32 PriorityNone = 0;// 无
    const csmInt32 PriorityIdle = 1;// 怠慢
    const csmInt32 PriorityNormal = 2;// 正常
    const csmInt32 PriorityForce = 3;// 强迫

    // 调试日志显示选项
    const csmBool DebugLogEnable = true;
    const csmBool DebugTouchLogEnable = false;

    const CubismFramework::Option::LogLevel CubismLoggingLevel = CubismFramework::Option::LogLevel_Verbose;
}
