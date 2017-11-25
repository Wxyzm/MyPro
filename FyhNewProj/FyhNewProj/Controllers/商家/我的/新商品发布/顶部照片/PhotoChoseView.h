//
//  PhotoChoseView.h
//  FyhNewProj
//
//  Created by yh f on 2017/10/30.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoChoseView : UIView


@property (nonatomic,strong)NSMutableArray  *urlPhotos;

-(void)reloadTableView;

@end
