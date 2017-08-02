//
//  ViewController.m
//  ZLSecurityCode
//
//  Created by ZL on 2017/8/1.
//  Copyright © 2017年 ZL. All rights reserved.
//

#import "ViewController.h"
#import "ZLSecurityCodeImgView.h"

@interface ViewController () <UITextFieldDelegate>

// 验证码输入框
@property (nonatomic, weak) UITextField *codeField;

@property (nonatomic, strong) ZLSecurityCodeImgView *codeImgView;

// 验证码值
@property (nonatomic, copy) NSString *imageCodeStr;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
   
    // 验证码输入框
    UITextField *codeField = [[UITextField alloc]initWithFrame:CGRectMake(50, 200, 150, 40)];
    codeField.borderStyle = UITextBorderStyleBezel;
    codeField.placeholder = @"请输入验证码";
    codeField.delegate = self;
    codeField.backgroundColor = [UIColor whiteColor];
    codeField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    codeField.returnKeyType = UIReturnKeyDone;
    codeField.font = [UIFont systemFontOfSize:15];
    codeField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:codeField];
    self.codeField = codeField;
    
    // 初始化添加
    [self setupSecurityCodeImgView];
    
    // 添加手势点击刷新
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    [_codeImgView addGestureRecognizer:tap];
}

// 初始化添加验证码
- (void)setupSecurityCodeImgView {
    
    // 验证码背景宽高可根据需求自定义
    _codeImgView = [[ZLSecurityCodeImgView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.codeField.frame), 200, 100, 40)];
    _codeImgView.bolck = ^(NSString *imageCodeStr){ // 根据需求是否使用验证码值
        // 打印生成的验证码
        NSLog(@"imageCodeStr = %@", imageCodeStr);
        
        self.imageCodeStr = imageCodeStr;
    };
    // 验证码字符是否需要斜着
    _codeImgView.isRotation = YES;
    [_codeImgView refreshSecurityCode];
    [self.view addSubview: _codeImgView];
}

- (void)tapClick:(UITapGestureRecognizer *)tap {
    
    [_codeImgView refreshSecurityCode];
}

#pragma mark- UITextFieldDelegate

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.codeField resignFirstResponder];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.codeField) {
        [self.codeField resignFirstResponder];
        
        // 判断验证码字符是否输入正确(区分大小写)
        if ([textField.text isEqualToString:self.imageCodeStr]) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"测试" message:@"匹配成功" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alert addAction:okAction];
            [self presentViewController:alert animated:YES completion:nil];
        } else {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"测试" message:@"匹配失败" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alert addAction:okAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
        
    }
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
