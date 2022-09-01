//
//  ViewController.m
//  Live2DNewTest
//
//  Created by 谢佳培 on 2022/8/24.
//

#import "ViewController.h"
#import "Live2DBridge.h"
#import "Live2DChangeClothes.h"
//#import <Masonry/Masonry.h>

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
    
    self.live2DXibView.modelName = @"Hiyori";
//    [Live2DBridge createSprite: self.live2DXibView.bounds.size];
}

- (Live2DView *)live2DView {
    if (!_live2DView) {
        _live2DView = [[Live2DView alloc] init];
    }
    return _live2DView;
}

- (IBAction)changeModel:(UIButton *)sender {
    self.live2DXibView.modelName = [Live2DBridge nextLive2DModelName];
}

- (IBAction)changeClothes:(UIButton *)sender {
    NSString* castFilePath = [[NSBundle mainBundle]
                              pathForResource:@"replaceImage"
                              ofType:@"png"
                              inDirectory:@""];
    NSData *data = [NSData dataWithContentsOfFile:castFilePath];
    
    [Live2DChangeClothes replaceModelPNG:self.live2DXibView.modelName pngIndexStr:@"01" newPNGData:data];
}

@end
