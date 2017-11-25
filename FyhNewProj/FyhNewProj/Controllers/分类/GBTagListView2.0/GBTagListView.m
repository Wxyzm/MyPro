//
//  GBTagListView.m
//  升级版流式标签支持点击
//
//  Created by 张国兵 on 15/8/16.
//  Copyright (c) 2015年 zhangguobing. All rights reserved.
//

#import "GBTagListView.h"
#import "UnitModel.h"

#define HORIZONTAL_PADDING 7.0f
#define VERTICAL_PADDING   3.0f
#define LABEL_MARGIN       15.0f
#define BOTTOM_MARGIN      10.0f
#define KBtnTag            1000
#define R_G_B_16(rgbValue)\
\
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 \
alpha:1.0]

@implementation GBTagListView{

    NSMutableArray *_btnArr;
}

-(id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        totalHeight=0;
        self.frame=frame;
        _tagArr=[[NSMutableArray alloc]init];
        _btnArr =[[NSMutableArray alloc]init];
    }
    return self;
    
    
}
-(void)setTagWithTagArray:(NSArray*)arr{
    previousFrame = CGRectZero;
    
    previousFrame.origin.y = 34;
    [_tagArr removeAllObjects];
    [_tagArr addObjectsFromArray:arr];
    
    for ( UIButton*tagBtn in _btnArr) {
        [tagBtn removeFromSuperview];
    }
    [_btnArr removeAllObjects];
    totalHeight=0;

    
    [arr enumerateObjectsUsingBlock:^(UnitModel*model, NSUInteger idx, BOOL *stop) {
        

        
        UIButton*tagBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        tagBtn.frame=CGRectZero;
        [_btnArr addObject:tagBtn];

        if(_canTouch){
            tagBtn.userInteractionEnabled=YES;
            
        }else{
            
            tagBtn.userInteractionEnabled=NO;
        }
        if (model.on) {
            [tagBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            tagBtn.backgroundColor=UIColorFromRGB(RedColorValue);

        }else{
            [tagBtn setTitleColor:UIColorFromRGB(BlackColorValue) forState:UIControlStateNormal];
            tagBtn.backgroundColor=UIColorFromRGB(0xf5f5f5);
        }
        tagBtn.titleLabel.font=[UIFont boldSystemFontOfSize:12];
        [tagBtn addTarget:self action:@selector(tagBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [tagBtn setTitle:model.name forState:UIControlStateNormal];
        tagBtn.tag=KBtnTag+idx;
        tagBtn.layer.cornerRadius = 10;
        tagBtn.clipsToBounds=YES;
        NSDictionary *attrs = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:12]};
        CGSize Size_str=[model.name sizeWithAttributes:attrs];
        Size_str.width += HORIZONTAL_PADDING*3;
        Size_str.height = 30;
        
        CGRect newRect = CGRectZero;
        
        if (previousFrame.origin.x + previousFrame.size.width + Size_str.width + LABEL_MARGIN > self.bounds.size.width) {
            
            newRect.origin = CGPointMake(15, previousFrame.origin.y + Size_str.height + BOTTOM_MARGIN);
            totalHeight +=Size_str.height + BOTTOM_MARGIN;
        }
        else {
            newRect.origin = CGPointMake(previousFrame.origin.x + previousFrame.size.width + LABEL_MARGIN, previousFrame.origin.y);
            
        }
        newRect.size = Size_str;
        [tagBtn setFrame:newRect];
        previousFrame=tagBtn.frame;
        [self setHight:self andHight:totalHeight+Size_str.height + BOTTOM_MARGIN];
        [self addSubview:tagBtn];

        
    }
     
     ];
    if(_GBbackgroundColor){
        
        self.backgroundColor=_GBbackgroundColor;
        
    }else{
        
        self.backgroundColor=[UIColor whiteColor];
        
    }
    
    
}
#pragma mark-改变控件高度
- (void)setHight:(UIView *)view andHight:(CGFloat)hight
{
    CGRect tempFrame = view.frame;
    tempFrame.size.height = 0;
    tempFrame.size.height = hight +38;
    view.frame = tempFrame;
}
-(void)tagBtnClick:(UIButton*)button{
    
    for (UnitModel *mdoel in _tagArr) {
        mdoel.on = NO;
    }
    UnitModel *onmdoel = _tagArr[button.tag -KBtnTag ];
    onmdoel.on = YES;
    
    
    
    for (UIButton* btn in _btnArr) {
        btn.selected  = NO;
    }
    button.selected = YES;
    
    
    for (int i = 0; i<_tagArr.count; i++) {
        UnitModel *mdoel = _tagArr[i];
        UIButton *btn = _btnArr[i];
        if (mdoel.on) {
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            btn.backgroundColor=UIColorFromRGB(RedColorValue);
            
        }else{
            [btn setTitleColor:UIColorFromRGB(BlackColorValue) forState:UIControlStateNormal];
            btn.backgroundColor=UIColorFromRGB(0xf5f5f5);
        }
    }
    
    
    [self didSelectItemswithBtn:onmdoel];
    
    
}
-(void)didSelectItemswithBtn:(UnitModel *)mdoel{
    
    self.didselectItemBlock(mdoel);
}
@end
