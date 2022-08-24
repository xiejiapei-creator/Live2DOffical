//
//  LTouchManager.h
//  Live2DNewTest
//
//  Created by 谢佳培 on 2022/8/24.
//

#ifndef LTouchManager_h
#define LTouchManager_h

@interface LTouchManager : NSObject

@property (nonatomic, readonly) float startX; // 开始触摸时的x值
@property (nonatomic, readonly) float startY; // 开始触摸时的y值
@property (nonatomic, readonly, getter=getX) float lastX; // 上次触摸时x的值
@property (nonatomic, readonly, getter=getY) float lastY; // 上次触摸时的y值
@property (nonatomic, readonly, getter=getX1) float lastX1; // 双重触碰时的第一个x的值
@property (nonatomic, readonly, getter=getY1) float lastY1; // 双重触碰时的第一个y的值
@property (nonatomic, readonly, getter=getX2) float lastX2; // 双重触碰时的第二个x的值
@property (nonatomic, readonly, getter=getY2) float lastY2; // 双重触碰时的第二个y的值
@property (nonatomic, readonly) float lastTouchDistance; // 用2根以上手指触摸时的距离
@property (nonatomic, readonly) float deltaX; // 从上次的值到这次的值的x的移动距离
@property (nonatomic, readonly) float deltaY; // 从上次的值到这次的值的y的移动距离
@property (nonatomic, readonly) float scale; // 放大率
@property (nonatomic, readonly) float touchSingle; // 单手指触摸
@property (nonatomic, readonly) float flipAvailable; // 翻转是否有效

/**
 * @brief 初始化
 */
- (id)init;

/*
 * @brief 触摸开始时的事件
 *
 * @param[in] deviceY    触摸画面的y值
 * @param[in] deviceX    触摸画面的x值
 */
- (void)touchesBegan:(float)deviceX DeciveY:(float)deviceY;

/*
 * @brief 拖动时的活动
 *
 * @param[in] deviceX    触摸画面的x值
 * @param[in] deviceY    触摸画面的y值
 */
- (void)touchesMoved:(float)deviceX DeviceY:(float)deviceY;

/*
 * @brief 拖动时的活动
 *
 * @param[in] deviceX1   第一个触摸的画面x的值
 * @param[in] deviceY1   第一个触摸的画面y的值
 * @param[in] deviceX2   第二个触摸的画面x的值
 * @param[in] deviceY2   第二个触摸画面的y的值
 */
- (void)touchesMoved:(float)deviceX1 DeviceY1:(float)deviceY1 DeviceX2:(float) deviceX2 DeviceY2:(float)deviceY2;

/*
 * @brief 轻拂的距离测量
 *
 * @return 摆动距离
 */
- (float)getFlickDistance;

/*
 * @brief 求从点1到点2的距离
 *
 * @param[in] x1 第一个触摸的画面x的值
 * @param[in] y1 第一个触摸的画面y的值
 * @param[in] x2 第二个触摸的画面x的值
 * @param[in] y2 第二个触摸的画面y的值
 * @return   两点的距离
 */
- (float)calculateDistance:(float)x1 TouchY1:(float)y1 TouchX2:(float)x2 TouchY2:(float)y2;

/*
 * 从两个值求出移动量
 * 如果方向不同，移动量为0。方向相同的情况下，参照绝对值小的值
 *
 * @param[in] v1    第一个移动量
 * @param[in] v2    第二个移动量
 *
 * @return   小的移动量
 */
- (float)calculateMovingAmount:(float)v1 Vector2:(float)v2;

@end

#endif /* LTouchManager_h */
