//
//  LAppPal.h
//  Live2DNewTest
//
//  Created by 谢佳培 on 2022/8/24.
//

#ifndef LAppPal_h
#define LAppPal_h

#import <string>
#import <CubismFramework.hpp>

/**
 * @brief 依赖功能合集
 *
 * 汇总 文件读取 和 时刻获取 等依赖于平台的函数
 *
 */
class LAppPal
{
public:
    /**
     * @brief 把文件作为字节数据读取
     *
     * @param[in]   filePath    读取目标文件的路径
     * @param[out]  outSize     文件大小
     * @return                  字节数据
     */
    static Csm::csmByte* LoadFileAsBytes(const std::string filePath, Csm::csmSizeInt* outSize);


    /**
     * @brief 释放字节数据
     *
     *
     * @param[in]   byteData    想要释放的字节数据
     */
    static void ReleaseBytes(Csm::csmByte* byteData);

    /**
     * @biref  获取增量时间（与上一帧的差值）
     *
     * @return  增量时间[ms]
     *
     */
    static double GetDeltaTime() {return s_deltaTime;}

    /**
     * @brief 更新时间
     */
    static void UpdateTime();

    /**
     * @brief 输出日志
     *
     * @param[in]   format  格式字符串
     * @param[in]   ...     (可变长度自变量)字符串
     *
     */
    static void PrintLog(const Csm::csmChar* format, ...);

    /**
     * @brief 输出信息
     *
     * @param[in]   message  信息
     *
     */
    static void PrintMessage(const Csm::csmChar* message);

private:
    static double s_currentFrame;
    static double s_lastFrame;
    static double s_deltaTime;
};

#endif /* LAppPal_h */
