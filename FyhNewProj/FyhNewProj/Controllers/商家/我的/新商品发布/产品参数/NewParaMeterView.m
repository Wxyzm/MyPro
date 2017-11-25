//
//  ParaMeterView.m
//  FyhNewProj
//
//  Created by yh f on 2017/10/30.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "NewParaMeterView.h"
#import "ParaMeterModel.h"
//cell
#import "ParaMeterSelectCell.h"
#import "ParaMeterInputCell.h"
#import "ParaMeterTwoWayCell.h"
#import "PareMeterSelectedController.h"
#import "ComponentViewController.h"
#import "ComponentModel.h"
#import "HTMLViewController.h"
#import "AddUnitView.h"
#import "AttributesModel.h"
@interface NewParaMeterView ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,AddUnitViewDelegate,ParaMeterInputCellDelegate>

@property (nonatomic,strong) UITableView *unitTableView;

@property (nonatomic , strong) AddUnitView *addView;

@end

@implementation NewParaMeterView{
    
    NSArray  *_nameArr;
}


-(AddUnitView *)addView{
    
    if (!_addView) {
        _addView = [[AddUnitView alloc]init];
        _addView.delegate = self;
        _addView.type = 1;
    }
    return _addView;
    
}

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorFromRGB(WhiteColorValue);
        _unitArr = [NSMutableArray arrayWithCapacity:0];
        [self setUp];
    }
    
    return self;
}

- (void)setUp{
    

    
    _unitTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, (_unitArr.count + 2) * 48)];
    _unitTableView.bounces = NO;
    _unitTableView.scrollEnabled = NO;
    _unitTableView.delegate = self;
    _unitTableView.dataSource = self;
    _unitTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:_unitTableView];
    
    
    
}

