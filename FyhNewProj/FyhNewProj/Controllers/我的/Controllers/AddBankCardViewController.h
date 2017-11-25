//
//  AddBankCardViewController.h
//  FyhNewProj
//
//  Created by yh f on 2017/9/12.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "FyhBaseViewController.h"
@class BankCardModel;
typedef void(^didAddBankCardBlock) (BankCardModel *addModel);


@interface AddBankCardViewController : FyhBaseViewController

@property(nonatomic,copy)didAddBankCardBlock AddBankCardBlock;

@end
