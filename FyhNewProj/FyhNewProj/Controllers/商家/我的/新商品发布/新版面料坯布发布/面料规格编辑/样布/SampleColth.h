//
//  SampleColth.h
//  FyhNewProj
//
//  Created by yh f on 2017/10/31.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SampleColthModel;


@interface SampleColth : UIView

@property (nonatomic,strong)UILabel *nameLab;               //样布、买断等

@property (nonatomic,strong)UITextField *priceTxt;           //价格

@property (nonatomic,strong)UITextField *stockTxt;           //库存

@property (nonatomic,strong)SampleColthModel *clothModel;    //数据模板



@end
