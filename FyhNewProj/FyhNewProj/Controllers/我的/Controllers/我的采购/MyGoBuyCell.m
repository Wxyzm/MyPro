//
//  MyGoBuyCell.m
//  FyhNewProj
//
//  Created by yh f on 2017/4/14.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "MyGoBuyCell.h"
#import "MyNeedsModel.h"
@implementation MyGoBuyCell{
    BOOL _flag;
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

   

     _bgscrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 100)];
    [self.contentView   addSubview:_bgscrollView];
    _bgscrollView.contentSize = CGSizeMake(ScreenWidth +60, 0);
    _bgscrollView.showsVerticalScrollIndicator = NO;
    _bgscrollView.showsHorizontalScrollIndicator = NO;

    UITapGestureRecognizer *r5 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doTapChange:)];
    r5.numberOfTapsRequired = 1;
    [_bgscrollView addGestureRecognizer:r5];
    
 
//    UIButton *bgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    bgBtn.frame = CGRectMake(0, 0, ScreenWidth, 100);
//    [bgBtn addTarget:self action:@selector(bgBtnclick) forControlEvents:UIControlEventTouchUpInside];
    
    _picture = [[UIImageView alloc]init];
    _picture.clipsToBounds = YES;
    _picture.contentMode = UIViewContentModeScaleAspectFill;
    [_bgscrollView addSubview:_picture];
    
    _backImageView = [UIImageView new];
    _backImageView.contentMode = UIViewContentModeScaleToFill;
    _backImageView.clipsToBounds = YES;
    _backImageView.image = [UIImage imageNamed:@"result_background"];
    [_bgscrollView addSubview:_backImageView];

    
    _bgscrollView.bounces = NO;
    _bgscrollView.pagingEnabled = YES;
    
    _nameLab = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(BlackColorValue) font:APPFONT(13) textAligment:NSTextAlignmentLeft andtext:@""];
    _nameLab.numberOfLines = 2;
    
    _priceLab = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(RedColorValue) font:APPFONT(13) textAligment:NSTextAlignmentRight andtext:@""];

    _statuesLab = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(PlaColorValue) font:APPFONT(13) textAligment:NSTextAlignmentLeft andtext:@""];
    _kindLab = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(BlackColorValue) font:APPFONT(13) textAligment:NSTextAlignmentLeft andtext:@""];
    _dateLab  = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(PlaColorValue) font:APPFONT(15) textAligment:NSTextAlignmentRight andtext:@""];

    _acceptBtn = [SubBtn buttonWithtitle:@"接受报价" backgroundColor:UIColorFromRGB(RedColorValue) titlecolor:UIColorFromRGB(WhiteColorValue) cornerRadius:16 andtarget:self action:@selector(btnclick)];
    _acceptBtn.titleLabel.font = APPFONT(13);
    _acceptBtn.hidden = YES;
    
    [_bgscrollView addSubview:_nameLab];
    [_bgscrollView addSubview:_priceLab];
    [_bgscrollView addSubview:_statuesLab];
    [_bgscrollView addSubview:_kindLab];
    [_bgscrollView addSubview:_dateLab];

    [_bgscrollView addSubview:_acceptBtn];

    SubBtn *btn1 = [SubBtn buttonWithtitle:@"删除" titlecolor:UIColorFromRGB(WhiteColorValue) cornerRadius:0 andtarget:self action:@selector(shanchuBtnclick) andframe:CGRectMake(ScreenWidth, 0, 60, 50)];
    [_bgscrollView addSubview:btn1];
    SubBtn *btn2 = [SubBtn buttonWithtitle:@"编辑" backgroundColor:UIColorFromRGB(PlaColorValue) titlecolor:UIColorFromRGB(WhiteColorValue) cornerRadius:0 andtarget:self action:@selector(bianjiBtnclick)];
    btn2.frame = CGRectMake(ScreenWidth, 50, 60, 50);
    [_bgscrollView addSubview:btn2];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 99, ScreenWidth, 1)];
    [self.contentView addSubview:line];
    line.backgroundColor = UIColorFromRGB(LineColorValue);
}

//-(void)layoutSubviews{
//    
//    
//    }

- (void)shanchuBtnclick{

    if ([self.delegate respondsToSelector:@selector(didSelectedDeleteBtnWithcell:)]) {
        [self.delegate didSelectedDeleteBtnWithcell:self];
    }
}

