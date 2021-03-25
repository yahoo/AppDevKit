//
//  ViewAutoLayoutCombineViewController.m
//  AppDevKit
//
//  Created by Jeff Lin on 12/3/15.
//  Copyright © 2015, Yahoo Inc.
//  Licensed under the terms of the BSD License.
//  Please see the LICENSE file in the project root for terms.
//

#import "ViewAutoLayoutCombineViewController.h"
#import "AppDevKit.h"
#import "UIColor+ThemeColor.h"

@interface ViewAutoLayoutCombineViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *topLeftImageView;
@property (weak, nonatomic) IBOutlet UIImageView *topLeftAssistBottomImageView;
@property (weak, nonatomic) IBOutlet UIImageView *topLeftAssistRightImageView;

@property (weak, nonatomic) IBOutlet UIImageView *bottomRightImageView;
@property (weak, nonatomic) IBOutlet UIImageView *bottomRightAssistTopImageView;
@property (weak, nonatomic) IBOutlet UIImageView *bottomRightAssistLeftImageView;

@property (weak, nonatomic) IBOutlet UIButton *hideTopBtn;
@property (weak, nonatomic) IBOutlet UIButton *hideLeftBtn;
@property (weak, nonatomic) IBOutlet UIButton *hideBottomBtn;
@property (weak, nonatomic) IBOutlet UIButton *hideRightBtn;

@end

@implementation ViewAutoLayoutCombineViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupView
{
    self.title = @"AutoLayout Combination example";
    self.view.backgroundColor = [UIColor themeBackgroundColor];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.hideTopBtn.layer.borderWidth = 1.0f;
    self.hideLeftBtn.layer.borderWidth = 1.0f;
    self.hideBottomBtn.layer.borderWidth = 1.0f;
    self.hideRightBtn.layer.borderWidth = 1.0f;
    
    self.hideTopBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    self.hideLeftBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    self.hideBottomBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    self.hideRightBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    
    self.hideTopBtn.layer.cornerRadius = 3.0f;
    self.hideLeftBtn.layer.cornerRadius = 3.0f;
    self.hideBottomBtn.layer.cornerRadius = 3.0f;
    self.hideRightBtn.layer.cornerRadius = 3.0f;

    self.bottomRightImageView.layer.borderWidth = 2.0f;
    self.bottomRightImageView.layer.borderColor = [UIColor orangeColor].CGColor;

    self.topLeftImageView.layer.borderWidth = 2.0f;
    self.topLeftImageView.layer.borderColor = [UIColor orangeColor].CGColor;
}

#pragma mark - UI event

- (IBAction)hideTopTapped:(UIButton *)sender
{
    sender.selected = !sender.selected;
    [self.bottomRightImageView ADKHideView:sender.isSelected withConstraints:ADKLayoutAttributeBottom | ADKLayoutAttributeHeight];
}

- (IBAction)hideLeftTapped:(UIButton *)sender
{
    sender.selected = !sender.selected;
    [self.bottomRightImageView ADKHideView:sender.isSelected withConstraints:ADKLayoutAttributeTrailing | ADKLayoutAttributeWidth];
}

- (IBAction)hideBottomTapped:(UIButton *)sender
{
    sender.selected = !sender.selected;
    [self.topLeftImageView ADKHideView:sender.isSelected withConstraints:ADKLayoutAttributeTop | ADKLayoutAttributeHeight];
}

- (IBAction)hideRightTapped:(UIButton *)sender
{
    sender.selected = !sender.selected;
    [self.topLeftImageView ADKHideView:sender.isSelected withConstraints:ADKLayoutAttributeLeading | ADKLayoutAttributeWidth];
}

@end
