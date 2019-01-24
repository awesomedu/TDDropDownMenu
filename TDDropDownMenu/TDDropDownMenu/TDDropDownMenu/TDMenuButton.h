//
//  TDMenuButton.h
//  TDDropDownMenu
//
//  Created by mac on 2019/1/24.
//  Copyright © 2019年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TDMenuButton : UIView
/// 按钮标题
@property (nonatomic, copy) NSString *btnTitle;
/// 是否选择
@property (nonatomic, assign) BOOL isSelected;

/// 选择某个按钮回调
@property (nonatomic, copy) void (^clickMenuBtn)(TDMenuButton *clickBtn,NSString *title,BOOL isSelected);
/// 初始化方法
- (instancetype)initWithFrame:(CGRect)frame
                     btnTitle:(NSString *)title
                   defaultImg:(UIImage *)defaulImg
                selectedImage:(UIImage *)selectedImg;
/// 重置某个按钮状态
- (void)resetButtonStatus:(TDMenuButton *)button;


@end

NS_ASSUME_NONNULL_END
