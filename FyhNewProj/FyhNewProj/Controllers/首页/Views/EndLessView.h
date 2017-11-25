//
//  EndLessView.h
//  FyhNewProj
//
//  Created by yh f on 2017/6/24.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EndLessViewDelegate <NSObject>

- (void)didSelectedBtnWithDic:(NSDictionary *)itemDic;


- (void)didSelectedBtnWithEndLessViewDic:(NSDictionary *)dataDic;

@end


@interface EndLessView : UIView

@property (nonatomic , assign) id<EndLessViewDelegate> delegate;

@property (nonatomic , strong) UIImageView *faceImageView;

@property (nonatomic , strong) UILabel *nameLab;

@property (nonatomic , strong) UILabel *adressLab;

@property (nonatomic , strong) UIImageView *goods1;

@property (nonatomic , strong) UIImageView *goods2;

@property (nonatomic , strong) UIImageView *goods3;

@property (nonatomic , strong) UIButton *btn1;

@property (nonatomic , strong) UIButton *btn2;

@property (nonatomic , strong) UIButton *btn3;

@property (nonatomic , strong) NSMutableDictionary *dataDic;

@end
