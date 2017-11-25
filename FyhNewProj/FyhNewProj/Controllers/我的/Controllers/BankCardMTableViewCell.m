//
//  BankCardMTableViewCell.m
//  FyhNewProj
//
//  Created by yh f on 2017/9/14.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "BankCardMTableViewCell.h"
#import "BankCardModel.h"

@implementation BankCardMTableViewCell{

    UIImageView *_bg_ImageView;             //银行背景图
        UILabel *_bankmunber_Lab;           //银行尾号

}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = UIColorFromRGB(0x393d42);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setUp];
    }
    return self;
}


- (void)setUp{

    _bg_ImageView = [[UIImageView alloc]init];
    _bg_ImageView.layer.cornerRadius = 5;
    _bg_ImageView.clipsToBounds = YES;
    [self.contentView addSubview:_bg_ImageView];
    _bg_ImageView.sd_layout.leftSpaceToView(self.contentView, 12)
                           .rightSpaceToView(self.contentView, 12)
                           .bottomEqualToView(self.contentView)
                           .heightIs(110);
    
    _bankmunber_Lab = [BaseViewFactory labelWithFrame:CGRectZero
                                            textColor:UIColorFromRGB(WhiteColorValue)
                                                 font:[UIFont boldSystemFontOfSize:24]
                                         textAligment:NSTextAlignmentCenter
                                              andtext:@"0000"];
    [_bg_ImageView addSubview:_bankmunber_Lab];
    _bankmunber_Lab.sd_layout
                   .rightSpaceToView(_bg_ImageView, 28)
                   .topSpaceToView(_bg_ImageView, 68)
                   .heightIs(25);
    [_bankmunber_Lab setSingleLineAutoResizeWithMaxWidth:0];
    
    
    CGFloat width = (ScreenWidth - 61-28-24 - 60)/3;
    for (int i = 0; i<3; i++) {
        
        
        UILabel *lab = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(WhiteColorValue) font:APPFONT(18) textAligment:NSTextAlignmentLeft andtext:@"****"];
        [_bg_ImageView addSubview:lab];
        lab.sd_layout
           .leftSpaceToView(_bg_ImageView, 61+width *i)
           .topSpaceToView(_bg_ImageView, 68)
           .heightIs(25)
           .widthIs(width);

        
    }
    
    
    
}


-(void)setModel:(BankCardModel *)model{

    _model = model;
    
    if ([model.bankName isEqualToString:@"中国农业银行"]) {
        _bg_ImageView.image = [UIImage imageNamed:@"Ass-NYBK"];
        
    }else if ([model.bankName isEqualToString:@"中国工商银行"]){
        _bg_ImageView.image = [UIImage imageNamed:@"Ass-GSBK"];
    
    }else if ([model.bankName isEqualToString:@"中国招商银行"]){
        _bg_ImageView.image = [UIImage imageNamed:@"Ass-ZSBK"];
        
    }else if ([model.bankName isEqualToString:@"中国银行"]){
        _bg_ImageView.image = [UIImage imageNamed:@"Ass-BK"];

    }else if ([model.bankName isEqualToString:@"中国交通银行"]){
        _bg_ImageView.image = [UIImage imageNamed:@"Ass-JTBK"];
        
    }else if ([model.bankName isEqualToString:@"中国建设银行"]){
        _bg_ImageView.image = [UIImage imageNamed:@"Ass-JSBK"];
        
    }
    if (model.bankAccountNumber.length>5) {
        _bankmunber_Lab.text = [model.bankAccountNumber substringFromIndex:model.bankAccountNumber.length-4];

    }
    _bg_ImageView.sd_layout.leftSpaceToView(self.contentView, 12)
    .rightSpaceToView(self.contentView, 12)
    .bottomEqualToView(self.contentView)
    .heightIs(110);

}

@end
