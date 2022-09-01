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
    
//    [Live2DBridge createSprite: self.live2DXibView.bounds.size];
    
    NSString *modelName = [[NSUserDefaults standardUserDefaults] objectForKey:@"originModel"];
    if (modelName == nil || [modelName isEqualToString:@""]) {
        modelName = @"Hiyori";
    }
    self.live2DXibView.modelName = modelName;
}

- (Live2DView *)live2DView {
    if (!_live2DView) {
        _live2DView = [[Live2DView alloc] init];
    }
    return _live2DView;
}

#pragma mark - 按钮操作

- (IBAction)originModelWithHiyori:(UIButton *)sender {
    [[NSUserDefaults standardUserDefaults] setObject:@"Hiyori" forKey:@"originModel"];
}

- (IBAction)originModelSword:(UIButton *)sender {
    [[NSUserDefaults standardUserDefaults] setObject:@"Gantzert_Felixander" forKey:@"originModel"];
}

- (IBAction)originModelClerk:(UIButton *)sender {
    [[NSUserDefaults standardUserDefaults] setObject:@"Haru" forKey:@"originModel"];
}

- (IBAction)changeHiyoriModel:(UIButton *)sender {
    self.live2DXibView.modelName = @"Hiyori";
}

- (IBAction)changeSwordModel:(UIButton *)sender {
    self.live2DXibView.modelName = @"Gantzert_Felixander";
}

- (IBAction)changeClerkModel:(UIButton *)sender {
    self.live2DXibView.modelName = @"Haru";
}

- (IBAction)changeNextModel:(UIButton *)sender {
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

- (IBAction)resetModel:(UIButton *)sender {
    [Live2DChangeClothes resetModelPNG:self.live2DXibView.modelName pngIndexStr:@"01"];
}

@end
