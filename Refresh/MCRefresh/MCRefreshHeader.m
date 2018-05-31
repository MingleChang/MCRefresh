//
//  MCRefreshHeader.m
//  Refresh
//
//  Created by gongtao on 2018/5/31.
//  Copyright © 2018年 mingle. All rights reserved.
//

#import "MCRefreshHeader.h"
#import "MCRefreshConfigure.h"

@interface MCRefreshHeader ()

@end

@implementation MCRefreshHeader

- (instancetype)initWithTarget:(id)target action:(SEL)action scrollView:(UIScrollView *)scrollView {
    self = [super init];
    if (self) {
        self.target = target;
        self.action = action;
        self.scrollView = scrollView;
        self.scrollViewDefaultInsets = scrollView.contentInset;
        self.frame = CGRectMake(0, -MCHeaderHeight - self.scrollViewDefaultInsets.top, scrollView.frame.size.width, MCHeaderHeight);
        [scrollView addSubview:self];
        [self initSubviews];
    }
    return self;
}
+ (MCRefreshHeader *)headerWithTarget:(id)target action:(SEL)action scrollView:(UIScrollView *)scrollView {
    MCRefreshHeader *lHeader = [[MCRefreshHeader alloc] initWithTarget:target action:action scrollView:scrollView];
    return lHeader;
}
#pragma mark - Private
#pragma mark - Setter And Getter
- (void)setState:(MCRefreshState)state {
    MCRefreshCheckState
    if (state == MCRefreshStateNormal) {
        if (oldState != MCRefreshStateRefreshing) {
            return;
        }
        [UIView animateWithDuration:MCRefreshSlowAnimationTimeInterval animations:^{
            self.scrollView.contentInset = self.scrollViewDefaultInsets;
        } completion:^(BOOL finished) {
            
        }];
    }else if (state == MCRefreshStateRefreshing) {
        [UIView animateWithDuration:MCRefreshFastAnimationTimeInterval animations:^{
            UIEdgeInsets lEdgeInset = self.scrollViewDefaultInsets;
            CGPoint lOffset = self.scrollView.contentOffset;
            lEdgeInset.top = lEdgeInset.top + self.height;
            lOffset.y = -lEdgeInset.top;
            self.scrollView.contentInset = lEdgeInset;
            [self.scrollView setContentOffset:lOffset animated:YES];
        } completion:^(BOOL finished) {
            [self executeRefreshCallBack];
        }];
    }
}
- (void)setHeight:(CGFloat)height {
    if (self.frame.size.height == height) {
        return;
    }
    CGRect lFrame = self.frame;
    lFrame.origin.y = -height - self.scrollViewDefaultInsets.top;
    lFrame.size.height = height;
    self.frame = lFrame;
}
- (void)setScrollViewDefaultInsets:(UIEdgeInsets)scrollViewDefaultInsets {
    [super setScrollViewDefaultInsets:scrollViewDefaultInsets];
    if (self.scrollViewDefaultInsets.top != scrollViewDefaultInsets.top) {
        CGRect lFrame = self.frame;
        lFrame.origin.y = -lFrame.size.height - self.scrollViewDefaultInsets.top;
        self.frame = lFrame;
    }
}
#pragma mark - Override
- (void)scrollViewFrameChange:(NSDictionary<NSKeyValueChangeKey,id> *)change {
    if (self.frame.size.width != self.scrollView.frame.size.width) {
        CGRect lFrame = self.frame;
        lFrame.size.width = self.frame.size.width;
        self.frame = lFrame;
    }
}
- (void)scrollViewContentSizeChange:(NSDictionary<NSKeyValueChangeKey,id> *)change {
    
}
- (void)scrollViewContentOffsetChange:(NSDictionary<NSKeyValueChangeKey,id> *)change {
    CGFloat lStartOffsetY = -self.scrollViewDefaultInsets.top;
    CGFloat lEndOffsetY = lStartOffsetY - self.height;
    CGFloat lOffsetY = self.scrollView.contentOffset.y;
    if (self.scrollView.isDragging) {
        if (self.state == MCRefreshStateNormal && lOffsetY < lEndOffsetY) {
            self.state = MCRefreshStatePulling;
        }else if (self.state == MCRefreshStatePulling && lOffsetY >= lEndOffsetY) {
            self.state = MCRefreshStateNormal;
        }
    }else if (self.state == MCRefreshStatePulling) {
        self.state = MCRefreshStateRefreshing;
    }
}
@end
