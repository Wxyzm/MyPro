//
//  AccessListCell.h
//  FyhNewProj
//
//  Created by yh f on 2017/6/20.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AccessCellModel;

@protocol AccessListCellDelegate <NSObject>


- (void)didSelectedAccessListCellUpImagedBtnWithModel:(AccessCellModel *)model;

@end


@interface AccessListCell : UITableViewCell


@property (nonatomic , assign) id <AccessListCellDelegate>delegate;

//@property (nonatomic , strong) UIScrollView *bgscrollView;  //底部scrollview

@property (nonatomic , strong) UIImageView *faceImageView;  //展示图片

@property (nonatomic , strong) UILabel *kindLab;            //文件类型

@property (nonatomic , strong) UILabel *colorLab;            //颜色

@property (nonatomic , strong) UILabel *stateLab;             //状态

@property (nonatomic , strong) UITextField *stockTxt;       //库存

@property (nonatomic , strong) UITextField *minBuyTxt;      //起订量

@property (nonatomic , strong) UITextField *priceTxt;       //价格

@property (nonatomic , strong) YLButton *selectBtn;         //选中状态

@property (nonatomic , strong) SubBtn *editBtn;             //编辑按钮

@property (nonatomic , strong) SubBtn *compBtn;             //完成按钮

@property (nonatomic , strong) UIButton *upImageBtn;

@property (nonatomic , strong) AccessCellModel *model;

@end
