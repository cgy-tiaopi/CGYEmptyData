//
//  UIScrollView+Empty.m
//  CGYEmptyDataView
//
//  Created by chengangyu on 16/12/15.
//  Copyright © 2016年 tiaopi.cgy. All rights reserved.
//

#import "UIScrollView+Empty.h"
#import <objc/runtime.h>

@interface ProtocolContainer : NSObject

@property (nonatomic, weak) id protocolContainer;

- (id)initWithProtocol:(id)object;

@end

@implementation ProtocolContainer

-(id)initWithProtocol:(id)object
{
    self = [super init];
    if (self)
    {
        _protocolContainer = object;
    }
    return self;
}

@end

@interface EmptyDataView : UIView

@property (nonatomic, strong) UIImageView   *imageView;

@property (nonatomic, strong) UILabel       *label;

@end

@implementation EmptyDataView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    return self;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        [self createUI];
    }
    return self;
}

#pragma mark Get方法
- (UIImageView *)imageView
{
    if (!_imageView)
    {
        _imageView = [[UIImageView alloc] init];
    }
    
    return _imageView;
}

- (UILabel *)label
{
    if (!_label)
    {
        _label = [[UILabel alloc] init];
    }
    
    return _label;
}

- (void)createUI
{
    
}

@end

static NSMutableDictionary *_cacheDictionary;       //缓存已被替换的方法

@interface UIScrollView ()

@property (nonatomic, strong) EmptyDataView *emptyDataView;

@end

static char *const kEmptyDataView = "kEmptyDataView";
static char *const kEmptyDataDataSource = "kEmptyDataDataSource";

@implementation UIScrollView (EmptyData)

@dynamic emptyViewDataSource;

#pragma mark - Set方法
- (void)setEmptyViewDataSource:(id<EmptyDataViewDataSource>)emptyViewDataSource
{
    ProtocolContainer *container = [[ProtocolContainer alloc] initWithProtocol:emptyViewDataSource];
    objc_setAssociatedObject(self, kEmptyDataDataSource, container, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self SelectorShouldBeSwizzle];         //在EmptyViewDataSource的set方法中实现系统方法的替换操作
}

