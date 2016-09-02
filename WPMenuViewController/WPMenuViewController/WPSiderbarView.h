//
//  WPSiderbarView.h
//  WPMenuViewController
//
//  Created by 吴鹏 on 16/9/2.
//  Copyright © 2016年 wupeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WPSiderbarView;
@protocol WPSiderbarViewDelegate <NSObject>

- (void)wp_sliderClick:(NSInteger)index;

@end

@interface WPSiderbarView : UIView

- (id)initWithImageArray:(NSArray *)imageArray
                   index:(NSInteger)index
   contentViewController:(UIViewController *)contentViewController
                   width:(float)width;

- (void)wp_showSiderBar;

@property (nonatomic , assign) id<WPSiderbarViewDelegate>delegate;

@end
