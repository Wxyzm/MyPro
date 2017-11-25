//
//  IdeaGoodsListCell.m
//  FyhNewProj
//
//  Created by yh f on 2017/6/14.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "IdeaGoodsListCell.h"
#import "IdeaCellModel.h"

@interface IdeaGoodsListCell ()<UITextFieldDelegate>

@end

@implementation IdeaGoodsListCell{


    CGFloat _OriginX;
    UILabel *_stolab;
    UILabel *_pricelab;
    BOOL   isHaveDian;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = UIColorFromRGB(WhiteColorValue);
        _OriginX = 44;
        [self setUp];
    }
    return self;
}

- (void)setUp{
    UIView *topView = [BaseViewFactory  viewWithFrame:CGRectMake(0, 100, ScreenWidth, 12) color:UIColorFromRGB(LineColorValue)];
    [self.contentView addSubview:topView];
    
    UIView *lineView= [BaseViewFactory viewWithFrame:CGRectMake(100, 29, ScreenWidth -100 , 1) color:UIColorFromRGB(LineColorValue)];
    [self.contentView addSubview:lineView];

    
    _selectBtn = [YLButton buttonWithType:UIButtonTypeCustom];
    [_selectBtn setImage:[UIImage imageNamed:@"circle-40"] forState:UIControlStateNormal];
    [_selectBtn setImageRect:CGRectMake(10, 10, 20, 20)];
    [self.contentView addSubview:_selectBtn];
    [_selectBtn addTarget:self action:@selector(shopCartGoodBtnClick) forControlEvents:UIControlEventTouchUpInside];
    _selectBtn.hidden = YES;
    
    
    _faceImageView = [[UIImageView alloc]init];
    [self.contentView addSubview:_faceImageView];
    
    _upImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:_upImageBtn];
    [_upImageBtn addTarget:self action:@selector(upImageBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_upImageBtn setImage:[UIImage imageNamed:@"Upload"] forState:UIControlStateNormal];
    
    _kindLab = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(0x434a54) font:APPFONT(13) textAligment:NSTextAlignmentLeft andtext:@"JPG"];
    [self.contentView addSubview:_kindLab];
 
    _useLab = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(0x434a54) font:APPFONT(13) textAligment:NSTextAlignmentLeft andtext:@"授权使用"];
    [self.contentView addSubview:_useLab];
    
    
    
    
    _stolab = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(0x434a54) font:APPFONT(13) textAligment:NSTextAlignmentLeft andtext:@"库存:"];
    [self.contentView addSubview:_stolab];
    
    _pricelab = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(0x434a54) font:APPFONT(13) textAligment:NSTextAlignmentLeft andtext:@"价格:"];
    [self.contentView addSubview:_pricelab];

    
    _stockTxt = [BaseViewFactory textFieldWithFrame:CGRectZero font:APPFONT(13) placeholder:@"" textColor:UIColorFromRGB(0x434a54) placeholderColor:UIColorFromRGB(0x434a54) delegate:self];
//    _stockTxt.userInteractionEnabled = NO;
    _stockTxt.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_stockTxt];
    _stockTxt.keyboardType = UIKeyboardTypeNumberPad;
    _stockTxt.layer.cornerRadius = 5;
    _stockTxt.layer.borderColor = UIColorFromRGB(LineColorValue).CGColor;
    _stockTxt.layer.borderWidth = 1;

    
    _priceTxt = [BaseViewFactory textFieldWithFrame:CGRectZero font:APPFONT(13) placeholder:@"" textColor:UIColorFromRGB(0x434a54) placeholderColor:UIColorFromRGB(0x434a54) delegate:self];
//    _priceTxt.userInteractionEnabled = NO;
    _priceTxt.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_priceTxt];
    _priceTxt.keyboardType = UIKeyboardTypeDecimalPad;
    _priceTxt.layer.cornerRadius = 5;
    _priceTxt.layer.borderColor = UIColorFromRGB(LineColorValue).CGColor;
    _priceTxt.layer.borderWidth = 1;

    [self layoutFrame];
    
}


/**
 选中
 */
- (void)shopCartGoodBtnClick{

    _model.select = !_model.select;
    if (_model.select) {
        [_selectBtn setImage:[UIImage imageNamed:@"iv_cart_chose"] forState:UIControlStateNormal];

    }else{
        [_selectBtn setImage:[UIImage imageNamed:@"circle-40"] forState:UIControlStateNormal];

    }
    
}


