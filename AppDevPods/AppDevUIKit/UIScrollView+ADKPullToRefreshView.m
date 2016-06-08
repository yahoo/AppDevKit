//
//  UIScrollView+PullToRefreshView.m
//  AppDevKit
//
//  Created by Chih Feng Sung on 12/23/13.
//  Copyright © 2013, Yahoo Inc.
//  Licensed under the terms of the BSD License.
//  Please see the LICENSE file in the project root for terms.
//

#import <objc/runtime.h>

#import "UIScrollView+ADKPullToRefreshView.h"

@interface UIScrollView ()

@property (nonatomic, readonly) CGFloat pullToRefreshViewHeight;
@property (nonatomic, weak) ADKPullToRefreshContentView *pullToRefreshContentView;
@property (nonatomic, weak) UIView <ADKPullToRefreshViewProtocol> *pullToRefreshHandleView;

@end


@interface ADKPullToRefreshContentView ()

- (void)resetScrollViewContentInset;
- (void)setScrollViewContentInsetForLoading;
- (void)setScrollViewContentInset:(UIEdgeInsets)contentInset;
- (void)updateLayout;

@property (nonatomic, copy) void (^pullToRefreshActionHandler)(void);
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, assign) ADKPullToRefreshState state;
@property (nonatomic, assign) ADKPullToRefreshState previousState;
@property (nonatomic, assign) BOOL isObserving;
@property (nonatomic, assign) CGFloat pullToRefreshContentViewBottomMargin;

@end



@implementation UIScrollView (ADKPullToRefreshView)

NSString * const pullToRefreshContentViewKey;
NSString * const pullToRefreshHandleViewKey;
NSString * const pullToRefreshContentViewBottomMarginKey;

@dynamic showPullToRefresh, pullToRefreshContentView;

- (void)ADKAddPullToRefreshWithHandleView:(UIView <ADKPullToRefreshViewProtocol> *)refreshHandleView actionHandler:(void (^)(void))actionHandler
{
    ADKPullToRefreshContentView *pullToRefreshContentView = self.pullToRefreshContentView;
    if (!pullToRefreshContentView) {
        CGRect refreshViewFrame = CGRectMake(0.0f, -CGRectGetHeight(refreshHandleView.bounds), CGRectGetWidth(self.bounds), CGRectGetHeight(refreshHandleView.bounds));
        ADKPullToRefreshContentView *pullToRefreshContentView = [[ADKPullToRefreshContentView alloc] initWithFrame:refreshViewFrame];
        pullToRefreshContentView.alpha = 0.0f;
        pullToRefreshContentView.scrollView = self;
        [self addSubview:pullToRefreshContentView];
        [pullToRefreshContentView addSubview:refreshHandleView];
        
        pullToRefreshContentView.originalTopInset = self.contentInset.top;
        pullToRefreshContentView.originalBottomInset = self.contentInset.bottom;
        pullToRefreshContentView.pullToRefreshActionHandler = actionHandler;
        self.pullToRefreshContentView = pullToRefreshContentView;
        self.pullToRefreshHandleView = refreshHandleView;
        self.showPullToRefresh = YES;
        
        [pullToRefreshContentView updateLayout];
    }
}

- (void)willRemoveSubview:(UIView *)subview
{
    ADKPullToRefreshContentView *pullToRefreshContentView = self.pullToRefreshContentView;
    if (subview == pullToRefreshContentView && pullToRefreshContentView.isObserving) {
        [self removeObserver:pullToRefreshContentView forKeyPath:@"contentOffset"];
        pullToRefreshContentView.isObserving = NO;
    }
    [super willRemoveSubview:subview];
}
 
- (void)ADKTriggerPullToRefresh
{
    ADKPullToRefreshContentView *pullToRefreshContentView = self.pullToRefreshContentView;
    if (pullToRefreshContentView.state == ADKPullToRefreshStateLoading || pullToRefreshContentView.hidden) {
        return;
    }
    
    pullToRefreshContentView.state = ADKPullToRefreshStateTriggered;
    
    [pullToRefreshContentView startAnimating];
}

#pragma mark - Setter & Getter

- (CGFloat)pullToRefreshViewHeight
{
    return CGRectGetHeight(self.pullToRefreshContentView.frame);
}

- (void)setPullToRefreshContentView:(ADKPullToRefreshContentView *)pullToRefreshContentView
{
    [self willChangeValueForKey:@"PullToRefreshContentView"];
    objc_setAssociatedObject(self, &pullToRefreshContentViewKey, pullToRefreshContentView, OBJC_ASSOCIATION_ASSIGN);
    [self didChangeValueForKey:@"PullToRefreshContentView"];
}

- (ADKPullToRefreshContentView *)pullToRefreshContentView
{
    return objc_getAssociatedObject(self, &pullToRefreshContentViewKey);
}

- (void)setPullToRefreshHandleView:(UIView <ADKPullToRefreshViewProtocol> *)pullToRefreshHandleView
{
    [self willChangeValueForKey:@"PullToRefreshHandleView"];
    objc_setAssociatedObject(self, &pullToRefreshHandleViewKey, pullToRefreshHandleView, OBJC_ASSOCIATION_ASSIGN);
    [self didChangeValueForKey:@"PullToRefreshHandleView"];
}

