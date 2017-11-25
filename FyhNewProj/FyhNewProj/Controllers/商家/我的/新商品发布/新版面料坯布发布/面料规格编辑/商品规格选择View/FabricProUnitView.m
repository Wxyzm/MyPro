//
//  FabricProUnitView.m
//  FyhNewProj
//
//  Created by yh f on 2017/10/31.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "FabricProUnitView.h"
#import "AddColorController.h"
#import "ColorModel.h"

#define LABEL_MARGIN     12.0f
#define BOTTOM_MARGIN    10.0f

#define ORIGIN_X         67.0f
#define ORIGIN_Y         145.0f

#define ADDBTNWIDTH      48.0f

#define KINDBTNTAG       1000
#define STATUSBTNTAG     2000
#define COLORBTNTAG      3000
#define DELETEBTNTAG     4000




@implementation FabricProUnitView{
    
           UILabel *_colorLab;          //颜色lab
            CGRect previousFrame ;
               int totalHeight ;
          UIButton *addBtn;
           NSArray *_kindArr;
           NSArray *_statusArr;
           NSMutableArray *_kindBtnArr;
           NSMutableArray *_statusBtnArr;

}

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorFromRGB(WhiteColorValue);
        _colorBtnArr = [NSMutableArray arrayWithCapacity:0];
        _colorTitleArr = [NSMutableArray arrayWithCapacity:0];
        _kindTitleArr = [NSMutableArray arrayWithCapacity:0];
        _statusTitleArr = [NSMutableArray arrayWithCapacity:0];
        _outPutArr = [NSMutableArray arrayWithCapacity:0];
        _kindBtnArr = [NSMutableArray arrayWithCapacity:0];
        _statusBtnArr = [NSMutableArray arrayWithCapacity:0];
        [self setUp];
    }
    
    return self;
}

