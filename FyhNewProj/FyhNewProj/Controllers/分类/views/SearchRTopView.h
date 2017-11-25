//
//  SearchRTopView.h
//  FyhNewProj
//
//  Created by yh f on 2017/5/22.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SearchRTopViewDelegate <NSObject>


- (void)didselectedBtn:(YLButton *)button;


@end

@interface SearchRTopView : UIView

@property (nonatomic , assign) id<SearchRTopViewDelegate> delegate;

@property (nonatomic , strong) YLButton *allBtn;

@property (nonatomic , strong) YLButton *salesBtn;

@property (nonatomic , strong) YLButton *priceBtn;

@property (nonatomic , strong) YLButton *neBtn;

@end
