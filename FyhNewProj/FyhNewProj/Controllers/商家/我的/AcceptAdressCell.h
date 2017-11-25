//
//  AcceptAdressCell.h
//  FyhNewProj
//
//  Created by yh f on 2017/7/18.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SellerOrderModel;

@interface AcceptAdressCell : UITableViewCell

@property (nonatomic , strong) UIImageView *faceView;

@property (nonatomic , strong) UILabel *nameLab;

@property (nonatomic , strong) UILabel *phoneLab;

@property (nonatomic , strong) UILabel *adressLab;

@property (nonatomic , strong) SellerOrderModel *model;

@property (nonatomic , strong) NSDictionary *adressDic;

@end
