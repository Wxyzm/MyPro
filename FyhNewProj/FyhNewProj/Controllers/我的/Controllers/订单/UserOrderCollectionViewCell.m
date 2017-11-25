//
//  UserOrderCollectionViewCell.m
//  FyhNewProj
//
//  Created by yh f on 2017/7/14.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "UserOrderCollectionViewCell.h"
#import "UserOrder.h"
#import "OrderSellerItems.h"
#import "OrderItems.h"
@implementation UserOrderCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 5;
        self.clipsToBounds = YES;
        
        [self setup];
    }
    return self;
}

- (void)setup{

    _productFace = [UIImageView new];
    _productFace.contentMode = UIViewContentModeScaleToFill;
    _productFace.clipsToBounds = YES;
    [self.contentView addSubview:_productFace];
    
    _backImageView = [UIImageView new];
    _backImageView.contentMode = UIViewContentModeScaleToFill;
    _backImageView.clipsToBounds = YES;
    _backImageView.image = [UIImage imageNamed:@"result_background"];
    [self.contentView  addSubview:_backImageView];

    _productFace.sd_layout.rightSpaceToView(self.contentView,0).leftSpaceToView(self.contentView,0).topSpaceToView(self.contentView,0).bottomSpaceToView(self.contentView,0);
    
    _backImageView.sd_layout.rightSpaceToView(self.contentView,0).leftSpaceToView(self.contentView,0).topSpaceToView(self.contentView,0).bottomSpaceToView(self.contentView,0);
}


-(void)setModel:(OrderItems *)model{

    _model = model;
    if (model.imageUrlList.count >0) {
        NSString *imageUrl = model.imageUrlList[0];
        [_productFace sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"loding"]];
    }else{
        _productFace.image = [UIImage imageNamed:@"loding"];
    }
  


}
/*"sellerItemOrders": [
 {
 "sellerInfo": "CN 15757855240",
 "itemOrders": [
 {
 "id": 61,
 "userOrderId": 36,
 "payAmount": "0.00",
 "itemId": -1,
 "title": "运费：测试测试1911 源文件 授权使用, 测试测试1911 JPG 授权使用, 你牛你1912 样卡 红色 期货",
 "status": 0,
 "quantity": 1,
 "createTime": "1498716787",
 "updateTime": "1498716787",
 "accountId": 13,
 "sellerId": 14,
 "memo": "",
 "currencyCode": "CNY",
 "logistics": null,
 "sellerInfo": "CN 15757855240",
 "imageUrl": null,
 "itemUrl": null,
 "itemSpecificationDescription": null
 },
 {
 "id": 62,
 "userOrderId": 36,
 "payAmount": "0.13",
 "itemId": 8319,
 "title": "测试测试1911 JPG 授权使用",
 "status": 0,
 "quantity": 13,
 "createTime": "1498716787",
 "updateTime": "1498716787",
 "accountId": 13,
 "sellerId": 14,
 "memo": "",
 "currencyCode": "CNY",
 "logistics": null,
 "sellerInfo": "CN 15757855240",
 "imageUrl": "upload_development/14-312f7752c8cb6f647cb242902b162135.jpeg,upload_development/14-8c4600a77dc368aa31bcb2fc04360f43.jpeg,upload_development/14-4771299d60c12649dff84b93595599fb.jpeg",
 "itemUrl": "http://114.55.5.207:82/item/8319",
 "itemSpecificationDescription": "类型：JPG 权限：授权使用",
 "imageUrlList": [
 "https://om6h1w22l.qnssl.com/upload_development/14-312f7752c8cb6f647cb242902b162135.jpeg",
 "https://om6h1w22l.qnssl.com/upload_development/14-8c4600a77dc368aa31bcb2fc04360f43.jpeg",
 "https://om6h1w22l.qnssl.com/upload_development/14-4771299d60c12649dff84b93595599fb.jpeg"
 ]
 },
 {
 "id": 63,
 "userOrderId": 36,
 "payAmount": "0.10",
 "itemId": 8320,
 "title": "测试测试1911 源文件 授权使用",
 "status": 0,
 "quantity": 10,
 "createTime": "1498716787",
 "updateTime": "1498716787",
 "accountId": 13,
 "sellerId": 14,
 "memo": "",
 "currencyCode": "CNY",
 "logistics": null,
 "sellerInfo": "CN 15757855240",
 "imageUrl": "upload_development/14-10f5b4351ce012a03e25a51350be5cdf.jpeg,upload_development/14-8c4600a77dc368aa31bcb2fc04360f43.jpeg,upload_development/14-4771299d60c12649dff84b93595599fb.jpeg",
 "itemUrl": "http://114.55.5.207:82/item/8320",
 "itemSpecificationDescription": "类型：源文件 权限：授权使用",
 "imageUrlList": [
 "https://om6h1w22l.qnssl.com/upload_development/14-10f5b4351ce012a03e25a51350be5cdf.jpeg",
 "https://om6h1w22l.qnssl.com/upload_development/14-8c4600a77dc368aa31bcb2fc04360f43.jpeg",
 "https://om6h1w22l.qnssl.com/upload_development/14-4771299d60c12649dff84b93595599fb.jpeg"
 ]
 },
 {
 "id": 64,
 "userOrderId": 36,
 "payAmount": "0.04",
 "itemId": 8325,
 "title": "你牛你1912 样卡 红色 期货",
 "status": 0,
 "quantity": 4,
 "createTime": "1498716787",
 "updateTime": "1498716787",
 "accountId": 13,
 "sellerId": 14,
 "memo": "",
 "currencyCode": "CNY",
 "logistics": null,
 "sellerInfo": "CN 15757855240",
 "imageUrl": "upload_development/14-4970e272ca251e477be6911e4bea5b05.jpeg,upload_development/14-bde8a828faf7c133beb03e5291b20701.jpeg,upload_development/14-423de798d94c52bf8908bb49e5a8d041.jpeg",
 "itemUrl": "http://114.55.5.207:82/item/8325",
 "itemSpecificationDescription": "类型：样卡 颜色：红色 状态：期货",
 "imageUrlList": [
 "https://om6h1w22l.qnssl.com/upload_development/14-4970e272ca251e477be6911e4bea5b05.jpeg",
 "https://om6h1w22l.qnssl.com/upload_development/14-bde8a828faf7c133beb03e5291b20701.jpeg",
 "https://om6h1w22l.qnssl.com/upload_development/14-423de798d94c52bf8908bb49e5a8d041.jpeg"
 ]
 }
 ]
 }
 ],*/


