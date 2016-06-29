//
//  ModalMaskViewViewController.m
//  AppDevKit
//
//  Created by Chih Feng Sung on 6/9/15.
//  Copyright © 2015, Yahoo Inc.
//  Licensed under the terms of the BSD License.
//  Please see the LICENSE file in the project root for terms.
//

#import "ModalMaskViewViewController.h"
#import "AppDevKit.h"
#import "UIColor+ThemeColor.h"
#import "SampleVCollectionViewCell.h"
#import "ModalViewController.h"

static NSString * const CellCollectionViewCellIdentifier = @"SampleVCollectionViewCell";

@interface ModalMaskViewViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, ADKModalMaskViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *demoCollectionView;

@property (strong, nonatomic) NSArray *flagArray;
@property (strong, nonatomic) ADKModalMaskView *modalView;
@property (strong, nonatomic) ModalViewController *modalController;

@end

@implementation ModalMaskViewViewController

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
    self.title = @"ModalMaskView";

    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Country-data" ofType:@"plist"];
    self.flagArray = [NSArray arrayWithContentsOfFile:plistPath];

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
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.flagArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = nil;
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellCollectionViewCellIdentifier
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
