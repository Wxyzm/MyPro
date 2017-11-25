//
//  DrawalRequestListCell.m
//  FyhNewProj
//
//  Created by yh f on 2017/9/18.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "DrawalRequestListCell.h"
#import "WithdrawalListModel.h"
@implementation DrawalRequestListCell{
    
    UILabel *_leftLab;
    UILabel *_moneyLab;
    UILabel *_timeLab;
    UILabel *_memoLab;

    
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
    
    UIView *lineView = [BaseViewFactory viewWithFrame:CGRectMake(0, 0, ScreenWidth, 1) color:UIColorFromRGB(LineColorValue)];
    [self.contentView addSubview:lineView];
    
    _leftLab = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(0x434a54) font:APPFONT(15) textAligment:NSTextAlignmentLeft andtext:@""];
    [self.contentView addSubview:_leftLab];
    
    _memoLab = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(0xaab2bd) font:APPFONT(12) textAligment:NSTextAlignmentLeft andtext:@""];
    [self.contentView addSubview:_memoLab];
    
    _moneyLab = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(0x434a54) font:APPFONT(16) textAligment:NSTextAlignmentRight andtext:@""];
    [self.contentView addSubview:_moneyLab];
    
    _timeLab = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(0xaab2bd) font:APPFONT(12) textAligment:NSTextAlignmentRight andtext:@""];
    [self.contentView addSubview:_timeLab];
}


-(void)setModel:(WithdrawalListModel *)model {

    NSString *status;
    switch (model.status) {
        case 0:{
            status = @"提现申请中";
            break;
        }
        case 1:{
            status = @"提现通过";

            break;
        }
        case 2:{
            status = @"提现取消";

            break;
        }
        case 3:{
            status = @"提现失败";

            break;
        }
        case 4:{
            status = @"提现异常处理中";

            break;
        }
       
        default:
            break;
    }
    _leftLab.text = status;
    _memoLab.text = model.memo;
    
    _moneyLab.text = [NSString stringWithFormat:@"￥%@",model.amount];
    _timeLab.text = [GlobalMethod returnTimeStrWith:model.createTime];
    
    if (model.memo.length <= 0 ) {
        _leftLab.sd_layout.leftSpaceToView(self.contentView, 16).centerYEqualToView(self.contentView).widthIs(200).heightIs(50);
        _memoLab.hidden = YES;
    }else{
        _leftLab.sd_layout.leftSpaceToView(self.contentView, 16).topSpaceToView(self.contentView, 7.5) .widthIs(200).heightIs(16);
        _memoLab.hidden = NO;
        _memoLab.sd_layout.leftSpaceToView(self.contentView, 16).topSpaceToView(_leftLab, 7).widthIs(ScreenWidth - 140).heightIs(13);

    }
    
     _moneyLab.sd_layout.rightSpaceToView(self.contentView, 16).topSpaceToView(self.contentView, 7.5) .widthIs(200).heightIs(16);
    
    _timeLab.sd_layout.rightSpaceToView(self.contentView, 16).topSpaceToView(_moneyLab, 8).widthIs(140).heightIs(12);
}

@end
