//
//  AppDelegate.h
//  Live2DNewTest
//
//  Created by 谢佳培 on 2022/8/24.
//

#import <UIKit/UIKit.h>
#include "ViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

/**
 * @brief   退出应用程序
 */
- (void)finishApplication;

@end

