//
//  ComponentCell.m
//  FyhNewProj
//
//  Created by yh f on 2017/11/8.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "ComponentCell.h"
#import "ParaMeterModel.h"
#import "ComponentModel.h"
#import "TwoUnitSelectedController.h"

@interface ComponentCell ()<UITextFieldDelegate>


@end


@implementation ComponentCell{
    
    NSInteger   _index;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = UIColorFromRGB(WhiteColorValue);
        
        [self setUP];
    }
    return self;
    
}

- (void)setUP{
    _nameLab  = [BaseViewFactory  labelWithFrame:CGRectMake(16, 0, 100, 48) textColor:UIColorFromRGB(PLAHColorValue) font:APPFONT(15) textAligment:NSTextAlignmentLeft andtext:@""];
    [self.contentView addSubview:_nameLab];
    
    UIImageView *rightImageView = [BaseViewFactory icomWithWidth:8 imagePath:@"ParaMeter_Down"];
    [self.contentView addSubview:rightImageView];
    rightImageView.frame = CGRectMake(ScreenWidth - 24, 20.5, 8, 7);
    
    
    
    _unitLab = [BaseViewFactory  labelWithFrame:CGRectMake(ScreenWidth - 102, 0, 72, 48) textColor:UIColorFromRGB(BlackColorValue) font:APPFONT(15) textAligment:NSTextAlignmentRight andtext:@""];
    [self.contentView addSubview:_unitLab];
    
    
    UILabel *lab = [BaseViewFactory  labelWithFrame:CGRectMake(ScreenWidth - 102, 0, 20, 48) textColor:UIColorFromRGB(BlackColorValue) font:APPFONT(15) textAligment:NSTextAlignmentRight andtext:@"%"];
    [self.contentView addSubview:lab];
    
    _valueTxt = [BaseViewFactory textFieldWithFrame:CGRectMake(128, 0, ScreenWidth - 128-102 -18, 48) font:APPFONT(15) placeholder:@"请输入数值" textColor:UIColorFromRGB(BlackColorValue) placeholderColor:UIColorFromRGB(PLAHColorValue) delegate:self];
    _valueTxt.textAlignment = NSTextAlignmentRight;
    _valueTxt.keyboardType = UIKeyboardTypeNumberPad;
    [self.contentView addSubview:_valueTxt];
    
    
    UIView *lineView = [BaseViewFactory viewWithFrame:CGRectMake(0, 47.5, ScreenWidth, 0.5) color:UIColorFromRGB(PLAHColorValue)];
    [self.contentView addSubview:lineView];
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:btn];
    btn.frame = CGRectMake(ScreenWidth - 102, 0, 102, 48);
    [btn addTarget:self action:@selector(unitBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)unitBtnClick{
    TwoUnitSelectedController *unVc = [[TwoUnitSelectedController alloc]init];
    unVc.Index = _index;
    unVc.model = _model;
    [[GlobalMethod getCurrentVC].navigationController pushViewController:unVc animated:YES];
}

- (void)setModel:(ParaMeterModel *)model{
    
    _model = model;
    _nameLab.text = model.ParaKind;
    
}

- (void)setModel:(ParaMeterModel *)model andIndex:(NSInteger)index{
    
    _model = model;
    _nameLab.text = model.ParaKind;
    _index = index;
    NSMutableDictionary *dic = model.componentModel.chenfenArr[index];
    _valueTxt.text = dic[COMPENTVALUE];
    _unitLab.text = dic[COMPENTUNIT];
    
}



- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    if (textField == _valueTxt) {
        NSMutableDictionary *dic = _model.componentModel.chenfenArr[_index];
        [dic setValue:_valueTxt.text forKey:COMPENTVALUE];
    }
    
    
}


@end
