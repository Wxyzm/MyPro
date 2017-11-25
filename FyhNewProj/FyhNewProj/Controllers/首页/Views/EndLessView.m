//
//  EndLessView.m
//  FyhNewProj
//
//  Created by yh f on 2017/6/24.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "EndLessView.h"

@implementation EndLessView

-(instancetype)init{

    self = [super init];
    if (self) {
        [self setUP];
    }

    return self;
}


- (void)setUP{

    _faceImageView = [[UIImageView alloc]init];
    [self addSubview:_faceImageView];
    _faceImageView.frame = CGRectMake(125, 35 , 50, 50);
    _faceImageView.layer.cornerRadius = 25;
    _faceImageView.clipsToBounds = YES;
    
    
    _nameLab = [BaseViewFactory labelWithFrame:CGRectMake(0, 100, 300, 15) textColor:UIColorFromRGB(0x434a54) font:APPFONT(15) textAligment:NSTextAlignmentCenter andtext:@""];
    [self addSubview:_nameLab];
    
    
    _adressLab = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(0xaab2bd) font:APPFONT(14) textAligment:NSTextAlignmentCenter andtext:@""];
     _adressLab.layer.cornerRadius = 12.5;
    _adressLab.layer.borderColor = UIColorFromRGB(0xc546fb).CGColor;
    _adressLab.layer.borderWidth = 1;
    //CGRectMake(0, 120, 300, 11)
    [self addSubview:_adressLab];
    
    
    
    UIButton *selecBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [selecBtn addTarget:self action:@selector(selecBtnClick) forControlEvents:UIControlEventTouchUpInside];
    selecBtn.frame = CGRectMake(0, 0, 300, 289);
    [self addSubview:selecBtn];

    _goods1 = [[UIImageView alloc]init];
    [self addSubview:_goods1];
    _goods1.frame = CGRectMake(20, 189, 80, 80);
    _goods1.userInteractionEnabled = YES;
    _btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    _btn1.frame = CGRectMake(0, 0, 80, 80);
    [_goods1 addSubview:_btn1];
    [_btn1 addTarget:self action:@selector(btn1Click) forControlEvents:UIControlEventTouchUpInside];
    
    _goods2 = [[UIImageView alloc]init];
    [self addSubview:_goods2];
    _goods2.frame = CGRectMake(110, 189, 80, 80);
    _goods2.userInteractionEnabled = YES;

    _btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    _btn2.frame = CGRectMake(0, 0, 80, 80);
    [_goods2 addSubview:_btn2];
    [_btn2 addTarget:self action:@selector(btn2Click) forControlEvents:UIControlEventTouchUpInside];

    
    _goods3 = [[UIImageView alloc]init];
    [self addSubview:_goods3];
    _goods3.userInteractionEnabled = YES;

    _goods3.frame = CGRectMake(200, 189, 80, 80);
   _btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    _btn3.frame = CGRectMake(0, 0, 80, 80);
    [_goods3 addSubview:_btn3];
    [_btn3 addTarget:self action:@selector(btn3Click) forControlEvents:UIControlEventTouchUpInside];

    if (iPad) {
        _faceImageView.frame = CGRectMake(125*TimeScaleY, 35*TimeScaleY , 50*TimeScaleY, 50*TimeScaleY);
        _faceImageView.layer.cornerRadius = 50*TimeScaleY/2;

        _nameLab.frame = CGRectMake(0, 100*TimeScaleY , 300*TimeScaleY, 15*TimeScaleY);
        selecBtn.frame = CGRectMake(0, 0, 300*TimeScaleY, 289*TimeScaleY);
        _goods1.frame = CGRectMake(20*TimeScaleY, 189*TimeScaleY, 80*TimeScaleY, 80*TimeScaleY);
        _goods2.frame = CGRectMake(110*TimeScaleY, 189*TimeScaleY, 80*TimeScaleY, 80*TimeScaleY);
        _goods3.frame = CGRectMake(200*TimeScaleY, 189*TimeScaleY, 80*TimeScaleY, 80*TimeScaleY);
        _btn1.frame = CGRectMake(0, 0, 80*TimeScaleY, 80*TimeScaleY);
        _btn2.frame = CGRectMake(0, 0, 80*TimeScaleY, 80*TimeScaleY);
        _btn3.frame = CGRectMake(0, 0, 80*TimeScaleY, 80*TimeScaleY);

    }
    
}


- (void)setDataDic:(NSMutableDictionary *)dataDic{

    _dataDic = dataDic;
    if (!dataDic) {
        return;
    }
    
    [_faceImageView sd_setImageWithURL:[NSURL URLWithString:dataDic[@"imageUrl"]] placeholderImage:[UIImage imageNamed:@"loding"]];
    _nameLab.text = dataDic[@"title"];
    _adressLab.text = dataDic[@"tags"];
    NSDictionary *attrs = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:14]};
    CGSize Size_str=[dataDic[@"tags"] sizeWithAttributes:attrs];

    if (iPad) {
        _adressLab.sd_layout.centerXEqualToView(self).topSpaceToView(self,140*TimeScaleY).heightIs(25*TimeScaleY).widthIs(Size_str.width+10);

    }else{
        _adressLab.sd_layout.centerXEqualToView(self).topSpaceToView(self,140).heightIs(25).widthIs(Size_str.width+10);
    }
    NSArray *arr = dataDic[@"itemList"];
    if (arr[0]) {
        [_goods1 sd_setImageWithURL:arr[0][@"imageUrl"] placeholderImage:[UIImage imageNamed:@"loding"]];
    }
    if (arr.count>1) {
        [_goods2 sd_setImageWithURL:arr[1][@"imageUrl"] placeholderImage:[UIImage imageNamed:@"loding"]];
    }
    if (arr.count>2) {
        [_goods3 sd_setImageWithURL:arr[2][@"imageUrl"] placeholderImage:[UIImage imageNamed:@"loding"]];
    }

    

}

- (void)selecBtnClick{

    if ([self.delegate respondsToSelector:@selector(didSelectedBtnWithEndLessViewDic:)]) {
        [self.delegate didSelectedBtnWithEndLessViewDic:_dataDic];
    }
    



}

- (void)btn1Click{
    NSArray *arr = _dataDic[@"itemList"];
    if (!arr[0]) {
        return;
    }
    if ([self.delegate respondsToSelector:@selector(didSelectedBtnWithDic:)]) {
        [self.delegate didSelectedBtnWithDic:arr[0]];
    }

}


- (void)btn2Click{
    NSArray *arr = _dataDic[@"itemList"];

    if (arr.count<2) {
        return;
    }
    if (!arr[1]) {
        return;
    }
    if ([self.delegate respondsToSelector:@selector(didSelectedBtnWithDic:)]) {
        [self.delegate didSelectedBtnWithDic:arr[1]];
    }

}

- (void)btn3Click{
    NSArray *arr = _dataDic[@"itemList"];
    if (arr.count<3) {
        return;
    }
    if (!arr[2]) {
        return;
    }
    if ([self.delegate respondsToSelector:@selector(didSelectedBtnWithDic:)]) {
        [self.delegate didSelectedBtnWithDic:arr[2]];
    }

}

@end
