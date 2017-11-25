//
//  MemoCell.h
//  FyhNewProj
//
//  Created by yh f on 2017/7/19.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SellerOrderModel;

@interface MemoCell : UITableViewCell

@property (nonatomic , strong) UIImageView *faceView;

@property (nonatomic , strong) UILabel *memoLab;

@property (nonatomic , strong) SellerOrderModel *model;

@property (nonatomic , strong)UIButton *selectBtn;

@end
