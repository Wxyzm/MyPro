//
//  ParaMeterInputCell.m
//  FyhNewProj
//
//  Created by yh f on 2017/11/1.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "ParaMeterInputCell.h"
#import "ParaMeterModel.h"

@interface ParaMeterInputCell ()<UITextFieldDelegate>


@end

@implementation ParaMeterInputCell

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
    
    _nameLab  = [BaseViewFactory  labelWithFrame:CGRectMake(16, 0, 100, 48) textColor:UIColorFromRGB(BlackColorValue) font:APPFONT(15) textAligment:NSTextAlignmentLeft andtext:@""];
    [self.contentView addSubview:_nameLab];
    
    _valueTxt = [BaseViewFactory textFieldWithFrame:CGRectMake(128, 0, ScreenWidth - 128-16, 48) font:APPFONT(15) placeholder:@"" textColor:UIColorFromRGB(PLAHColorValue) placeholderColor:UIColorFromRGB(PLAHColorValue) delegate:self];
    _valueTxt.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_valueTxt];
    
    UIView *line = [BaseViewFactory viewWithFrame:CGRectMake(0, 47.5, ScreenWidth, 0.5) color:UIColorFromRGB(PLAHColorValue)];
    [self.contentView addSubview:line];
    
    _deleteBtn = [YLButton buttonWithType:UIButtonTypeCustom];
    _deleteBtn.imageRect = CGRectMake(16, 15, 18, 18);
    [_deleteBtn setImage:[UIImage imageNamed:@"unit_delete"] forState:UIControlStateNormal];
    [self.contentView addSubview:_deleteBtn];
    _deleteBtn.frame = CGRectMake(0, 0, 50, 48);
    _deleteBtn.hidden = YES;
    [_deleteBtn addTarget:self action:@selector(deleteBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
}


- (void)setModel:(ParaMeterModel *)model{
    
    _model = model;
    _nameLab.text = model.ParaKind;
    _valueTxt.placeholder = [NSString stringWithFormat:@"请输入%@",model.ParaKind];
    _valueTxt.text = model.inputValue;
    if (model.isNew) {
        _deleteBtn.hidden = NO;
        _nameLab.frame = CGRectMake(50, 0, 100, 48);
    }else{
        _deleteBtn.hidden = YES;
        _nameLab.frame = CGRectMake(16, 0, 100, 48);

        
    }
    
}


-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    _model.inputValue = textField.text;
    
}


- (void)deleteBtnClick{
    
    if ([self.delegate respondsToSelector:@selector(didSelectedDeleteunitBtnWithCell:)]) {
        [self.delegate didSelectedDeleteunitBtnWithCell:self];
    }
}



@end
