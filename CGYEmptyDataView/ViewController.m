//
//  ViewController.m
//  CGYEmptyDataView
//
//  Created by chengangyu on 16/12/15.
//  Copyright © 2016年 tiaopi.cgy. All rights reserved.
//

#import "ViewController.h"
#import "UIScrollView+Empty.h"
#import "TestViewController.h"

@interface ViewController ()
{
    UIButton        *btn;
}

@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (nil == btn)
    {
        btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        [btn setTitle:@"跳转" forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor redColor];
        [btn addTarget:self action:@selector(onClickBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [self.view addSubview:btn];
}

- (void)dealloc
{
    NSLog(@"%s",__func__);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onClickBtn
{
    TestViewController *tviewCtrl = [[TestViewController alloc] init];
    [self.navigationController pushViewController:tviewCtrl animated:YES];
}

@end
