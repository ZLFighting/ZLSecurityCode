//
//  ZLSecurityCodeImgView.m
//  ZLSecurityCode
//
//  Created by ZL on 2017/8/1.
//  Copyright © 2017年 ZL. All rights reserved.
//

#import "ZLSecurityCodeImgView.h"

#define ARC4RAND_MAX 0x100000000

#define CodeCount 5

@interface ZLSecurityCodeImgView ()

// 内容数组
@property (nonatomic, strong) NSArray *textArr;

// 背景图
@property (nonatomic, strong) UIView *bgView;

@end

@implementation ZLSecurityCodeImgView

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

// 点击验证图，重新获取验证码的方法
- (void)refreshSecurityCode {
    
    // 获取验证图上的字符码
    [self changeCodeStr];
    [self initImageCodeView];
}

// 获取验证图上的字符码
- (void)changeCodeStr {
    
    // 目前是数字字母
    self.textArr = [[NSArray alloc] initWithObjects:@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",@"a",@"b",@"c",@"d",@"e",@"f",@"g",@"h",@"i",@"j",@"k",@"l",@"m",@"n",@"o",@"p",@"q",@"r",@"s",@"t",@"u",@"v",@"w",@"x",@"y",@"z",nil];
    
    for(NSInteger i = 0; i < CodeCount; i++) {
        NSInteger index = arc4random() % ([self.textArr count] - 1);
        NSString *oneText = [self.textArr objectAtIndex:index];
        self.imageCodeStr = (i==0) ? oneText : [self.imageCodeStr stringByAppendingString:oneText];
    }
    // block 块带回验证码值
    if (self.bolck) {
        self.bolck(self.imageCodeStr);
    }
}

// 初始化背景
- (void)initImageCodeView {
    
    if (_bgView) {
        [_bgView removeFromSuperview];
    }
    _bgView = [[UIView alloc]initWithFrame:self.bounds];
    [self addSubview:_bgView];
    [_bgView setBackgroundColor:[self getRandomBgColorWithAlpha:0.5]];
    CGSize textSize = [@"W" sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20]}];
    int randWidth = (self.frame.size.width)/self.imageCodeStr.length - textSize.width;
    int randHeight = self.frame.size.height - textSize.height;
    
    for (int i = 0; i<self.imageCodeStr.length; i++) {
        
        CGFloat px = arc4random()%randWidth + i*(self.frame.size.width-3)/self.imageCodeStr.length;
        CGFloat py = arc4random()%randHeight;
        UILabel * label = [[UILabel alloc] initWithFrame: CGRectMake(px+3, py, textSize.width, textSize.height)];
        label.text = [NSString stringWithFormat:@"%C", [self.imageCodeStr characterAtIndex:i]];
        label.font = [UIFont systemFontOfSize:20];
        
        if (self.isRotation) { // 验证码字符是否需要斜着
            double r = (double)arc4random() / ARC4RAND_MAX * 2 - 1.0f; // 随机-1到1
            if (r > 0.3) {
                r = 0.3;
            }else if(r < -0.3){
                r = -0.3;
            }
            label.transform = CGAffineTransformMakeRotation(r);
        }
        
        [_bgView addSubview:label];
    }
    
    // 添加干扰线于背景
    for (int i = 0; i<10; i++) {
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        CGFloat pX = arc4random() % (int)CGRectGetWidth(self.frame);
        CGFloat pY = arc4random() % (int)CGRectGetHeight(self.frame);
        [path moveToPoint:CGPointMake(pX, pY)];
        CGFloat ptX = arc4random() % (int)CGRectGetWidth(self.frame);
        CGFloat ptY = arc4random() % (int)CGRectGetHeight(self.frame);
        [path addLineToPoint:CGPointMake(ptX, ptY)];
        
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.strokeColor = [[self getRandomBgColorWithAlpha:0.2] CGColor]; // layer的边框色
        layer.lineWidth = 1.0f;
        layer.strokeEnd = 1;
        layer.fillColor = [UIColor clearColor].CGColor;
        layer.path = path.CGPath;
        [_bgView.layer addSublayer:layer];
    }
    
}

// 背景随机色
- (UIColor *)getRandomBgColorWithAlpha:(CGFloat)alpha {
    
    float red = arc4random() % 100 / 100.0;
    float green = arc4random() % 100 / 100.0;
    float blue = arc4random() % 100 / 100.0;
    UIColor *color = [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
    
    return color;
}

@end
