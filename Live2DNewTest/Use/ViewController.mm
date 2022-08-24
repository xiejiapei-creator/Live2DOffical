/**
 * Copyright(c) Live2D Inc. All rights reserved.
 *
 * Use of this source code is governed by the Live2D Open Software license
 * that can be found at https://www.live2d.com/eula/live2d-open-software-license-agreement_en.html.
 */

#import "ViewController.h"

//#import <math.h>
//#import <QuartzCore/QuartzCore.h>
//#import <QuartzCore/CAMetalLayer.h>
//#import "LAppModel.h"

#import "MetalUIView.h"// Metal视图

#import "L2DSprite.h"
#import "L2DMetal.h"
#import "L2DTouch.h"

@implementation ViewController

#pragma mark - 生命周期

/// 以编程方式创建视图层次结构，而不使用xib
- (void)loadView {
    MetalUIView *metalUiView = [[MetalUIView alloc] init];
    [self setView:metalUiView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /// 创建 Metal 渲染视图
    [[L2DMetal sharedInstance] createMetalView:self.view];
}

- (void)dealloc {
    [[L2DMetal sharedInstance] destroyRenderView:self.view];
    [[L2DSprite sharedInstance] destroySprite];
    [[L2DTouch sharedInstance] destroyTouchManager];
}

#pragma mark - 触摸事件

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [[L2DTouch sharedInstance] touchesBegan:touches view:self.view];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [[L2DTouch sharedInstance] touchesMoved:touches view:self.view];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [[L2DTouch sharedInstance] touchesEnded:touches view:self.view];
}

@end