- (UIView <ADKPullToRefreshViewProtocol> *)pullToRefreshHandleView
{
    return objc_getAssociatedObject(self, &pullToRefreshHandleViewKey);
}

- (void)setShowPullToRefresh:(BOOL)showPullToRefresh
{
    ADKPullToRefreshContentView *pullToRefreshContentView = self.pullToRefreshContentView;
    if (pullToRefreshContentView) {
        pullToRefreshContentView.hidden = !showPullToRefresh;
        if (showPullToRefresh) {
            if (!pullToRefreshContentView.isObserving) {
                [self addObserver:pullToRefreshContentView forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
                pullToRefreshContentView.isObserving = YES;
            }
        } else {
            if (pullToRefreshContentView.isObserving) {
                [self removeObserver:pullToRefreshContentView forKeyPath:@"contentOffset"];
                pullToRefreshContentView.isObserving = NO;
            }
        }
    }
}

- (BOOL)showPullToRefresh
{
    ADKPullToRefreshContentView *pullToRefreshContentView = self.pullToRefreshContentView;
    if (pullToRefreshContentView) {
        return !pullToRefreshContentView.hidden;
    }
    return NO;
}

- (void)setPullToRefreshContentViewBottomMargin:(CGFloat)pullToRefreshContentViewBottomMargin
{
    [self willChangeValueForKey:@"PullToRefreshContentViewBottomMargin"];
    self.pullToRefreshContentView.pullToRefreshContentViewBottomMargin = pullToRefreshContentViewBottomMargin;
    [self didChangeValueForKey:@"PullToRefreshContentViewBottomMargin"];
}

- (CGFloat)pullToRefreshContentViewBottomMargin
{
    return self.pullToRefreshContentView.pullToRefreshContentViewBottomMargin;
}

@end

#pragma mark - ADKPullToRefreshContentView

@implementation ADKPullToRefreshContentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.state = ADKPullToRefreshStateStopped;
    }
    
    return self;
}

- (void)setState:(ADKPullToRefreshState)state
{
    UIView <ADKPullToRefreshViewProtocol> *pullToRefreshHandleView = self.scrollView.pullToRefreshHandleView;
    if (self.state != state) {
        _state = state;
        switch (self.state) {
            case ADKPullToRefreshStateStopped:
                [self resetScrollViewContentInset];
                if ([pullToRefreshHandleView respondsToSelector:@selector(ADKPullToRefreshStopped:)]) {
                    [pullToRefreshHandleView ADKPullToRefreshStopped:self.scrollView];
                }
                break;
            case ADKPullToRefreshStateDragging:
                if ([pullToRefreshHandleView respondsToSelector:@selector(ADKPullToRefreshDragging:)]) {
                    [pullToRefreshHandleView ADKPullToRefreshDragging:self.scrollView];
                }
                break;
            case ADKPullToRefreshStateTriggered:
                if ([pullToRefreshHandleView respondsToSelector:@selector(ADKPullToRefreshTriggered:)]) {
                    [pullToRefreshHandleView ADKPullToRefreshTriggered:self.scrollView];
                }
                break;
            case ADKPullToRefreshStateLoading:
                [self setScrollViewContentInsetForLoading];
                if ([pullToRefreshHandleView respondsToSelector:@selector(ADKPullToRefreshLoading:)]) {
                    [pullToRefreshHandleView ADKPullToRefreshLoading:self.scrollView];
                }
                if (self.previousState == ADKPullToRefreshStateTriggered && self.pullToRefreshActionHandler) {
                    self.pullToRefreshActionHandler();
                }
                break;
        }
        
        self.previousState = state;
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentOffset"]) {
        CGPoint offsetPoint = [[change valueForKey:NSKeyValueChangeNewKey] CGPointValue];
        [self scrollViewDidScroll:offsetPoint];
    }
}

