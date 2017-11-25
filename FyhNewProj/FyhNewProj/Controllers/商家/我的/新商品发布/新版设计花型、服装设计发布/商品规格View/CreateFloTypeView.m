//
//  CreateFloTypeView.m
//  FyhNewProj
//
//  Created by yh f on 2017/11/9.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "CreateFloTypeView.h"
#import "AddColorController.h"
#import "ColorModel.h"

#define LABEL_MARGIN     12.0f
#define BOTTOM_MARGIN    10.0f

#define ORIGIN_X         67.0f
#define ORIGIN_Y         49.0f

#define ADDBTNWIDTH      48.0f

#define KINDBTNTAG       1000
#define STATUSBTNTAG     2000
#define DELETEBTNTAG     4000

@implementation CreateFloTypeView{
    
    UILabel  *_kindLab;     //类型
    UILabel  *_statuLab;    //状态
    UIView   *_hline;       //横线
    UIButton *addBtn;

    NSArray *_statusArr;
    NSMutableArray *_kindBtnArr;
    NSMutableArray *_statusBtnArr;

    CGRect previousFrame ;
    int totalHeight ;

    
}

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorFromRGB(WhiteColorValue);
        _kindTitleArr = [NSMutableArray arrayWithCapacity:0];
        _statusTitleArr = [NSMutableArray arrayWithCapacity:0];
        _kindBtnArr = [NSMutableArray arrayWithCapacity:0];
        _statusBtnArr = [NSMutableArray arrayWithCapacity:0];
        [self setUp];
    }
    
    return self;
}

