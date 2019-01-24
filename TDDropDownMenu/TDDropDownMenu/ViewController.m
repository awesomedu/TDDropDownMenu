//
//  ViewController.m
//  TDDropDownMenu
//
//  Created by mac on 2019/1/24.
//  Copyright © 2019年 mac. All rights reserved.
//

#import "ViewController.h"
#import "TDDropDownMenu/TDMenuButton.h"
#import "TDDropDownMenu/TDMenuListView.h"

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ViewController

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 15;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    // 推荐将`MenuListView`设置为tableView的第一组的组头视图
    UIImage *defImg = [UIImage imageNamed:@"gc_navi_arrow_down"];
    UIImage *selImg = [UIImage imageNamed:@"gc_navi_arrow_up"];
    CGRect frame = CGRectMake(0.f, 0.f, self.view.frame.size.width, 40.f);
    NSArray *titles = @[@"自助餐", @"附近", @"智能排序",@"提阿尼器",@"阿斯蒂芬健身房"];

    TDMenuListView *menu = [[TDMenuListView alloc] initWithFrame:frame Titles:titles defaultImg:defImg selectImg:selImg];
    __weak typeof (menu)weakMenu = menu;
    menu.clickMenuButton = ^(TDMenuButton * _Nonnull button, NSInteger index, BOOL selected) {
        if (index == 0) {
            weakMenu.dataSource = @[@"自助餐",@"火锅",@"海鲜",@"烧烤啤酒",@"甜点饮食",@"生日蛋糕",@"小吃快餐",@"烧烤啤酒",@"甜点饮食",@"烧烤啤酒",@"甜点饮食",@"烧烤啤酒",@"甜点饮食",@"烧烤啤酒",@"甜点饮食",@"烧烤啤酒",@"甜点饮食",@"烧烤啤酒",@"甜点饮食",@"烧烤啤酒",@"甜点饮食",@"烧烤啤酒",@"甜点饮食",@"烧烤啤酒",@"甜点饮食",@"烧烤啤酒",@"甜点饮食",@"烧烤啤酒",@"甜点饮食",@"烧烤啤酒",@"甜点饮食",@"烧烤啤酒",@"甜点饮食",@"烧烤啤酒",@"甜点饮食",@"烧烤啤酒",@"甜点饮食",@"烧烤啤酒",@"甜点饮食",@"烧烤啤酒",@"甜点饮食",@"烧烤啤酒",@"甜点饮食"];
        }
        else if (index == 1) {
            weakMenu.dataSource = @[@"附近",@"新津县",@"都江堰",@"温江区",@"郫县",@"龙泉驿区",@"锦江区"];
        }
        else if (index == 2) {
            weakMenu.dataSource = @[@"智能排序", @"离我最近", @"评价最高", @"最新发布", @"人气最高"];
        }  else if(index == 3) {
            weakMenu.dataSource = @[@"智能排序", @"离我最近", @"评价最高", @"最新发布", @"人气最高"];
        }
        else if (index == 4) {
            weakMenu.dataSource = @[@"智能排序", @"离我最近", @"评价最高", @"最新发布", @"人气最高"];
        }
    };
    
    // 选中下拉列表某行时的回调（这个回调方法请务必实现！）
    menu.clickListView = ^(NSInteger index, NSString *title){
        NSLog(@"选中了：%ld   标题：%@", index, title);
    };
    
    return menu;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"ZFMainVCCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    }
    cell.textLabel.numberOfLines = 0;
    
    return cell;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"下拉列表Demo";
    
    self.tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}


@end