- (void)setEmptyDataView:(EmptyDataView *)emptyDataView
{
    objc_setAssociatedObject(self, kEmptyDataView, emptyDataView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - Get方法

- (id<EmptyDataViewDataSource>)emptyViewDataSource
{
    ProtocolContainer *container = objc_getAssociatedObject(self, kEmptyDataDataSource);
    return container.protocolContainer;
}

- (EmptyDataView *)emptyDataView{
    
    EmptyDataView *view = objc_getAssociatedObject(self, kEmptyDataView);
    
    if (!view)
    {
        view = [[EmptyDataView alloc] init];
        
        [self setEmptyDataView:view];
    }
    
    return view;
}

-(UIView *)emptyView
{
    UIView *view = [[UIView alloc] init];
    
    return view;
}

/**
 判断是否需要展示缺省页EmptyDataView
 */
- (BOOL)canEmptyDataViewShow
{
    NSInteger itemCount = 0;
    
    NSAssert([self respondsToSelector:@selector(dataSource)], @"tableView或CollectionView没有实现dataSource");
    
    if ([self isKindOfClass:[UITableView class]])
    {
        UITableView *tableView = (UITableView *)self;
        id<UITableViewDataSource> dataSource = tableView.dataSource;
        NSInteger sections = 1;
        if (dataSource && [dataSource respondsToSelector:@selector(numberOfSectionsInTableView:)])
        {
            sections = [dataSource numberOfSectionsInTableView:tableView];
        }
        if(dataSource && [dataSource respondsToSelector:@selector(tableView:numberOfRowsInSection:)])
        {
            for (NSInteger i=0; i<sections; i++) {
                itemCount += [dataSource tableView:tableView numberOfRowsInSection:i];
            }
        }
    }
    
    if ([self isKindOfClass:[UICollectionView class]])
    {
        UICollectionView *collectionView = (UICollectionView *)self;
        id<UICollectionViewDataSource> dataSource = collectionView.dataSource;
        NSInteger sections = 1;
        if (!dataSource || [dataSource respondsToSelector:@selector(numberOfSectionsInCollectionView:)])
        {
            sections = [dataSource respondsToSelector:@selector(numberOfSectionsInCollectionView:)];
        }
        if (!dataSource || [dataSource respondsToSelector:@selector(collectionView:numberOfItemsInSection:)])
        {
            for (NSInteger i=0; i<sections; i++) {
                itemCount += [dataSource collectionView:collectionView numberOfItemsInSection:i];
            }
        }
    }
    
    if (itemCount == 0)
    {
        return YES;
    }
    else
    {
        return  NO;
    }
}


/**
 需要被替换的系统方法
 */
- (void)SelectorShouldBeSwizzle
{
    [self methodSwizzle:@selector(reloadData)];             //替换系统的reloadData实现方法
    
    if ([self isKindOfClass:[UITableView class]])           //由于tableView有Cell的插入，删除实现，需要替换tableView的endUpdates方法，在操作结束后判断是否为空
    {
        [self methodSwizzle:@selector(endUpdates)];
    }
}

#pragma mark - 系统方法替换

/**
 替换系统方法的实现

 @param selector 需要被替换的系统方法
 */
- (void)methodSwizzle:(SEL)selector
{
    NSAssert([self respondsToSelector:selector], @"self不能响应selector方法");
    
    if (!_cacheDictionary)              //如果缓存字典为空，开辟空间
    {
        _cacheDictionary = [[NSMutableDictionary alloc] init];
    }
    
    NSString *selfClass = NSStringFromClass([self class]);                          //获取当前类的类型
    NSString *selectorName = NSStringFromSelector(selector);                        //获取方法名
    NSString *key = [NSString stringWithFormat:@"%@_%@",selfClass,selectorName];    //类型＋方法名组成需要被替换的方法的key
    
    NSValue *value = [_cacheDictionary objectForKey:key];               //查询方法是否被替换
    
    if (value)
    {
        return;                                                         //方法被替换时，直接return
    }
    
    Method method = class_getInstanceMethod([self class], selector);
    
    IMP originalImplemention = method_setImplementation(method, (IMP)newImplemention);       //获取替换前的系统方法实现
    
    [_cacheDictionary setObject:[NSValue valueWithPointer:originalImplemention] forKey:key]; //缓存替换前的系统方法实现
}


/**
 被替换后的方法

 @param self self
 @param _cmd 方法名称
 */
void newImplemention(id self, SEL _cmd)
{
    NSString *selfClass = NSStringFromClass([self class]);
    NSString *selectorName = NSStringFromSelector(_cmd);
    NSString *key = [NSString stringWithFormat:@"%@_%@",selfClass,selectorName];        //使用当前的类名和当前方法的名称组合称为key值
    
    NSValue *value = [_cacheDictionary objectForKey:key];                               //通过key从缓存字典中取出系统原来方法实现
    
    IMP originalImplemention = [value pointerValue];
    
    if (originalImplemention)
    {
        ((void(*)(id,SEL))originalImplemention)(self,_cmd);                             //执行被替换前系统原来的方法
    }
    
    if([self canEmptyDataViewShow])                                                     //判断是否需要展示缺省页
    {
        [self reloadEmptyView];
    }
}


- (void)reloadEmptyView
{
    UIView *emptyView;
    if (self.emptyViewDataSource && [self.emptyViewDataSource respondsToSelector:@selector(emptyDataCustomView)])
    {
        emptyView = [self.emptyViewDataSource emptyDataCustomView];
    }
    else
    {
        emptyView = self.emptyDataView;
        emptyView.backgroundColor = [UIColor redColor];
    }
    
    if (!emptyView.superview)
    {
        if (self.subviews.count > 1)
        {
            [self insertSubview:emptyView atIndex:1];
        }
    }
    emptyView.frame = self.frame;
}
@end
