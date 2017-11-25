//
//  AdministrationaddViewController.h
//  FyhNewProj
//
//  Created by yh f on 2017/4/10.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "FyhBaseViewController.h"
@class AdressModel;

@interface AdministrationaddViewController : FyhBaseViewController


@property (nonatomic , assign) NSInteger selectedType;

@property(nonatomic,copy)void (^didselectAdressBlock)(AdressModel*selectedModel);


@end
