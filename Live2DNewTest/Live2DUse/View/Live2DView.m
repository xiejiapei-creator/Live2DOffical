//
//  Live2DView.m
//  Live2DNewTest
//
//  Created by 谢佳培 on 2022/8/24.
//

#import "Live2DView.h"
#import "Live2DBridge.h"

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
    [Live2DBridge createLive2DView: self];
}

- (void)dealloc {
    [Live2DBridge destroyTouchManager];
    [Live2DBridge destroyLive2DView];
}

- (void)setIsLiveBroadcast:(BOOL)isLiveBroadcast {
    _isLiveBroadcast = isLiveBroadcast;
    [Live2DBridge isLiveBroadcast:isLiveBroadcast];
}

#pragma mark - 触摸事件

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [Live2DBridge touchesBegan:touches view:self];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [Live2DBridge touchesMoved:touches view:self];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [Live2DBridge touchesEnded:touches view:self];
}

@end
