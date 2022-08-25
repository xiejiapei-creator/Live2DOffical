//
//  L2DTouch.h
//  Live2DNewTest
//
//  Created by 谢佳培 on 2022/8/24.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Live2DView.h"// 视图

NS_ASSUME_NONNULL_BEGIN

@interface L2DTouch : NSObject

+ (instancetype)sharedInstance;

/// 触摸开始
- (void)touchesBegan:(NSSet *)touches view:(Live2DView *)view;

/// 触摸移动
- (void)touchesMoved:(NSSet *)touches view:(Live2DView *)view;

/// 触摸结束
- (void)touchesEnded:(NSSet *)touches view:(Live2DView *)view;

/// 销毁触摸事件管理器
- (void)destroyTouchManager;

@end

NS_ASSUME_NONNULL_END
