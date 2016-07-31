//
//  ViewController.m
//  AppDevKit
//
//  Created by Chih Feng Sung on 5/13/15.
//  Copyright © 2015, Yahoo Inc.
//  Licensed under the terms of the BSD License.
//  Please see the LICENSE file in the project root for terms.
//

#import "ViewController.h"
#import "AppDevKit.h"
#import "UIColor+ThemeColor.h"

#import "DemoCollectionReusableView.h"
#import "DemoCollectionViewCell.h"

#import "ModalMaskViewViewController.h"
#import "ImageFilterViewController.h"
#import "ViewAutoLayoutSupportViewController.h"
#import "ViewAutoLayoutCombineViewController.h"
#import "ColorHexPresentationViewController.h"
#import "DynamicHeightCellViewController.h"
#import "DynamicWidthCellViewController.h"
#import "OperationViewController.h"
#import "PullToRefreshExampleViewController.h"
#import "YMDCDemoViewController.h"

static NSString * const HeaderCollectionReusableViewIdentifier = @"DemoCollectionReusableView";
static NSString * const CellCollectionViewCellIdentifier = @"DemoCollectionViewCell";

typedef NS_ENUM(NSInteger, ADKitDemoSection) {
    ADKitDemoSectionUI = 0,
    ADKitDemoSectionImage,
    ADKitDemoSectionListView,
    ADKitDemoSectionYMDCDemo,
    ADKitDemoSectionCount
};

@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *demoCollectionView;

@end

@implementation ViewController


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
    self.title = @"AppDevKit - Demo App";

    UINib *headerNib = [UINib nibWithNibName:HeaderCollectionReusableViewIdentifier bundle:nil];
    [self.demoCollectionView registerNib:headerNib
              forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                     withReuseIdentifier:HeaderCollectionReusableViewIdentifier];
    UINib *cellNib = [UINib nibWithNibName:CellCollectionViewCellIdentifier bundle:nil];
    [self.demoCollectionView registerNib:cellNib
              forCellWithReuseIdentifier:CellCollectionViewCellIdentifier];

    self.demoCollectionView.delegate = self;
    self.demoCollectionView.dataSource = self;

    self.demoCollectionView.backgroundColor = [UIColor themeBackgroundColor];
}


