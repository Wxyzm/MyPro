//
//  UserMemoCell.m
//  FyhNewProj
//
//  Created by yh f on 2017/7/28.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "UserMemoCell.h"

@implementation UserMemoCell{

    UIImageView *imageView;
    UILabel *melab;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = UIColorFromRGB(WhiteColorValue);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        UIView *line1 = [BaseViewFactory viewWithFrame:CGRectMake(0, 0, ScreenWidth, 1) color:UIColorFromRGB(LineColorValue)];
        [self.contentView addSubview:line1];
        [self setUp];
    }
    return self;
}

- (void)setUp{
    
    _memoLab = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(BlackColorValue) font:APPFONT(13) textAligment:NSTextAlignmentLeft andtext:@""];
    [self.contentView addSubview:_memoLab];
    
    imageView = [BaseViewFactory icomWithWidth:20 imagePath:@"goto_message"];
    [self.contentView addSubview:imageView];
    imageView.sd_layout.leftSpaceToView(self.contentView,20).centerYEqualToView(self.contentView).widthIs(20).heightIs(20);
    
    melab = [BaseViewFactory labelWithFrame:CGRectMake(50, 10, 100, 14) textColor:UIColorFromRGB(BlackColorValue) font:APPFONT(13) textAligment:NSTextAlignmentLeft andtext:@"买家留言"];
    [self.contentView addSubview:melab];
    
}

-(void)setMemoStr:(NSString *)memoStr{

    if (memoStr.length <=0) {
        return;
    }
//    NSData *jsonData = [memoStr dataUsingEncoding:NSUTF8StringEncoding];
//    NSMutableArray *dicArr = [NSJSONSerialization JSONObjectWithData:jsonData
//                                                        options:NSJSONReadingMutableContainers
//                                                          error:nil];
//    if (dicArr[0][@"memo"]) {
//        _memoStr = dicArr[0][@"memo"];
//
//    }
    _memoStr = memoStr;
    _memoLab.text = memoStr;
    _memoLab.sd_layout.leftSpaceToView(imageView,10).topSpaceToView(melab,8).widthIs(ScreenWidth - 70).autoHeightRatio(0);
    [_memoLab setMaxNumberOfLinesToShow:2];


}

@end
