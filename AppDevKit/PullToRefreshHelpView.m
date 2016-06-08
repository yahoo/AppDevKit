//
//  PullToRefreshHelpView.m
//  AppDevKit
//
//  Created by Jeff Lin on 12/6/15.
//  Copyright © 2015, Yahoo Inc.
//  Licensed under the terms of the BSD License.
//  Please see the LICENSE file in the project root for terms.
//

#import "PullToRefreshHelpView.h"

@interface PullToRefreshHelpView ()

@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;
@property (nonatomic, strong) UILabel *indicatorLabel;

@end

@implementation PullToRefreshHelpView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor lightGrayColor];
        self.indicatorView = ({
            UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
            indicatorView.center = CGPointMake(self.center.x, self.center.y - 10.0f);
            indicatorView;
        });
        [self addSubview:self.indicatorView];
        
        self.indicatorLabel = ({
            UILabel *indicatorLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.frame.size.width, 20.0f)];
            indicatorLabel.center = CGPointMake(self.center.x, CGRectGetMaxY(self.indicatorView.frame) + 10.0f);
            indicatorLabel.textAlignment = NSTextAlignmentCenter;
            indicatorLabel.textColor = [UIColor whiteColor];
            indicatorLabel;
        });
        [self addSubview:self.indicatorLabel];
    }
    
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    [self stopIndicatorView];
}

#pragma mark - UI update
- (void)stopIndicatorView
{
    self.indicatorView.hidden = YES;
    [self.indicatorView stopAnimating];
    self.indicatorLabel.text = NSStringFromSelector(_cmd);
    self.indicatorLabel.textColor = [UIColor lightTextColor];
}

#pragma mark - ADKPullToRefreshViewProtocol
- (void)ADKPullToRefreshStopped:(UIScrollView *)scrollView
{
    [self stopIndicatorView];
}

- (void)ADKPullToRefreshDragging:(UIScrollView *)scrollView
{
    self.indicatorLabel.text = NSStringFromSelector(_cmd);
    self.indicatorLabel.textColor = [UIColor lightTextColor];
}

- (void)ADKPullToRefreshView:(UIScrollView *)scrollView draggingWithProgress:(CGFloat)progress
{
    int progressPercent = progress * 100;
    self.indicatorLabel.text = [NSString stringWithFormat:@"%@ %d%% ", NSStringFromSelector(_cmd), progressPercent];
    self.indicatorLabel.textColor = [UIColor lightTextColor];
}

- (void)ADKPullToRefreshTriggered:(UIScrollView *)scrollView
{
    self.indicatorView.hidden = NO;
    self.indicatorLabel.text = NSStringFromSelector(_cmd);
    self.indicatorLabel.textColor = [UIColor orangeColor];
}

- (void)ADKPullToRefreshLoading:(UIScrollView *)scrollView
{
    [self.indicatorView startAnimating];
    self.indicatorLabel.text = NSStringFromSelector(_cmd);
    self.indicatorLabel.textColor = [UIColor whiteColor];
}

#pragma mark - ADKInfiniteScrollingViewProtocol

- (void)ADKInfiniteScrollingStopped:(UIScrollView *)scrollView
{
    [self stopIndicatorView];
}

- (void)ADKInfiniteScrollingDragging:(UIScrollView *)scrollView
{
    self.indicatorLabel.text = NSStringFromSelector(_cmd);
    self.indicatorLabel.textColor = [UIColor lightTextColor];
}

- (void)ADKInfiniteScrollView:(UIScrollView *)scrollView draggingWithProgress:(CGFloat)progress
{
    int progressPercent = progress * 100;
    self.indicatorLabel.text = [NSString stringWithFormat:@"%@ %d%% ", NSStringFromSelector(_cmd), progressPercent];
    self.indicatorLabel.textColor = [UIColor lightTextColor];
}

- (void)ADKInfiniteScrollingTriggered:(UIScrollView *)scrollView
{
    self.indicatorView.hidden = NO;
    self.indicatorLabel.text = NSStringFromSelector(_cmd);
    self.indicatorLabel.textColor = [UIColor orangeColor];
}

- (void)ADKInfiniteScrollingLoading:(UIScrollView *)scrollView
{
    [self.indicatorView startAnimating];
    self.indicatorLabel.text = NSStringFromSelector(_cmd);
    self.indicatorLabel.textColor = [UIColor whiteColor];
}

- (CGFloat)ADKInfiniteScrollingTriggerDistanceTimes:(UIScrollView *)scrollView
{
    return 2.0f;
}

@end
