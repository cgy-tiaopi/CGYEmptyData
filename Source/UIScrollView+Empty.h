//
//  UIScrollView+Empty.h
//  CGYEmptyDataView
//
//  Created by chengangyu on 16/12/15.
//  Copyright © 2016年 tiaopi.cgy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EmptyDataViewDataSource;

@interface UIScrollView (EmptyData)

@property (nonatomic, weak) id <EmptyDataViewDataSource> emptyViewDataSource;

@end

@protocol EmptyDataViewDataSource <NSObject>

@optional

- (UIView *)emptyDataCustomView;

@end
