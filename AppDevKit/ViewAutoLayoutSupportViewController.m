//
//  UIViewAutoLayoutSupportViewController.m
//  AppDevKit
//
//  Created by Chih Feng Sung on 6/9/15.
//  Copyright © 2015, Yahoo Inc.
//  Licensed under the terms of the BSD License.
//  Please see the LICENSE file in the project root for terms.
//

#import "ViewAutoLayoutSupportViewController.h"
#import "AppDevKit.h"
#import "UIColor+ThemeColor.h"
#import "AvatorCollectionViewCell.h"
#import "SampleVCollectionViewCell.h"
#import "ModalViewController.h"


static NSString * const AvatorCellCollectionViewCellIdentifier = @"AvatorCollectionViewCell";
static NSString * const CellCollectionViewCellIdentifier = @"SampleVCollectionViewCell";

@interface ViewAutoLayoutSupportViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, ADKModalMaskViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *avatorCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *demoCollectionView;

@property (strong, nonatomic) NSArray *flagArray;
@property (strong, nonatomic) ADKModalMaskView *modalView;
@property (strong, nonatomic) ModalViewController *modalController;
@property (weak, nonatomic) IBOutlet UISegmentedControl *typeSegmentedControl;

- (IBAction)typeChangedHandler;

@end

@implementation ViewAutoLayoutSupportViewController

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
    self.title = @"UIView+ADKAutoLayoutSupport";
    self.view.backgroundColor = [UIColor blackColor];
    self.typeSegmentedControl.tintColor = [UIColor ADKColorWithHexString:@"CCCCCC"];

    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.avatorCollectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Country-data" ofType:@"plist"];
    self.flagArray = [NSArray arrayWithContentsOfFile:plistPath];

    UINib *avatorCellNib = [UINib nibWithNibName:AvatorCellCollectionViewCellIdentifier bundle:nil];
    [self.avatorCollectionView registerNib:avatorCellNib forCellWithReuseIdentifier:AvatorCellCollectionViewCellIdentifier];

    self.avatorCollectionView.dataSource = self;
    self.avatorCollectionView.backgroundColor = [UIColor themeBackgroundColor];


    UINib *cellNib = [UINib nibWithNibName:CellCollectionViewCellIdentifier bundle:nil];
    [self.demoCollectionView registerNib:cellNib
              forCellWithReuseIdentifier:CellCollectionViewCellIdentifier];

    self.demoCollectionView.delegate = self;
    self.demoCollectionView.dataSource = self;
    self.demoCollectionView.backgroundColor = [UIColor themeBackgroundColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
}


#pragma mark - Event handlers

- (void)typeChangedHandler
{
    if (self.typeSegmentedControl.selectedSegmentIndex == 0) {
//        [self.avatorCollectionView ADKUnhideViewHeight];
//        [self.demoCollectionView ADKUnhideTopConstraint];
        [self.avatorCollectionView ADKHideView:NO withConstraints:ADKLayoutAttributeHeight | ADKLayoutAttributeTop];
    } else {
//        [self.avatorCollectionView hideViewHeight];
//        [self.demoCollectionView hideTopConstraint];
        [self.avatorCollectionView ADKHideView:YES withConstraints:ADKLayoutAttributeHeight | ADKLayoutAttributeTop];
    }
}


#pragma mark - UICollectionView delegate methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.flagArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = nil;

    NSString *identifier;

    if (collectionView == self.avatorCollectionView) {
        identifier = AvatorCellCollectionViewCellIdentifier;
    } else {
        identifier = CellCollectionViewCellIdentifier;
    }

    cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier
                                                     forIndexPath:indexPath];
    if (cell) {

        NSDictionary *dict = self.flagArray[indexPath.row];
        SampleVCollectionViewCell *avengersCell = (SampleVCollectionViewCell *)cell;
        avengersCell.imageView.image = [UIImage imageNamed:dict[@"photo"]];
        avengersCell.titleLabel.text = dict[@"title"];
        avengersCell.descriptionLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        avengersCell.descriptionLabel.numberOfLines = 2;
        avengersCell.descriptionLabel.text = dict[@"desc"];
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

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [[ADKNibSizeCalculator sharedInstance] sizeForNibNamed:CellCollectionViewCellIdentifier
                                                     withStyle:ADKNibFixedHeightScaling];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = self.flagArray[indexPath.row];

    if (!self.modalController) {
        self.modalController = [[ModalViewController alloc] init];
    }

    if (!self.modalView) {
        self.modalView = [[ADKModalMaskView alloc] initWithView:self.modalController.view
                                                  modalColor:[[UIColor blackColor] colorWithAlphaComponent:0.7f]
                                                 autoDismiss:YES];
    }

    self.modalController.imageView.image = [UIImage imageNamed:dict[@"photo"]];
    self.modalController.titleLabel.text = dict[@"title"];
    self.modalController.descriptionTextView.text = dict[@"desc"];

    self.modalView.delegate = self;
    [self.modalView showInView:self.view
                 withAnimation:YES
                    completion:^(BOOL finished) {
                        // no-op
                    }];

    self.modalController.view.alpha = 0.0f;
    CGPoint startPoint = self.modalController.view.center;
    startPoint.y = CGRectGetMaxY(ADKPortraitScreenBoundRect());
    CGPoint endPoint = self.modalController.view.center;
    self.modalController.view.center = startPoint;

    [UIView animateWithDuration:0.3f
                          delay:0.2f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.modalController.view.alpha = 1.0f;
                         self.modalController.view.center = endPoint;
                     }
                     completion:^(BOOL finished) {

                     }];
}


#pragma mark - ADKModalMaskViewDelegate methods

- (void)maskViewWillAutoDismiss:(ADKModalMaskView *)maskView
{
    CGPoint endPoint = self.modalController.view.center;
    endPoint.y = CGRectGetMaxY(ADKPortraitScreenBoundRect());

    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.modalController.view.alpha = 0.0f;
                         self.modalController.view.center = endPoint;
                     }
                     completion:^(BOOL finished) {

                     }];
}

- (void)maskViewDidAutoDismiss:(ADKModalMaskView *)maskView
{
    self.modalView = nil;
    self.modalController = nil;
}


#pragma mark - UIContentContainer delegate methods

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [self.demoCollectionView.collectionViewLayout invalidateLayout];
}

@end
