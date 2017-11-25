//
//  ClassifyCell.m
//  FyhNewProj
//
//  Created by yh f on 2017/4/13.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "ClassifyCell.h"
#import "GoodsLvTwoModel.h"
#import "GoodsLvThreeModel.h"


@implementation ClassifyCell{

    NSMutableArray      *_imgViews;
    NSMutableArray      *_Btns;


}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = UIColorFromRGB(WhiteColorValue);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setUp];
    }

    return self;
}

- (void)setUp{

    _namelab = [BaseViewFactory labelWithFrame:CGRectMake(20, 0, 200, 39) textColor:UIColorFromRGB(BlackColorValue) font:APPFONT(15) textAligment:NSTextAlignmentLeft andtext:@"涤棉"];
    [self.contentView addSubview:_namelab];
    
    _moreBtn = [YLButton buttonWithType:UIButtonTypeCustom];
    _moreBtn.titleLabel.font =APPFONT(13);
    [_moreBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [_moreBtn setTitle:@"更多" forState:UIControlStateNormal];
    [_moreBtn setTitleColor:UIColorFromRGB(PlaColorValue) forState:UIControlStateNormal];
    [_moreBtn setImage:[UIImage imageNamed:@"right"] forState:UIControlStateNormal];
    [_moreBtn setImageRect:CGRectMake(50, 11.5, 10, 16)];
    [_moreBtn setTitleRect:CGRectMake(0, 0, 45, 39)];
    [self.contentView addSubview:_moreBtn];
    _moreBtn.frame = CGRectMake(ScreenWidth - 80, 0, 60, 39);
    [_moreBtn addTarget:self action:@selector(moreBtnclick) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 38.5, ScreenWidth, 1)];
    lineView.backgroundColor = UIColorFromRGB(LineColorValue);
    [self.contentView addSubview:lineView];
   
    //图片摆放
    _imgViews = [NSMutableArray array];
    _Btns = [NSMutableArray array];
    CGFloat imageWidth = (ScreenWidth - 50)/4;
    CGFloat imageHeight = imageWidth;
    for (int i = 0; i<4; i++) {
        
        
        UIImageView *topImage = [[UIImageView alloc]initWithFrame:CGRectMake(10+(10+imageWidth)*i, 49, imageWidth, imageHeight)];
        topImage.backgroundColor = UIColorFromRGB(WhiteColorValue);
        topImage.clipsToBounds = YES;
        topImage.tag = 20000+i;
        [self.contentView addSubview:topImage];
        [_imgViews  addObject:topImage];
        
        UIImageView *   _backImageView = [UIImageView new];
        _backImageView.frame = CGRectMake(0, 0, imageWidth, imageHeight);
        _backImageView.contentMode = UIViewContentModeScaleToFill;
        _backImageView.clipsToBounds = YES;
        _backImageView.image = [UIImage imageNamed:@"result_background"];
        [topImage addSubview:_backImageView];
        


        YLButton *btn =[YLButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(10+(10+imageWidth)*i, 49, imageWidth,imageHeight+30);
        [btn addTarget:self action:@selector(twoCategoryBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView   addSubview:btn];
        btn.tag = 10000+i;
        
        UILabel *titleLab = [BaseViewFactory labelWithFrame: CGRectMake(0, imageHeight +10, imageWidth, 14) textColor:UIColorFromRGB(BlackColorValue) font:APPFONT(13) textAligment:NSTextAlignmentCenter andtext:@""];
        [btn addSubview:titleLab];
        titleLab.tag = 20000;
        [_Btns  addObject:btn];
        
           }
    



    
    UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 49+imageHeight+30, ScreenWidth, 12)];
    lineView1.backgroundColor = UIColorFromRGB(LineColorValue);
    [self.contentView addSubview:lineView1];
}


-(void)setGoodModel:(GoodsLvTwoModel *)goodModel{
    _goodModel = goodModel;
    
    _namelab.text = goodModel.name;
    NSInteger imageNum = goodModel.threeModelArr.count;
    if (goodModel.threeModelArr.count>4) {
        imageNum = 4;
    }
    for (YLButton *btn in _Btns ) {
        btn.hidden = YES;
    }
    for (UIImageView *imageview in _imgViews ) {
        imageview.hidden = YES;
    }
    for (int i = 0;i <imageNum;i++) {
        GoodsLvThreeModel *threeModel =  goodModel.threeModelArr[i];
        
        YLButton *btn = _Btns[i];
        btn.hidden = NO;
        UILabel *lab = (UILabel *)[btn viewWithTag:20000];
        lab.text = threeModel.name;
        UIImageView *imageView = _imgViews[i];
        imageView.hidden = NO;
        [imageView sd_setImageWithURL:[NSURL URLWithString:threeModel.logoUrl] placeholderImage:[UIImage imageNamed:@"loding"]];
    }

}


#pragma mark ===== 按钮点击

- (void)moreBtnclick{

    if ([self.delegate respondsToSelector:@selector(didselectedMoreBtnwithcell:)]) {
        [self.delegate didselectedMoreBtnwithcell:self];
    }

}
- (void)twoCategoryBtnClick:(YLButton *)button{

    if ([self.delegate respondsToSelector:@selector(didselectedItemWithBtn:andcell:)]) {
        [self.delegate didselectedItemWithBtn:button andcell:self];
    }


}


@end
