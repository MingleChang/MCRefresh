//
//  MCRefreshBase.h
//  Refresh
//
//  Created by gongtao on 2018/5/31.
//  Copyright © 2018年 mingle. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MCRefreshState) {
    MCRefreshStateNormal = 0,
    MCRefreshStatePulling,
    MCRefreshStateRefreshing,
};

@interface MCRefreshBase : UIView

@property (nonatomic, assign)MCRefreshState state;
@property (nonatomic, weak)id target;
@property (nonatomic, assign)SEL action;
@property (nonatomic, weak)UIScrollView *scrollView;
@property (nonatomic, assign)CGFloat height;
@property (nonatomic, assign)UIEdgeInsets scrollViewDefaultInsets;

- (void)beginRefreshing;
- (void)endRefreshing;

#pragma mark - Protected
- (void)addObservers;
- (void)removeObservers;
- (void)executeRefreshCallBack;

#pragma mark - Override
- (void)initSubviews;
- (void)scrollViewFrameChange:(NSDictionary<NSKeyValueChangeKey,id> *)change;
- (void)scrollViewContentSizeChange:(NSDictionary<NSKeyValueChangeKey,id> *)change;
- (void)scrollViewContentOffsetChange:(NSDictionary<NSKeyValueChangeKey,id> *)change;

@end
