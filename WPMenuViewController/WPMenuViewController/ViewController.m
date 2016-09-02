//
//  ViewController.m
//  WPMenuViewController
//
//  Created by 吴鹏 on 16/9/2.
//  Copyright © 2016年 wupeng. All rights reserved.
//

#import "ViewController.h"
#import "WPSiderbarView.h"

@interface ViewController ()<WPSiderbarViewDelegate>
{
    WPSiderbarView * _barview;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"我p无敌强";
    NSArray * array = @[@"burger",
                        @"gear",
                        @"globe",
                        @"profile",
                        @"star"];
    
    _barview = [[WPSiderbarView alloc]initWithImageArray:array index:0 contentViewController:self width:150];
    _barview.delegate = self;
    
}

#pragma mark - UITouch

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_barview wp_showSiderBar];
    
}

#pragma mark - WPSiderbarViewDelegate

- (void)wp_sliderClick:(NSInteger)index
{
    NSLog(@" %ld ",index);
}



@end
