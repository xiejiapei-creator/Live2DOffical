//
//  MetalLive2DViewController.m
//  Live2DNewTest
//
//  Created by 谢佳培 on 2022/8/17.
//

#import "MetalLive2DViewController.h"
#import "KGMetalLive2DView.h"

@interface MetalLive2DViewController () <MetalRenderDelegate>
/// 渲染线程
@property (nonatomic, strong) dispatch_queue_t renderQueue;
/// 展示 live2d 的 View
@property (nonatomic, strong) KGMetalLive2DView *live2DView;
/// 是否已经加载资源
@property (nonatomic, assign) BOOL hasLoadResource;
@end

@implementation MetalLive2DViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        // Metal 可异步渲染
        _renderQueue = dispatch_queue_create("com.xiejiapei.render.home", DISPATCH_QUEUE_CONCURRENT);
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Live2D Metal Render";
    self.view.backgroundColor = UIColor.clearColor;
    
    [self.view addSubview:self.live2DView];
    self.live2DView.backgroundColor = UIColor.clearColor;
    self.live2DView.preferredFramesPerSecond = 30;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];

    if (!self.live2DView.paused) {
        self.live2DView.paused = YES;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    if (self.live2DView.paused) {
        self.live2DView.paused = NO;
    }
    
    if (!self.hasLoadResource) {
        [self.live2DView loadLive2DModelWithDir:@"Live2DResources/Mark/" mocJsonName:@"Mark.model3.json"];
        self.hasLoadResource = YES;
    }
}

- (void)dealloc {
    self.live2DView.delegate = nil;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    self.live2DView.frame = CGRectMake(0, 200, CGRectGetWidth(self.view.frame), 500);
}

#pragma mark - MetalRenderDelegate

- (void)rendererUpdateWithRender:(L2DMetalRender *)renderer duration:(NSTimeInterval)duration {
}

#pragma mark - lazy load
- (KGMetalLive2DView *)live2DView {
    if (!_live2DView) {
        _live2DView = [[KGMetalLive2DView alloc] init];
        _live2DView.delegate = self;
    }
    return _live2DView;
}

@end
