//
//  ModalViewController.m
//  AppDevKit
//
//  Created by Chih Feng Sung on 6/10/15.
//  Copyright © 2015, Yahoo Inc.
//  Licensed under the terms of the BSD License.
//  Please see the LICENSE file in the project root for terms.
//

#import "ModalViewController.h"
#import "UIColor+ThemeColor.h"
#import "ADKModalMaskView.h"

@interface ModalViewController ()

- (IBAction)closeButtonTapHandler:(id)sender;

@end

@implementation ModalViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupView
{
    self.view.backgroundColor = [UIColor themeCardBackgroundColor];
    self.descriptionTextView.contentInset = UIEdgeInsetsMake(-10.0f, 0.0f, 0.0f, 0.0f);
}

- (IBAction)closeButtonTapHandler:(id)sender
{
    UIView *modalMaskView = [self.view superview];
    if ([modalMaskView isKindOfClass:[ADKModalMaskView class]]) {
        [((ADKModalMaskView *)modalMaskView) dismiss:^(BOOL finished) {
            // no-op
        } withAnimation:YES];

    }
}

@end
