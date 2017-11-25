//
//  ParaUnitSelectedCell.h
//  FyhNewProj
//
//  Created by yh f on 2017/11/1.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ParaUnitModel;

@interface ParaUnitSelectedCell : UITableViewCell

@property (nonatomic,strong)UILabel     *nameLab;       //属性名

@property (nonatomic,strong)UIImageView *rightImv;      //🐶勾勾

@property (nonatomic,strong)ParaUnitModel *Model;


@end
