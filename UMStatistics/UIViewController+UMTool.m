//
//  UIViewController+UMTool.m
//  UMStatistics
//
//  Created by aDu on 2017/3/15.
//  Copyright © 2017年 DuKaiShun. All rights reserved.
//

#import "UIViewController+UMTool.h"
#import <UMMobClick/MobClick.h>
#import "RuntimeKit.h"

@implementation UIViewController (UMTool)

+ (void)load
{
    //创建新的viewWillAppear方法
    [RuntimeKit methodSwap:[self class] firstMethod:@selector(viewWillAppear:) secondMethod:@selector(sy_viewWillAppear:)];
    //创建新的viewWillDisappear方法
    [RuntimeKit methodSwap:[self class] firstMethod:@selector(viewWillDisappear:) secondMethod:@selector(sy_viewWillDisappear:)];
}

//新的viewWillAppear方法
- (void)sy_viewWillAppear:(BOOL)animated
{
    [self sy_viewWillAppear:animated];
    //开始友盟页面统计
    [MobClick beginLogPageView:[RuntimeKit fetchClassName:[self class]]];
    
    //当然这里也可以使用self.title作为页面的名称，这样在友盟后台查看的时候更加方便些
    //[MobClick beginLogPageView:self.title];
}

//新的viewWillDisappear方法
- (void)sy_viewWillDisappear:(BOOL)animated
{
    [self sy_viewWillDisappear:animated];
    //结束友盟页面统计
    [MobClick endLogPageView:[RuntimeKit fetchClassName:[self class]]];
    
    //当然这里也可以使用self.title作为页面的名称，这样在友盟后台查看的时候更加方便些
    //[MobClick endLogPageView:self.title];
}

@end
