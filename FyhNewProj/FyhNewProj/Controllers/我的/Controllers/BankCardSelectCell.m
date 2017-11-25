//
//  BankCardSelectCell.m
//  FyhNewProj
//
//  Created by yh f on 2017/9/16.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "BankCardSelectCell.h"
#import "BankCardModel.h"   

@implementation BankCardSelectCell{

    UILabel *_leftLab;
    UIImageView *_selectedImageView;

}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = UIColorFromRGB(WhiteColorValue);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setUp];
    }
    return self;
}


- (void)setUp{

    UIView *lineView = [BaseViewFactory viewWithFrame:CGRectMake(0, 0, ScreenWidth, 1) color:UIColorFromRGB(LineColorValue)];
    [self.contentView addSubview:lineView];
    
    _leftLab = [BaseViewFactory labelWithFrame:CGRectMake(16, 0, 200, 50) textColor:UIColorFromRGB(0x434a54) font:APPFONT(15) textAligment:NSTextAlignmentLeft andtext:@""];
    [self.contentView addSubview:_leftLab];
    
    _selectedImageView = [[UIImageView alloc]init];
    _selectedImageView.image = [UIImage imageNamed:@"Ass-select"];
    [self.contentView addSubview:_selectedImageView];
    _selectedImageView.frame = CGRectMake(ScreenWidth - 28, 19, 12, 12);
    _selectedImageView.hidden = YES;
    
    

}



-(void)setModel:(BankCardModel *)model{
    _model = model;
    _leftLab.text = [NSString stringWithFormat:@"%@(尾号%@)",_model.bankName,[_model.bankAccountNumber substringFromIndex:_model.bankAccountNumber.length-4]];
    if (_model.selected) {
        _selectedImageView.hidden = NO;

    }else{
        _selectedImageView.hidden = YES;

    }

}

@end
