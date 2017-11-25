//
//  FabricProUnitView.h
//  FyhNewProj
//
//  Created by yh f on 2017/10/31.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol FabricProUnitViewDelegate <NSObject>


- (void)DidSelectedFabricProUnitViewOutPutBtn:(NSMutableArray *)kindTitleArr andstatusTitleArr:(NSMutableArray *)statusTitleArr andcolorTitleArr:(NSMutableArray *)colorTitleArr andType:(NSInteger )type;


@end

@interface FabricProUnitView : UIView

@property (nonatomic,strong)NSMutableArray *kindTitleArr;        //类型
@property (nonatomic,strong)NSMutableArray *statusTitleArr;      //状态
@property (nonatomic,strong)NSMutableArray *colorBtnArr;         //颜色
@property (nonatomic,strong)NSMutableArray *colorTitleArr;       //选中颜色数组


@property (nonatomic,strong)NSMutableArray *outPutArr;           //选中的组合


@property (nonatomic, assign) id<FabricProUnitViewDelegate>delegate;


- (void)refreshColorBtnView;
@end
