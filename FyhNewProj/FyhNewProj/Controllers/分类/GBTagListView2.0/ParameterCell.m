//
//  ParameterCell.m
//  FyhNewProj
//
//  Created by yh f on 2017/6/22.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "ParameterCell.h"

@implementation ParameterCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUP];
        
    }
    return self;
}

- (void)setUP{
    
    
    
    _nameLab = [BaseViewFactory labelWithFrame:CGRectMake(15, 0, 150, 50) textColor:UIColorFromRGB(0xaab2bd) font:APPFONT(18) textAligment:NSTextAlignmentLeft andtext:@""];
    [self.contentView addSubview:_nameLab];

    _paraLab = [BaseViewFactory labelWithFrame:CGRectMake(150, 0, ScreenWidth- 135, 50) textColor:UIColorFromRGB(0x434a54) font:APPFONT(15) textAligment:NSTextAlignmentLeft andtext:@""];
    [self.contentView addSubview:_paraLab];

    UIView *line1 = [BaseViewFactory viewWithFrame:CGRectMake(0, 49,  ScreenWidth, 1) color:UIColorFromRGB(LineColorValue)];
    [self.contentView addSubview:line1];

}

@end
