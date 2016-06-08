//
//  YMDCDemoViewController.m
//  AppDevKit
//
//  Created by Jeff Lin on 3/19/16.
//  Copyright © 2016, Yahoo Inc.
//  Licensed under the terms of the BSD License.
//  Please see the LICENSE file in the project root for terms.
//

#import "YMDCDemoViewController.h"
#import "AppDevKit.h"

#import "LSPullToRefreshView.h"
#import "InfiniteScrollingHelpView.h"

#import "YMDCDataProvider.h"
#import "YMDCDemoImageCell.h"
#import "MovieDescCell.h"
#import "DynamicHeightCell.h"
#import "ModalViewController.h"

#define DEMO_IMAGE_COUNT    5
#define ITEM_INTERSPACING    3.0f

typedef NS_ENUM(NSUInteger, YMDCDemoSection) {
    YMDCDemoSectionMainImage,
    YMDCDemoSectionDescription,
    YMDCDemoSectionImages,
    YMDCDemoSectionComments,
    YMDCDemoSectionCount    // for count enum number only
};

@interface YMDCDemoViewController () <UICollectionViewDelegate, UICollectionViewDataSource, ADKModalMaskViewDelegate>
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *descriptionArray;
@property (nonatomic, strong) NSArray *faceColorArray;
@property (nonatomic, strong) NSArray *eyesColorArray;

@property (nonatomic, strong) ADKModalMaskView *modalView;
@property (nonatomic, strong) ModalViewController *modalController;
@property (nonatomic, weak) IBOutlet UIImageView *blurImageView;

@end

@implementation YMDCDemoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupView];
}

- (void)didMoveToParentViewController:(UIViewController *)parent
{
    [super didMoveToParentViewController:parent];
    if (!parent) {
        return;
    }
    
    [self setupPullToRefreshView];
    [self setupInfiniteScrollingView];
}

- (void)dealloc
{
    self.collectionView.showInfiniteScrolling = NO;
    self.collectionView.showPullToRefresh = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareData
{
    self.titleArray = [YMDCDataProvider titles];
    self.descriptionArray = [YMDCDataProvider itemDescription];
    self.faceColorArray = @[[UIColor ADKColorWithHexNumber:0xFBC900],
                            [UIColor ADKColorWithHexNumber:0x73fe68],
                            [UIColor ADKColorWithHexNumber:0xf19da8],
                            [UIColor ADKColorWithHexNumber:0xfd8800],
                            [UIColor ADKColorWithHexNumber:0xdc76e5]];
    
    self.eyesColorArray = @[[UIColor ADKColorWithHexNumber:0x000000],
                            [UIColor ADKColorWithHexNumber:0x51115d],
                            [UIColor ADKColorWithHexNumber:0xc21a1e],
                            [UIColor brownColor],
                            [UIColor ADKColorWithHexNumber:0xb22599]];
}

- (void)setupView
{
    self.title = @"AppDevKit Demo - Movie";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self prepareData];
    
    [self setupCollectionView];
    
}

- (void)setupCollectionView
{
    [@[YMDCDemoImageCellIdentifier, MovieDescCellIdentifier, DynamicHeightCellIdentifer] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UINib *cellNib = [UINib nibWithNibName:obj bundle:nil];
        [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:obj];
    }];
    
    self.collectionView.backgroundColor = [UIColor blackColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.allowsMultipleSelection = NO;
}

- (void)setupPullToRefreshView
{
    self.collectionView.alwaysBounceVertical = YES;
    LSPullToRefreshView *refreshView = [[LSPullToRefreshView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, 60.0f)];
    
    __weak YMDCDemoViewController *weakSelf = self;
    [self.collectionView ADKAddPullToRefreshWithHandleView:refreshView actionHandler:^{
        // Delay 3s, for show animation
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            weakSelf.titleArray = [YMDCDataProvider titles];
            weakSelf.descriptionArray = [YMDCDataProvider itemDescription];
            [weakSelf.collectionView reloadData];
            [weakSelf.collectionView.pullToRefreshContentView stopAnimating];
        });
    }];
}

