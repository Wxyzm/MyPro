//
//  BussLeiMuCell.m
//  FyhNewProj
//
//  Created by yh f on 2017/3/12.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "BussLeiMuCell.h"

@implementation BussLeiMuCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _rightLab = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth-75, 14, 60, 14)];
        _rightLab.font = FSYSTEMFONT(13);
        _rightLab.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_rightLab];
    }

    return self;
}

@end
