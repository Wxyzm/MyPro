//
//  CreateFloTypeView.h
//  FyhNewProj
//
//  Created by yh f on 2017/11/9.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CreateFloTypeViewDelegate <NSObject>


- (void)DidSelectedCreateFloTypeProUnitViewOutPutBtn:(NSMutableArray *)kindTitleArr andstatusTitleArr:(NSMutableArray *)statusTitleArr andType:(NSInteger )type;


@end

@interface CreateFloTypeView : UIView

@property (nonatomic,strong)NSMutableArray *kindTitleArr;        //类型

@property (nonatomic,strong)NSMutableArray *statusTitleArr;      //状态

@property (nonatomic, assign) id<CreateFloTypeViewDelegate>delegate;


@property (nonatomic,assign)NSInteger TYPE;

- (void)refreshKindBtnView;

@end
