//
//  ParaUnitSelectedCell.m
//  FyhNewProj
//
//  Created by yh f on 2017/11/1.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "ParaUnitSelectedCell.h"
#import "ParaUnitModel.h"

@implementation ParaUnitSelectedCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = UIColorFromRGB(WhiteColorValue);
        self.selectionStyle = UITableViewCellSeparatorStyleNone;
        [self setUP];
        
        
    }
    return self;
    
}

- (void)setUP{
    
    _nameLab = [BaseViewFactory labelWithFrame:CGRectMake(16, 0, 200, 48) textColor:UIColorFromRGB(BlackColorValue) font:APPFONT(15) textAligment:NSTextAlignmentLeft andtext:@""];
    [self.contentView addSubview:_nameLab];
    
    
    UIView *line = [BaseViewFactory viewWithFrame:CGRectMake(0, 47.5, ScreenWidth, 0.5) color:UIColorFromRGB(PLAHColorValue)];
    [self.contentView addSubview:line];
    
    _rightImv = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth - 32, 16, 16, 16)];
    _rightImv.image  = [UIImage imageNamed:@"ParaMeter_Right"];
    [self.contentView addSubview:_rightImv];
    _rightImv.hidden = YES;
    
}

-(void)setModel:(ParaUnitModel *)Model{
    
    _Model = Model;
    _nameLab.text = Model.unitName;
    if (Model.isSelected) {
        _rightImv.hidden = NO;
    }else{
        _rightImv.hidden = YES;
    }
    
}

@end
