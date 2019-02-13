//
//  GradientViewController.m
//  AppDevKit
//
//  Created by  Chih Feng Sung on 1/29/19.
//  Copyright © 2019 Yahoo. All rights reserved.
//

#import "GradientViewController.h"
#import "AppDevKit.h"

@interface GradientViewController ()

@property (weak, nonatomic) IBOutlet ADKGradientView *gradientView;
@property (weak, nonatomic) IBOutlet ADKMultiGradientView *multiGradientView;

- (IBAction)blendsTypeFromLeftToRightButtonTapHandler:(id)sender;
- (IBAction)blendsTypeFromLeftTopToRightBottomButtonTapHandler:(id)sender;

@end

@implementation GradientViewController

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
    self.title = @"Gradient View";

    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;

    UIColor *firstColor = [self randomColor];
    UIColor *secondColor = [self randomColor];
    UIColor *thirdColor = [self randomColor];
    UIColor *fourthColor = [self randomColor];

    self.gradientView.beginColor = firstColor;
    self.gradientView.endColor = secondColor;
    self.gradientView.blendsType = ADKBlendsTypeFromLeftTopToRightBottom;

    self.multiGradientView.gradientColors = @[firstColor, secondColor, thirdColor, fourthColor];
    self.multiGradientView.gradientLocations = @[@0.0f, @0.3f, @0.6f, @1.0f];
    self.multiGradientView.blendsType = ADKBlendsTypeFromLeftTopToRightBottom;
}

- (UIColor *)randomColor
{
    CGFloat hue = ( arc4random() % 256 / 256.0f );
    CGFloat saturation = ( arc4random() % 256 / 256.0f);
    CGFloat brightness = ( arc4random() % 256 / 256.0f);

    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1.0f];
}


- (IBAction)blendsTypeFromLeftToRightButtonTapHandler:(id)sender
{
    self.gradientView.blendsType = ADKBlendsTypeFromLeftToRight;
    [self.gradientView redrawView];

    self.multiGradientView.blendsType = ADKBlendsTypeFromLeftToRight;
    [self.multiGradientView redrawView];
}

- (IBAction)blendsTypeFromLeftTopToRightBottomButtonTapHandler:(id)sender
{
    self.gradientView.blendsType = ADKBlendsTypeFromLeftTopToRightBottom;
    [self.gradientView redrawView];

    self.multiGradientView.blendsType = ADKBlendsTypeFromLeftTopToRightBottom;
    [self.multiGradientView redrawView];
}
@end
