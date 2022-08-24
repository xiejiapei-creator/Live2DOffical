//
//  ViewController.m
//  Live2DNewTest
//
//  Created by 谢佳培 on 2022/8/24.
//

#import "ViewController.h"

@implementation ViewController

#pragma mark - 生命周期

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    
    [self.view addSubview:self.live2DView];
    self.live2DView.frame = self.view.bounds;
}

- (Live2DView *)live2DView {
    if (!_live2DView) {
        _live2DView = [[Live2DView alloc] init];
    }
    return _live2DView;
}

@end