- (void)bianjiBtnclick{

    if ([self.delegate respondsToSelector:@selector(didSelectedEditBtnWithcell:)]) {
        [self.delegate didSelectedEditBtnWithcell:self];
    }
}


//点击
-(void)doTapChange:(UITapGestureRecognizer *)sender{
    if ([self.delegate respondsToSelector:@selector(didSelectedBgBtnWithcell:)]) {
        [self.delegate didSelectedBgBtnWithcell:self];
    }
}

- (void)btnclick{
    if ([self.delegate respondsToSelector:@selector(didSelectedBgBtnWithcell:)]) {
        [self.delegate didSelectedBgBtnWithcell:self];
    }

}


-(void)setModel:(MyNeedsModel *)model{

    _model = model;
    NSArray *imageArr = model.imageUrlList;
    [_picture sd_setImageWithURL:[NSURL URLWithString:imageArr[0]] placeholderImage:nil];
    _nameLab.text = model.title;
       _kindLab.text = [NSString stringWithFormat:@"分类:%@",model.categoryName];
    
    if (model.quotations.count >0) {
        NSDictionary *zerodic = model.quotations[0];
        _priceDic = zerodic;
        CGFloat minPrice =  [zerodic[@"price"] floatValue];
        for (NSDictionary *dic in model.quotations) {
            if (minPrice > [dic[@"price"] floatValue]) {
                minPrice = [dic[@"price"] floatValue];
                _priceDic = dic;
            }
        }
        _priceLab.text = [NSString stringWithFormat:@"%.2f元/%@",minPrice,model.unit];
    }else{
        _priceLab.text =@"";

    }


    if ([model.status intValue] == 1) {
        _statuesLab.text = @"状态:审核中";
        _acceptBtn.hidden = YES;
        _priceLab.hidden = YES;

    }else if ([model.status intValue] == 3){
        _statuesLab.text = @"状态:未通过";
        _acceptBtn.hidden = YES;
        _priceLab.hidden = YES;


    }else if ([model.status intValue] == 4){
        _statuesLab.text = @"状态:进行中";
        _acceptBtn.hidden = YES;
        _priceLab.hidden = YES;


    }else if ([model.status intValue] == 6){
        _statuesLab.text = @"状态:报价中";
        _acceptBtn.hidden = NO;
        _priceLab.hidden = NO;


    }else if ([model.status intValue] == 9){
        _statuesLab.text = @"状态:已完成";
        _acceptBtn.hidden = YES;
        _priceLab.hidden = YES;


    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:@"YYYY-MM-dd"]; // （@"YYYY-MM-dd hh:mm:ss"）----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    
    [formatter setTimeZone:timeZone];
    
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[model.updateTime integerValue]];
    
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    _dateLab.text = confromTimespStr;
    
    
    _picture.sd_layout.leftSpaceToView(_bgscrollView,20).topSpaceToView(_bgscrollView,10).widthIs(80).heightIs(80);
    
    _backImageView.sd_layout.leftSpaceToView(_bgscrollView,20).topSpaceToView(_bgscrollView,10).widthIs(80).heightIs(80);
    _priceLab.sd_layout.rightSpaceToView(_bgscrollView,20).topSpaceToView(_bgscrollView,9).widthIs(80).heightIs(16);
    
    
    _nameLab.sd_layout.leftSpaceToView(_picture,20).topEqualToView(_picture).rightSpaceToView(_priceLab,5).autoHeightRatio(0);
    [_nameLab setMaxNumberOfLinesToShow:2];
    
    _kindLab.sd_layout.leftEqualToView(_nameLab).bottomEqualToView(_picture).rightEqualToView(_nameLab).heightIs(14);
    _statuesLab.sd_layout.leftEqualToView(_nameLab).bottomSpaceToView(_kindLab,5).rightEqualToView(_bgscrollView).heightIs(14);
    
    _dateLab.sd_layout.rightEqualToView(_priceLab).bottomEqualToView(_kindLab).widthIs(100).heightIs(14);
    _acceptBtn.sd_layout.centerYEqualToView(_bgscrollView).rightSpaceToView(_bgscrollView,20).heightIs(32).widthIs(70);

    
}



@end
