//
//  ThreeClassifyCell.m
//  FyhNewProj
//
//  Created by yh f on 2017/5/8.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "ThreeClassifyCell.h"
#import "GoodsLvThreeModel.h"

@implementation ThreeClassifyCell{
    
    NSMutableArray      *_imgViews;
    
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

    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
    lineView.backgroundColor = UIColorFromRGB(LineColorValue);
    [self.contentView addSubview:lineView];
    
    //图片摆放
    _imgViews = [NSMutableArray array];
    CGFloat imageWidth = (ScreenWidth - 50)/4;
    CGFloat imageHeight = 80;
    for (int i = 0; i<4; i++) {
        
        YLButton *btn =[YLButton buttonWithType:UIButtonTypeCustom];
        btn.tag = 30000+i;
        btn.frame = CGRectMake(10+(10+imageWidth)*i, 10, imageWidth, 110);
        [btn addTarget:self action:@selector(twoCategoryBtnClick:) forControlEvents:UIControlEventTouchUpInside];

        [self.contentView   addSubview:btn];
        UIImageView *topImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, imageWidth, imageHeight)];
        topImage.tag = 10000 + i;
        [btn addSubview:topImage];
        topImage.hidden = YES;
        UILabel *titleLab = [BaseViewFactory labelWithFrame: CGRectMake(0, 90, imageWidth, 14) textColor:UIColorFromRGB(BlackColorValue) font:APPFONT(13) textAligment:NSTextAlignmentCenter andtext:@""];
        [btn addSubview:titleLab];
        titleLab.tag = 20000+i;
        [_imgViews addObject:btn];
    }
    
    
    
    UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 119, ScreenWidth, 1)];
    lineView1.backgroundColor = UIColorFromRGB(LineColorValue);
    [self.contentView addSubview:lineView1];


}

- (void)twoCategoryBtnClick:(YLButton *)btn{
    if ([self.delegate respondsToSelector:@selector(didselectedItemWithBtn:andcell:)]) {
        [self.delegate didselectedItemWithBtn:btn andcell:self];
    }
    



}

-(void)setDataArr:(NSArray *)dataArr
{

    _dataArr = dataArr;
    for (int i = 0;i <dataArr.count;i++) {
        GoodsLvThreeModel *threeModel =  dataArr[i];
        
        YLButton *btn = _imgViews[i];
        btn.hidden = NO;
        UILabel *lab = (UILabel *)[btn viewWithTag:20000+i];
        lab.text = threeModel.name;
        UIImageView *imageView =  (UIImageView *)[btn viewWithTag:10000+i];
        imageView.hidden = NO;
        [imageView sd_setImageWithURL:[NSURL URLWithString:threeModel.logoUrl] placeholderImage:[UIImage imageNamed:@"loding"]];
    }


}


@end
