/**
 * Copyright(c) Live2D Inc. All rights reserved.
 *
 * Use of this source code is governed by the Live2D Open Software license
 * that can be found at https://www.live2d.com/eula/live2d-open-software-license-agreement_en.html.
 */

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
