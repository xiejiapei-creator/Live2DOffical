//
//  ViewController.m
//  Live2DNewTest
//
//  Created by 谢佳培 on 2022/8/24.
//

#import "ViewController.h"
#import "Live2DBridge.h"
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
    
    // 创建角色模型以外的精灵（绘图）
    // 必须保证精灵在初始化 Cubism SDK 和视图呈现之后创建，因为顺序颠倒会崩溃
    //[Live2DBridge createSprite: self.live2DXibView.bounds.size];
}

- (Live2DView *)live2DView {
    if (!_live2DView) {
        _live2DView = [[Live2DView alloc] init];
    }
    return _live2DView;
}

- (IBAction)changeadsfsdaf:(UIButton *)sender {
    [self replaceModelPNG:@"Haru" pngIndexStr:@"01"];
}


- (IBAction)changeModel:(UIButton *)sender {
    [Live2DBridge changeNextLive2DModel];
    

}

- (void)replaceModelPNG:(NSString *)modelName pngIndexStr:(NSString *)pngIndexStr {
    NSArray *modelPNGPathList = [self getModelPNGList:modelName];
    
    NSString *modelPNGPath;
    for (NSString *pngPath in modelPNGPathList) {
        NSString *pngName = [pngPath lastPathComponent];
        NSArray *nameComponent = [pngName componentsSeparatedByString:@"_"];
        NSString *nameIndexStr = [nameComponent lastObject];
        nameIndexStr = [nameIndexStr stringByReplacingOccurrencesOfString:@".png" withString:@""];
        
        if ([nameIndexStr isEqualToString:pngIndexStr]) {
            modelPNGPath = pngPath;
            break;
        }
    }
    
    NSString *pngName = [modelPNGPath lastPathComponent];
    NSString *modifyPNGFilePath = [modelPNGPath stringByReplacingOccurrencesOfString:pngName withString:@"texture_origin.png"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL success = [fileManager moveItemAtPath:modelPNGPath toPath:modifyPNGFilePath error:nil];
    
    NSArray *newlist = [self getModelPNGList:@"Haru"];
    
    NSString* castFilePath = [[NSBundle mainBundle]
                              pathForResource:@"replaceImage"
                              ofType:@"png"
                              inDirectory:@""];
    NSData *newPNGData = [NSData dataWithContentsOfFile:castFilePath];
    
    BOOL filePathIsDir = NO;
    BOOL fileExisted = [fileManager fileExistsAtPath:modelPNGPath isDirectory:&filePathIsDir];
    if ((filePathIsDir == NO && fileExisted == NO)) {
        [fileManager createFileAtPath:modelPNGPath contents:newPNGData attributes:nil];
    }
    
    NSArray *newlist2 = [self getModelPNGList:@"Haru"];
    NSData *testPNGData = [NSData dataWithContentsOfFile:modelPNGPath];
    UIImage *image = [UIImage imageWithData:testPNGData];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = CGRectMake(100, 100, 200, 200);
    [self.view addSubview:imageView];
}

- (NSArray *)getModelPNGList:(NSString *)modelName {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *live2DResourcesPath = [NSString stringWithFormat:@"%@/%@", documentDirectory, @"Live2DResources"];
    NSArray *pathList = [fileManager subpathsAtPath:live2DResourcesPath];

    NSMutableArray *modelPNGPathList = [NSMutableArray array];
    for (NSString *path in pathList)
    {
        if ([path containsString:@".png"] && [path containsString:modelName])
        {
            NSString *fullPath = [NSString stringWithFormat:@"%@/Live2DResources/%@", documentDirectory, path];
            [modelPNGPathList addObject:fullPath];
            
            NSLog(@"获得当前文件的所有子文件：%@",modelPNGPathList);
        }
    }

    return [modelPNGPathList copy];
}


@end
