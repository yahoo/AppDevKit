//
//  UIScrollView+ADKInfiniteScrollingView.h
//  AppDevKit
//
//  Created by Chih Feng Sung on 12/24/13.
//  Copyright © 2013, Yahoo Inc.
//  Licensed under the terms of the BSD License.
//  Please see the LICENSE file in the project root for terms.
//

#import <UIKit/UIKit.h>

@class ADKInfiniteScrollingContentView;

@protocol ADKInfiniteScrollingViewProtocol <NSObject>

@required
- (void)ADKInfiniteScrollingStopped:(UIScrollView *)scrollView;
- (void)ADKInfiniteScrollingTriggered:(UIScrollView *)scrollView;
- (void)ADKInfiniteScrollingLoading:(UIScrollView *)scrollView;

@optional
/**
 *  @brief Determine when infinite scrolling will trigger, should be times of handle view height, default is 1.0 (same as view height).
 *
 *  @return times of handle view height
 */
- (CGFloat)ADKInfiniteScrollingTriggerDistanceTimes:(UIScrollView *)scrollView;
- (void)ADKInfiniteScrollingDragging:(UIScrollView *)scrollView;
- (void)ADKInfiniteScrollView:(UIScrollView *)scrollView draggingWithProgress:(CGFloat)progress;

@end

@interface UIScrollView (ADKInfiniteScrollingView)

/**
 *  @brief Add a infinite scrolling view at scrollview content view end, when infinite scrolling trigger, actionHandler will be triggered
 *
 *  @param infiniteScrollingHandleView A UIView should conform ADKInfiniteScrollingViewProtocol
 *  @param actionHandler               Block will invoke while infinite scrolling triggered
 */
- (void)ADKAddInfiniteScrollingWithHandleView:(UIView <ADKInfiniteScrollingViewProtocol> *)infiniteScrollingHandleView actionHandler:(void (^)(void))actionHandler;

/**
 *  @brief Programmatically trigger infinite scrolling loading, will invoke actionHandler
 *
 *  @param animated Do scrolling animate or not
 */
- (void)ADKTriggerInfiniteScrollingWithAnimation:(BOOL)animated;

/**
 *  @brief Deal animation and infinite scrolling state. Please reference Class ADKInfiniteScrollingContentView
 */
@property (nonatomic, readonly) ADKInfiniteScrollingContentView *infiniteScrollingContentView;

/**
 *  @brief Enable/disable and make infiniteScrollingContentView visiable/hidden
 */
@property (nonatomic, assign) BOOL showInfiniteScrolling;

@end


typedef NS_ENUM(NSUInteger, ADKInfiniteScrollingState) {
    ADKInfiniteScrollingStateStopped = 1,
    ADKInfiniteScrollingStateDragging,
    ADKInfiniteScrollingStateTriggered,
    ADKInfiniteScrollingStateLoading,
};


@interface ADKInfiniteScrollingContentView : UIView

/**
 *  @brief Start animation for infinite scrolling. Will triggered when ADKInfiniteScrollingStateTriggered.
 */
- (void)startAnimating;

/**
 *  @brief Stop animation for infinite scrolling. Remeber to call this method when data is ready to stop animation.
 */
- (void)stopAnimating;

/**
 *  @brief Current state of infinite Scrolling
 */
@property (nonatomic, readonly) ADKInfiniteScrollingState state;


/**
 *  @brief Enable automatic fade in and fade out effect if value is YES.
 */
@property (nonatomic, assign) BOOL autoFadeEffect;

@end
