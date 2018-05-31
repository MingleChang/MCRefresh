//
//  MCRefreshBase.m
//  Refresh
//
//  Created by gongtao on 2018/5/31.
//  Copyright © 2018年 mingle. All rights reserved.
//

#import "MCRefreshBase.h"
#import "MCRefreshConfigure.h"

@implementation MCRefreshBase
- (void)dealloc {
    [self removeObservers];
}
- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}
#pragma mark - Public
- (void)beginRefreshing {
    self.state = MCRefreshStateRefreshing;
}
- (void)endRefreshing {
    self.state = MCRefreshStateNormal;
}
#pragma mark - Protected
- (void)addObservers {
    NSKeyValueObservingOptions lOptions = NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld;
    [self.scrollView addObserver:self forKeyPath:MCKeyPathFrame options:lOptions context:nil];
    [self.scrollView addObserver:self forKeyPath:MCKeyPathContentSize options:lOptions context:nil];
    [self.scrollView addObserver:self forKeyPath:MCKeyPathContentOffset options:lOptions context:nil];
}
- (void)removeObservers {
    [self.scrollView removeObserver:self forKeyPath:MCKeyPathFrame];
    [self.scrollView removeObserver:self forKeyPath:MCKeyPathContentSize];
    [self.scrollView removeObserver:self forKeyPath:MCKeyPathContentOffset];
}
- (void)executeRefreshCallBack {
    if ([self.target respondsToSelector:self.action]) {
        NSMethodSignature *lSignature = [self.target methodSignatureForSelector:self.action];
        if (lSignature) {
            id lTarget = self.target;
            SEL lSelector = self.action;
            MCRefreshBase *lRefresh = self;
            NSInvocation *lInvocation = [NSInvocation invocationWithMethodSignature:lSignature];
            lInvocation.target = lTarget;
            lInvocation.selector = lSelector;
            [lInvocation setArgument:&lTarget atIndex:0];
            [lInvocation setArgument:&lSelector atIndex:1];
            [lInvocation setArgument:&lRefresh atIndex:2];
            [lInvocation invoke];
        }
    }
}
#pragma mark - Override
- (void)initSubviews {
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
}
- (void)scrollViewFrameChange:(NSDictionary<NSKeyValueChangeKey,id> *)change {}
- (void)scrollViewContentSizeChange:(NSDictionary<NSKeyValueChangeKey,id> *)change {}
- (void)scrollViewContentOffsetChange:(NSDictionary<NSKeyValueChangeKey,id> *)change {}

#pragma mark - Private
#pragma mark - Observers
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:MCKeyPathFrame] && [object isEqual:self.scrollView]) {
        [self scrollViewFrameChange:change];
    }
    if ([keyPath isEqualToString:MCKeyPathContentSize] && [object isEqual:self.scrollView]) {
        [self scrollViewContentSizeChange:change];
    }
    if (self.hidden == YES) {
        return;
    }
    if ([keyPath isEqualToString:MCKeyPathContentOffset] && [object isEqual:self.scrollView]) {
        [self scrollViewContentOffsetChange:change];
    }
}
#pragma mark - Setter And Getter
- (void)setScrollView:(UIScrollView *)scrollView {
    if ([_scrollView isEqual:scrollView]) {
        return;
    }
    [self removeObservers];
    _scrollView = scrollView;
    [self addObservers];
}
- (CGFloat)height {
    return self.frame.size.height;
}
- (void)setHeight:(CGFloat)height {
    if (self.frame.size.height == height) {
        return;
    }
    CGRect lFrame = self.frame;
    lFrame.size.height = height;
    self.frame = lFrame;
}
@end