-(void)setUnitArr:(NSMutableArray *)unitArr{
    
    NSLog(@"%@",unitArr);
    
    for (int i = 0;i<unitArr.count ; i++) {
        AttributesModel *model = unitArr[i];
        for (ParaMeterModel *paramodel in _unitArr) {
            if ([paramodel.ParaKind isEqualToString:model.attributeName]) {
                
            }
        }
    }
    
   
    
    
    
}
- (void)setParaMeterType:(ParaMeterType)paraMeterType andDataArr:(NSMutableArray *)dataArr{
    
    _paraMeterType = paraMeterType;
    [_unitArr removeAllObjects];
    NSMutableArray *nameArr = [NSMutableArray arrayWithCapacity:0];
    switch (_paraMeterType) {
        case FABRIC_TYPE:{
            //面料 坯布
            _nameArr = @[@"货号",@"成分",@"克重",@"门幅",@"编织方式",@"组织",@"工艺",@"弹力"];
            [nameArr addObjectsFromArray:_nameArr];
            for (AttributesModel *attModel in dataArr) {
                if (![nameArr containsObject:attModel.attributeName]) {
                    [nameArr addObject:attModel.attributeName];
                }
            }
            for (int i = 0; i<nameArr.count; i++) {
                ParaMeterModel *model = [[ParaMeterModel alloc]init];
                model.ParaKind = nameArr[i];
                if (![_nameArr containsObject:model.ParaKind]) {
                    model.isNew = YES;
                    model.KindWay = INPUT_WAY;
                }else{
                    if ([model.ParaKind isEqualToString:@"货号"]) {
                        model.KindWay = INPUT_WAY;
                    }else if ([model.ParaKind isEqualToString:@"克重"]||[model.ParaKind isEqualToString:@"门幅"]){
                        model.KindWay = ALLTWO_WAY;
                    }else if ([model.ParaKind isEqualToString:@"成分"]){
                        model.KindWay = SELECT_WAY;
                        model.componentModel.isFirstEdit = YES;
                    }
                    else{
                        model.KindWay = SELECT_WAY;
                    }
                }
                [self appendDataWithModel:model andArr:dataArr];
                [_unitArr addObject:model];
            }
            
            break;
            
        }
        case PATTERNDES_WAY:{
            //花型设计
            _nameArr = @[@"货号",@"套数",@"排版",@"尺寸",@"分辨率",@"回位",@"印染工艺"];
            nameArr = [_nameArr mutableCopy];
            for (AttributesModel *attModel in dataArr) {
                if (![nameArr containsObject:attModel.attributeName]) {
                    [nameArr addObject:attModel.attributeName];
                }
            }
            for (int i = 0; i<_nameArr.count; i++) {
                ParaMeterModel *model = [[ParaMeterModel alloc]init];
                model.ParaKind = nameArr[i];
                if (![_nameArr containsObject:model.ParaKind]) {
                    model.isNew = YES;
                    model.KindWay = INPUT_WAY;
                }
                else
                {
                if ([model.ParaKind isEqualToString:@"货号"]||[model.ParaKind isEqualToString:@"套数"]||[model.ParaKind isEqualToString:@"排版"]||[model.ParaKind isEqualToString:@"尺寸"]) {
                    model.KindWay = INPUT_WAY;
                }else if ([model.ParaKind isEqualToString:@"分辨率"]){
                    model.KindWay = ALLTWO_WAY;
                }else{
                    model.KindWay = SELECT_WAY;
                }
                    
                }
                [self appendDataWithModel:model andArr:dataArr];

                [_unitArr addObject:model];
            }
            break;
            
        }
        case CLOTHINGDES_WAY:{
            //服装设计
            _nameArr = @[@"货号",@"分辨率",@"应用",@"图案",@"衣长",@"廓形",@"腰型",@"领型"];
            nameArr = [_nameArr mutableCopy];
            for (AttributesModel *attModel in dataArr) {
                if (![nameArr containsObject:attModel.attributeName]) {
                    [nameArr addObject:attModel.attributeName];
                }
            }
            for (int i = 0; i<_nameArr.count; i++) {
                ParaMeterModel *model = [[ParaMeterModel alloc]init];
                model.ParaKind = nameArr[i];
             
                if (![_nameArr containsObject:model.ParaKind]) {
                    model.isNew = YES;
                    model.KindWay = INPUT_WAY;
                }
                else
                {if ([model.ParaKind isEqualToString:@"货号"]) {
                    model.KindWay = INPUT_WAY;
                }else if ([model.ParaKind isEqualToString:@"分辨率"]){
                    model.KindWay = ALLTWO_WAY;
                }else{
                    model.KindWay = SELECT_WAY;
                }
                    
                }
                [self appendDataWithModel:model andArr:dataArr];

                [_unitArr addObject:model];
            }
            break;
            
        }
        case ACCESS_WAY:{
            //辅料
            _nameArr = @[@"货号",@"成分",@"面料",@"材质",@"工艺",@"风格"];
            nameArr = [_nameArr mutableCopy];
            for (AttributesModel *attModel in dataArr) {
                if (![nameArr containsObject:attModel.attributeName]) {
                    [nameArr addObject:attModel.attributeName];
                }
            }
            for (int i = 0; i<_nameArr.count; i++) {
                ParaMeterModel *model = [[ParaMeterModel alloc]init];
                model.ParaKind = nameArr[i];
                if (![_nameArr containsObject:model.ParaKind]) {
                    model.isNew = YES;
                    model.KindWay = INPUT_WAY;
                }
                else{
                if ([model.ParaKind isEqualToString:@"货号"]) {
                    model.KindWay = INPUT_WAY;
                }else if ([model.ParaKind isEqualToString:@"成分"]){
                    model.KindWay = SELECT_WAY;
                    
                    model.componentModel.isFirstEdit = YES;
                    
                    
                }else{
                    model.KindWay = SELECT_WAY;
                }
                    
                }
                [self appendDataWithModel:model andArr:dataArr];

                [_unitArr addObject:model];
            }
            break;
            
        }
        case DRESS_WAY:{
            //服装
            _nameArr = @[@"货号",@"成分",@"面料",@"季节",@"风格",@"腰型",@"领型",@"袖长"];
            nameArr = [_nameArr mutableCopy];
            for (AttributesModel *attModel in dataArr) {
                if (![nameArr containsObject:attModel.attributeName]) {
                    [nameArr addObject:attModel.attributeName];
                }
            }
            for (int i = 0; i<_nameArr.count; i++) {
                ParaMeterModel *model = [[ParaMeterModel alloc]init];
                model.ParaKind = nameArr[i];
                
                if (![_nameArr containsObject:model.ParaKind]) {
                    model.isNew = YES;
                    model.KindWay = INPUT_WAY;
                }
                else{
                if ([model.ParaKind isEqualToString:@"货号"]) {
                    model.KindWay = INPUT_WAY;
                }else if ([model.ParaKind isEqualToString:@"成分"]){
                    model.KindWay = SELECT_WAY;
                    
                    model.componentModel.isFirstEdit = YES;
                    
                    
                }else{
                    model.KindWay = SELECT_WAY;
                }
                    
                    
                }
                [self appendDataWithModel:model andArr:dataArr];

                [_unitArr addObject:model];
            }
            break;
            
        }
        case HOMETEXT_WAY:{
            //家纺
            
            _nameArr = @[@"货号",@"成分",@"面料",@"季节",@"风格",@"图案",@"材质",@"工艺"];
            nameArr = [_nameArr mutableCopy];
            for (AttributesModel *attModel in dataArr) {
                if (![nameArr containsObject:attModel.attributeName]) {
                    [nameArr addObject:attModel.attributeName];
                }
            }
            for (int i = 0; i<_nameArr.count; i++) {
                ParaMeterModel *model = [[ParaMeterModel alloc]init];
                model.ParaKind = nameArr[i];
                if (![_nameArr containsObject:model.ParaKind]) {
                    model.isNew = YES;
                    model.KindWay = INPUT_WAY;
                }
                else{
                if ([model.ParaKind isEqualToString:@"货号"]) {
                    model.KindWay = INPUT_WAY;
                }else if ([model.ParaKind isEqualToString:@"分辨率"]){
                    model.KindWay = ALLTWO_WAY;
                }else if ([model.ParaKind isEqualToString:@"成分"]){
                    model.KindWay = SELECT_WAY;
                    
                    model.componentModel.isFirstEdit = YES;
                    
                    
                }else{
                    model.KindWay = SELECT_WAY;
                }
                }
                [self appendDataWithModel:model andArr:dataArr];

                [_unitArr addObject:model];
            }
            break;
            
        }
        default:
            break;
    }
    
    [_unitTableView reloadData];
    CGRect frame = self.frame;
    frame.size.height = (_unitArr.count + 2) * 48;
    self.frame = frame;
    CGRect tableframe = _unitTableView.frame;
    tableframe.size.height = (_unitArr.count + 2) * 48;
    _unitTableView.frame = tableframe;
    
}


