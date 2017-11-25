//
//  AdressTopCell.h
//  FyhNewProj
//
//  Created by yh f on 2017/9/29.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AdressModel;

@interface AdressTopCell : UITableViewCell

@property (nonatomic,strong)AdressModel *model;

@property (nonatomic,assign)CGFloat Heigh;

@property (nonatomic,assign)BOOL isSelectedAdress;

@end
