//
//  MCRefreshFooter.m
//  Refresh
//
//  Created by gongtao on 2018/5/31.
//  Copyright © 2018年 mingle. All rights reserved.
//

#import "MCRefreshFooter.h"
#import "MCRefreshConfigure.h"

@interface MCRefreshFooter ()

@end

@implementation MCRefreshFooter

- (instancetype)initWithTarget:(id)target action:(SEL)action scrollView:(UIScrollView *)scrollView {
    self = [super init];
    if (self) {
        self.target = target;
        self.action = action;
        self.scrollView = scrollView;
        self.scrollViewDefaultInsets = scrollView.contentInset;
        CGFloat lY = MAX(self.scrollView.contentSize.height + self.scrollViewDefaultInsets.bottom, self.scrollView.frame.size.height - self.scrollViewDefaultInsets.top);
        self.frame = CGRectMake(0, lY, scrollView.frame.size.width, MCFooterHeight);
        [scrollView addSubview:self];
        [self initSubviews];
    }
    return self;
}
+ (MCRefreshFooter *)footerWithTarget:(id)target action:(SEL)action scrollView:(UIScrollView *)scrollView {
    MCRefreshFooter *lFooter = [[MCRefreshFooter alloc] initWithTarget:target action:action scrollView:scrollView];
    return lFooter;
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
            lEdgeInset.bottom = lEdgeInset.bottom + self.height;
            lOffset.y = self.frame.origin.y + self.frame.size.height - self.scrollView.frame.size.height;
            self.scrollView.contentInset = lEdgeInset;
            [self.scrollView setContentOffset:lOffset animated:YES];
        } completion:^(BOOL finished) {
            [self executeRefreshCallBack];
        }];
    }
}
- (void)setScrollViewDefaultInsets:(UIEdgeInsets)scrollViewDefaultInsets {
    [super setScrollViewDefaultInsets:scrollViewDefaultInsets];
    CGFloat lY = MAX(self.scrollView.contentSize.height + self.scrollViewDefaultInsets.bottom, self.scrollView.frame.size.height - self.scrollViewDefaultInsets.top);
    CGRect lFrame = self.frame;
    lFrame.origin.y = lY;
    self.frame = lFrame;
}
#pragma mark - Override
- (void)scrollViewFrameChange:(NSDictionary<NSKeyValueChangeKey,id> *)change {
    CGFloat lY = MAX(self.scrollView.contentSize.height + self.scrollViewDefaultInsets.bottom, self.scrollView.frame.size.height - self.scrollViewDefaultInsets.top);
    CGRect lFrame = self.frame;
    lFrame.origin.y = lY;
    self.frame = lFrame;
}
- (void)scrollViewContentSizeChange:(NSDictionary<NSKeyValueChangeKey,id> *)change {
    CGFloat lY = MAX(self.scrollView.contentSize.height + self.scrollViewDefaultInsets.bottom, self.scrollView.frame.size.height - self.scrollViewDefaultInsets.top);
    CGRect lFrame = self.frame;
    lFrame.origin.y = lY;
    self.frame = lFrame;
}
- (void)scrollViewContentOffsetChange:(NSDictionary<NSKeyValueChangeKey,id> *)change {
    CGFloat lStartOffsetY = self.frame.origin.y - self.scrollView.frame.size.height;
    CGFloat lEndOffsetY = lStartOffsetY + self.height;
    CGFloat lOffsetY = self.scrollView.contentOffset.y;
    if (self.scrollView.isDragging) {
        if (self.state == MCRefreshStateNormal && lOffsetY > lEndOffsetY) {
            self.state = MCRefreshStatePulling;
        }else if (self.state == MCRefreshStatePulling && lOffsetY <= lEndOffsetY) {
            self.state = MCRefreshStateNormal;
        }
    }else if (self.state == MCRefreshStatePulling) {
        self.state = MCRefreshStateRefreshing;
    }
}

@end
