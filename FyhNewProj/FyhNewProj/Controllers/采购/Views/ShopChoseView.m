//
//  ShopChoseView.m
//  FyhNewProj
//
//  Created by yh f on 2017/5/10.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "ShopChoseView.h"

@implementation ShopChoseView{

    CGFloat         _width;
    NSMutableArray *_btnArr;
    
}

-(instancetype)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorFromRGB(LineColorValue);
        _btnArr = [[NSMutableArray alloc]init];
        [self setUP];
    }
    return self;
}


- (void)setUP{
    _width = ScreenWidth/3;
    _classifyBtn = [YLButton buttonWithType:UIButtonTypeCustom];
    _classifyBtn.frame = CGRectMake(0, 0,_width, 40);
    [_btnArr addObject:_classifyBtn];
    _classifyBtn.tag = 10001;
    [self setThebtntitle:@"全部分类" AndimagewithBtn:_classifyBtn];
    
    _allBtn = [YLButton buttonWithType:UIButtonTypeCustom];
    _allBtn.frame = CGRectMake(_width, 0,_width, 40);
    [_btnArr addObject:_allBtn];
    _allBtn.tag = 10002;
    [self setThebtntitle:@"全部状态" AndimagewithBtn:_allBtn];

    _timeBtn = [YLButton buttonWithType:UIButtonTypeCustom];
    _timeBtn.frame = CGRectMake(_width*2, 0,_width, 40);
    [_btnArr addObject:_timeBtn];
    _timeBtn.tag = 10003;
    [self setThebtntitle:@"时间倒序" AndimagewithBtn:_timeBtn];

    
    
}


- (void)refreshBtn{
                if (_classifyBtn.on) {
                    [_classifyBtn setTitleColor:UIColorFromRGB(RedColorValue) forState:UIControlStateNormal];
                    [_classifyBtn setImage:[UIImage imageNamed:@"Triangle-up"] forState:UIControlStateNormal];
        
                }else{
                    [_classifyBtn setTitleColor:UIColorFromRGB(BlackColorValue) forState:UIControlStateNormal];
                    [_classifyBtn setImage:[UIImage imageNamed:@"Triangle-b"] forState:UIControlStateNormal];
                }
        
                if (_allBtn.on) {
                    [_allBtn setTitleColor:UIColorFromRGB(RedColorValue) forState:UIControlStateNormal];
                    [_allBtn setImage:[UIImage imageNamed:@"Triangle-up"] forState:UIControlStateNormal];
        
                }else{
                    [_allBtn setTitleColor:UIColorFromRGB(BlackColorValue) forState:UIControlStateNormal];
                    [_allBtn setImage:[UIImage imageNamed:@"Triangle-b"] forState:UIControlStateNormal];
                }
        
                if (_timeBtn.on) {
                    [_timeBtn setTitleColor:UIColorFromRGB(RedColorValue) forState:UIControlStateNormal];
                    [_timeBtn setImage:[UIImage imageNamed:@"Triangle-up"] forState:UIControlStateNormal];
        
                }else{
                    [_timeBtn setTitleColor:UIColorFromRGB(RedColorValue) forState:UIControlStateNormal];
                    [_timeBtn setImage:[UIImage imageNamed:@"Triangle"] forState:UIControlStateNormal];
                }
    

}






- (void)setThebtntitle:(NSString*)title AndimagewithBtn:(YLButton*)btn{

    [btn setTitle:title forState:UIControlStateNormal];
   // [btn addTarget:self action:@selector(topBtnclick:) forControlEvents:UIControlEventTouchUpInside];
    btn.titleLabel.font = APPFONT(14);
    btn.on = NO;
    [btn setTitleColor:UIColorFromRGB(BlackColorValue) forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"Triangle-b"] forState:UIControlStateNormal];
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15],};
    CGSize textSize = [title boundingRectWithSize:CGSizeMake(_width, 40) options:NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;
    btn.titleRect = CGRectMake((_width-textSize.width-20)/2, 0, textSize.width, 40);
    btn.imageRect = CGRectMake((_width-textSize.width-20)/2+textSize.width+10, 15, 10, 9);
    btn.backgroundColor = UIColorFromRGB(WhiteColorValue);
    [self addSubview:btn];
}



@end
