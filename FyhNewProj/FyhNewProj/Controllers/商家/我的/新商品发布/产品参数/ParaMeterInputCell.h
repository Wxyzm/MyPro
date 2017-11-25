//
//  ParaMeterInputCell.h
//  FyhNewProj
//
//  Created by yh f on 2017/11/1.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ParaMeterModel;
@class ParaMeterInputCell;

@protocol ParaMeterInputCellDelegate <NSObject>


- (void)didSelectedDeleteunitBtnWithCell:(ParaMeterInputCell *)cell;



@end



@interface ParaMeterInputCell : UITableViewCell

@property (nonatomic,strong) UILabel         *nameLab;      //属性名称

@property (nonatomic,strong) UITextField     *valueTxt;     //属性值

@property (nonatomic,strong) ParaMeterModel  *model;        //model

@property (nonatomic,strong) YLButton *deleteBtn;

@property (nonatomic,assign)id<ParaMeterInputCellDelegate> delegate;

@end
