//
//  PullToRefreshExampleViewController.m
//  AppDevKit
//
//  Created by Jeff Lin on 12/6/15.
//  Copyright © 2015, Yahoo Inc.
//  Licensed under the terms of the BSD License.
//  Please see the LICENSE file in the project root for terms.
//

#import "PullToRefreshExampleViewController.h"
#import "AppDevKit.h"
#import "UIColor+ThemeColor.h"
#import "SampleVCollectionViewCell.h"
#import "PullToRefreshHelpView.h"
#import "InfiniteScrollingHelpView.h"

static NSString * const CellCollectionViewCellIdentifier = @"SampleVCollectionViewCell";

@interface PullToRefreshExampleViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *flagArray;

@end

@implementation PullToRefreshExampleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    self.collectionView.showInfiniteScrolling = NO;
    self.collectionView.showPullToRefresh = NO;
}

- (void)setupView
{
    self.title = @"Pull to refresh + infinite scroll";
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Country-data" ofType:@"plist"];
    self.flagArray = [[NSArray arrayWithContentsOfFile:plistPath] mutableCopy];
    
    UINib *cellNib = [UINib nibWithNibName:CellCollectionViewCellIdentifier bundle:nil];
    [self.collectionView registerNib:cellNib
              forCellWithReuseIdentifier:CellCollectionViewCellIdentifier];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    self.collectionView.backgroundColor = [UIColor themeBackgroundColor];
}

- (void)setupPullToRefreshView
{
    PullToRefreshHelpView *refreshView = [[PullToRefreshHelpView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, 60.0f)];
    
    __weak PullToRefreshExampleViewController *weakSelf = self;
    [self.collectionView ADKAddPullToRefreshWithHandleView:refreshView actionHandler:^{
        // Delay 3s, for show animation
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Country-data" ofType:@"plist"];
            weakSelf.flagArray = [[NSArray arrayWithContentsOfFile:plistPath] mutableCopy];
            [weakSelf.collectionView reloadData];
            [weakSelf.collectionView.pullToRefreshContentView stopAnimating];
        });
    }];
    self.collectionView.pullToRefreshContentView.autoFadeEffect = YES;
}

- (void)setupInfiniteScrollingView
{
    InfiniteScrollingHelpView *infiniteScrollView = [[InfiniteScrollingHelpView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, 60.0f)];
    
    __weak PullToRefreshExampleViewController *weakSelf = self;
    [self.collectionView ADKAddInfiniteScrollingWithHandleView:infiniteScrollView actionHandler:^{
        // Delay 1s, for show animation
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Country-data" ofType:@"plist"];
            [weakSelf.flagArray addObjectsFromArray:[NSArray arrayWithContentsOfFile:plistPath]];
            [weakSelf.collectionView reloadData];
            [weakSelf.collectionView.infiniteScrollingContentView stopAnimating];
        });
    }];
    self.collectionView.infiniteScrollingContentView.autoFadeEffect = YES;
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

@end
