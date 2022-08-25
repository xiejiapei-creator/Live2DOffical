//
//  Live2DView.m
//  Live2DNewTest
//
//  Created by 谢佳培 on 2022/8/24.
//

#import "Live2DView.h"
#import "L2DBridge.h"
#import "L2DTouch.h"

@implementation Live2DView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    [L2DBridge createLive2DView: self];
}

- (void)dealloc {
    [[L2DTouch sharedInstance] destroyTouchManager];
    [L2DBridge destroyLive2DView];
}

#pragma mark - 触摸事件

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [[L2DTouch sharedInstance] touchesBegan:touches view:self];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [[L2DTouch sharedInstance] touchesMoved:touches view:self];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [[L2DTouch sharedInstance] touchesEnded:touches view:self];
}

@end
