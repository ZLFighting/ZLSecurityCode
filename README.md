# ZLSecurityCode
iOS-仿智联字符图片验证码

随机字符组成的图片验证码, 字符位数可改变, 字符可斜可正排列.

项目中有时候会有这种需求: 获取这种 随机字符组成的图片验证码.
随机字符组成的图片验证码, 字符位数可改变, 字符可斜可正排列.

![字符图片验证码.png](https://github.com/ZLFighting/ZLSecurityCode/blob/master/ZLSecurityCode/字符图片验证码.png)

>主要思路:
1.初始化验证码的背景且设置随机色
2.获取验证图上的字符码并通过bolck带回验证码值
3.在背景上添加标签,获取字符随机产生赋值给标签(可斜可正排列)
4.初始化添加验证码视图 并添加手势点击刷新
5.判断验证码字符是否输入正确(区分大小写)

## 首先 初始化创建验证码背景:ZLSecurityCodeImgView

#### 1. 初始化验证码的背景且设置随机色
初始化背景:
```
if (_bgView) {
[_bgView removeFromSuperview];
}
_bgView = [[UIView alloc]initWithFrame:self.bounds];
[self addSubview:_bgView];
[_bgView setBackgroundColor:[self getRandomBgColorWithAlpha:0.5]];
```
产生背景随机色:
```
- (UIColor *)getRandomBgColorWithAlpha:(CGFloat)alpha {

float red = arc4random() % 100 / 100.0;
float green = arc4random() % 100 / 100.0;
float blue = arc4random() % 100 / 100.0;
UIColor *color = [UIColor colorWithRed:red green:green blue:blue alpha:alpha];

return color;
}
```

#### 2. 获取验证图上的字符码
```
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
```
其中这个字符CodeCount的个数可以按照自己需求了来修改.
![四位斜验证码.png](https://github.com/ZLFighting/ZLSecurityCode/blob/master/ZLSecurityCode/四位斜验证码截图.png)

![5位斜字符验证码.png](https://github.com/ZLFighting/ZLSecurityCode/blob/master/ZLSecurityCode/5位验证码.png)

#### 3. 在背景上添加标签, 获取字符随机产生赋值给标签(可斜可正排列)

```
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
```
其中这个字符的正斜可以按照自己需求了来修改,这里看下正的:
![正验证码截图.png](https://github.com/ZLFighting/ZLSecurityCode/blob/master/ZLSecurityCode/正验证码图.gif)

## 最后初始化添加验证码视图
#### 4. 初始化添加验证码视图 并添加手势点击刷新
初始化添加验证码视图:
```
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
```
添加手势:
```
UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
[_codeImgView addGestureRecognizer:tap];
```
点击刷新:
```
- (void)tapClick:(UITapGestureRecognizer *)tap {

[_codeImgView refreshSecurityCode];
}
```
![斜验证码图.gif](https://github.com/ZLFighting/ZLSecurityCode/blob/master/ZLSecurityCode/斜验证码图.gif)

#### 5. 判断验证码字符是否输入正确(区分大小写)
```
#pragma mark- UITextFieldDelegate
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
```
这时候测试一下效果 :
![验证码图.gif](https://github.com/ZLFighting/ZLSecurityCode/blob/master/ZLSecurityCode/验证码图.gif)


思路详情请移步技术文章:[iOS-仿智联字符图片验证码](http://www.jianshu.com/p/883faf8fe520)

您的支持是作为程序媛的我最大的动力, 如果觉得对你有帮助请送个Star吧,谢谢啦
