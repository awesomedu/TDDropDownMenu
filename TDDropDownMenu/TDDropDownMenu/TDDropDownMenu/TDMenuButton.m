//
//  TDMenuButton.m
//  TDDropDownMenu
//
//  Created by mac on 2019/1/24.
//  Copyright © 2019年 mac. All rights reserved.
//

#import "TDMenuButton.h"

#define tFontSize 13.f
#define tTriangleWH 20.f
#define tDefTitleCor [UIColor colorWithRed:0.560 green:0.550 blue:0.520 alpha:1.000]
#define tSelTitleCor [UIColor colorWithRed:0.980 green:0.440 blue:0.270 alpha:1.000]

@interface TDMenuButton (){
    NSString *_title; /// 按钮标题
    UIImage *_defaultImg; /// 按钮没有选中时右边图片
    UIImage *_selectedImg; /// 按钮选中时右边图片
}

@property (nonatomic, strong) TDMenuButton *selectedBtn;
@property (nonatomic, assign) BOOL selected;
/// 用来设置按钮标题
@property (nonatomic, strong) UILabel *titLabel;
/// 用来设置图片
@property (nonatomic, strong) UIImageView *imgView;




@end


@implementation TDMenuButton

#pragma -mark lazy

- (UILabel *)titLabel{
    if (!_titLabel) {
        _titLabel = [[UILabel alloc] init];
        _titLabel.text = _title;
        _titLabel.textColor = tDefTitleCor;
        _titLabel.font = [UIFont systemFontOfSize:tFontSize];
        _titLabel.center = CGPointMake(self.frame.size.width / 2 - tTriangleWH / 2, self.frame.size.height / 2);
        CGSize size = [_title sizeWithAttributes:@{
                                                   NSFontAttributeName:[UIFont systemFontOfSize:tFontSize]
                                                   }];
        _titLabel.bounds = CGRectMake(0, 0, size.width, size.height);
    }
    return _titLabel;
}

- (UIImageView *)imgView{
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
        _imgView.image = _defaultImg;
        _imgView.contentMode = UIViewContentModeCenter;
        _imgView.frame = CGRectMake(CGRectGetMaxX(self.titLabel.frame), (self.frame.size.height - tTriangleWH) / 2, tTriangleWH, tTriangleWH);
    }
    return _imgView;
}

- (instancetype)initWithFrame:(CGRect)frame btnTitle:(NSString *)title defaultImg:(UIImage *)defaulImg selectedImage:(UIImage *)selectedImg{
    if (self = [super initWithFrame:frame]) {
        _title = title;
        _defaultImg = defaulImg;
        _selectedImg = selectedImg;
        [self setUpSubViews];
    }
    return self;
}

- (void)setUpSubViews{
    self.selected = NO;
    [self addSubview:self.titLabel];
    [self addSubview:self.imgView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(menuBtnClicked)];
    [self addGestureRecognizer:tap];
}

#pragma -mark gestureClick
- (void)menuBtnClicked{
    _selected = !_selected;
    if (_selected) {
        self.titLabel.textColor = tSelTitleCor;
        self.imgView.image = _selectedImg;
    }else{
        self.titLabel.textColor = tDefTitleCor;
        self.imgView.image = _defaultImg;
    }
    
    if (self.clickMenuBtn) {
        self.clickMenuBtn(self, self.titLabel.text, _selected);
    }
}


#pragma -mark setter
- (void)setIsSelected:(BOOL)isSelected{
    if (!isSelected) {
        _selectedBtn.titLabel.textColor = tDefTitleCor;
        _selectedBtn.imgView.image = _defaultImg;
    }
}

- (void)setBtnTitle:(NSString *)btnTitle{
    self.titLabel.text = btnTitle;
    // 为了不至于让标题和图片由于位置变化而太难看，我们需要在按钮标题每次改变时重新设置它的frame
    CGSize size = [btnTitle sizeWithAttributes:@{
                                               NSFontAttributeName:[UIFont systemFontOfSize:tFontSize]
                                               }];
    _titLabel.center = CGPointMake(self.frame.size.width / 2 - tTriangleWH / 2, self.frame.size.height / 2);
    _titLabel.bounds = CGRectMake(0, 0, size.width, size.height);
    _imgView.frame = CGRectMake(CGRectGetMaxX(self.titLabel.frame), (self.frame.size.height - tTriangleWH)/2, tTriangleWH, tTriangleWH);
    [self setNeedsLayout];
    [self setIsSelected:NO];
}

- (void)resetButtonStatus:(TDMenuButton *)button{
    button.titLabel.textColor = tDefTitleCor;
    button.imgView.image = _defaultImg;
    button.selected = NO;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
