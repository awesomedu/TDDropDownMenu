//
//  TDMenuListView.m
//  TDDropDownMenu
//
//  Created by mac on 2019/1/24.
//  Copyright © 2019年 mac. All rights reserved.
//

#import "TDMenuListView.h"
#import "TDMenuButton.h"

#define tAnimationDuration 0.3f
#define tTitleCor [UIColor colorWithRed:0.100 green:0.700 blue:0.610 alpha:1.000]

@interface TDListCell ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *imgView;

@end

@implementation TDListCell

#pragma -mark lazy
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        CGFloat titleLabelH = self.frame.size.height - 2*10.f;
        _titleLabel.frame = CGRectMake(55.f, 10.f, self.frame.size.width - 100.f, titleLabelH);
        _titleLabel.font = [UIFont systemFontOfSize:14.f];
    }
    return _titleLabel;
}

- (UIImageView *)imgView
{
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
        CGFloat imgViewWH = self.frame.size.height - 2*10.f;
        _imgView.contentMode = UIViewContentModeCenter;
        _imgView.frame = CGRectMake(15.f, 10.f, imgViewWH, imgViewWH);
    }
    return _imgView;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *cellId = @"ListCell";
    TDListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[TDListCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:self.imgView];
    [self.contentView addSubview:self.titleLabel];
}

#pragma -mark setter

- (void)setTitle:(NSString *)title
{
    _title = title;
    _titleLabel.text = title;
}

- (void)setIsSelected:(BOOL)isSelected
{
    if (isSelected) {
        [self setSelected:YES animated:YES];
    }else {
        [self setSelected:NO animated:YES];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    if (selected) {
        self.titleLabel.textColor = tTitleCor;
        self.imgView.image = [UIImage imageNamed:@"gc_navi_selected_icon"];
    }else {
        self.titleLabel.textColor = [UIColor blackColor];
        self.imgView.image = nil;
    }
}
@end






#define tLineW 0.5f
#define tLineH 25.f
#define tLineCor [UIColor colorWithWhite:0.850 alpha:1.000]
#define TS_W [UIScreen mainScreen].bounds.size.width
#define TS_H [UIScreen mainScreen].bounds.size.height

#define tRowH 40.f
@interface TDMenuListView ()<UITableViewDelegate, UITableViewDataSource>
{
    NSString *_currenTitle;
    TDMenuButton *_button;
}
@property (nonatomic, strong) UITableView *lTableView;
@property (nonatomic, strong) UITableView *rTableView;
@property (nonatomic, strong) UIView *shadow;

@end

@implementation TDMenuListView

#pragma -mark lazy
- (UIView *)shadow
{
    if (!_shadow) {
        _shadow = [[UIView alloc] init];
        _shadow.alpha = 0.f;
        _shadow.userInteractionEnabled = YES;
        _shadow.frame = CGRectMake(0, 104, TS_W, TS_H);
        _shadow.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.6];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shadowViewClick)];
        [_shadow addGestureRecognizer:tap];
    }
    return _shadow;
}

- (UITableView *)lTableView
{
    if (!_lTableView) {
        CGRect frame = CGRectMake(0.f, 64 + self.frame.size.height, self.frame.size.width, 0.f);
        _lTableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        _lTableView.delegate = self;
        _lTableView.dataSource = self;
    }
    return _lTableView;
}

- (instancetype)initWithFrame:(CGRect)frame Titles:(NSArray<NSString *> *)titles defaultImg:(UIImage *)defaultImg selectImg:(UIImage *)selectImg{
    if (self = [super initWithFrame:frame]) {
        [self subViewsWithTitles:titles defaultImg:defaultImg selectImg:selectImg];
    }
    return self;
}

