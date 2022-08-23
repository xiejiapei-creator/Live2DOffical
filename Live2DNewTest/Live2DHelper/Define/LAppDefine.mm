/**
 * Copyright(c) Live2D Inc. All rights reserved.
 *
 * Use of this source code is governed by the Live2D Open Software license
 * that can be found at https://www.live2d.com/eula/live2d-open-software-license-agreement_en.html.
 */

#import "LAppDefine.h"
#import <Foundation/Foundation.h>

namespace LAppDefine {

    using namespace Csm;

    // 画面
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

    // 资源路径
    const csmChar* ResourcesPath = "Live2DResources/";

    // 模型后面的背景图像文件
    const csmChar* BackImageName = "back_class_normal.png";
    // 齿轮
    const csmChar* GearImageName = "icon_gear.png";
    // 关闭
    const csmChar* PowerImageName = "close.png";

    // 模型定义
    // 放置模型的目录名数组
    // 使目录名与model3.json的名字一致
    const csmChar* ModelDir[] = {
        "Haru",
        "Hiyori",
        "Mark",
        "Natori",
        "Rice"
    };
    const csmInt32 ModelDirSize = sizeof(ModelDir) / sizeof(const csmChar*);

    // 与外部定义文件（json）匹配
    const csmChar* MotionGroupIdle = "Idle"; // 发呆
    const csmChar* MotionGroupTapBody = "TapBody"; // 点击身体的时候

    // 与外部定义文件（json）匹配
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

    // 从框架输出的日志级别设置
    const CubismFramework::Option::LogLevel CubismLoggingLevel = CubismFramework::Option::LogLevel_Verbose;
}
