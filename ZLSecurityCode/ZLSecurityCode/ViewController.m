//
//  ViewController.m
//  ZLSecurityCode
//
//  Created by ZL on 2017/8/1.
//  Copyright © 2017年 ZL. All rights reserved.
//

#import "ViewController.h"
#import "ZLSecurityCodeImgView.h"

@interface ViewController ()

@property (nonatomic, strong) ZLSecurityCodeImgView *codeImgView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // 初始化添加
    [self setupSecurityCodeImgView];
    
    // 添加手势点击刷新
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    [_codeImgView addGestureRecognizer:tap];
}

// 初始化添加验证码
- (void)setupSecurityCodeImgView {
    
    // 验证码背景宽高可根据需求自定义
    _codeImgView = [[ZLSecurityCodeImgView alloc] initWithFrame:CGRectMake(150, 200, 100, 40)];
    _codeImgView.bolck = ^(NSString *imageCodeStr){ // 根据需求是否使用验证码值
        // 打印生成的验证码
        NSLog(@"imageCodeStr = %@", imageCodeStr);
    };
    // 验证码字符是否需要斜着
    _codeImgView.isRotation = YES;
    [_codeImgView refreshSecurityCode];
    [self.view addSubview: _codeImgView];
}

- (void)tapClick:(UITapGestureRecognizer *)tap {
    
    [_codeImgView refreshSecurityCode];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
