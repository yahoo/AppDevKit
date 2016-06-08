//
//  LSPullToRefreshView.m
//  AppDevKit
//
//  Created by Jeff Lin on 3/25/16.
//  Copyright © 2016, Yahoo Inc.
//  Licensed under the terms of the BSD License.
//  Please see the LICENSE file in the project root for terms.
//

#import "LSPullToRefreshView.h"
#import "UIColor+ADKHexPresentation.h"

@interface LSPullToRefreshView ()

@property (nonatomic, strong) UIImageView *lightSaberView;
@property (nonatomic, strong) UILabel *indicatorLabel;

@end

@implementation LSPullToRefreshView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        self.lightSaberView = ({
            UIImageView *indicatorView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"Lightsaber"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 40.0f, 0.0f, 10.0f)]];
            indicatorView.frame = CGRectMake(50.0f, 6.75f, 40.0f, 27.0f);
            indicatorView;
        });
        [self addSubview:self.lightSaberView];
        
        self.indicatorLabel = ({
            UILabel *indicatorLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.frame.size.width, 20.0f)];
            indicatorLabel.center = CGPointMake(self.center.x, CGRectGetMaxY(self.lightSaberView.frame) + 10.0f);
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
    [self stopLightSaberIndicator];
}

#pragma mark - UI state
- (void)stopLightSaberIndicator
{
    self.indicatorLabel.text = @"Stop";
    self.indicatorLabel.textColor = [UIColor lightTextColor];
}

#pragma mark - ADKPullToRefreshViewProtocol
- (void)ADKPullToRefreshStopped:(UIScrollView *)scrollView
{
    [self stopLightSaberIndicator];
}

- (void)ADKPullToRefreshDragging:(UIScrollView *)scrollView
{
    self.indicatorLabel.text = NSStringFromSelector(_cmd);
    self.indicatorLabel.textColor = [UIColor lightTextColor];
}

- (void)ADKPullToRefreshView:(UIScrollView *)scrollView draggingWithProgress:(CGFloat)progress
{
    CGRect rect = CGRectMake(50.0f, 6.75f, 40.0f, 27.0f);
    rect.size.width = MAX(50, 275 * progress) ;
    self.lightSaberView.frame = rect;
    int progressPercent = progress * 100;
    self.indicatorLabel.text = [NSString stringWithFormat:@"Force awakening...%d%% ", progressPercent];
    self.indicatorLabel.textColor = [UIColor lightTextColor];
}

- (void)ADKPullToRefreshTriggered:(UIScrollView *)scrollView
{
    self.indicatorLabel.text = @"Awakened!";
    self.indicatorLabel.textColor = [UIColor ADKColorWithHexNumber:0x52D8F8];
}

- (void)ADKPullToRefreshLoading:(UIScrollView *)scrollView
{
    CGRect rect = CGRectMake(50.0f, 6.75f, 70.0f, 27.0f);
    [UIView animateWithDuration:3.2f animations:^{
        self.lightSaberView.frame = rect;
    }];
    self.indicatorLabel.text = @"Loading...";
    self.indicatorLabel.textColor = [UIColor whiteColor];
}

- (CGFloat)ADKPullToRefreshTriggerDistanceTimes:(UIScrollView *)scrollView
{
    return 2.5f;
}

@end
