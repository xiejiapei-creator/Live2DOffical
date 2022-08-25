//
//  L2DTouch.m
//  Live2DNewTest
//
//  Created by 谢佳培 on 2022/8/24.
//

#import "L2DTouch.h"

#import "LTouchManager.h"// 触摸管理器
#import "LAppLive2DManager.h"// 角色模型
#import "L2DMetal.h"// metal
#import "L2DSprite.h"// 精灵

#import "AppDelegate.h"

@interface L2DTouch ()

@property (nonatomic) LTouchManager *touchManager;// 触摸管理器

@end

@implementation L2DTouch

+ (instancetype)sharedInstance {
    static L2DTouch *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[L2DTouch alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        // 创建触摸事件管理器
        _touchManager = [[LTouchManager alloc] init];
    }
    return self;
}

- (void)destroyTouchManager {
    _touchManager = nil;
}

#pragma mark - 触摸过程

/// 触摸开始
- (void)touchesBegan:(NSSet *)touches view:(Live2DView *)view
{
    // 获取触摸点在视图中的坐标位置 point = (x = 425.5, y = 57)
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView: view];

    // 记录下触摸开始点的位置
    [_touchManager touchesBegan:point.x DeciveY:point.y];
}

/// 触摸移动
- (void)touchesMoved:(NSSet *)touches view:(Live2DView *)view
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView: view];

    // 获取触摸点转换为角色模型点后的坐标
    // viewX = -0.16183567 viewY = 0.707729459
    float viewX = [self transformViewX:[_touchManager getX]];
    float viewY = [self transformViewY:[_touchManager getY]];

    // 更新触摸的位置
    [_touchManager touchesMoved:point.x DeviceY:point.y];
    
    // 在角色模型的x和y轴上拖动相应坐标点
    [[LAppLive2DManager getInstance] onDrag:viewX floatY:viewY];
}

/// 触摸结束
- (void)touchesEnded:(NSSet *)touches view:(Live2DView *)view
{
    // 人物模型移动结束，x和y轴上拖动的坐标点重置为0，眼睛回归到中央
    LAppLive2DManager* live2DManager = [LAppLive2DManager getInstance];
    [live2DManager onDrag:0.0f floatY:0.0f];
    
    // 获取触摸点转换为角色模型点后的坐标，再放大、缩小、移动后的值
    float getX = [_touchManager getX];// getX = 476
    float getY = [_touchManager getY];// getY = 79.5
    float x = [[L2DMetal sharedInstance] deviceToScreen]->TransformX(getX);// x = 0.1352
    float y = [[L2DMetal sharedInstance] deviceToScreen]->TransformY(getY);// y = 0.615942001
    
    // 点击画面时的处理
    [live2DManager onTap:x floatY:y];
    
    // 获取触摸点在视图中的坐标位置
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView: view];
    float pointY = [self transformTapY:point.y view:view];// pointY = 332.5

    // 点击精灵按钮触发的操作
    [self touchSpriteAction:point.x y:pointY live2DManager:live2DManager];
}

// 点击精灵按钮触发的操作
- (void)touchSpriteAction:(CGFloat)x y:(CGFloat)y live2DManager:(LAppLive2DManager*)live2DManager
{
    // 点击了齿轮则切换到下一个人物模型
    if ([[[L2DSprite sharedInstance] gear] isHit:x PointY:y])
    {
        [live2DManager nextScene];
    }

    // 点击电源按钮则让APP结束运行
    if ([[[L2DSprite sharedInstance] power] isHit:x PointY:y])
    {
        AppDelegate *delegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
        [delegate finishApplication];
    }
}

#pragma mark - 坐标变换

/// 将 设备X坐标 转换为 View 坐标
- (float)transformViewX:(float)deviceX
{
    // deviceX = 425.5 ——> screenX = -0.108695507
    float screenX = [[L2DMetal sharedInstance] deviceToScreen]->TransformX(deviceX);
    
    // 用现在的矩阵逆计算X轴的值
    return [[L2DMetal sharedInstance] viewMatrix]->InvertTransformX(screenX);
}

/// 将 设备Y坐标 转换为 View 坐标
- (float)transformViewY:(float)deviceY
{
    float screenY = [[L2DMetal sharedInstance] deviceToScreen]->TransformY(deviceY);
    return [[L2DMetal sharedInstance] viewMatrix]->InvertTransformY(screenY);
}

/// 转换点击位置的Y坐标
- (float)transformTapY:(float)deviceY view:(Live2DView *)view
{
    float height = view.frame.size.height;
    return deviceY * -1 + height;
}

@end
