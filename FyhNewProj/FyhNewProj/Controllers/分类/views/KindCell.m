//
//  KindCell.m
//  FyhNewProj
//
//  Created by yh f on 2017/4/15.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "KindCell.h"
#import "KindModel.h"
#import "GoodsLVOneModel.h"
#import "UIImage+WebP.h"
@implementation KindCell{


    CGFloat _viewWidth;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = UIColorFromRGB(WhiteColorValue);
        [self setUp];
    }
    
    return self;
}

- (void)setUp{
    _picture = [[UIImageView alloc]init];
   // _picture.backgroundColor = [UIColor orangeColor];
    [self.contentView addSubview:_picture];

    _nameLab = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(BlackColorValue) font:APPFONT(15) textAligment:NSTextAlignmentLeft andtext:@"胚布"];
    [self.contentView addSubview:_nameLab];

    UIImageView *rightView = [BaseViewFactory icomWithWidth:10 imagePath:@"right"];
    [self.contentView addSubview:rightView];
    rightView.sd_layout.rightSpaceToView(self.contentView ,20).centerYEqualToView(_picture).widthIs(10).heightIs(16);

     _viewWidth = ScreenWidth * 0.7;
    UIView *lineView = [BaseViewFactory viewWithFrame:CGRectMake(65, 49,ScreenWidth-65, 1) color:UIColorFromRGB(PlaColorValue)];
    [self.contentView addSubview:lineView];
    
}
-(void)layoutSubviews{
    
    
    _picture.sd_layout.leftSpaceToView(self.contentView,20).centerYEqualToView(self.contentView).widthIs(25).heightIs(25);
    
    
    _nameLab.sd_layout.leftSpaceToView(_picture,20).centerYEqualToView(_picture).rightSpaceToView(self.contentView,30).heightIs(20);
    
       
}

-(void)setModel:(GoodsLVOneModel *)model{

    _model = model;
    if (model.logoUrl) {
        [_picture sd_setImageWithURL:[NSURL URLWithString:model.logoUrl] placeholderImage:[UIImage imageNamed:@"Half"]];

    }else{
        _picture.image  = [UIImage imageNamed:@"Half"];
    }
   
    _nameLab.text = model.name;

}

@end