- (void)setupInfiniteScrollingView
{
    InfiniteScrollingHelpView *infiniteScrollView = [[InfiniteScrollingHelpView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, 60.0f)];
    
    __weak YMDCDemoViewController *weakSelf = self;
    [self.collectionView ADKAddInfiniteScrollingWithHandleView:infiniteScrollView actionHandler:^{
        // Delay 1s, for show animation
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSMutableArray *newTitleArray = [weakSelf.titleArray mutableCopy];
            [newTitleArray addObjectsFromArray:[YMDCDataProvider titles]];
            weakSelf.titleArray = [newTitleArray copy];
            
            NSMutableArray *newDescriptionArray = [weakSelf.descriptionArray mutableCopy];
            [newDescriptionArray addObjectsFromArray:[YMDCDataProvider itemDescription]];
            weakSelf.descriptionArray = newDescriptionArray;
            [weakSelf.collectionView reloadData];
            [weakSelf.collectionView.infiniteScrollingContentView stopAnimating];
        });
    }];
}

#pragma mark - Util

- (void)fillCell:(DynamicHeightCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    cell.titleLabel.text = self.titleArray[indexPath.row];
    cell.descriptionLabel.text = self.descriptionArray[indexPath.row];

    UIColor *newFaceColor = self.faceColorArray[indexPath.row % self.faceColorArray.count];
    UIColor *newEyeColor = self.eyesColorArray[indexPath.row % self.eyesColorArray.count];
    UIImage *newImage = [UIImage ADKImage:[UIImage imageNamed:@"avatar"] replaceColor:[UIColor ADKColorWithHexNumber:0xFBC900] withColor:newFaceColor];
    newImage = [UIImage ADKImage:newImage replaceColor:[UIColor ADKColorWithHexNumber:0x000000] withColor:newEyeColor];
    cell.avatarView.image = newImage;
}

- (UIImage *)imageForIndexPath:(NSIndexPath *)indexPath
{
    UIImage *returnImage = [UIImage imageNamed:@"DemoMain"];
    switch (indexPath.row) {
        case 1:
            returnImage = [returnImage ADKGaussianBlurWithRadius:5];
            break;
        case 2:
            returnImage = [[UIImage imageNamed:@"DemoMain"] ADKOverlayWithTexture:[UIImage imageNamed:@"MainMask"] transparent:0.5f];
            break;
        case 3:
            returnImage = [UIImage ADKImage:returnImage tintColor:[UIColor ADKColorWithHexNumber:0x018d2d]];
            break;
        case 4:
            returnImage = [returnImage ADKBlackAndWhiteImage];
            break;
        default:
            break;
    }
    return returnImage;
}

- (UIColor *)modalBackgroundColorForIndexPath:(NSIndexPath *)indexPath
{
    UIColor *color;
    switch (indexPath.row) {
        case 0:
            color = [UIColor clearColor];
            break;
        case 1:
            color = [[UIColor blackColor] colorWithAlphaComponent:0.7f];
            break;
        case 2:
            color = [[UIColor blueColor] colorWithAlphaComponent:0.5f];
            break;
        case 3:
            color = [[UIColor greenColor] colorWithAlphaComponent:0.5f];
            break;
        case 4:
            color = [[UIColor whiteColor] colorWithAlphaComponent:0.7f];
            break;
        default:
            break;
    }
    return color;
}

- (NSString *)modalTitleForIndexPath:(NSIndexPath *)indexPath
{
    NSString *title;
    switch (indexPath.row) {
        case 0:
            title = @"Normal image + Blur effect";
            break;
        case 1:
            title = @"Blur image + Black background";
            break;
        case 2:
            title = @"Replace color + Blue background";
            break;
        case 3:
            title = @"Green Mask + Green background";
            break;
        case 4:
            title = @"Gray scale + White background";
            break;
        default:
            break;
    }
    return title;
}

