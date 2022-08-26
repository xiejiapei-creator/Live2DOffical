//
//  ViewController.m
//  Live2DNewTest
//
//  Created by 谢佳培 on 2022/8/24.
//

#import "ViewController.h"
#import "Live2DBridge.h"
#import <Masonry/Masonry.h>

@implementation ViewController

#pragma mark - 生命周期

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;

//    [self.view addSubview:self.live2DView];
//    self.live2DView.frame = self.view.bounds;
//    [self.live2DView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.view);
//    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // 创建角色模型以外的精灵（绘图）
    // 必须保证精灵在初始化 Cubism SDK 和视图呈现之后创建，因为顺序颠倒会崩溃
    [Live2DBridge createSprite: self.live2DXibView.bounds.size];
}

- (Live2DView *)live2DView {
    if (!_live2DView) {
        _live2DView = [[Live2DView alloc] init];
    }
    return _live2DView;
}

- (IBAction)changeModel:(UIButton *)sender {
    [Live2DBridge changeNextLive2DModel];
}


@end
