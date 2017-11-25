//
//  ParaMeterView.h
//  FyhNewProj
//
//  Created by yh f on 2017/10/30.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import <UIKit/UIKit.h>



typedef NS_ENUM(NSInteger, ParaMeterType) {
    FABRIC_TYPE                = 1,  //面料 坯布
    PATTERNDES_WAY             = 2,  //花型设计
    CLOTHINGDES_WAY            = 3,  //服装设计
    ACCESS_WAY                 = 4,  //辅料
    DRESS_WAY                  = 5,  //服装
    HOMETEXT_WAY               = 6   //家纺
};

@protocol NewParaMeterViewDelegate <NSObject>


- (void)didSelectedaddunitBtn;



@end


@interface NewParaMeterView : UIView

@property (nonatomic , strong) NSMutableArray *unitArr;         //产品参数

@property (nonatomic , assign) ParaMeterType paraMeterType;         //产品参数

@property (nonatomic,copy)NSString *htmlStr;

@property (nonatomic, assign) id<NewParaMeterViewDelegate>delegate;

- (void)reloadTableView;

- (void)setParaMeterType:(ParaMeterType)paraMeterType andDataArr:(NSMutableArray *)dataArr;


@end
