//
//  CYShopCell.m
//  瀑布流
//
//  Created by 葛聪颖 on 15/11/15.
//  Copyright © 2015年 聪颖不聪颖. All rights reserved.
//

#import "CYShopCell.h"
#import "CYShop.h"
#import "UIImageView+WebCache.h"

@interface CYShopCell()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@end

@implementation CYShopCell

- (void)setShop:(CYShop *)shop
{
    _shop = shop;
    
    // 1.图片
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:shop.img] placeholderImage:[UIImage imageNamed:@"loading"]];
    
    // 2.价格
    self.priceLabel.text = shop.price;
}
@end