- (CGRect)modalFrameForIndexPath:(NSIndexPath *)indexPath
{
    CGRect rect;
    switch (indexPath.row) {
        case 0:
            rect = CGRectMake(0.0f, 0.0f, 280.0f, 460.0f);
            break;
        case 1:
            rect = CGRectMake(0.0f, 0.0f, 280.0f, 460.0f);
            break;
        case 2:
            rect = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.view.frame), 460.0f);
            break;
        case 3:
            rect = CGRectMake(0.0f, 0.0f, 280.0f, 460.0f);
            break;
        case 4:
            rect = CGRectMake(0.0f, 0.0f, 280.0f, 460.0f);
            break;
        default:
            rect = CGRectZero;
            break;
    }
    return rect;
}

#pragma mark - ADKModalMaskViewDelegate methods

- (void)maskViewWillAutoDismiss:(ADKModalMaskView *)maskView
{
    [self maskWillDismissHandler];
}

- (void)maskViewDidAutoDismiss:(ADKModalMaskView *)maskView
{
    [self maskDidDismissHandler];
}

- (void)maskViewWillDismiss:(ADKModalMaskView *)maskView
{
    [self maskWillDismissHandler];
}

- (void)maskViewDidDismiss:(ADKModalMaskView *)maskView
{
    [self maskDidDismissHandler];
}

- (void)maskDidDismissHandler
{
    self.modalView = nil;
    self.modalController = nil;
}

