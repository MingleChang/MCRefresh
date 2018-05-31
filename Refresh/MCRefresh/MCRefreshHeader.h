//
//  MCRefreshHeader.h
//  Refresh
//
//  Created by gongtao on 2018/5/31.
//  Copyright © 2018年 mingle. All rights reserved.
//

#import "MCRefreshBase.h"

@interface MCRefreshHeader : MCRefreshBase

- (instancetype)initWithTarget:(id)target action:(SEL)action scrollView:(UIScrollView *)scrollView;
+ (MCRefreshHeader *)headerWithTarget:(id)target action:(SEL)action scrollView:(UIScrollView *)scrollView;

@end
