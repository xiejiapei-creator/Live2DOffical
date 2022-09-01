//
//  Live2DView.h
//  Live2DNewTest
//
//  Created by 谢佳培 on 2022/8/24.
//

#import "LMetalUIView.h"// Metal视图

NS_ASSUME_NONNULL_BEGIN

@interface Live2DView : LMetalUIView

/// Live2DView 视图当前展示的模型的名称
/// 必须保证在renderToMetalLayer调用之后赋值，因为顺序颠倒会崩溃，可以放在viewDidAppear中执行
@property (nonatomic, copy) NSString *modelName;

@end

NS_ASSUME_NONNULL_END
