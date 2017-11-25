//
//  ThreeClassifyCell.h
//  FyhNewProj
//
//  Created by yh f on 2017/5/8.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ThreeClassifyCell;

@protocol ThreeClassifyCellDelegate <NSObject>


- (void)didselectedItemWithBtn:(YLButton *)button andcell:(ThreeClassifyCell *)cell;


@end

@interface ThreeClassifyCell : UITableViewCell

@property (nonatomic,assign)id<ThreeClassifyCellDelegate>delegate;

@property (nonatomic,strong)NSArray *dataArr;

@end
