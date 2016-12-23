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
        
    }
    
    [self.view addSubview:_tableView];
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

//#pragma mark - EmptyDataViewDataSource
//- (UIView *)emptyDataCustomView
//{
//    UIView *view = [[UIView alloc] init];
//    view.backgroundColor = [UIColor redColor];
//    view.translatesAutoresizingMaskIntoConstraints = NO;
//    
//    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"customEmpty"]];
//    image.translatesAutoresizingMaskIntoConstraints = NO;
//    [view addSubview:image];
//    
//    NSLayoutConstraint *imgConstraintCenterX = [NSLayoutConstraint constraintWithItem:image attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
//    NSLayoutConstraint *imgConstraintCenterY = [NSLayoutConstraint constraintWithItem:image attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeCenterY multiplier:1 constant:-100];
//    NSLayoutConstraint *imgConstraintHeight = [NSLayoutConstraint constraintWithItem:image attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeHeight multiplier:0 constant:100];
//    NSLayoutConstraint *imgConstraintWidth = [NSLayoutConstraint constraintWithItem:image attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeWidth multiplier:0 constant:100];
//    [view  addConstraints:@[imgConstraintCenterX,imgConstraintCenterY,imgConstraintHeight,imgConstraintWidth]];
//    
//    return view;
//}

@end
