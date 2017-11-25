//
//  NewAccessView.h
//  FyhNewProj
//
//  Created by yh f on 2017/11/9.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NewAccessViewDelegate <NSObject>


- (void)DidSelectedFNewAccessProUnitViewOutPutBtn:(NSMutableArray *)kindTitleArr andstatusTitleArr:(NSMutableArray *)statusTitleArr andcolorTitleArr:(NSMutableArray *)colorTitleArr andType:(NSInteger )type;


@end


@interface NewAccessView : UIView

@property (nonatomic,strong)NSMutableArray *kindTitleArr;        //类型
@property (nonatomic,strong)NSMutableArray *statusTitleArr;      //状态
@property (nonatomic,strong)NSMutableArray *colorBtnArr;         //颜色
@property (nonatomic,strong)NSMutableArray *colorTitleArr;       //选中颜色数组

@property (nonatomic, assign) id<NewAccessViewDelegate>delegate;

- (void)refreshColorBtnView;

@end
