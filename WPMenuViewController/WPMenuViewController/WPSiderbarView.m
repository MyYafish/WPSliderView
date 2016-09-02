//
//  WPSiderbarView.m
//  WPMenuViewController
//
//  Created by 吴鹏 on 16/9/2.
//  Copyright © 2016年 wupeng. All rights reserved.
//

#import "WPSiderbarView.h"

#define imageWidth 70

@interface WPSiderbarView ()
{
    NSInteger ind;
    float _width;
}

@property (nonatomic , strong) UIScrollView * scrollView;
@property (nonatomic , strong) NSArray * imageArray;
@property (nonatomic , strong) NSMutableArray * itmeArray;
@property (nonatomic , strong) UIView * contentView;

@end

@implementation WPSiderbarView

- (id)initWithImageArray:(NSArray *)imageArray
                   index:(NSInteger)index
   contentViewController:(UIViewController *)contentViewController
                   width:(float)width

{
    self = [super init];
    {
        self.imageArray = imageArray;
        ind = index;
        _width = width;
        self.itmeArray = [NSMutableArray array];
        self.contentView = contentViewController.view;
        self.frame = CGRectMake(-CGRectGetWidth([UIScreen mainScreen].bounds), 0, CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds));
        [self addSubview:self.scrollView];
        
        
    }
    return self;
}

#pragma mark - property

- (UIScrollView *)scrollView
{
    if(!_scrollView)
    {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, _width, CGRectGetHeight(self.frame))];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.bounces = NO;
        _scrollView.contentSize = CGSizeMake(_width,70+ (imageWidth + 40) * self.imageArray.count);
        _scrollView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        [self setUI];
        
    }
    return _scrollView;
}

#pragma mark - private 


- (void)setUI
{
    for(NSInteger i = 0 ;i < self.imageArray.count ;i++)
    {
        UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(_width/2 - imageWidth/2,70 + i * (40 + imageWidth), imageWidth, imageWidth)];
        [button setImage:[UIImage imageNamed:self.imageArray[i]] forState:UIControlStateNormal];
        button.layer.cornerRadius = imageWidth/2;
        button.layer.borderWidth = 5;
        button.backgroundColor = [UIColor blueColor];
        [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        if(i == ind)
            button.layer.borderColor = [UIColor redColor].CGColor;
        else
            button.layer.borderColor = [UIColor clearColor].CGColor;
        [_scrollView addSubview:button];
        button.tag = i;
        [self.itmeArray addObject:button];
        
    }
}

- (void)wp_showSiderBar
{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:.25
                     animations:^{
        self.frame = CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds));
    } completion:^(BOOL finished) {
        
    }];
    for(NSInteger i = 0 ; i < self.itmeArray.count ; i++)
    {
        UIView * view = self.itmeArray[i];
        view.layer.transform = CATransform3DMakeScale(0.3, 0.3, 1);
        view.alpha = 0;
        [self animation:i view:view];
    }
}

- (void)animation:(NSInteger)index view:(UIView *)view;
{
    [UIView animateWithDuration:0.2
                          delay:(0.1 + index*0.1f)
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         view.layer.transform = CATransform3DMakeScale(1.3, 1.3, 1);
                         view.alpha = 1;
                     }
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.2 animations:^{
                             view.layer.transform = CATransform3DIdentity;
                         }];
                     }];
}

- (void)btnClick:(UIButton *)sender
{
    
    [self setAnimation:sender];
    if(self.delegate && [self.delegate respondsToSelector:@selector(wp_sliderClick:)])
    {
        [self.delegate wp_sliderClick:sender.tag];
    }

    
}

- (void)setAnimation:(UIButton *)sender
{
    
    [UIView animateWithDuration:0.25 animations:^{
        sender.layer.transform = CATransform3DMakeScale(1.2, 1.2, 1);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.25 animations:^{
            sender.layer.transform = CATransform3DIdentity;
        }];
    }];
    
    for (NSInteger i = 0; i < self.itmeArray.count; i++)
    {
        UIView * view = self.itmeArray[i];
        if(i == sender.tag)
        {
            view.layer.borderWidth = 5;
            view.layer.borderColor = [UIColor redColor].CGColor;
        }else
        {
            view.layer.borderWidth = 0;
            view.layer.borderColor = [UIColor clearColor].CGColor;
        }
    }
    
    CGRect fram = CGRectMake(-CGRectGetMidX(sender.bounds),-CGRectGetMidY(sender.bounds), sender.bounds.size.width, sender.bounds.size.height);
    UIBezierPath * patch = [UIBezierPath bezierPathWithOvalInRect:fram];
    
    
    CAShapeLayer * layer = [CAShapeLayer layer];
    layer.path = patch.CGPath;
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.opacity = 0;
    layer.strokeColor = [UIColor redColor].CGColor;
    layer.lineWidth = 5;
    layer.position = CGPointMake(imageWidth/2, imageWidth/2);
    
    [sender.layer addSublayer:layer];
    
    CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    animation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(2.5, 2.5, 1)];
    
    CABasicAnimation * animation1 = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation1.fromValue = @1;
    animation1.toValue = @0;
    
    CAAnimationGroup * group = [CAAnimationGroup animation];
    group.animations = @[animation,animation1];
    group.duration = 0.5;
    group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    [layer addAnimation:group forKey:nil];
    
    
    
}


#pragma mark - UITouch

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [UIView animateWithDuration:0.25 animations:^{
        self.frame = CGRectMake(-CGRectGetWidth([UIScreen mainScreen].bounds), 0, CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds));
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
