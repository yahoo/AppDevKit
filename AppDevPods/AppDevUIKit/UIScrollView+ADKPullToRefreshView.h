//
//  UIScrollView+ADKPullToRefreshView.h
//  AppDevKit
//
//  Created by Chih Feng Sung on 12/23/13.
//  Copyright © 2013, Yahoo Inc.
//  Licensed under the terms of the BSD License.
//  Please see the LICENSE file in the project root for terms.
//

#import <UIKit/UIKit.h>

@class ADKPullToRefreshContentView;

@protocol ADKPullToRefreshViewProtocol <NSObject>

@required
- (void)ADKPullToRefreshStopped:(UIScrollView *)scrollView;
- (void)ADKPullToRefreshTriggered:(UIScrollView *)scrollView;
- (void)ADKPullToRefreshLoading:(UIScrollView *)scrollView;

@optional
/**
 *  @brief Determine when pull to refresh will trigger, should be times of handle view height, default is 1.5.
 *
 *  @return times of handle view height
 */
- (CGFloat)ADKPullToRefreshTriggerDistanceTimes:(UIScrollView *)scrollView;
- (void)ADKPullToRefreshDragging:(UIScrollView *)scrollView;
- (void)ADKPullToRefreshView:(UIScrollView *)scrollView draggingWithProgress:(CGFloat)progress;

@end


@interface UIScrollView (ADKPullToRefreshView)

/**
 *  @brief Add a pull to refresh view at scrollview content view top, when pull to refresh trigger, actionHandler will be triggered.
 *
 *  @param refreshHandleView A UIView should conform ADKPullToRefreshViewProtocol
 *  @param actionHandler Block will invoke while pull to refresh triggered
 */
- (void)ADKAddPullToRefreshWithHandleView:(UIView <ADKPullToRefreshViewProtocol> *)refreshHandleView actionHandler:(void (^)(void))actionHandler;

/**
 *  @brief Programmatically trigger pull to refresh, will invoke actionHandler.
 */
- (void)ADKTriggerPullToRefresh;

/**
 *  @brief Deal animation and infinite scrolling state. Please reference Class ADKPullToRefreshContentView.
 */
@property (nonatomic, readonly) ADKPullToRefreshContentView *pullToRefreshContentView;

/**
 *  @brief Change content size to make refreshHandleView visiable or not.
 */
@property (nonatomic, assign) BOOL showPullToRefresh;

/**
 *  @brief The distance between the bottom of pullToRefreshContentView and the top value of contentInset.  The default value is 0.  This method should be set after -addPullToRefreshWithHandleView:actionHandler: is invoked.
 */
@property (nonatomic, assign) CGFloat pullToRefreshContentViewBottomMargin;

@end


typedef NS_ENUM(NSUInteger, ADKPullToRefreshState) {
    ADKPullToRefreshStateStopped = 1,
    ADKPullToRefreshStateDragging,
    ADKPullToRefreshStateTriggered,
    ADKPullToRefreshStateLoading,
};

@interface ADKPullToRefreshContentView : UIView

/**
 *  @brief Start animation for infinite scrolling. Will triggered when ADKPullToRefreshStateLoading.
 */
- (void)startAnimating;

/**
 *  @brief Stop animation for pull to refresh. Remeber to call this method when data is ready to stop animation.
 */
- (void)stopAnimating;

/**
 *  @brief Stop animation for pull to refresh. Remeber to call this method when data is ready to stop animation.
 */
- (void)stopAnimatingAndScrollToTop;

/**
 *  @brief Top inset value of origin scroll view
 */
@property (nonatomic, assign) CGFloat originalTopInset;

/**
 *  @brief Bottom inset value of origin scroll view
 */
@property (nonatomic, assign) CGFloat originalBottomInset;

/**
 *  @brief Current state of pull to refresh
 */
@property (nonatomic, readonly) ADKPullToRefreshState state;

/**
 *  @brief Enable automatic fade in and fade out effect if value is YES.
 */
@property (nonatomic, assign) BOOL autoFadeEffect;

/**
 *  @brief Support display status change when you are using fake drag behavior. (For example: O2O new entry)
 */
@property (nonatomic, assign) BOOL detectDisplayStatusMode;

@end