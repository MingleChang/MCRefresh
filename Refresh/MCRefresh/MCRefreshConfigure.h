//
//  MCRefreshConfigure.h
//  Refresh
//
//  Created by gongtao on 2018/5/31.
//  Copyright © 2018年 mingle. All rights reserved.
//

#import <UIKit/UIKit.h>

FOUNDATION_EXTERN NSTimeInterval const MCRefreshSlowAnimationTimeInterval;
FOUNDATION_EXTERN NSTimeInterval const MCRefreshFastAnimationTimeInterval;

FOUNDATION_EXTERN CGFloat const MCHeaderHeight;
FOUNDATION_EXTERN CGFloat const MCFooterHeight;

typedef NSString *const MCKeyPath;

FOUNDATION_EXTERN MCKeyPath MCKeyPathFrame;
FOUNDATION_EXTERN MCKeyPath MCKeyPathContentOffset;
FOUNDATION_EXTERN MCKeyPath MCKeyPathContentSize;
FOUNDATION_EXTERN MCKeyPath MCKeyPathContentInset;

#define MCRefreshCheckState \
MCRefreshState oldState = self.state; \
if (state == oldState) return; \
[super setState:state];
