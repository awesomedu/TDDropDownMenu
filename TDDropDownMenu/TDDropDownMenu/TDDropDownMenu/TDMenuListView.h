//
//  TDMenuListView.h
//  TDDropDownMenu
//
//  Created by mac on 2019/1/24.
//  Copyright © 2019年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TDListCell : UITableViewCell
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) BOOL isSelected;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end






@class TDMenuButton;

@interface TDMenuListView : UIView

/// dataSource
@property (nonatomic, strong) NSArray *dataSource;
/// 选中按钮回调
@property (nonatomic, copy) void (^clickMenuButton) (TDMenuButton *button, NSInteger index, BOOL selected);
/// 选中下拉列表回调
@property (nonatomic, copy) void (^clickListView) ( NSInteger index, NSString *title);
/// 初始化
- (instancetype)initWithFrame:(CGRect)frame
                       Titles:(NSArray <NSString *>*)titles
                   defaultImg:(UIImage *)defaultImg
                    selectImg:(UIImage *)selectImg;
@end

NS_ASSUME_NONNULL_END
