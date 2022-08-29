//
//  Live2DView.h
//  Live2DNewTest
//
//  Created by 谢佳培 on 2022/8/24.
//

#import "LMetalUIView.h"// Metal视图

NS_ASSUME_NONNULL_BEGIN

@interface Live2DView : LMetalUIView

/// 判断是否直播 直播使用AR来更新运动参数
@property (nonatomic, assign) BOOL isLiveBroadcast;

@end

NS_ASSUME_NONNULL_END
