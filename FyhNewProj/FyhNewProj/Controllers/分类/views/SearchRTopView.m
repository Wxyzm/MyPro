//
//  SearchRTopView.m
//  FyhNewProj
//
//  Created by yh f on 2017/5/22.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "SearchRTopView.h"

@implementation SearchRTopView{
    CGFloat         _width;
    NSMutableArray *_btnArr;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorFromRGB(WhiteColorValue);
        _btnArr = [NSMutableArray arrayWithCapacity:0];
        [self setupUI];
        
    }

    return self;
}

- (void)setupUI{

    _width = ScreenWidth/4;
    _allBtn = [YLButton buttonWithType:UIButtonTypeCustom];
    _allBtn.frame = CGRectMake(0, 0,_width, 40);
    [_btnArr addObject:_allBtn];
    _allBtn.tag = 10001;
    [self setThebtntitle:@"综合" AndimagewithBtn:_allBtn];
    
    _salesBtn = [YLButton buttonWithType:UIButtonTypeCustom];
    _salesBtn.frame = CGRectMake(_width, 0,_width, 40);
    [_btnArr addObject:_salesBtn];
    _salesBtn.tag = 10002;
    [self setThebtntitle:@"销量" AndimagewithBtn:_salesBtn];
    
    
    _priceBtn = [YLButton buttonWithType:UIButtonTypeCustom];
    _priceBtn.frame = CGRectMake(_width*2, 0,_width, 40);
    [_btnArr addObject:_priceBtn];
    _priceBtn.tag = 10003;
    [self setThebtntitle:@"价格" AndimagewithBtn:_priceBtn];

    _neBtn = [YLButton buttonWithType:UIButtonTypeCustom];
    _neBtn.frame = CGRectMake(_width*3, 0,_width, 40);
    [_btnArr addObject:_neBtn];
    _neBtn.tag = 10004;
    [self setThebtntitle:@"最新" AndimagewithBtn:_neBtn];


}


- (void)btncliak:(YLButton *)btn{

    if (btn == _priceBtn) {
        _allBtn.on = NO;
        _salesBtn.on = NO;
        _neBtn.on = NO;
        _priceBtn.on = !_priceBtn.on;
        [_allBtn setTitleColor:UIColorFromRGB(BlackColorValue) forState:UIControlStateNormal];
        [_allBtn setImage:[UIImage imageNamed:@"Triangle-b"] forState:UIControlStateNormal];
        [_salesBtn setTitleColor:UIColorFromRGB(BlackColorValue) forState:UIControlStateNormal];
        [_salesBtn setImage:[UIImage imageNamed:@"Triangle-b"] forState:UIControlStateNormal];
        [_neBtn setTitleColor:UIColorFromRGB(BlackColorValue) forState:UIControlStateNormal];
        [_neBtn setImage:[UIImage imageNamed:@"Triangle-b"] forState:UIControlStateNormal];
        [_priceBtn setTitleColor:UIColorFromRGB(RedColorValue) forState:UIControlStateNormal];
        [_priceBtn setImage:[UIImage imageNamed:@"Triangle"] forState:UIControlStateNormal];
        
    }else{
        for (YLButton *button in _btnArr) {
            if (button.tag != btn.tag) {
                button.on = NO;
                [button setTitleColor:UIColorFromRGB(BlackColorValue) forState:UIControlStateNormal];
                [button setImage:[UIImage imageNamed:@"Triangle-b"] forState:UIControlStateNormal];
            }
        }
        btn.on = YES;
        [btn setTitleColor:UIColorFromRGB(RedColorValue) forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"Triangle"] forState:UIControlStateNormal];
    }
    
    if ([self.delegate respondsToSelector:@selector(didselectedBtn:)]) {
        [self.delegate didselectedBtn:btn];
    }
    
}



- (void)setThebtntitle:(NSString*)title AndimagewithBtn:(YLButton*)btn{
    
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font = APPFONT(15);
    btn.on = NO;
    [btn setTitleColor:UIColorFromRGB(BlackColorValue) forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"Triangle-b"] forState:UIControlStateNormal];
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15],};
    CGSize textSize = [title boundingRectWithSize:CGSizeMake(_width, 40) options:NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;
    btn.titleRect = CGRectMake((_width-textSize.width-20)/2, 0, textSize.width, 40);
    btn.imageRect = CGRectMake((_width-textSize.width-20)/2+textSize.width+10, 15, 10, 9);
    btn.backgroundColor = UIColorFromRGB(WhiteColorValue);
    [btn addTarget:self action:@selector(btncliak:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
}

@end
