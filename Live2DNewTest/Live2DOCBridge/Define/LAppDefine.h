//
//  Live2DView.h
//  Live2DNewTest
//
//  Created by 谢佳培 on 2022/8/24.
//

#ifndef LAppDefine_h
#define LAppDefine_h

#import <Foundation/Foundation.h>
#import <CubismFramework.hpp>

/**
 * @brief  App使用的常数
 *
 */
namespace LAppDefine {

    using namespace Csm;

    extern const csmFloat32 ViewScale;              ///< 放大缩小率
    extern const csmFloat32 ViewMaxScale;           ///< 放大缩小率的最大值
    extern const csmFloat32 ViewMinScale;           ///< 放大缩小率的最小值

    extern const csmFloat32 ViewLogicalLeft;        ///< 逻辑视图坐标系左端的值
    extern const csmFloat32 ViewLogicalRight;       ///< 逻辑视图坐标系最右边的值
    extern const csmFloat32 ViewLogicalBottom;      ///< 逻辑视图坐标系下端的值
    extern const csmFloat32 ViewLogicalTop;         ///< 逻辑视图坐标系上端的值

    extern const csmFloat32 ViewLogicalMaxLeft;     ///< 逻辑视图坐标系左端的最大值
    extern const csmFloat32 ViewLogicalMaxRight;    ///< 逻辑视图坐标系右端的最大值
    extern const csmFloat32 ViewLogicalMaxBottom;   ///< 逻辑视图坐标系下端的最大值
    extern const csmFloat32 ViewLogicalMaxTop;      ///< 逻辑视图坐标系上端的最大值

    extern const csmChar* ResourcesPath;            ///< 资源路径
    extern const csmChar* BackImageName;         ///< 背景图像文件
    extern const csmChar* GearImageName;         ///< 齿轮图像文件
    extern const csmChar* PowerImageName;        ///< 结束按钮图像文件

    // 模型定义--------------------------------------------
    extern const csmChar* ModelDir[];               ///< 配置模型的目录名的数组 目录名和model3.json的名字保持一致
    extern const csmInt32 ModelDirSize;             ///< 模型目录数组的大小

    // 配合外部定义文件(json)
    extern const csmChar* MotionGroupIdle;          ///< 发呆时播放的动作列表
    extern const csmChar* MotionGroupTapBody;       ///< 点击身体时播放的动作列表

    // 配合外部定义文件(json)
    extern const csmChar* HitAreaNameHead;          ///< 判定正确的[Head]标签
    extern const csmChar* HitAreaNameBody;          ///< 判定正确的[Body]标签

    // 运动的优先级常数
    extern const csmInt32 PriorityNone;             ///< 运动的优先级常数:0
    extern const csmInt32 PriorityIdle;             ///< 运动的优先级常数:1
    extern const csmInt32 PriorityNormal;           ///< 运动的优先级常数:2
    extern const csmInt32 PriorityForce;            ///< 运动的优先级常数:3

    // 调试用日志的表示
    extern const csmBool DebugLogEnable;            ///< 调试用记录表示的有效·无效
    extern const csmBool DebugTouchLogEnable;       ///< 触摸处理调试用记录显示的有效与无效

    // 从Framework输出的日志的等级设定
    extern const CubismFramework::Option::LogLevel CubismLoggingLevel;
}

#endif /* LAppDefine_h */
