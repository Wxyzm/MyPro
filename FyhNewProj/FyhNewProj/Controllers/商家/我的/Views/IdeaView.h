//
//  IdeaView.h
//  FyhNewProj
//
//  Created by yh f on 2017/6/12.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TagLIstButtonView;


@protocol IdeaViewDelegate <NSObject>


- (void)didSelectedAddBtnwithType:(NSInteger)type;

- (void)didSelectedIdeaViewGoodsList;

- (void)didSelectedIdeaViewdeleteBtn;

- (void)didSelectedIdeaViewRemoveListArrBtn;

@end

@interface IdeaView : UIView


@property (nonatomic , assign) BOOL itemIsEditComplete;

@property (nonatomic , strong)  TagLIstButtonView   *kindView;     //类型

@property (nonatomic , strong)  TagLIstButtonView *quanView;


@property (nonatomic, assign) id<IdeaViewDelegate>delegate;

@property (nonatomic , strong) NSMutableArray *kindArr;         //类型数据

@property (nonatomic , strong) NSMutableArray *unitArr;         //产品参数

//@property (nonatomic , strong)     NSMutableArray  *kindmodelArr;

@property (nonatomic , strong)     NSMutableArray  *outPutArr;

@property (nonatomic , strong)     NSMutableArray  *outPutArr1;

@property (nonatomic , strong) UILabel *rightLab;

- (void)refreshViewFrame;


@end