- (void)maskWillDismissHandler
{
    CGPoint endPoint = self.modalController.view.center;
    endPoint.y = CGRectGetMaxY(ADKPortraitScreenBoundRect());
    if (((NSIndexPath *)[[self.collectionView indexPathsForSelectedItems] lastObject]).row == 4) {
        endPoint.y = -480.0f;
    }
    
    __weak YMDCDemoViewController *weakSelf = self;
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         weakSelf.modalController.view.alpha = 0.0f;
                         weakSelf.modalController.view.center = endPoint;
                     }
                     completion:^(BOOL finished) {
                         // No-op
                     }];
    
    if (self.blurImageView.image) {
        [UIView animateWithDuration:0.3f animations:^{
            weakSelf.blurImageView.alpha = 0.0f;
        } completion:^(BOOL finished) {
            weakSelf.blurImageView.image = nil;
        }];
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return YMDCDemoSectionCount;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSUInteger numberOfItem;
    switch (section) {
        case YMDCDemoSectionMainImage:
            numberOfItem = 1;
            break;
        case YMDCDemoSectionDescription:
            numberOfItem = 1;
            break;
        case YMDCDemoSectionImages:
            numberOfItem = DEMO_IMAGE_COUNT;
            break;
        case YMDCDemoSectionComments:
            numberOfItem = [self.titleArray count];
            break;
        default:
            numberOfItem = 0;
            break;
    }
    return numberOfItem;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (YMDCDemoSectionMainImage == indexPath.section || YMDCDemoSectionImages == indexPath.section) {
        YMDCDemoImageCell *imageCell = [collectionView dequeueReusableCellWithReuseIdentifier:YMDCDemoImageCellIdentifier forIndexPath:indexPath];
        if (YMDCDemoSectionMainImage == indexPath.section) {
            imageCell.imageView.image = [[UIImage imageNamed:@"DemoMain"] ADKOverlayWithTexture:[UIImage imageNamed:@"opal"] transparent:0.5f];
        } else {
            imageCell.imageView.image = [self imageForIndexPath:indexPath];
        }
        return imageCell;
    } else if (YMDCDemoSectionDescription == indexPath.section){
        MovieDescCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MovieDescCellIdentifier forIndexPath:indexPath];
        return cell;
    }
    DynamicHeightCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:DynamicHeightCellIdentifer forIndexPath:indexPath];
    for (int i = 0; i < MIN(5, indexPath.row); i++) {
        UIImageView *starView = cell.ratingViews[i];
        starView.image = [UIImage ADKImage:starView.image replaceColor:[UIColor yellowColor]];
    }
    [self fillCell:cell atIndexPath:indexPath];
    
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return ITEM_INTERSPACING;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0f;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (YMDCDemoSectionMainImage == section) {
        return UIEdgeInsetsZero;
    }
    return UIEdgeInsetsMake(0.0f, 20.0f, 0.0f, 20.0f);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (YMDCDemoSectionDescription == indexPath.section) {
        return [[ADKNibSizeCalculator sharedInstance] sizeForNibNamed:YMDCDemoImageCellIdentifier withStyle:ADKNibDefaultScaling fitSize:CGSizeMake(CGRectGetWidth(collectionView.frame) - 40, CGRectGetHeight(collectionView.frame))];
    }
    if (YMDCDemoSectionMainImage == indexPath.section || YMDCDemoSectionImages == indexPath.section) {
        CGSize imageSize = [[UIImage imageNamed:@"DemoMain"] ADKResizeByMaxLength:collectionView.frame.size.width - 40.0f].size;
        CGFloat ratio = imageSize.height / imageSize.width;
        if (YMDCDemoSectionMainImage == indexPath.section) {
            imageSize = [[ADKNibSizeCalculator sharedInstance] sizeForNibNamed:MovieDescCellIdentifier withStyle:ADKNibDefaultScaling];
        }
        else {
            if (indexPath.row < 2) {
                imageSize.width = imageSize.width / 2 - ITEM_INTERSPACING;
                imageSize.height = imageSize.width * ratio;
            } else {
                imageSize.width = imageSize.width / 3 - ITEM_INTERSPACING * 2;
                imageSize.height = imageSize.width * ratio;
            }
        }
        
        return imageSize;
    }

    DynamicHeightCell *cell = (DynamicHeightCell *)[[ADKNibCacheManager sharedInstance] instanceForNibNamed:DynamicHeightCellIdentifer];
    CGSize cellSize;
    
    // For Demo
    cellSize = [[ADKNibSizeCalculator sharedInstance] sizeForNibNamed:DynamicHeightCellIdentifer withStyle:ADKNibFixedHeightScaling fitSize:CGSizeMake(CGRectGetWidth(collectionView.frame) - 40.0f, CGRectGetHeight(collectionView.frame))];
    [self fillCell:cell atIndexPath:indexPath];

    cellSize = [[ADKCellDynamicSizeCalculator sharedInstance] sizeForDynamicHeightCellInstance:cell preferredSize:cellSize];
    
    return cellSize;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (YMDCDemoSectionImages == indexPath.section) {
        if (!self.modalController) {
            self.modalController = [[ModalViewController alloc] init];
        }
        if (!self.modalView) {
            self.modalView = [[ADKModalMaskView alloc] initWithView:self.modalController.view
                                                         modalColor:[self modalBackgroundColorForIndexPath:indexPath]
                                                        autoDismiss:YES];
        }
        
        self.modalController.imageView.image = [self imageForIndexPath:indexPath];
        self.modalController.titleLabel.text = [self modalTitleForIndexPath:indexPath];
        self.modalController.descriptionTextView.text = [YMDCDataProvider movieDescription];
        self.modalController.view.alpha = 0.0f;
        
        self.modalView.delegate = self;
        [self.modalView showInView:self.view
                     withAnimation:YES
                        completion:^(BOOL finished) {
                            // no-op
                        }];
        
        CGPoint startPoint = self.modalController.view.center;
        startPoint.y = CGRectGetMaxY(ADKPortraitScreenBoundRect());
        if (indexPath.row == 4) {
            startPoint.y = -480.0f;
        }
        CGPoint endPoint = self.modalController.view.center;
        if (indexPath.row == 2) {
            endPoint.y += 95.0f;
        }
        self.modalController.view.frame = [self modalFrameForIndexPath:indexPath];
        self.modalController.view.center = startPoint;
        
        if (!indexPath.row) {
            UIImage *capturedImage = [UIImage ADKCaptureView:self.view];
            self.blurImageView.image = [capturedImage ADKGaussianBlurWithRadius:20.0f];
            [UIView animateWithDuration:0.3f animations:^{
                self.blurImageView.alpha = 1.0f;
            }];
        }

        __weak YMDCDemoViewController *weakSelf = self;
        [UIView animateWithDuration:0.3f
                              delay:0.2f
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             weakSelf.modalController.view.alpha = 1.0f;
                             weakSelf.modalController.view.center = endPoint;
                         }
                         completion:^(BOOL finished) {
                             // No-op
                         }];
        return;
    }
    
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    cell.selected = YES;
    
    [self.collectionView performBatchUpdates:nil completion:nil];
}

@end
