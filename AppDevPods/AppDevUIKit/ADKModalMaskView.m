//
//  ADKModalMaskView.m
//  AppDevKit
//
//  Created by Chih Feng Sung on 9/14/13.
//  Copyright © 2015, Yahoo Inc.
//  Licensed under the terms of the BSD License.
//  Please see the LICENSE file in the project root for terms.
//

#define ANIMATION_TIMETINTERVAL 0.4f

#import "ADKModalMaskView.h"

@interface ADKModalMaskView ()

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, assign) BOOL isAutoDismiss;
@property (nonatomic, strong) UIView *baseView;

@end


@implementation ADKModalMaskView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isAutoDismiss = NO;
        self.modalMode = ADKModalMaskNormalMode;
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (instancetype)initWithView:(UIView *)view
{
    UIColor *defaultModalColor = [UIColor colorWithWhite:0.0f alpha:0.5f];
    self = [self initWithView:view modalColor:defaultModalColor];
    if (self) {
        
    }
    
    return self;
}

- (instancetype)initWithView:(UIView *)view showInFullScreen:(BOOL)showInFullScreen autoDismiss:(BOOL)isAuto
{
    return [self initWithView:view showInFullScreen:showInFullScreen autoDismiss:isAuto modalColor:[UIColor colorWithWhite:0.0f alpha:0.5f] maskView:nil];
}

- (instancetype)initWithView:(UIView *)view showInFullScreen:(BOOL)showInFullScreen autoDismiss:(BOOL)isAuto modalColor:(UIColor *)color maskView:(UIView *)maskView
{
    UIColor *defaultModalColor = color;
    self = [self initWithView:view showInFullScreen:showInFullScreen modalColor:defaultModalColor];
    if (self) {
        if (maskView) {
            [self insertSubview:maskView belowSubview:self.contentView];
        }
        self.isAutoDismiss = isAuto;
    }
    
    return self;
}

- (instancetype)initWithView:(UIView *)view autoDismiss:(BOOL)isAuto
{
    return [self initWithView:view showInFullScreen:NO autoDismiss:isAuto];
}

- (instancetype)initWithView:(UIView *)view showInFullScreen:(BOOL)showInFullScreen modalColor:(UIColor *)color
{
    self = [self init];
    if (self) {
        self.userInteractionEnabled = YES;
        self.contentView = view;
        self.translatesAutoresizingMaskIntoConstraints = YES;
        self.modalColor = color;
        self.backgroundColor = [UIColor clearColor];
        self.frame = showInFullScreen ? [UIScreen mainScreen].bounds : [UIScreen mainScreen].applicationFrame;
        [self addSubview:view];
        view.center = CGPointMake(self.frame.size.width / 2.0f, self.frame.size.height / 2.0f);
        view.userInteractionEnabled = YES;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(statusBarFrameChanged)
                                                     name:UIApplicationDidChangeStatusBarFrameNotification
                                                   object:nil];
    }
    
    return self;
}

- (instancetype)initWithView:(UIView *)view modalColor:(UIColor *)color
{
    return [self initWithView:view modalColor:color autoDismiss:YES];
}

- (instancetype)initWithView:(UIView *)view modalColor:(UIColor *)color autoDismiss:(BOOL)isAuto
{
    self = [self initWithView:view showInFullScreen:NO modalColor:color];
    if (self) {
        self.isAutoDismiss = isAuto;
    }
    
    return self;
}

- (void)statusBarFrameChanged
{
    self.frame = [UIScreen mainScreen].applicationFrame;
}

- (void)showInView:(UIView *)baseView completion:(void (^)(BOOL finished))completion
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.baseView = baseView;
    [window addSubview:self];
    
    self.backgroundColor = [UIColor clearColor];
    self.translatesAutoresizingMaskIntoConstraints = YES;
    [UIView animateWithDuration:ANIMATION_TIMETINTERVAL
                     animations:^{
                         self.backgroundColor = self.modalColor;
                         // self.baseView.transform = CGAffineTransformMakeScale(0.93f, 0.93f);
                     }
                     completion:^(BOOL finished) {
                         if (completion) {
                             completion(finished);
                         }
                     }];
}

- (void)showInView:(UIView *)baseView withAnimation:(BOOL)animation completion:(void (^)(BOOL finished))completion
{
    if (animation) {
        [self showInView:baseView completion:completion];
    } else {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        self.baseView = baseView;
        [window addSubview:self];
        
        self.backgroundColor = self.modalColor;
        // self.baseView.transform = CGAffineTransformMakeScale(0.93f, 0.93f);
        if (completion) {
            completion(YES);
        }
    }
}

- (void)dismiss:(void (^)(BOOL finished))completion
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(maskViewWillDismiss:)] ) {
        [self.delegate maskViewWillDismiss:self];
    }
    
    [UIView animateWithDuration:ANIMATION_TIMETINTERVAL
                     animations:^{
                         self.backgroundColor = [UIColor clearColor];
                         self.baseView.transform = CGAffineTransformIdentity;
                     } completion:^(BOOL finished) {
                         [self removeFromSuperview];
                         if (completion) {
                             completion(finished);
                             if (self.delegate && [self.delegate respondsToSelector:@selector(maskViewDidDismiss:)] ) {
                                 [self.delegate maskViewDidDismiss:self];
                             }
                         }
                     }];
}

- (void)dismiss:(void (^)(BOOL finished))completion withAnimation:(BOOL)animation
{
    if (animation) {
        [self dismiss:completion];
    } else {
        self.backgroundColor = [UIColor clearColor];
        [self removeFromSuperview];
        if (completion) {
            completion(YES);
        }
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!self.isAutoDismiss) return;
    
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    
    if (!CGRectContainsPoint(self.contentView.frame, touchPoint) || self.modalMode == ADKModalMaskHintMode) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(maskViewWillAutoDismiss:)] ) {
            [self.delegate maskViewWillAutoDismiss:self];
        }
        [self dismiss:^(BOOL finished) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(maskViewDidAutoDismiss:)] ) {
                [self.delegate maskViewDidAutoDismiss:self];
            }
        }];

    }
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationDidChangeStatusBarFrameNotification
                                                  object:nil];
    
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
}


@end
