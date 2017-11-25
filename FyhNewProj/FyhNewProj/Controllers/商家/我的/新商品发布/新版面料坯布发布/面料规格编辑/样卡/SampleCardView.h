//
//  SampleCardView.h
//  FyhNewProj
//
//  Created by yh f on 2017/10/31.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SampleCardModel;



@interface SampleCardView : UIView

@property (nonatomic,strong)UITextField *priceTxt;           //价格

@property (nonatomic,strong)UITextField *limTxt;             //限购

@property (nonatomic,strong)UITextField *stockTxt;           //库存

@property (nonatomic,strong)SampleCardModel *cardModel;      //数据模板



@end
