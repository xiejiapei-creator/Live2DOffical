/**
 * Copyright(c) Live2D Inc. All rights reserved.
 *
 * Use of this source code is governed by the Live2D Open Software license
 * that can be found at https://www.live2d.com/eula/live2d-open-software-license-agreement_en.html.
 */

#pragma once

#include "CubismMatrix44.hpp"

namespace Live2D { namespace Cubism { namespace Framework {
/**
 * @brief 在照相机的位置变更中使用方便的4 × 4矩阵
 */
class CubismViewMatrix : public CubismMatrix44
{
public:
    /**
     * @brief 构造器
     */
    CubismViewMatrix();

    /**
     * @brief 析构
     */
    virtual ~CubismViewMatrix();

    /**
     * @brief 调整移动
     *
     * @param[in]   x   X轴的移动量
     * @param[in]   y   Y轴的移动量
     */
    void        AdjustTranslate(csmFloat32 x, csmFloat32 y);

    /**
     * @brief 调整放大率
     *
     * @param[in]   cx      拡大を行うX軸の中心位置
     * @param[in]   cy      拡大を行うY軸の中心位置
     * @param[in]   scale   拡大率
     */
    void        AdjustScale(csmFloat32 cx, csmFloat32 cy, csmFloat32 scale);

    /**
     * @brief 设置对应于设备的逻辑坐标上的范围
     *
     * @param[in]   left    左边X轴的位置
     * @param[in]   right   右边X轴的位置
     * @param[in]   bottom  下边Y轴的位置
     * @param[in]   top     上边Y轴的位置
     */
    void        SetScreenRect(csmFloat32 left, csmFloat32 right, csmFloat32 bottom, csmFloat32 top);

    /**
     * @brief デバイスに対応する論理座標上の移動可能範囲の設定
     *
     * デバイスに対応する論理座標上の移動可能範囲の設定を行う。
     *
     * @param[in]   left    左辺のX軸の位置
     * @param[in]   right   右辺のX軸の位置
     * @param[in]   bottom  下辺のY軸の位置
     * @param[in]   top     上辺のY軸の位置
     */
    void        SetMaxScreenRect(csmFloat32 left, csmFloat32 right, csmFloat32 bottom, csmFloat32 top);

    /**
     * @brief 设定最大放大率
     *
     * @param[in]   maxScale    最大放大率
     */
    void        SetMaxScale(csmFloat32 maxScale);

    /**
     * @brief 设定最小放大率
     *
     * @param[in]   minScale    最小放大率
     */
    void        SetMinScale(csmFloat32 minScale);

    /**
     * @brief 最大拡大率の取得
     *
     * 最大拡大率を取得する。
     *
     * @return 最大拡大率
     */
    csmFloat32  GetMaxScale() const;

    /**
     * @brief 最小拡大率の取得
     *
     * 最小拡大率を取得する。
     *
     * @return 最小拡大率
     */
    csmFloat32  GetMinScale() const;

    /**
     * @brief 拡大率が最大か？
     *
     * 拡大率が最大になっているかどうかを確認する。
     *
     * @retval  true    拡大率は最大になっている
     * @retval  false   拡大率は最大になっていない
     */
    csmBool     IsMaxScale() const;

    /**
     * @brief 拡大率が最小か？
     *
     * 拡大率が最小になっているかどうかを確認する。
     *
     * @retval  true    拡大率は最小になっている
     * @retval  false   拡大率は最小になっていない
     */
    csmBool     IsMinScale() const;

    /**
     * @brief デバイスに対応する論理座標の左辺のX軸位置の取得
     *
     * デバイスに対応する論理座標の左辺のX軸位置を取得する。
     *
     * @return デバイスに対応する論理座標の左辺のX軸位置
     */
    csmFloat32  GetScreenLeft() const;

    /**
    * @brief デバイスに対応する論理座標の右辺のX軸位置の取得
    *
    * デバイスに対応する論理座標の右辺のX軸位置を取得する。
    *
    * @return デバイスに対応する論理座標の右辺のX軸位置
    */
    csmFloat32  GetScreenRight() const;

    /**
    * @brief デバイスに対応する論理座標の下辺のY軸位置の取得
    *
    * デバイスに対応する論理座標の下辺のY軸位置を取得する。
    *
    * @return デバイスに対応する論理座標の下辺のY軸位置
    */
    csmFloat32  GetScreenBottom() const;

    /**
    * @brief デバイスに対応する論理座標の上辺のY軸位置の取得
    *
    * デバイスに対応する論理座標の上辺のY軸位置を取得する。
    *
    * @return デバイスに対応する論理座標の上辺のY軸位置
    */
    csmFloat32  GetScreenTop() const;

    /**
     * @brief 左辺のX軸位置の最大値の取得
     *
     * 左辺のX軸位置の最大値を取得する。
     *
     * @return 左辺のX軸位置の最大値
     */
    csmFloat32  GetMaxLeft() const;

    /**
    * @brief 右辺のX軸位置の最大値の取得
    *
    * 右辺のX軸位置の最大値を取得する。
    *
    * @return 右辺のX軸位置の最大値
    */
    csmFloat32  GetMaxRight() const;

    /**
    * @brief 下辺のY軸位置の最大値の取得
    *
    * 下辺のY軸位置の最大値を取得する。
    *
    * @return 下辺のY軸位置の最大値
    */
    csmFloat32  GetMaxBottom() const;

    /**
    * @brief 上辺のY軸位置の最大値の取得
    *
    * 上辺のY軸位置の最大値を取得する。
    *
    * @return 上辺のY軸位置の最大値
    */
    csmFloat32  GetMaxTop() const;

private:
    csmFloat32  _screenLeft;        ///< 对应于设备的逻辑坐标上的范围(左边Y轴位置)
    csmFloat32  _screenRight;       ///< 对应于设备的逻辑坐标上的范围(右边Y轴位置)
    csmFloat32  _screenTop;         ///< 对应于设备的逻辑坐标上的范围(下边Y轴位置)
    csmFloat32  _screenBottom;      ///< 对应于设备的逻辑坐标上的范围(上边Y轴位置)
    csmFloat32  _maxLeft;           ///< 逻辑坐标上的可移动范围(左侧X轴位置)
    csmFloat32  _maxRight;          ///< 逻辑坐标上的可移动范围(右侧X轴位置)
    csmFloat32  _maxTop;            ///< 逻辑坐标上的可移动范围(下侧Y轴位置)
    csmFloat32  _maxBottom;         ///< 逻辑坐标上的可移动范围(上侧Y轴位置)
    csmFloat32  _maxScale;          ///< 放大率的最大值
    csmFloat32  _minScale;          ///< 放大率的最小值
};

}}}
