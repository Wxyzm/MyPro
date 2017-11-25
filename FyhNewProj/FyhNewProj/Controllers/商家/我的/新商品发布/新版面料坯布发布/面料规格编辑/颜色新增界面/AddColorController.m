//
//  AddColorController.m
//  FyhNewProj
//
//  Created by yh f on 2017/11/2.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "AddColorController.h"
#import "ColorSelectedCell.h"
#import "AddUnitView.h"

#import "ColorModel.h"

@interface AddColorController ()<UITableViewDelegate,UITableViewDataSource,AddUnitViewDelegate>

@property (nonatomic , strong) AddUnitView *addView;

@end

@implementation AddColorController{
    
    
    UITableView *_colorTableView;
    NSMutableArray  *_dataArr;
    
}
-(AddUnitView *)addView{
    
    if (!_addView) {
        _addView = [[AddUnitView alloc]init];
        _addView.delegate = self;
        _addView.type = 1;
    }
    return _addView;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBarBackBtnWithImage:[UIImage imageNamed:@"back-d"]];
    self.view.backgroundColor = UIColorFromRGB(BGColorValue);
    UILabel *titlelab;
    titlelab = [BaseViewFactory labelWithFrame:CGRectMake(0, 0, 200, 44) textColor:UIColorFromRGB(BlackColorValue) font:APPFONT(18) textAligment:NSTextAlignmentCenter andtext:@"颜色"];
    self.navigationItem.titleView = titlelab;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    if (!_dataArr) {
        _dataArr = [NSMutableArray arrayWithCapacity:0];

    }
    if (!_colorArr) {
        _colorArr = [NSMutableArray arrayWithCapacity:0];

    }
    [self createNavagationItem];
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    UIView *myView = [[self.navigationController valueForKey:@"_navigationBar"] valueForKey:@"_backgroundView"];
    myView.backgroundColor = [UIColor whiteColor];
    myView.layer.sublayers[0].hidden = YES;
    for (CALayer *layers in myView.layer.sublayers) {
        layers.hidden = YES;
    }
    NSLog(@"%@",myView.layer.sublayers);
    self.navigationController.navigationBar.backgroundColor = UIColorFromRGB(WhiteColorValue);
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    UIView *myView = [[self.navigationController valueForKey:@"_navigationBar"] valueForKey:@"_backgroundView"];
    for (CALayer *layers in myView.layer.sublayers) {
        layers.hidden = NO;
    }
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

}


