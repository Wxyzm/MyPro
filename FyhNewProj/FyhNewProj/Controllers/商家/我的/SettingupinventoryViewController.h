//
//  SettingupinventoryViewController.h
//  FyhNewProj
//
//  Created by yh f on 2017/10/31.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "FyhBaseViewController.h"

@interface SettingupinventoryViewController : FyhBaseViewController

@property (nonatomic,copy)NSString *numStr;

@property(nonatomic,copy)void (^didSetNumberBlock)(NSString*number);

@end
