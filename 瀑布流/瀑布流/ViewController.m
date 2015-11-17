//
//  ViewController.m
//  瀑布流
//
//  Created by 葛聪颖 on 15/11/15.
//  Copyright © 2015年 聪颖不聪颖. All rights reserved.
//

#import "ViewController.h"
#import "CYWaterFlowLayout.h"
#import "CYShop.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "CYShopCell.h"

@interface ViewController () <UICollectionViewDataSource, CYWaterFlowLayoutDelegate>
/** 所有的商品数据 */
@property (nonatomic, strong) NSMutableArray *shops;

@property (nonatomic, weak) UICollectionView *collectionView;
@end

@implementation ViewController

- (NSMutableArray *)shops
{
    if (!_shops) {
        _shops = [NSMutableArray array];
    }
    return _shops;
}

static NSString * const CYShopId = @"shop";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupLayout];
    
    [self setupRefresh];
}

- (void)setupRefresh
{
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewShops)];
    [self.collectionView.mj_header beginRefreshing];
    
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreShops)];
    self.collectionView.mj_footer.hidden = YES;
}

- (void)loadNewShops
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSArray *shops = [CYShop mj_objectArrayWithFilename:@"1.plist"];
        [self.shops removeAllObjects];
        [self.shops addObjectsFromArray:shops];
        
        // 刷新数据
        [self.collectionView reloadData];
        
        [self.collectionView.mj_footer endRefreshing];
    });
}

- (void)loadMoreShops
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSArray *shops = [CYShop mj_objectArrayWithFilename:@"1.plist"];
        [self.shops addObjectsFromArray:shops];
        
        // 刷新数据
        [self.collectionView reloadData];
        
        [self.collectionView.mj_footer endRefreshing];
    });
}

- (void)setupLayout
{
    // 创建布局
    CYWaterFlowLayout *layout = [[CYWaterFlowLayout alloc] init];
    layout.delegate = self;
    
    // 创建CollectionView
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.dataSource = self;
    [self.view addSubview:collectionView];
    
    // 注册
    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([CYShopCell class]) bundle:nil] forCellWithReuseIdentifier:CYShopId];
    
    self.collectionView = collectionView;
}

#pragma mark - <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    self.collectionView.mj_footer.hidden = self.shops.count == 0;
    return self.shops.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CYShopCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CYShopId forIndexPath:indexPath];
    
    cell.shop = self.shops[indexPath.item];
    
    return cell;
}

#pragma mark - <XMGWaterflowLayoutDelegate>
- (CGFloat)waterflowLayout:(CYWaterFlowLayout *)waterflowLayout heightForItemAtIndex:(NSUInteger)index itemWidth:(CGFloat)itemWidth
{
    CYShop *shop = self.shops[index];
    
    return itemWidth * shop.h / shop.w;
}

- (CGFloat)rowMarginInWaterflowLayout:(CYWaterFlowLayout *)waterflowLayout
{
    return 20;
}

- (CGFloat)columnCountInWaterflowLayout:(CYWaterFlowLayout *)waterflowLayout
{
//    if (self.shops.count <= 50) return 2;
    return 3;
}

- (UIEdgeInsets)edgeInsetsInWaterflowLayout:(CYWaterFlowLayout *)waterflowLayout
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

@end
