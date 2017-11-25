//
//  BankCardSeleteViewController.h
//  FyhNewProj
//
//  Created by yh f on 2017/9/16.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "FyhBaseViewController.h"
@class BankCardModel;

@interface BankCardSeleteViewController : FyhBaseViewController

@property (nonatomic , strong) NSMutableArray *dataArr;


@property(nonatomic,copy)void (^didselectStatusItemBlock)(BankCardModel*selectedModel);



@end