- (void)setParaMeterType:(ParaMeterType)paraMeterType{
    _paraMeterType = paraMeterType;
    [_unitArr removeAllObjects];
    switch (_paraMeterType) {
        case FABRIC_TYPE:{
             //面料 坯布
            _nameArr = @[@"货号",@"成分",@"克重",@"门幅",@"编织方式",@"组织",@"工艺",@"弹力"];
            for (int i = 0; i<_nameArr.count; i++) {
                ParaMeterModel *model = [[ParaMeterModel alloc]init];
                model.ParaKind = _nameArr[i];
                if ([model.ParaKind isEqualToString:@"货号"]) {
                    model.KindWay = INPUT_WAY;
                }else if ([model.ParaKind isEqualToString:@"克重"]||[model.ParaKind isEqualToString:@"门幅"]){
                    model.KindWay = ALLTWO_WAY;
                }else if ([model.ParaKind isEqualToString:@"成分"]){
                    model.KindWay = SELECT_WAY;
                    
                    model.componentModel.isFirstEdit = YES;

                    
                }
                else{
                    model.KindWay = SELECT_WAY;
                }
                [_unitArr addObject:model];
            }
            
            break;
            
        }
        case PATTERNDES_WAY:{
             //花型设计
           _nameArr = @[@"货号",@"套数",@"排版",@"尺寸",@"分辨率",@"回位",@"印染工艺"];
            for (int i = 0; i<_nameArr.count; i++) {
                ParaMeterModel *model = [[ParaMeterModel alloc]init];
                model.ParaKind = _nameArr[i];
                if ([model.ParaKind isEqualToString:@"货号"]||[model.ParaKind isEqualToString:@"套数"]||[model.ParaKind isEqualToString:@"排版"]||[model.ParaKind isEqualToString:@"尺寸"]) {
                    model.KindWay = INPUT_WAY;
                }else if ([model.ParaKind isEqualToString:@"分辨率"]){
                    model.KindWay = ALLTWO_WAY;
                }else{
                    model.KindWay = SELECT_WAY;
                }
                [_unitArr addObject:model];
            }
            break;
            
        }
        case CLOTHINGDES_WAY:{
            //服装设计
          _nameArr = @[@"货号",@"分辨率",@"应用",@"图案",@"衣长",@"廓形",@"腰型",@"领型"];
            for (int i = 0; i<_nameArr.count; i++) {
                ParaMeterModel *model = [[ParaMeterModel alloc]init];
                model.ParaKind = _nameArr[i];
                if ([model.ParaKind isEqualToString:@"货号"]) {
                    model.KindWay = INPUT_WAY;
                }else if ([model.ParaKind isEqualToString:@"分辨率"]){
                    model.KindWay = ALLTWO_WAY;
                }else{
                    model.KindWay = SELECT_WAY;
                }
                [_unitArr addObject:model];
            }
            break;
            
        }
        case ACCESS_WAY:{
            //辅料
           _nameArr = @[@"货号",@"成分",@"面料",@"材质",@"工艺",@"风格"];
            for (int i = 0; i<_nameArr.count; i++) {
                ParaMeterModel *model = [[ParaMeterModel alloc]init];
                model.ParaKind = _nameArr[i];
                if ([model.ParaKind isEqualToString:@"货号"]) {
                    model.KindWay = INPUT_WAY;
                }else if ([model.ParaKind isEqualToString:@"成分"]){
                    model.KindWay = SELECT_WAY;
                    
                    model.componentModel.isFirstEdit = YES;
                    
                    
                }else{
                    model.KindWay = SELECT_WAY;
                }
                [_unitArr addObject:model];
            }
            break;
            
        }
        case DRESS_WAY:{
            //服装
           _nameArr = @[@"货号",@"成分",@"面料",@"季节",@"风格",@"腰型",@"领型",@"袖长"];
            for (int i = 0; i<_nameArr.count; i++) {
                ParaMeterModel *model = [[ParaMeterModel alloc]init];
                model.ParaKind = _nameArr[i];
                if ([model.ParaKind isEqualToString:@"货号"]) {
                    model.KindWay = INPUT_WAY;
                }else if ([model.ParaKind isEqualToString:@"成分"]){
                    model.KindWay = SELECT_WAY;
                    
                    model.componentModel.isFirstEdit = YES;
                    
                    
                }else{
                    model.KindWay = SELECT_WAY;
                }
                [_unitArr addObject:model];
            }
            break;
            
        }
        case HOMETEXT_WAY:{
             //家纺
            
           _nameArr = @[@"货号",@"成分",@"面料",@"季节",@"风格",@"图案",@"材质",@"工艺"];
            for (int i = 0; i<_nameArr.count; i++) {
                ParaMeterModel *model = [[ParaMeterModel alloc]init];
                model.ParaKind = _nameArr[i];
                if ([model.ParaKind isEqualToString:@"货号"]) {
                    model.KindWay = INPUT_WAY;
                }else if ([model.ParaKind isEqualToString:@"分辨率"]){
                    model.KindWay = ALLTWO_WAY;
                }else if ([model.ParaKind isEqualToString:@"成分"]){
                    model.KindWay = SELECT_WAY;
                    
                    model.componentModel.isFirstEdit = YES;
                    
                    
                }else{
                    model.KindWay = SELECT_WAY;
                }
                [_unitArr addObject:model];
            }
            break;
            
        }
        default:
            break;
    }
    
    [_unitTableView reloadData];
    CGRect frame = self.frame;
    frame.size.height = (_unitArr.count + 2) * 48;
    self.frame = frame;
    CGRect tableframe = _unitTableView.frame;
    tableframe.size.height = (_unitArr.count + 2) * 48;
    _unitTableView.frame = tableframe;
    
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _unitArr.count + 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 48;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row ==_unitArr.count) {
        static NSString *cellid = @"downcell";
        ParaMeterSelectCell *cell =[tableView dequeueReusableCellWithIdentifier:cellid];
        if (!cell) {
            cell = [[ParaMeterSelectCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        }
        cell.nameLab.text = @"添加新属性";
        cell.valueLab.text =@"";
        cell.rightImageView.image = [UIImage imageNamed:@"Create_add"];
        cell.rightImageView.frame = CGRectMake(ScreenWidth - 34, 15, 18, 18);
        return cell;
    }else if (indexPath.row ==_unitArr.count+1){
        static NSString *inputCellid =@"canshuCellid";
        ParaMeterSelectCell *cell =[tableView dequeueReusableCellWithIdentifier:inputCellid];
        if (!cell) {
            cell = [[ParaMeterSelectCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:inputCellid];
        }
        cell.nameLab.text = @"宝贝描述";
        cell.valueLab.text =@"";
        return cell;
    }
    
    ParaMeterModel *model = _unitArr[indexPath.row];
    if (model.KindWay == INPUT_WAY) {
        //纯输入
        static NSString *inputCellid =@"inputCellid";
        ParaMeterInputCell *cell =[tableView dequeueReusableCellWithIdentifier:inputCellid];
        if (!cell) {
            cell = [[ParaMeterInputCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:inputCellid];
        }
        cell.model = model;
        cell.delegate = self;
        return cell;
    }else if (model.KindWay == SELECT_WAY){
        //纯选择
        static NSString *inputCellid =@"ParaMeterSelectCellid";
        ParaMeterSelectCell *cell =[tableView dequeueReusableCellWithIdentifier:inputCellid];
        if (!cell) {
            cell = [[ParaMeterSelectCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:inputCellid];
        }
        cell.model = model;
        return cell;
    }else{
        //两者都有
        static NSString *inputCellid =@"ParaMeterTwoWayCellid";
        ParaMeterTwoWayCell *cell =[tableView dequeueReusableCellWithIdentifier:inputCellid];
        if (!cell) {
            cell = [[ParaMeterTwoWayCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:inputCellid];
        }
        cell.model = model;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == _unitArr.count) {
        if (_unitArr.count<=0) {
            return;
        }
        [self.addView showinView:[GlobalMethod getCurrentVC].view];
        
    }else if (indexPath.row == _unitArr.count+1){
        HTMLViewController * htmlVC = [[HTMLViewController alloc]init];
        if (_htmlStr.length >0) {
            htmlVC.inHtmlString = _htmlStr;
        }
        [[GlobalMethod getCurrentVC].navigationController pushViewController:htmlVC animated:YES];

        
    }else{
        ParaMeterModel *model = _unitArr[indexPath.row];
        
        if (model.KindWay == SELECT_WAY) {
            //成分需要拿出来
            if ([model.ParaKind isEqualToString:@"成分"]) {
                ComponentViewController *comVc=[[ComponentViewController alloc]init];
                comVc.model = model;
                [[GlobalMethod getCurrentVC].navigationController pushViewController:comVc animated:YES];

                
                
            }else{
                
                PareMeterSelectedController *pavc = [[PareMeterSelectedController alloc]init];
                pavc.model  = model;
                [[GlobalMethod getCurrentVC].navigationController pushViewController:pavc animated:YES];
            }
            
        }
        
        
    }
    
   
    
    
    
    
}

- (void)reloadTableView{
    
    [_unitTableView reloadData];
    
}


/**
 删除新增属性

 @param cell cell
 */
-(void)didSelectedDeleteunitBtnWithCell:(ParaMeterInputCell *)cell{
    
    [_unitArr removeObject:cell.model];
    [self reloadTableView];
    
    CGRect frame = self.frame;
    frame.size.height = (_unitArr.count + 2) * 48;
    self.frame = frame;
    CGRect tableframe = _unitTableView.frame;
    tableframe.size.height = (_unitArr.count + 2) * 48;
    _unitTableView.frame = tableframe;
    if ([self.delegate respondsToSelector:@selector(didSelectedaddunitBtn)]) {
        [self.delegate didSelectedaddunitBtn];
        
        
    }
    
}

/**
 新增属性

 @param text text description
 */
-(void)didSelectedaddunitBtnwithtext:(NSString *)text{
    
    NSMutableArray *nameArr = [[NSMutableArray alloc]init];
    for (ParaMeterModel *model in _unitArr) {
        [nameArr addObject:model.ParaKind];
    }
    if ([nameArr containsObject:text]) {
        [self showTextHud:@"不能添加相同的属性"];
        return;
    }
    ParaMeterModel *model = [[ParaMeterModel alloc]init];
    model.ParaKind = text;
    model.isNew = YES;
    model.KindWay = INPUT_WAY;
    [_unitArr addObject:model];
    [self reloadTableView];
    CGRect frame = self.frame;
    frame.size.height = (_unitArr.count + 2) * 48;
    self.frame = frame;
    CGRect tableframe = _unitTableView.frame;
    tableframe.size.height = (_unitArr.count + 2) * 48;
    _unitTableView.frame = tableframe;
    if ([self.delegate respondsToSelector:@selector(didSelectedaddunitBtn)]) {
        [self.delegate didSelectedaddunitBtn];
    }
}


- (void)showTextHud:(NSString*)msg {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.hidden = NO;
    hud.mode = MBProgressHUDModeText;
    hud.label.text = msg;
    hud.margin = 10.0f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:1.5];
    [self performSelector:@selector(hideHUD:) withObject:hud afterDelay:1.5];
}

-(void) hideHUD:(MBProgressHUD*) progress {
    __block MBProgressHUD* progressC = progress;
    dispatch_async(dispatch_get_main_queue(), ^{
        [progressC hideAnimated:YES afterDelay:0                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       ];
        
        [progressC hideAnimated:YES];
        progressC = nil;
    });
}


- (NSInteger)returnNumBerLoacWithStr:(NSString *)str{
    NSString *temp =nil;
    NSInteger number=0;
    for(int i =0; i < [str length]; i++)
    {
        temp = [str substringWithRange:NSMakeRange(i,1)];
        if ([self isPureInt:temp]) {
            number = i;
        }
        NSLog(@"第%d个字是:%@",i,temp);
    }
    return number+1;
    
}
- (BOOL)isPureInt:(NSString *)string{
    NSScanner *scan = [NSScanner scannerWithString:string];
    int value;
    return [scan scanInt:&value] && [scan isAtEnd];
}

-(void)appendDataWithModel:(ParaMeterModel *)model andArr:(NSMutableArray*)dataArr{
    
    for (AttributesModel *attModel in dataArr) {
        if ([attModel.attributeName isEqualToString:model.ParaKind]) {
            if ( model.KindWay == INPUT_WAY) {
                
                model.inputValue = attModel.attributeDefaultValue;
            }
            else if ( model.KindWay == ALLTWO_WAY){
                NSInteger number = [self returnNumBerLoacWithStr: attModel.attributeDefaultValue];
                if (number>=0) {
                    model.twoValue = [attModel.attributeDefaultValue substringToIndex:number];
                    model.twoUnit = [attModel.attributeDefaultValue substringFromIndex:number];
                }
                
            }else if ( model.KindWay == SELECT_WAY&&[model.ParaKind isEqualToString:@"成分"]){
                NSArray *arr = [attModel.attributeDefaultValue componentsSeparatedByString:@","];
                for (int i = 0; i<arr.count ; i++) {
                    NSString *str = arr[i];
                    NSArray *strArr = [str componentsSeparatedByString:@"%"];
                    if (strArr.count>=2) {
                        NSDictionary *dic = @{@"chenfenunit":strArr[1],@"chenfenValue":strArr[0]};
                        [model.componentModel.chenfenArr addObject:dic];
                    }
                }
            }else{
                //纯选择
                [model.ParaNameArr addObjectsFromArray:[attModel.attributeDefaultValue componentsSeparatedByString:@","]] ;
                
            }
            
        }
    }
    
}

@end
