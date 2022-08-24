/**
 * Copyright(c) Live2D Inc. All rights reserved.
 *
 * Use of this source code is governed by the Live2D Open Software license
 * that can be found at https://www.live2d.com/eula/live2d-open-software-license-agreement_en.html.
 */

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
     * @brief ファイルをバイトデータとして読み込む
     *
     * ファイルをバイトデータとして読み込む
     *
     * @param[in]   filePath    読み込み対象ファイルのパス
     * @param[out]  outSize     ファイルサイズ
     * @return                  バイトデータ
     */
    static Csm::csmByte* LoadFileAsBytes(const std::string filePath, Csm::csmSizeInt* outSize);


    /**
     * @brief バイトデータを解放する
     *
     * バイトデータを解放する
     *
     * @param[in]   byteData    解放したいバイトデータ
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
     * @brief ログを出力する
     *
     * ログを出力する
     *
     * @param[in]   format  書式付文字列
     * @param[in]   ...     (可変長引数)文字列
     *
     */
    static void PrintLog(const Csm::csmChar* format, ...);

    /**
     * @brief メッセージを出力する
     *
     * メッセージを出力する
     *
     * @param[in]   message  文字列
     *
     */
    static void PrintMessage(const Csm::csmChar* message);

private:
    static double s_currentFrame;
    static double s_lastFrame;
    static double s_deltaTime;
};

#endif /* LAppPal_h */
