//
//  ZLSecurityCodeImgView.h
//  ZLSecurityCode
//
//  Created by ZL on 2017/8/1.
//  Copyright © 2017年 ZL. All rights reserved.
//  字母图片验证

#import <UIKit/UIKit.h>


typedef void(^ZLSecurityCodeImgBlock)(NSString *codeStr);


@interface ZLSecurityCodeImgView : UIView

@property (nonatomic, copy) ZLSecurityCodeImgBlock bolck;

// 验证码值
@property (nonatomic, strong) NSString *imageCodeStr;

// 验证码字符是否可以斜着 (可以:YES)
@property (nonatomic, assign) BOOL isRotation;

// 点击验证图，重新获取验证码的方法
-(void)refreshSecurityCode;

@end
