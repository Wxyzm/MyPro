//
//  OrderAdressView.m
//  FyhNewProj
//
//  Created by yh f on 2017/4/17.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "OrderAdressView.h"
#import "AdressModel.h"

@implementation OrderAdressView{

    UIImageView *_topImageView;
    UIImageView *_faceView;
    UILabel     *_addLab;
    UIImageView *_downImageView;
    SubBtn      *_leftBn;
    UIView      *_garyView;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        [self setUP];
    }
    return self;
}

- (void)setUP{


    _faceView = [[UIImageView alloc]init];
    [self addSubview:_faceView];
    _faceView.image = [UIImage imageNamed:@"position"];
    [UIImage imageNamed:@"position"];
    
    
    _nameLab = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(BlackColorValue) font:APPFONT(13) textAligment:NSTextAlignmentLeft andtext:@""];
    [self addSubview:_nameLab];

    _phoneLab = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(BlackColorValue) font:APPFONT(13) textAligment:NSTextAlignmentRight andtext:@""];
    [self addSubview:_phoneLab];

    _adressLab = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(BlackColorValue) font:APPFONT(13) textAligment:NSTextAlignmentLeft andtext:@""];
    [self addSubview:_adressLab];

    _topImageView = [BaseViewFactory icomWithWidth:64 imagePath:@"128"];
    [self addSubview:_topImageView];
    
    _addLab = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(BlackColorValue) font:APPFONT(15) textAligment:NSTextAlignmentCenter andtext:@"还没有收货地址，去添加"];
    [self addSubview:_addLab];

    NSString *str1 = @"去添加";
    NSRange range1 = [_addLab.text rangeOfString:str1];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:_addLab.text];
    [str addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(RedColorValue) range:range1];
    _addLab.attributedText = str;
    
    
    _downImageView = [BaseViewFactory icomWithWidth:ScreenWidth imagePath:@"caidai"];
     [self addSubview:_downImageView];
    
 
}


-(void)setModel:(AdressModel *)model{

    _model = model;

    _nameLab.text = [NSString stringWithFormat:@"%@",model.consigneeName];
    _phoneLab.text = [NSString stringWithFormat:@"电话 :%@",model.mobile];
    _adressLab.text = [NSString stringWithFormat:@"地址:%@-%@-%@  %@",model.province,model.city,model.area,model.consigneeAddress];
}

-(void)showAdress{
    
    CGFloat height = [GlobalMethod heightForString:_adressLab.text andWidth:ScreenWidth - 70 andFont:APPFONT(13)];  //42+height
    
    
    
    
    _faceView.sd_layout.leftSpaceToView(self,20).centerYIs((42+height)/2).widthIs(20).heightIs(20);
     _nameLab.sd_layout.leftSpaceToView(_faceView,10).topSpaceToView(self,10).widthIs(200).heightIs(14);
    _phoneLab.sd_layout.rightSpaceToView(self,20).topSpaceToView(self,10).widthIs(200).heightIs(14);
    _adressLab.sd_layout.leftSpaceToView(_faceView,10).topSpaceToView(_nameLab,8).widthIs(ScreenWidth - 70).heightIs(height);
    _adressLab.numberOfLines = 0;
    
    _downImageView.frame = CGRectMake(0, 38+height, ScreenWidth, 4);

    _topImageView.hidden = YES;
    _addLab.hidden = YES;
    
    _faceView.hidden = NO;
    _nameLab.hidden = NO;
    _phoneLab.hidden = NO;
    _adressLab.hidden = NO;
    
//    _nameLab.frame = CGRectMake(100, 27, 160, 40);
//    _phoneLab.frame = CGRectMake(ScreenWidth-180, 27, 160, 40);
//    _adressLab.frame = CGRectMake(100, 50, ScreenWidth-110, 40);
//    _downImageView.frame = CGRectMake(0, 96, ScreenWidth, 4);
    
  //  _garyView.frame = CGRectMake(0, 100, ScreenWidth, 12);
}


-(void)showAddAdressView{
    _topImageView.hidden = NO;
    _addLab.hidden = NO;

    _faceView.hidden = YES;
    _nameLab.hidden = YES;
    _phoneLab.hidden = YES;
    _adressLab.hidden = YES;
    
    
    _topImageView.frame = CGRectMake(ScreenWidth/2 - 32, 20, 64, 64);
    _addLab.frame = CGRectMake(0, 99, ScreenWidth, 16);
    _downImageView.frame = CGRectMake(0, 136, ScreenWidth, 4);
   // _garyView.frame = CGRectMake(0, 140, ScreenWidth, 12);
//

}


@end
