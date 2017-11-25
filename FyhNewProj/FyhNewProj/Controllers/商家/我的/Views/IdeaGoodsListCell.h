//
//  IdeaGoodsListCell.h
//  FyhNewProj
//
//  Created by yh f on 2017/6/14.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IdeaCellModel;

@protocol IdeaGoodsListCellDelegate <NSObject>


- (void)didSelectedUpImagedBtnWithModel:(IdeaCellModel *)model;

@end




@interface IdeaGoodsListCell : UITableViewCell

@property (nonatomic , assign) id<IdeaGoodsListCellDelegate>delegate;

@property (nonatomic , strong) UIScrollView *bgscrollView;  //底部scrollview

@property (nonatomic , strong) UIImageView *faceImageView;  //展示图片

@property (nonatomic , strong) UILabel *kindLab;            //文件类型

@property (nonatomic , strong) UILabel *useLab;             //使用种类

@property (nonatomic , strong) UITextField *stockTxt;       //库存

@property (nonatomic , strong) UITextField *priceTxt;       //价格

@property (nonatomic , strong) YLButton *selectBtn;         //选中状态

@property (nonatomic , strong) SubBtn *editBtn;             //编辑按钮

@property (nonatomic , strong) SubBtn *compBtn;             //完成按钮

@property (nonatomic , strong) UIButton *upImageBtn;

@property (nonatomic , strong) IdeaCellModel *model;

@end
