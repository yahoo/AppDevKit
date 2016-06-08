//
//  ADKModalMaskView.h
//  AppDevKit
//
//  Created by Chih Feng Sung on 9/14/13.
//  Copyright © 2013, Yahoo Inc.
//  Licensed under the terms of the BSD License.
//  Please see the LICENSE file in the project root for terms.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ADKModalMaskModeType) {
    ADKModalMaskNormalMode = 0,
    ADKModalMaskHintMode
};

@class ADKModalMaskView;

@protocol ADKModalMaskViewDelegate <NSObject>

@optional

/**
 * @brief Notify ADKModalMaskView will automatic dismiss.
 *
 */
- (void)maskViewWillAutoDismiss:(ADKModalMaskView *)maskView;

/**
 * @brief Notify ADKModalMaskView did automatic dismiss.
 *
 */
- (void)maskViewDidAutoDismiss:(ADKModalMaskView *)maskView;

/**
 * @brief Notify ModalMaskView will manually dismiss.
 *
 */
- (void)maskViewWillDismiss:(ADKModalMaskView *)maskView;

/**
 * @brief Notify ModalMaskView did manually dismiss.
 *
 */
- (void)maskViewDidDismiss:(ADKModalMaskView *)maskView;

@end


@interface ADKModalMaskView : UIView

/**
 * @brief Describe a specific UIColor that you want to apply on ADKModalMaskView's modal color.
 *
 */
@property (nonatomic, strong) UIColor *modalColor;

/**
 * @brief Assign a delegate owner for ADKModalMaskView. It will help you to do something before ADKModalMaskView dismiss or after dismiss.
 *
 */
@property (nonatomic, weak) id <ADKModalMaskViewDelegate> delegate;

/**
 * @brief Decide which present mode will be using in ADKModalMaskView.
 *
 */
@property (nonatomic, assign) ADKModalMaskModeType modalMode;

/**
 * @brief Generating a ADKModalMaskView to present your view.
 *
 * @param view Assiging specific view that you want to present on the screen.
 *
 * @return Instance of ADKModalMaskView.
 */
- (instancetype)initWithView:(UIView *)view;

/**
 * @brief Generating a ADKModalMaskView to present your view and set automatic dismiss mode at begin.
 *
 * @param view Assiging specific view that you want to present on the screen.
 * @param isAuto Enable or disable automatic dismiss mode. Yes means enabled and NO means disable.
 *
 * @return Instance of ADKModalMaskView.
 */
- (instancetype)initWithView:(UIView *)view autoDismiss:(BOOL)isAuto;

/**
 * @brief Generating a ADKModalMaskView to present your view with specific modal color.
 *
 * @param view Assiging specific view that you want to present on the screen.
 * @param color Describe a specific UIColor that you want to apply on ADKModalMaskView's modal color.
 *
 * @return Instance of ADKModalMaskView.
 */
- (instancetype)initWithView:(UIView *)view modalColor:(UIColor *)color;

/**
 * @brief Generating a ADKModalMaskView to present your view with specific modal color and set automatic dismiss mode at begin.
 *
 * @param view Assiging specific view that you want to present on the screen.
 * @param color Describe a specific UIColor that you want to apply on ADKModalMaskView's modal color.
 * @param isAuto Enable or disable automatic dismiss mode. Yes means enabled and NO means disable.
 *
 * @return Instance of ADKModalMaskView.
 */
- (instancetype)initWithView:(UIView *)view modalColor:(UIColor *)color autoDismiss:(BOOL)isAuto;

/**
 * @brief Generating a ADKModalMaskView to present your view with specific modal color and set automatic dismiss mode at begin.
 *
 * @param view Assiging specific view that you want to present on the screen.
 * @param showInFullScreen Decide presented view scaling mode. Yes means ADKModalMaskView will scale your view to full screen size. No means keep original size.
 * @param color Descirbe a specific UIColor that you want to apply on ADKModalMaskView's modal color.
 *
 * @return Instance of ADKModalMaskView.
 */
- (instancetype)initWithView:(UIView *)view showInFullScreen:(BOOL)showInFullScreen modalColor:(UIColor *)color;

/**
 * @brief Generating a ADKModalMaskView to present your view with specific modal color and set automatic dismiss mode at begin.
 *
 * @param view Assiging specific view that you want to present on the screen.
 * @param showInFullScreen Decide presnted view scaling mode. Yes means ADKModalMaskView will scale your view to full screen size. No means keep original size.
 * @param isAuto Enable or disable automatic dismiss mode. Yes means enabled and NO means disable.
 * @param color Decide a specific UIColor that you want to apply on ADKModalMaskView's modal color.
 * @param maskView Giving a specific view instance to replace original pure color.
 *
 * @return Instance of ADKModalMaskView.
 */
- (instancetype)initWithView:(UIView *)view showInFullScreen:(BOOL)showInFullScreen autoDismiss:(BOOL)isAuto modalColor:(UIColor *)color maskView:(UIView *)maskView;

/**
 * @brief Present your modal view by ADKModalMaskView.
 *
 * @param baseView Presented view will show above a specific base view.
 * @param completion This block will run when ADKModalMaskView did finish present.
 *
 */
- (void)showInView:(UIView *)baseView completion:(void (^)(BOOL finished))completion;

/**
 * @brief Present your modal view by ADKModalMaskView with aniamtion effect.
 *
 * @param baseView Presented view will show above a specific base view.
 * @param animation Present ADKModalMaskView with animation effect or without animation. Yes means want to use animation effect.
 * @param completion This block will run when ADKModalMaskView did finish present.
 *
 */
- (void)showInView:(UIView *)baseView withAnimation:(BOOL)animation completion:(void (^)(BOOL finished))completion;

/**
 * @brief Dismissing ADKModalMaskView manually.
 *
 * @param completion This block will run when ADKModalMaskView did finish dismiss.
 *
 */
- (void)dismiss:(void (^)(BOOL finished))completion;

/**
 * @brief Dismissing ADKModalMaskView manually and decide to use animation effect or not.
 *
 * @param completion This block will run when ADKModalMaskView did finish dismiss.
 * @param animation Dismiss ADKModalMaskView with animation effect or without animation. Yes means want to use animation effect.
 *
 */
- (void)dismiss:(void (^)(BOOL finished))completion withAnimation:(BOOL)animation;


@end