- (void)layoutFrame{
    
    if (_model.isopen) {
        _selectBtn.frame = CGRectMake(0, 32, 44, 44);
        _faceImageView.frame = CGRectMake(_OriginX, 0, 100, 100);
        _upImageBtn.frame = CGRectMake(_OriginX, 0, 100, 100);
        CGFloat  WIDTH = (ScreenWidth - 100 -35 - 36)/3;
        _kindLab.frame = CGRectMake(112+_OriginX, 0,WIDTH , 30);
        _useLab.frame = CGRectMake(_kindLab.right+12+_OriginX,0,WIDTH , 30);
        
        _stolab.frame =  CGRectMake(112+_OriginX, 52,39 , 30);
        _pricelab.frame =  CGRectMake( (ScreenWidth - 100 -35)/2+112+_OriginX, 52,39 , 30);
        _stockTxt.frame = CGRectMake(_stolab.right, 54.5, 70, 25);
        _priceTxt.frame = CGRectMake(_pricelab.right, 54.5, 70, 25);
        _selectBtn.hidden = NO;


    }else{
        _selectBtn.frame = CGRectMake(0, 32, 44, 44);
        _faceImageView.frame = CGRectMake(0, 0, 100, 100);
        _upImageBtn.frame = CGRectMake(0, 0, 100, 100);
        CGFloat  WIDTH = (ScreenWidth - 100 -35 - 36)/3;
        _kindLab.frame = CGRectMake(112, 0,WIDTH , 30);
        _useLab.frame = CGRectMake(_kindLab.right+12,0,WIDTH , 30);
        
        _stolab.frame =  CGRectMake(112, 52,39 , 30);
        _pricelab.frame =  CGRectMake( (ScreenWidth - 100 -35)/2+112, 52,39 , 30);
        _stockTxt.frame = CGRectMake(_stolab.right, 54.5, 70, 25);
        _priceTxt.frame = CGRectMake(_pricelab.right, 54.5, 70, 25);
        _selectBtn.hidden = YES;

    }

    

}


- (void)upImageBtnClick{
    if ([self.delegate respondsToSelector:@selector(didSelectedUpImagedBtnWithModel:)]) {
        [self.delegate didSelectedUpImagedBtnWithModel:_model];
    }


}


-(void)setModel:(IdeaCellModel *)model{

    _model = model;
    [self layoutFrame];
    
    if (model.image) {
        _faceImageView.image = model.image;
    }else{
        if (model.mainImageUrl.length >0) {
            [_faceImageView sd_setImageWithURL:[NSURL URLWithString:model.mainImageUrl] placeholderImage:[UIImage imageNamed:@"loding"]];
        }
    
    }
    _kindLab.text = model.kind;
    _useLab.text = model.use;
    if (model.stock >=0) {
        _stockTxt.text = [NSString stringWithFormat:@"%ld",model.stock];

    }
    if ([model.price floatValue]>0) {
        _priceTxt.text = model.price;

    }

    if (_model.select) {
        [_selectBtn setImage:[UIImage imageNamed:@"iv_cart_chose"] forState:UIControlStateNormal];
        
    }else{
        [_selectBtn setImage:[UIImage imageNamed:@"circle-40"] forState:UIControlStateNormal];
        
    }


}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    if (textField == _stockTxt) {
        if ([_stockTxt.text length]<=0) {
            _model.stock = -1;
        }else{
            _model.stock = [_stockTxt.text integerValue];

        }
        
        
    }else if (textField == _priceTxt){
        if ([_priceTxt.text length]<=0) {
            _model.price = @"-1";
        }else{
            _model.price = _priceTxt.text;
            
        }

        
    }


    return  YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == _priceTxt) {
        if ([textField.text rangeOfString:@"."].location == NSNotFound)
        {
            isHaveDian = NO;
        }else{
            isHaveDian = YES;
        }
        if ([string length] > 0)
        {
            unichar single = [string characterAtIndex:0];//当前输入的字符
            if ((single >= '0' && single <= '9') || single == '.')//数据格式正确
            {
                //首字母不能为0和小数点
                if([textField.text length] == 0)
                {
                    
                    if(single == '.')
                    {
                        
                        //  [self showMyMessage:@"亲，第一个数字不能为小数点!"];
                        
                        [textField.text stringByReplacingCharactersInRange:range withString:@""];
                        
                        return NO;
                        
                    }
                    
                    //                if (single == '0')
                    //                {
                    //
                    //                 //   [self showMyMessage:@"亲，第一个数字不能为0!"];
                    //
                    //                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    //
                    //                    return NO;
                    //
                    //                }
                    
                }
                
                //输入的字符是否是小数点
                
                if (single == '.')
                {
                    
                    if(!isHaveDian)//text中还没有小数点
                    {
                        
                        isHaveDian = YES;
                        
                        return YES;
                        
                    }else{
                        
                        //   [self showMyMessage:@"亲，您已经输入过小数点了!"];
                        
                        [textField.text stringByReplacingCharactersInRange:range withString:@""];
                        
                        return NO;
                        
                    }
                    
                }else{
                    
                    if (isHaveDian) {//存在小数点
                        
                        //判断小数点的位数
                        
                        NSRange ran = [textField.text rangeOfString:@"."];
                        
                        if (range.location - ran.location <= 2) {
                            
                            return YES;
                            
                        }else{
                            
                            //    [self showMyMessage:@"亲，您最多输入两位小数!"];
                            
                            return NO;
                            
                        }
                        
                    }else{
                        
                        return YES;
                        
                    }
                    
                }
                
            }else{//输入的数据格式不正确
                
                //   [self showMyMessage:@"亲，您输入的格式不正确!"];
                
                [textField.text stringByReplacingCharactersInRange:range withString:@""];
                
                return NO;
                
            }
            
        }
        
        else
            
        {
            
            return YES;
            
        }
    }
   
   return YES;
    
}


@end