- (void)subViewsWithTitles:(NSArray *)titles defaultImg:(UIImage *)defaultImage selectImg:(UIImage *)selectImage{
    self.backgroundColor = [UIColor whiteColor];
    NSUInteger count = [titles count];
    for (int i = 0; i < count; i ++) {
        CGFloat buttonW = (self.frame.size.width - (count - 1) *tLineW) / count;
        CGFloat buttonH = 40.0f;
        CGFloat buttonX = (buttonW + tLineW) *i;
        CGRect btnFrame = CGRectMake(buttonX, 0, buttonW, buttonH);
        TDMenuButton *btn = [[TDMenuButton alloc] initWithFrame:btnFrame btnTitle:titles[i] defaultImg:defaultImage selectedImage:selectImage];
        [self addSubview:btn];
        
        __weak typeof(self)weakSelf = self;
        btn.clickMenuBtn = ^(TDMenuButton * _Nonnull clickBtn, NSString * _Nonnull title, BOOL isSelected) {
            if (weakSelf.clickMenuButton) {
                weakSelf.clickMenuButton(clickBtn, i,isSelected);
            }
            
            if (!_button) {
                _button = clickBtn;
            }
            
            if (clickBtn != _button) {
                [_button resetButtonStatus:_button];
            }
            
            _currenTitle = title;
            _button = clickBtn;
            
            if (isSelected) {
                [self showListViewAnimation];
            }else{
                [self hideListViewAnimation];
            }
        };
    }
}

- (void)showListViewAnimation{
    UIView *superView = self.superview;
    [superView.window addSubview:self.shadow];
    [superView.window addSubview:self.lTableView];
    CGFloat height = [self maxListHeightWithModel:self.dataSource];
    CGRect oldFrame = self.lTableView.frame;
    [UIView animateWithDuration:tAnimationDuration animations:^{
        self.shadow.alpha = 1.0f;
        self.lTableView.frame = CGRectMake(oldFrame.origin.x, oldFrame.origin.y, oldFrame.size.width, height);
    }];
}

- (void)hideListViewAnimation{
    [UIView animateWithDuration:tAnimationDuration animations:^{
        self.shadow.alpha = 0;
        CGRect oldFrame = self.lTableView.frame;
        self.lTableView.frame = CGRectMake(oldFrame.origin.x, oldFrame.origin.y, oldFrame.size.width, 0);
    }completion:^(BOOL finished) {
        [self.shadow removeFromSuperview];
        [self.lTableView removeFromSuperview];
    }];
}

- (CGFloat)maxListHeightWithModel:(NSArray *)dataSource{
    NSInteger count = dataSource.count;
    CGFloat height = 0;
    CGFloat oriHeight = tRowH *count;
    oriHeight > TS_H/3*2 ? (height = TS_H/3*2) : (height = tRowH*count);
    
    return height;
}

#pragma -mark setter
- (void)setDataSource:(NSArray *)dataSource{
    _dataSource = dataSource;
    [self.lTableView reloadData];
}

#pragma -mark shadowViewClick
- (void)shadowViewClick
{
    [self hideListViewAnimation];
}

#pragma UITableViewDelegate
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return tRowH;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TDListCell *cell = [TDListCell cellWithTableView:tableView];
    cell.title = self.dataSource[indexPath.row];
    cell.selected = [self.dataSource[indexPath.row] isEqualToString:_currenTitle];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [UIView animateWithDuration:0.2f animations:^{
        self.shadow.alpha = 0.f;
        CGRect oldFrame = self.lTableView.frame;
        self.lTableView.frame = CGRectMake(oldFrame.origin.x, oldFrame.origin.y, oldFrame.size.width, 0);
    } completion:^(BOOL finished) {
        [self.shadow removeFromSuperview];
        [self.lTableView removeFromSuperview];
    }];
    
    _button.isSelected = NO;
    _button.btnTitle = self.dataSource[indexPath.row];
    
    [_button resetButtonStatus:_button];
    
    // 实现回调方法
    if (self.clickListView) {
        self.clickListView(indexPath.row, self.dataSource[indexPath.row]);
    }   
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
