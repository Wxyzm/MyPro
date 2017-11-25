//
//  ColorSelectedCell.h
//  FyhNewProj
//
//  Created by yh f on 2017/11/3.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ColorModel;

@interface ColorSelectedCell : UITableViewCell

@property (nonatomic,strong)UILabel     *nameLab;       //属性名

@property (nonatomic,strong)UIImageView *rightImv;      //🐶勾勾

@property (nonatomic,strong)ColorModel *Model;

@end
