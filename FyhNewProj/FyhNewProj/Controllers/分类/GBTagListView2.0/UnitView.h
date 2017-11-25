//
//  UnitView.h
//  FyhNewProj
//
//  Created by yh f on 2017/5/24.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GProductItemModel;
@class GItemModel;



@interface UnitView : UIView

@property (nonatomic, strong) UIViewController *baseVC;

@property (nonatomic , strong)     NSMutableArray *dataArr;  //装着GProductItemModel

@property (nonatomic , strong) GItemModel *ItemModel;

@property(nonatomic,copy)void (^didselectGoodsItemBlock)(NSDictionary*goodsDic);


@property (nonatomic , assign) NSInteger type;

- (void)showinView:(UIView *)view;
- (void)dismiss;


@end