- (void)setUp{
    UIView *topView = [BaseViewFactory  viewWithFrame:CGRectMake(0, 0, ScreenWidth, 39) color:UIColorFromRGB(0xe6e9ed)];
    [self addSubview:topView];
    
    UILabel *showLab = [BaseViewFactory labelWithFrame:CGRectMake(16, 0, ScreenWidth - 32, 39) textColor:UIColorFromRGB(0x434a54) font:APPFONT(15) textAligment:NSTextAlignmentLeft andtext:@"商品规格"];
    [self addSubview:showLab];
    
    NSArray *titleArr  = @[@"类型",@"状态"];
    for (int i = 0 ; i<titleArr.count; i++)
    {
        UILabel *lab = [BaseViewFactory labelWithFrame:CGRectMake(16, 39+48*i, 35, 48) textColor:UIColorFromRGB(BlackColorValue) font:APPFONT(15) textAligment:NSTextAlignmentLeft andtext:titleArr[i]];
        [self addSubview:lab];
        if (i==0) {
            _kindLab = lab;
        }else{
            _statuLab = lab;
        }
        
    }
    
    _hline = [BaseViewFactory viewWithFrame:CGRectMake(0, 48, ScreenWidth, 0.5) color:UIColorFromRGB(LineColorValue)];
    [self addSubview:_hline];
    
    _statusArr = @[@"授权",@"买断"];
    CGFloat OriginX2 = 77;
    for (int i = 0; i<_statusArr.count; i++)
    {
        YLButton *statusBtn = [YLButton buttonWithType:UIButtonTypeRoundedRect];
        [statusBtn setTitle:_statusArr[i] forState:UIControlStateNormal];
        [statusBtn setTitleColor:UIColorFromRGB(BlackColorValue) forState:UIControlStateNormal];
        [statusBtn setBackgroundColor:UIColorFromRGB(0xe6e9ed)];
        statusBtn.layer.cornerRadius = 4;
        statusBtn.titleLabel.font = APPFONT(15);
        statusBtn.frame = CGRectMake(OriginX2+76 *i, 39+10+48, 64, 28);
        statusBtn.tag = STATUSBTNTAG  + i;
        [statusBtn addTarget:self action:@selector(statusBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_statusBtnArr addObject:statusBtn];
        [self addSubview:statusBtn];
        
    }
    addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:addBtn];
    [addBtn setImage:[UIImage imageNamed:@"Create_add"] forState:UIControlStateNormal];
    addBtn.frame = CGRectMake(ScreenWidth - 34, 14+87, 18, 18);
    [addBtn addTarget:self action:@selector(addBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
}







#pragma mark ============ 按钮点击

/**
 添加类型
 */
- (void)addBtnClick{
    AddColorController  *accVc = [[AddColorController alloc]init];
    accVc.type = 1;
    accVc.colorArr = _kindTitleArr;
    [[GlobalMethod getCurrentVC].navigationController pushViewController:accVc animated:YES];
    
    
}

/**
 状态
 
 @param btn btn description
 */
- (void)statusBtnClick:(YLButton *)btn{
    
    btn.on = !btn.on;
    if (btn.on) {
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.backgroundColor=UIColorFromRGB(RedColorValue);
        if (![_statusTitleArr containsObject:_statusArr[btn.tag-STATUSBTNTAG ]]) {
            [_statusTitleArr addObject:_statusArr[btn.tag-STATUSBTNTAG]];
        }
    }else{
        [btn setTitleColor:UIColorFromRGB(BlackColorValue) forState:UIControlStateNormal];
        btn.backgroundColor=UIColorFromRGB(0xe6e9ed);
        if ([_statusTitleArr containsObject:_statusArr[btn.tag-STATUSBTNTAG ]]) {
            [_statusTitleArr removeObject:_statusArr[btn.tag-STATUSBTNTAG]];
        }
    }
    [self setOutPutArrData];

}

/**
 颜色按钮点击
 
 @param button button description
 */
- (void)tagBtnClick:(YLButton*)button{
    
    NSInteger index = button.tag - KINDBTNTAG;
    ColorModel *model = _kindTitleArr[index];
    model.IsSelected = !model.IsSelected;
    [self refreshKindBtnView];
    [self setOutPutArrData];

}

- (void)deleBtnclick:(UIButton *)button{
    
    [_kindTitleArr removeObjectAtIndex:button.tag - DELETEBTNTAG];
    [self refreshKindBtnView];

     [self setOutPutArrData];
    
    
}


#pragma mark =========  set

-(void)setKindTitleArr:(NSMutableArray *)kindTitleArr{
    _kindTitleArr = kindTitleArr;
    [self refreshKindBtnView];
    
}

-(void)setStatusTitleArr:(NSMutableArray *)statusTitleArr{
    
    _statusTitleArr = statusTitleArr;
    for (NSString *status in statusTitleArr) {
        for (YLButton *btn in _statusBtnArr) {
            if ([btn.titleLabel.text isEqualToString:status]) {
                btn.on = YES;
                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                btn.backgroundColor=UIColorFromRGB(RedColorValue);
            }
        }
    }
}


#pragma mark-改变控件高度
- (void)setHight:(UIView *)view andHight:(CGFloat)hight
{
    CGRect tempFrame = view.frame;
    tempFrame.size.height = 49+48;
    tempFrame.size.height += hight ;
    view.frame = tempFrame;
    _kindLab.frame = CGRectMake(16, 39 ,35, hight+10);
    addBtn.frame = CGRectMake(ScreenWidth - 34, 39+(hight-18+10)/2, 18,18);

    _hline.frame = CGRectMake(0, hight+49, ScreenWidth, 0.5);
    _statuLab.frame = CGRectMake(16, hight+49, 35, 48);
    for (int i = 0; i<_statusBtnArr.count; i++) {
        YLButton *btn = _statusBtnArr[i];
        btn.frame = CGRectMake(77+76 *i, hight+10+49, 64, 28);

    }
   
}


- (void)refreshKindBtnView{
    
    if (_kindBtnArr.count >0) {
        [_kindBtnArr makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [_kindBtnArr removeAllObjects];
        
    }
    previousFrame = CGRectMake(ORIGIN_X, ORIGIN_Y, 0, 0);
    totalHeight = 0;
    for (int i = 0; i<_kindTitleArr.count;i++ ) {
        ColorModel *model = _kindTitleArr[i];
        YLButton*tagBtn=[YLButton buttonWithType:UIButtonTypeCustom];
        tagBtn.frame=CGRectZero;
        [_kindBtnArr addObject:tagBtn];
        
        if (model.IsSelected) {
            [tagBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            tagBtn.backgroundColor=UIColorFromRGB(RedColorValue);
        }else{
            [tagBtn setTitleColor:UIColorFromRGB(BlackColorValue) forState:UIControlStateNormal];
            tagBtn.backgroundColor=UIColorFromRGB(0xe6e9ed);
            
        }
        
        
        tagBtn.titleLabel.font=[UIFont boldSystemFontOfSize:15];
        [tagBtn addTarget:self action:@selector(tagBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [tagBtn setTitle:model.colorName forState:UIControlStateNormal];
        tagBtn.tag = KINDBTNTAG + i;
        tagBtn.layer.cornerRadius = 4;
        
        NSDictionary *attrs = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:15]};
        CGSize Size_str=[model.colorName sizeWithAttributes:attrs];
        Size_str.width += 16;
        Size_str.height = 28;
        
        
        CGRect newRect = CGRectZero;
        
        if (previousFrame.origin.x + previousFrame.size.width + Size_str.width + LABEL_MARGIN + ADDBTNWIDTH> self.bounds.size.width) {
            
            newRect.origin = CGPointMake(ORIGIN_X+ LABEL_MARGIN, previousFrame.origin.y + Size_str.height + BOTTOM_MARGIN);
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
        
        UIButton *deleBtn = [BaseViewFactory buttonWithWidth:16 imagePath:@"delete-red"];
        [tagBtn addSubview:deleBtn];
        [deleBtn addTarget:self action:@selector(deleBtnclick:) forControlEvents:UIControlEventTouchUpInside];
        deleBtn.frame = CGRectMake(tagBtn.width -7, -4, 14, 14);
        deleBtn.tag = DELETEBTNTAG + i;
        
        
    }
    //
}

- (void)setOutPutArrData{
    
    NSMutableArray  *colorArr = [NSMutableArray arrayWithCapacity:0];
    for (ColorModel *model in _kindTitleArr) {
        if (model.IsSelected) {
            [colorArr addObject:model];
        }
    }
    
    
    if ([self.delegate respondsToSelector:@selector(DidSelectedCreateFloTypeProUnitViewOutPutBtn:andstatusTitleArr:andType:)]) {
        [self.delegate DidSelectedCreateFloTypeProUnitViewOutPutBtn:colorArr andstatusTitleArr:_statusTitleArr andType:1];
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:@"UserHaveChangeData" object:nil];

    
}

@end
