//
//  BatchSetCell.h
//  FyhNewProj
//
//  Created by yh f on 2017/10/31.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BatchModel;
@class BatchSetCell;

@protocol BatchSetCellDelegate <NSObject>


- (void)didSelectedUpImagedBtnWithCell:(BatchSetCell *)cell;

- (void)ChangedBatchSetCellViewData;


@end

@interface BatchSetCell : UITableViewCell

@property (nonatomic , assign) id<BatchSetCellDelegate>delegate;

@property (nonatomic,strong)UIImageView    *pictureIV;           //图片

@property (nonatomic,strong)UILabel        *unitLab;             //规格

@property (nonatomic,strong)UITextField    *stockTxt;            //库存

@property (nonatomic,strong)UITextField    *priceTxt;            //价格

@property (nonatomic,strong)UITextField    *MineeTxt;            //起订量

@property (nonatomic,strong)YLButton       *upImageBtn;          //上传图片按钮

@property (nonatomic,strong)BatchModel *model;


@end