- (void)scrollViewDidScroll:(CGPoint)contentOffset
{
    CGFloat visibleThreshold = fabs(contentOffset.y + self.originalTopInset) / (self.scrollView.pullToRefreshViewHeight * 1.0f);
    visibleThreshold = MAX(visibleThreshold, 0.0f);
    visibleThreshold = MIN(visibleThreshold, 1.0f);

    if (self.autoFadeEffect) {
        self.alpha = visibleThreshold;
    } else {
        self.alpha = 1.0f;
    }

    UIView <ADKPullToRefreshViewProtocol> *pullToRefreshHandleView = self.scrollView.pullToRefreshHandleView;
    if (self.state != ADKPullToRefreshStateLoading) {
        // Pull to refresh feature will trigger when user pull it down specific distance of pullToRefreshViewHeight. (Default is 1.5 times height)
        CGFloat triggerDistanceTimes = 1.5f;
        if ([pullToRefreshHandleView respondsToSelector:@selector(ADKPullToRefreshTriggerDistanceTimes:)]) {
            CGFloat distanceTimes = [pullToRefreshHandleView ADKPullToRefreshTriggerDistanceTimes:self.scrollView];
            if (distanceTimes >= 1.0f) {
                triggerDistanceTimes = distanceTimes;
            }
        }
        CGFloat scrollOffsetLimit = self.scrollView.pullToRefreshViewHeight * triggerDistanceTimes;
        CGFloat scrollOffsetThreshold = contentOffset.y + self.scrollView.contentInset.top + scrollOffsetLimit;

        if (self.scrollView.isDragging && self.state == ADKPullToRefreshStateStopped && scrollOffsetThreshold < scrollOffsetLimit) {
            self.state = ADKPullToRefreshStateDragging;
        } else if (self.scrollView.isDragging && self.state == ADKPullToRefreshStateDragging && scrollOffsetThreshold < 0.0f ) {
            self.state = ADKPullToRefreshStateTriggered;
        } else if (self.scrollView.isDragging && self.state == ADKPullToRefreshStateTriggered && scrollOffsetThreshold >= 0.0f) {
            self.state = ADKPullToRefreshStateDragging;
        } else if (self.scrollView.isDragging && self.state == ADKPullToRefreshStateDragging && scrollOffsetThreshold > scrollOffsetLimit) {
            self.state = ADKPullToRefreshStateStopped;
        } else if (!self.scrollView.isDragging && self.state == ADKPullToRefreshStateTriggered) {
            self.state = ADKPullToRefreshStateLoading;
        } else if (!self.scrollView.isDragging && self.state != ADKPullToRefreshStateStopped && self.state == ADKPullToRefreshStateDragging && scrollOffsetThreshold >= 0.0f) {
            self.state = ADKPullToRefreshStateStopped;
        } else if (self.detectDisplayStatusMode && self.state == ADKPullToRefreshStateDragging) {
            // Only update display view but not for status.
            if (scrollOffsetThreshold < 0.0f) {
                if ([pullToRefreshHandleView respondsToSelector:@selector(ADKPullToRefreshTriggered:)]) {
                    [pullToRefreshHandleView ADKPullToRefreshTriggered:self.scrollView];
                }
            } else {
                if ([pullToRefreshHandleView respondsToSelector:@selector(ADKPullToRefreshDragging:)]) {
                    [pullToRefreshHandleView ADKPullToRefreshDragging:self.scrollView];
                }
            }
        } else if (self.scrollView.isDragging && self.state == ADKPullToRefreshStateDragging) {
            if ([pullToRefreshHandleView respondsToSelector:@selector(ADKPullToRefreshView:draggingWithProgress:)]) {
                CGFloat progressValue = fabs(contentOffset.y + self.originalTopInset) / (self.scrollView.pullToRefreshViewHeight * triggerDistanceTimes);
                [pullToRefreshHandleView ADKPullToRefreshView:self.scrollView draggingWithProgress:progressValue];
            }
        }
    }
}

- (void)resetScrollViewContentInset
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIEdgeInsets contentInset = self.scrollView.contentInset;
        contentInset.top = self.originalTopInset;

        [self setScrollViewContentInset:contentInset];
    });
}

- (void)setScrollViewContentInsetForLoading
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIEdgeInsets currentInsets = self.scrollView.contentInset;
        currentInsets.top = self.originalTopInset + self.scrollView.pullToRefreshViewHeight;

        [self setScrollViewContentInset:currentInsets];
    });
}

- (void)setScrollViewContentInset:(UIEdgeInsets)contentInset
{
    self.scrollView.contentInset = contentInset;
}

- (void)setPullToRefreshContentViewBottomMargin:(CGFloat)pullToRefreshContentViewBottomMargin
{
    _pullToRefreshContentViewBottomMargin = pullToRefreshContentViewBottomMargin;
    [self updateLayout];
}

- (void)startAnimating
{
    self.state = ADKPullToRefreshStateLoading;
    
    CGFloat contentOffsetTop = self.scrollView.pullToRefreshViewHeight + self.originalTopInset;
    CGPoint scrollPoint = CGPointMake(self.scrollView.contentOffset.x, -contentOffsetTop);
    
    [UIView animateWithDuration:0.3f
                     animations:^{
                         self.scrollView.contentOffset = scrollPoint;
                     } completion:^(BOOL finished) {
                         // no-op
                     }];
}

- (void)stopAnimating
{
    self.state = ADKPullToRefreshStateStopped; 
}

- (void)stopAnimatingAndScrollToTop
{
    [self stopAnimating];

    CGFloat contentOffsetTop = self.originalTopInset;
    CGPoint scrollPoint = CGPointMake(self.scrollView.contentOffset.x, -contentOffsetTop);
    [UIView animateWithDuration:0.3f
                     animations:^{
                         self.scrollView.contentOffset = scrollPoint;
                     } completion:^(BOOL finished) {
                         // no-op
                     }];
}

- (void)updateLayout
{
    CGRect refreshViewFrame = CGRectMake(0.0f, -(CGRectGetHeight(self.bounds) + self.pullToRefreshContentViewBottomMargin), CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
    self.frame = refreshViewFrame;
}


@end
