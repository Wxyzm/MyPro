//
//  FabricView.h
//  FyhNewProj
//
//  Created by yh f on 2017/6/15.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TagLIstButtonView;
@protocol FabricViewDelegate <NSObject>


- (void)didSelectedFabricViewAddBtnwithType:(NSInteger)type;

- (void)didSelectedFabricViewGoodsList;

- (void)didSelectedFabricViewdeleteBtn;

- (void)didSelectedFabricViewRemoveListArrBtn;
@end

@interface FabricView : UIView

@property (nonatomic , assign) BOOL itemIsEditComplete;

@property (nonatomic , strong)  TagLIstButtonView   *kindView;     //颜色

@property (nonatomic , strong)TagLIstButtonView *leixinView;        //类型

@property (nonatomic , strong)TagLIstButtonView *quanView;          //状态
@property (nonatomic, assign) id<FabricViewDelegate>delegate;

@property (nonatomic , strong) NSMutableArray *kindArr;         //类型数据

@property (nonatomic , strong) NSMutableArray *unitArr;         //产品参数


@property (nonatomic , strong)     NSMutableArray  *outPutArr;

@property (nonatomic , strong)     NSMutableArray  *outPutArr1;

@property (nonatomic , strong)     NSMutableArray  *outPutArr2;
@property (nonatomic , strong) UILabel *rightLab;

@end