- (void)createNavagationItem
{
    UIButton *  btn = [YLButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"确认" forState:UIControlStateNormal];
    btn.titleLabel.font = APPFONT(15);
    [btn setTitleColor:UIColorFromRGB(BlackColorValue) forState:UIControlStateNormal];
    btn.frame = CGRectMake(0, 0, 40, 40);
    UIBarButtonItem * choiceCityBtn = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [btn addTarget:self action:@selector(sureBtnclick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = choiceCityBtn;
}



- (void)sureBtnclick{
    
    // 逆序遍历,然后查找删除
    NSEnumerator *enumerator = [_colorArr reverseObjectEnumerator];
    //forin遍历
    for (ColorModel *groupModel in enumerator) {
        if (!groupModel.IsSelected) {
            [_colorArr removeObject:groupModel];
        }
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UserHaveSelectedColor" object:nil];
    [self.navigationController  popViewControllerAnimated:YES];}

- (void)initUI{
    
    
    UIView *topView = [BaseViewFactory viewWithFrame:CGRectMake(0, 12, ScreenWidth, 48) color:UIColorFromRGB(WhiteColorValue)];
    [self.view addSubview:topView];
    
    [self createLabelWith:UIColorFromRGB(BlackColorValue) Font:APPFONT(15) WithSuper:topView Frame:CGRectMake(16, 0, 200, 48) Alignment:NSTextAlignmentLeft Text:@"自定义颜色"];
    
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [topView addSubview:addBtn];
    [addBtn setImage:[UIImage imageNamed:@"Create_add"] forState:UIControlStateNormal];
    addBtn.frame = CGRectMake(ScreenWidth - 34, 15, 18, 18);
    [addBtn addTarget:self action:@selector(addBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    _colorTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,72, ScreenWidth, ScreenHeight-64-72) style:UITableViewStylePlain];
    _colorTableView.delegate = self;
    _colorTableView.dataSource = self;
    _colorTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_colorTableView];
    
    
    
}


-(void)setColorArr:(NSMutableArray *)colorArr{
    
    
    _colorArr = colorArr;
  
    if (!_dataArr) {
        _dataArr = [NSMutableArray arrayWithCapacity:0];
    }
    
    NSMutableArray *locaColorArr;
    if (_type == 0||_type == 3||_type == 4||_type == 5) {
        locaColorArr = [NSMutableArray arrayWithObjects:@"白色系",@"黑色系",@"红色系",@"黄色系",@"绿色系",@"蓝色系",@"紫色系",@"棕色系",@"花色系",@"透明系", nil];
    }else if (_type == 1||_type ==2){
        
        locaColorArr = [NSMutableArray arrayWithObjects:@"JPG",@"AI",@"PSD",@"样衣",@"TIFF",@"米样",@"米样+花型",@"分层稿",@"金昌",@"挂钩", nil];

    }
    
    
    NSMutableArray *selectedColorArr = [NSMutableArray arrayWithCapacity:0];//选中的颜色
    for (ColorModel *model in colorArr) {
        if (model.IsSelected) {
            [selectedColorArr addObject:model.colorName];

        }
        if (![locaColorArr containsObject:model.colorName]) {
            [locaColorArr insertObject:model.colorName atIndex:0];
//            [locaColorArr addObject:model.colorName];
        }
    }
    
    
    for (NSString *colorStr in locaColorArr)
    {
        ColorModel *model = [[ColorModel alloc]init];
        model.colorName = colorStr;
        if ([selectedColorArr containsObject:model.colorName]) 
        {
            model.IsSelected = YES;
        }else{
            model.IsSelected = NO;
            
        }
        [_dataArr addObject:model];
    }

    [_colorTableView reloadData];
    
}

#pragma mark ========= tableviewdelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 48;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *colorCeillid = @"colorCeillid";
    ColorSelectedCell *cell = [tableView dequeueReusableCellWithIdentifier:colorCeillid ];
    if (!cell) {
        cell = [[ColorSelectedCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:colorCeillid];
    }
    cell.Model = _dataArr[indexPath.row];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ColorModel *model = _dataArr[indexPath.row];
    model.IsSelected = !model.IsSelected;
    if (model.IsSelected)
    {
        [_colorArr addObject:model];
    }
    else
    {
        NSMutableArray *selectedColorArr = [NSMutableArray arrayWithCapacity:0];//选中的颜色
        for (ColorModel *model in _colorArr) {
                [selectedColorArr addObject:model.colorName];
        }
        
        if ([selectedColorArr containsObject:model.colorName]) {
            NSInteger indes = [selectedColorArr indexOfObject:model.colorName];
            if (indes<=_colorArr.count) {
                [_colorArr removeObjectAtIndex:indes];

            }
        }
        
    }
    [_colorTableView reloadData];
    
    
}


-(void)respondToLeftButtonClickEvent{
    
    // 逆序遍历,然后查找删除
    NSEnumerator *enumerator = [_colorArr reverseObjectEnumerator];
    //forin遍历
    for (ColorModel *groupModel in enumerator) {
        if (!groupModel.IsSelected) {
            [_colorArr removeObject:groupModel];
        }
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UserHaveSelectedColor" object:nil];
    [self.navigationController  popViewControllerAnimated:YES];
    
}


/**
 新增颜色
 */
- (void)addBtnClick{
    
    [self.addView showinView:self.view];
    
    
}
-(void)didSelectedaddunitBtnwithtext:(NSString *)text{
    
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];

    for (ColorModel *model in _dataArr) {
        [arr addObject:model.colorName];
    }
    if ([arr containsObject:text]) {
        [self showTextHud:@"不能添加相同的颜色"];
        return;
    }
    ColorModel *model = [[ColorModel alloc]init];
    model.colorName = text;
    model.IsSelected = YES;
//    [_dataArr addObject:model];
    [_dataArr insertObject:model atIndex:0];
    [_colorArr addObject:model];
    [_colorTableView reloadData];
    

}
@end
