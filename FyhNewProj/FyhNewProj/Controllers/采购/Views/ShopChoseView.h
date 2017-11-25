//
//  ShopChoseView.h
//  FyhNewProj
//
//  Created by yh f on 2017/5/10.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import <UIKit/UIKit.h>

//@protocol ShopChoseViewDelegate <NSObject>
//
//@optional
////代理
//- (void)didSelectedBtn:(YLButton *)button;
//
//@end



@interface ShopChoseView : UIView

//@property (nonatomic , assign)  id <ShopChoseViewDelegate> delegate;

@property (nonatomic , strong) YLButton *classifyBtn;

@property (nonatomic , strong) YLButton *allBtn;

@property (nonatomic , strong) YLButton *timeBtn;

- (void)refreshBtn;
//
//- (void)closeAllBtn;

@end