- (void)setUp
{
    
    UIView *topView = [BaseViewFactory  viewWithFrame:CGRectMake(0, 0, ScreenWidth, 39) color:UIColorFromRGB(0xe6e9ed)];
    [self addSubview:topView];
    
    UILabel *showLab = [BaseViewFactory labelWithFrame:CGRectMake(16, 0, ScreenWidth - 32, 39) textColor:UIColorFromRGB(0x434a54) font:APPFONT(15) textAligment:NSTextAlignmentLeft andtext:@"商品规格"];
    [self addSubview:showLab];
    
    
    
    
   NSArray *titleArr  = @[@"类型",@"状态",@"颜色"];
    for (int i = 0 ; i<titleArr.count; i++)
    {
        UILabel *lab = [BaseViewFactory labelWithFrame:CGRectMake(16, 39+48*i, 35, 48) textColor:UIColorFromRGB(BlackColorValue) font:APPFONT(15) textAligment:NSTextAlignmentLeft andtext:titleArr[i]];
        [self addSubview:lab];
        if (i==2) {
            _colorLab = lab;
        }
       
            UIView *line = [BaseViewFactory viewWithFrame:CGRectMake(0, 39+48*i, ScreenWidth, 0.5) color:UIColorFromRGB(LineColorValue)];
            [self addSubview:line];
            
        
    }
    _kindArr    = @[@"样卡",@"样布",@"大货"];
    CGFloat OriginX1 = 77;
    for (int i = 0; i<_kindArr.count; i++)
    {
        YLButton *kindBtn = [YLButton buttonWithType:UIButtonTypeRoundedRect];
        [kindBtn setTitle:_kindArr[i] forState:UIControlStateNormal];
        [kindBtn setTitleColor:UIColorFromRGB(BlackColorValue) forState:UIControlStateNormal];
        [kindBtn setBackgroundColor:UIColorFromRGB(0xe6e9ed)];
        kindBtn.titleLabel.font = APPFONT(15);
        kindBtn.layer.cornerRadius = 4;
        kindBtn.tag = KINDBTNTAG  + i;
        kindBtn.frame = CGRectMake(OriginX1+76 *i, 39+10, 64, 28);
        [kindBtn addTarget:self action:@selector(kindBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:kindBtn];
        [_kindBtnArr addObject:kindBtn];
        
    }
    
   _statusArr = @[@"现货",@"订制"];
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
    addBtn.frame = CGRectMake(ScreenWidth - 34, 14+135, 18, 18);
    [addBtn addTarget:self action:@selector(addBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    NSArray *color =@[@"白色系",@"黑色系",@"红色系"];
    for (NSString *colorstr in color) {
        ColorModel *model   = [[ColorModel alloc]init];
        model.colorName = colorstr;
        model.IsSelected = YES;
        [_colorTitleArr addObject:model];
    }
    
    
}

#pragma mark =========  set

-(void)setColorTitleArr:(NSMutableArray *)colorTitleArr{
    _colorTitleArr = colorTitleArr;
    [self refreshColorBtnView];
    
    
}

-(void)setKindTitleArr:(NSMutableArray *)kindTitleArr{
    
    _kindTitleArr = kindTitleArr;
    for (NSString *kind in kindTitleArr) {
        for (YLButton *btn in _kindBtnArr) {
            if ([btn.titleLabel.text isEqualToString:kind]) {
                btn.on = YES;
                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                btn.backgroundColor=UIColorFromRGB(RedColorValue);
            }
        }
    }
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







- (void)refreshColorBtnView{
    
    if (_colorBtnArr.count >0) {
        [_colorBtnArr makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [_colorBtnArr removeAllObjects];

    }
    previousFrame = CGRectMake(ORIGIN_X, ORIGIN_Y, 0, 0);
    totalHeight = 0;
    for (int i = 0; i<_colorTitleArr.count;i++ ) {
        ColorModel *model = _colorTitleArr[i];
        YLButton*tagBtn=[YLButton buttonWithType:UIButtonTypeCustom];
        tagBtn.frame=CGRectZero;
        [_colorBtnArr addObject:tagBtn];
        
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
         tagBtn.tag = COLORBTNTAG + i;
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





#pragma mark-改变控件高度
- (void)setHight:(UIView *)view andHight:(CGFloat)hight
{
    CGRect tempFrame = view.frame;
    tempFrame.size.height = 49+48+48;
    tempFrame.size.height += hight ;
    view.frame = tempFrame;
    _colorLab.frame = CGRectMake(16, 39+48+48, 35, hight+10);
    addBtn.frame = CGRectMake(ScreenWidth - 34, 39+48+48+(hight-18+10)/2, 18,18);
}


#pragma mark ============ 按钮点击



- (void)deleBtnclick:(UIButton *)button{
    
    [_colorTitleArr removeObjectAtIndex:button.tag - DELETEBTNTAG];
    [self refreshColorBtnView];

    [self setOutPutArrData];
    
    
}

/**
 添加新颜色
 */
- (void)addBtnClick{
    
    AddColorController  *accVc = [[AddColorController alloc]init];
    accVc.type = 0;

    accVc.colorArr = _colorTitleArr;
    [[GlobalMethod getCurrentVC].navigationController pushViewController:accVc animated:YES];
    
    
}

/**
 颜色按钮点击

 @param button button description
 */
- (void)tagBtnClick:(YLButton*)button{
    
    NSInteger index = button.tag - COLORBTNTAG;
    ColorModel *model = _colorTitleArr[index];
    model.IsSelected = !model.IsSelected;
    
    [self refreshColorBtnView];
    [self setOutPutArrData];
}

/**
 类型
 
 @param btn btn description
 */
- (void)kindBtnClick:(YLButton *)btn{
    
    btn.on = !btn.on;
    if (btn.on) {
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.backgroundColor=UIColorFromRGB(RedColorValue);
        if (![_kindTitleArr containsObject:_kindArr[btn.tag-KINDBTNTAG]]) {
            [_kindTitleArr addObject:_kindArr[btn.tag-KINDBTNTAG]];
        }
    }else{
        [btn setTitleColor:UIColorFromRGB(BlackColorValue) forState:UIControlStateNormal];
        btn.backgroundColor=UIColorFromRGB(0xe6e9ed);
        if ([_kindTitleArr containsObject:_kindArr[btn.tag-KINDBTNTAG]]) {
            [_kindTitleArr removeObject:_kindArr[btn.tag-KINDBTNTAG]];
        }
    }
    [self setOutPutArrData];
    
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


- (void)setOutPutArrData{
    
    NSMutableArray  *colorArr = [NSMutableArray arrayWithCapacity:0];
    for (ColorModel *model in _colorTitleArr) {
        if (model.IsSelected) {
            [colorArr addObject:model];
        }
    }
    
    
    if ([self.delegate respondsToSelector:@selector(DidSelectedFabricProUnitViewOutPutBtn:andstatusTitleArr:andcolorTitleArr:andType:)]) {
        [self.delegate DidSelectedFabricProUnitViewOutPutBtn:_kindTitleArr andstatusTitleArr:_statusTitleArr andcolorTitleArr:colorArr andType:1];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"UserHaveChangeData" object:nil];
    }
   
}

@end
