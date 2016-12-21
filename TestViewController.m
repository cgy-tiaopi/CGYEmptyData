//
//  TestViewController.m
//  CGYEmptyDataView
//
//  Created by chengangyu on 16/12/21.
//  Copyright © 2016年 tiaopi.cgy. All rights reserved.
//

#import "TestViewController.h"
//#import "ViewController.h"
#import "UIScrollView+Empty.h"

@interface TestViewController ()<UITableViewDelegate, UITableViewDataSource,EmptyDataViewDataSource>
{
    UITableView     *_tableView;
    
    NSMutableArray  *array;
}

@end

#define ScreenWidth             [UIScreen mainScreen].bounds.size.width
#define ScreenHeight            [UIScreen mainScreen].bounds.size.height

@implementation TestViewController

- (void)dealloc
{
    NSLog(@"%s",__func__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (array == nil)
    {
        array = [[NSMutableArray alloc] init];
        [array addObject:@"1"];
    }
    
    [self createUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createUI
{
    if (_tableView == nil)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.emptyViewDataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor yellowColor];
    }
    
    [self.view addSubview:_tableView];
    
//    [_tableView reloadData];
}



#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [array count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [[UITableViewCell alloc] init];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [array removeObjectAtIndex:indexPath.row];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    [tableView endUpdates];
    
}

#pragma mark - EmptyDataViewDataSource
- (UIView *)emptyDataCustomView
{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor blueColor];
    
    return view;
}

@end