/*
 "sellerItemOrders": [
 {
 "sellerInfo": "测试专用",
 "itemOrders": [
 {
 "id": 153,
 "userOrderId": 74,
 "payAmount": "0.00",
 "itemId": -1,
 "title": "运费：牛奶丝拉架/瑜伽服面料/印花弹力牛奶丝（1944） 大货 定制 现货, 30D拉架单位衣绵纶拉架衣秋冬家居服（1946）时装休闲运动服可染色卫衣布 大货 定制 现货",
 "status": 1,
 "quantity": 1,
 "createTime": "1499763878",
 "updateTime": "1499763878",
 "accountId": 13,
 "sellerId": 447,
 "memo": "",
 "currencyCode": "CNY",
 "logistics": null,
 "sellerInfo": "测试专用",
 "imageUrl": null,
 "itemUrl": null,
 "itemSpecificationDescription": null
 },
 {
 "id": 155,
 "userOrderId": 74,
 "payAmount": "0.04",
 "itemId": 8382,
 "title": "牛奶丝拉架/瑜伽服面料/印花弹力牛奶丝（1944） 大货 定制 现货",
 "status": 1,
 "quantity": 4,
 "createTime": "1499763878",
 "updateTime": "1499763878",
 "accountId": 13,
 "sellerId": 447,
 "memo": "",
 "currencyCode": "CNY",
 "logistics": null,
 "sellerInfo": "测试专用",
 "imageUrl": "upload_development/447-31098ef03c50bafdd0aecaaf97e5cb19.jpeg,upload_development/447-a2f8d1af0377d6740e959bfbc19b3a92.jpeg",
 "itemUrl": "http://114.55.5.207:82/item/8382",
 "itemSpecificationDescription": "类型：大货 颜色：定制 状态：现货",
 "imageUrlList": [
 "https://om6h1w22l.qnssl.com/upload_development/447-31098ef03c50bafdd0aecaaf97e5cb19.jpeg",
 "https://om6h1w22l.qnssl.com/upload_development/447-a2f8d1af0377d6740e959bfbc19b3a92.jpeg"
 ]
 }
 ]
 },
 {
 "sellerInfo": "CN 15571138888",
 "itemOrders": [
 {
 "id": 154,
 "userOrderId": 74,
 "payAmount": "0.00",
 "itemId": -1,
 "title": "运费：牛奶丝拉架/瑜伽服面料/印花弹力牛奶丝（1944） 大货 定制 现货, 30D拉架单位衣绵纶拉架衣秋冬家居服（1946）时装休闲运动服可染色卫衣布 大货 定制 现货",
 "status": 1,
 "quantity": 1,
 "createTime": "1499763878",
 "updateTime": "1499763878",
 "accountId": 13,
 "sellerId": 459,
 "memo": "",
 "currencyCode": "CNY",
 "logistics": null,
 "sellerInfo": "CN 15571138888",
 "imageUrl": null,
 "itemUrl": null,
 "itemSpecificationDescription": null
 },
 {
 "id": 156,
 "userOrderId": 74,
 "payAmount": "0.04",
 "itemId": 8394,
 "title": "30D拉架单位衣绵纶拉架衣秋冬家居服（1946）时装休闲运动服可染色卫衣布 大货 定制 现货",
 "status": 1,
 "quantity": 4,
 "createTime": "1499763878",
 "updateTime": "1499763878",
 "accountId": 13,
 "sellerId": 459,
 "memo": "",
 "currencyCode": "CNY",
 "logistics": null,
 "sellerInfo": "CN 15571138888",
 "imageUrl": "upload_development/459-0ff7027d4ee7cf86dff7ffba353d29f3.jpeg,upload_development/459-a9dd91a4c9e8d5a89e0322d4887f38f8.jpeg,upload_development/459-590c8b41173bf2fc4cdfbbf6b00d57de.jpeg",
 "itemUrl": "http://114.55.5.207:82/item/8394",
 "itemSpecificationDescription": "类型：大货 颜色：定制 状态：现货",
 "imageUrlList": [
 "https://om6h1w22l.qnssl.com/upload_development/459-0ff7027d4ee7cf86dff7ffba353d29f3.jpeg",
 "https://om6h1w22l.qnssl.com/upload_development/459-a9dd91a4c9e8d5a89e0322d4887f38f8.jpeg",
 "https://om6h1w22l.qnssl.com/upload_development/459-590c8b41173bf2fc4cdfbbf6b00d57de.jpeg"
 ]
 }
 ]
 }
 ]
 */

@end
