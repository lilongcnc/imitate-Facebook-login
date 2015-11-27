//
//  ViewController.m
//  login_wzx_pop
//
//  Created by wordoor－z on 15/11/26.
//  Copyright © 2015年 wzx. All rights reserved.
//

#import "ViewController.h"
#import "POP/POP.h"
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define WGroundColor [UIColor colorWithRed:59/255.0 green:88/255.0 blue:152/255.0 alpha:1]
#define WBtnColor [UIColor colorWithRed:79/255.0 green:106/255.0 blue:163/255.0 alpha:1]
#define WWidth self.view.frame.size.width
#define WHeight self.view.frame.size.height
@interface ViewController ()
{
    UIView * _logoView;
    UIView * _midView;
    UIView * _lowView;
    BOOL _isHide;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _isHide = YES;
    //设置背景颜色
    self.view.backgroundColor = WGroundColor;
    //logo视图
    [self createLogoView];
    //中间视图
    [self createMidView];
    //下方视图
    [self createLowView];
    
    //添加监听键盘弹起
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
-(void)createLogoView
{
    CGFloat viewHeigth = (120/667.0)*WHeight;
    CGFloat imgWidth = (50/375.0)*WWidth;
    _logoView = [[UIView alloc]initWithFrame:CGRectMake(0, viewHeigth , WWidth,imgWidth)];
    [self.view addSubview:_logoView];
    
    //imgview
    UIImageView * logoView = [[UIImageView alloc]initWithFrame:CGRectMake((_logoView.frame.size.width - imgWidth)/2.0, 0,imgWidth, imgWidth)];
    logoView.image = [UIImage imageNamed:@"logo"];
    logoView.layer.cornerRadius = 5;
    logoView.clipsToBounds = YES;
    [_logoView addSubview:logoView];
}
-(void)createMidView
{
    CGFloat viewHeigth = (275/667.0)*WHeight;
    CGFloat subViewWidth = (170/667.0)*WHeight;
    _midView = [[UIView alloc]initWithFrame:CGRectMake(0, viewHeigth, WWidth, subViewWidth)];
    [self.view addSubview:_midView];
  
    CGFloat left = (20/375.0)*WWidth;
    CGFloat textHeight = (53/667.0)*WHeight;
    
    //textfield背景view
    UIView * textGroudView = [[UIView alloc]initWithFrame:CGRectMake(left, 0, WWidth - 2*left, 2*textHeight)];
    textGroudView.backgroundColor = [UIColor whiteColor];
    textGroudView.layer.cornerRadius = 5;
    [_midView addSubview:textGroudView];
    
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, textHeight, WWidth - 2*left, 2)];
    lineView.backgroundColor = [UIColor colorWithRed:241/255.0 green:243/255.0 blue:247/255.0 alpha:1];
    [textGroudView addSubview:lineView];
    //textfield
   
    for (int i = 0; i<2; i++)
    {
        UITextField * textField = [[UITextField alloc]initWithFrame:CGRectMake(10, i * textHeight, WWidth - 2*left-10, textHeight)];
        if (i == 1)
        {
            textField.secureTextEntry = YES;
            textField.placeholder = @"密码";
        }
        else
        {
            textField.placeholder = @"邮箱或手机号";
        }
        textField.tag = 10000 + i;
        [textGroudView addSubview:textField];
    }
    
    //btn
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(left, _midView.frame.size.height - textHeight, WWidth - 2*left, textHeight);
    [btn setTitle:@"登录" forState:UIControlStateNormal];
    btn.backgroundColor = WBtnColor;
    btn.layer.cornerRadius = 5;
    [_midView addSubview:btn];
}
-(void)createLowView
{
    CGFloat viewHeigth = (560/667.0)*WHeight;
    CGFloat subViewWidth = (90/667.0)*WHeight;
    _lowView = [[UIView alloc]initWithFrame:CGRectMake(0, viewHeigth, WWidth, subViewWidth)];
    [self.view addSubview:_lowView];
    
    for (int i = 0; i<2; i++)
    {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, i*(subViewWidth/2.0), WWidth,subViewWidth/2.0);
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        if (i == 0)
        {
            [btn setTitle:@"注册Facebook帐户" forState:UIControlStateNormal];
             btn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        }
        else
        {
            [btn setTitle:@"需要帮助？" forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:13];
        }
        [_lowView addSubview:btn];
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    for (int i = 0; i<2; i++)
    {
        UITextField * textField = (UITextField *)[self.view viewWithTag:10000+i];
        [textField resignFirstResponder];
    }
}
-(void)keyboardWillShow:(NSNotification *)notif
{
    if (_isHide)
    {
        _isHide = NO;
        CGFloat sHeight = (120/667.0)*WHeight;
        NSDictionary *userInfo = [notif userInfo];
        NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
        CGRect keyboardRect = [aValue CGRectValue];
        CGFloat height = keyboardRect.size.height;
        CGFloat keyboardDuration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        
        POPBasicAnimation * basicAnimation1 = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerTranslationY];
        basicAnimation1.toValue = @(-height+10);
        basicAnimation1.duration = keyboardDuration - 0.05;
        basicAnimation1.timingFunction =[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];

        [_lowView.layer pop_addAnimation:basicAnimation1 forKey:@"up1"];
        
        POPBasicAnimation * decayAnimation2 = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerTranslationY];
        if (SCREEN_HEIGHT == 568)
        {
             decayAnimation2.toValue = @(-sHeight/2.0-30);
        }
        else
        {
             decayAnimation2.toValue = @(-sHeight/2.0);
        }
        decayAnimation2.duration = keyboardDuration - 0.05;
        decayAnimation2.timingFunction =[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        [_logoView.layer pop_addAnimation:decayAnimation2 forKey:@"up2"];
        
        POPBasicAnimation * decayAnimation3 = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerTranslationY];
        decayAnimation3.toValue = @(-(height - sHeight));
        decayAnimation3.duration = keyboardDuration - 0.05;
        decayAnimation3.timingFunction =[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];

        [_midView.layer pop_addAnimation:decayAnimation3 forKey:@"up3"];
    }
    
}
-(void)keyboardWillHide:(NSNotification *)notif
{
    
    if (!_isHide)
    {
        _isHide = YES;
        POPBasicAnimation * decayAnimation1 = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerTranslationY];
        decayAnimation1.toValue = @(0);
        decayAnimation1.duration = 0.5;
        [_lowView.layer pop_addAnimation:decayAnimation1 forKey:@"down1"];
        
        POPBasicAnimation * decayAnimation2 = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerTranslationY];
        decayAnimation2.toValue = @(0);
        decayAnimation2.duration = 0.5;
        [_logoView.layer pop_addAnimation:decayAnimation2 forKey:@"down2"];
        
        POPBasicAnimation * decayAnimation3 = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerTranslationY];
        decayAnimation3.toValue = @(0);
        decayAnimation3.duration = 0.5;
        [_midView.layer pop_addAnimation:decayAnimation3 forKey:@"down3"];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