#pragma mark - UICollectionView delegate methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return ADKitDemoSectionCount;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    switch (section) {
        case ADKitDemoSectionUI:
            return 5;
            break;
        case ADKitDemoSectionImage:
            return 1;
            break;
        case ADKitDemoSectionListView:
            return 3;
            break;
        case ADKitDemoSectionYMDCDemo:
            return 1;
            break;
        default:
            return 0;
            break;
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableView = nil;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                          withReuseIdentifier:HeaderCollectionReusableViewIdentifier
                                                                 forIndexPath:indexPath];
        if (reusableView) {
            DemoCollectionReusableView *demoHeaderView = (DemoCollectionReusableView *)reusableView;
            switch (indexPath.section) {
                case ADKitDemoSectionUI:
                    demoHeaderView.titleLabel.text = @"UI Tools";
                    break;
                case ADKitDemoSectionImage:
                    demoHeaderView.titleLabel.text = @"Image Tools";
                    break;
                case ADKitDemoSectionListView:
                    demoHeaderView.titleLabel.text = @"ListView Tools";
                    break;
                case ADKitDemoSectionYMDCDemo:
                    demoHeaderView.titleLabel.text = @"YMDC Demo";
                    break;
                default:
                    demoHeaderView.titleLabel.text = nil;
                    break;
            }
        }
    }

    return reusableView;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = nil;
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellCollectionViewCellIdentifier
                                                     forIndexPath:indexPath];
    if (cell) {
        DemoCollectionViewCell *collectionCell = (DemoCollectionViewCell *)cell;
        switch (indexPath.section) {
            case ADKitDemoSectionUI:
                if (indexPath.row == 0) {
                    collectionCell.titleLabel.text = @"UIColor+ADKHexPresentation";
                } else if (indexPath.row == 1) {
                    collectionCell.titleLabel.text = @"UIView+ADKAutoLayoutSupport";
                } else if (indexPath.row == 2) {
                    collectionCell.titleLabel.text = @"UIView+ADKAutoLayoutCombineOperation";
                } else if (indexPath.row == 3) {
                    collectionCell.titleLabel.text = @"ADKModalMaskView & UIImage+ADKImageFilter";
                } else if (indexPath.row == 4) {
                    collectionCell.titleLabel.text = @"ADKPullToRefreshView & ADKInfiniteScrollView";
                }
                break;
            case ADKitDemoSectionImage:
                if (indexPath.row == 0) {
                    collectionCell.titleLabel.text = @"UIImage+ADKImageFilter";
                }
                break;
            case ADKitDemoSectionListView:
                if (indexPath.row == 0) {
                    collectionCell.titleLabel.text = @"ADKCellDynamicSizeCalculator (Vertical)";
                } else if (indexPath.row == 1) {
                    collectionCell.titleLabel.text = @"ADKCellDynamicSizeCalculator (Horizontal)";
                } else if (indexPath.row == 2) {
                    collectionCell.titleLabel.text = @"UICollectionView+ADKOperation (Force stop)";
                }
                break;
            case ADKitDemoSectionYMDCDemo:
                if (indexPath.row == 0) {
                    collectionCell.titleLabel.text = @"YMDC demo";
                }
                break;
            default:
                break;
        }

    }

    return cell;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0f;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return [[ADKNibSizeCalculator sharedInstance] sizeForNibNamed:HeaderCollectionReusableViewIdentifier
                                                     withStyle:ADKNibFixedHeightScaling];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [[ADKNibSizeCalculator sharedInstance] sizeForNibNamed:CellCollectionViewCellIdentifier
                                                     withStyle:ADKNibFixedHeightScaling];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case ADKitDemoSectionUI:
            if (indexPath.row == 0) {
                ColorHexPresentationViewController *colorHexPresentationViewController = [[ColorHexPresentationViewController alloc] init];
                [self.navigationController pushViewController:colorHexPresentationViewController animated:YES];
            } else if (indexPath.row == 1) {
                ViewAutoLayoutSupportViewController *viewAutoLayoutSupportViewController = [[ViewAutoLayoutSupportViewController alloc] init];
                [self.navigationController pushViewController:viewAutoLayoutSupportViewController animated:YES];
            } else if (indexPath.row == 2) {
                ViewAutoLayoutCombineViewController *viewAutoLayoutSupportViewController = [[ViewAutoLayoutCombineViewController alloc] init];
                [self.navigationController pushViewController:viewAutoLayoutSupportViewController animated:YES];
            } else if (indexPath.row == 3) {
                ModalMaskViewViewController *modalMaskViewViewController = [[ModalMaskViewViewController alloc] init];
                [self.navigationController pushViewController:modalMaskViewViewController animated:YES];
            } else if (indexPath.row == 4){
                PullToRefreshExampleViewController *pullToRefreshViewController = [[PullToRefreshExampleViewController alloc] init];
                [self.navigationController pushViewController:pullToRefreshViewController animated:YES];
            }
            break;
        case ADKitDemoSectionImage:
            if (indexPath.row == 0) {
                ImageFilterViewController *imageImageFilterViewController = [[ImageFilterViewController alloc] init];
                [self.navigationController pushViewController:imageImageFilterViewController animated:YES];
            }
            break;
        case ADKitDemoSectionListView:
            if (indexPath.row == 0) {
                DynamicHeightCellViewController *dynamicHeightCellViewController = [[DynamicHeightCellViewController alloc] init];
                [self.navigationController pushViewController:dynamicHeightCellViewController animated:YES];
            } else if (indexPath.row == 1) {
                DynamicWidthCellViewController *dynamicWidthCellViewController = [[DynamicWidthCellViewController alloc] init];
                [self.navigationController pushViewController:dynamicWidthCellViewController animated:YES];
            } else if (indexPath.row == 2) {
                OperationViewController *operationViewController = [[OperationViewController alloc] init];
                [self.navigationController pushViewController:operationViewController animated:YES];
            }
            break;
        case ADKitDemoSectionYMDCDemo:
            if (indexPath.row == 0) {
                YMDCDemoViewController *demoViewController = [[YMDCDemoViewController alloc] init];
                [self.navigationController pushViewController:demoViewController animated:YES];
            }
            
            break;
        default:
            break;
    }
}


#pragma mark - UIContentContainer delegate methods

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [self.demoCollectionView.collectionViewLayout invalidateLayout];
}

@end
