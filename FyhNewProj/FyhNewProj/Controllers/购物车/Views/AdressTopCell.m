//
//  AdressTopCell.m
//  FyhNewProj
//
//  Created by yh f on 2017/9/29.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "AdressTopCell.h"
#import "OrderAdressView.h"
#import "AdressModel.h"
@implementation AdressTopCell{
    OrderAdressView *adressView;

    
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = UIColorFromRGB(WhiteColorValue);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.clipsToBounds = YES;
        [self setUp];
    }
    return self;
}


- (void)setUp{
   
    adressView = [[OrderAdressView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 140)];
    [self.contentView addSubview:adressView ];
    

}

-(void)setModel:(AdressModel *)model{
        _model = model;
        adressView.model = _model;
        if (_isSelectedAdress) {
        adressView.frame = CGRectMake(0, 0, ScreenWidth, _Heigh);
            [adressView showAdress];
    
        }else{
            adressView.frame = CGRectMake(0, 0, ScreenWidth, 140);
            [adressView showAddAdressView];
    
        }
    
}

@end
