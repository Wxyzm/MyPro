//
//  SearchboxViewController.m
//  FyhNewProj
//
//  Created by yh f on 2017/10/31.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "SearchboxViewController.h"
#import "waTableTableViewCell.h"
#import "MJRefresh.h"
#import "GoodsItemsPL.h"
#import "MasterProModel.h"
#import "ItemsModel.h"
#import "GItemModel.h"
#import "GoodsDetailViewController.h"

#import "ShopSettingPL.h"
#import "ProEditModel.h"
#import "AttributesModel.h"
#import "PrintQrNewViewController.h"
#import "ProEditViewController.h"

@interface SearchboxViewController ()<UITableViewDelegate,UITableViewDataSource,waTableTableViewCelldelegate,UITextFieldDelegate>

@property (nonatomic, strong) UITextField *inputTF;

@property (nonatomic , strong) UITableView   *resultTableView;

@property (nonatomic,assign)LoadWayType loadWay;

@property (nonatomic, strong) NSMutableArray *loadArray;

@end

@implementation SearchboxViewController{
    
    NSMutableArray *_dataArr;
    NSInteger _currpage1;
    NSString  *_searchStr;
    NSString  *_myPrint;
}
-(UITableView *)resultTableView{
    
    if (!_resultTableView) {
        _resultTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 70, ScreenWidth, ScreenHeight - 70) style:UITableViewStylePlain];
        _resultTableView.delegate = self;
        _resultTableView.dataSource = self;
        _resultTableView.backgroundColor = UIColorFromRGB(BGColorValue);
        _resultTableView.separatorStyle = UITableViewStylePlain;
        
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(reLoadData)];
        header.automaticallyChangeAlpha = YES;
        header.stateLabel.textColor = [UIColor lightGrayColor];
        header.lastUpdatedTimeLabel.textColor = [UIColor lightGrayColor];
        _resultTableView.mj_header = header;
        
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        footer.stateLabel.textColor = [UIColor lightGrayColor];
        _resultTableView.mj_footer = footer;
        _resultTableView.mj_footer.hidden = YES;
    }
    return _resultTableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _searchStr = @"";
    self.view.backgroundColor = UIColorFromRGB(BGColorValue);
    _dataArr = [NSMutableArray arrayWithCapacity:0];
    self.loadArray = [NSMutableArray arrayWithCapacity:0];
    [self setupui];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    
    self.navigationController.navigationBar.hidden = YES;
    
}

-(void)cancelBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setupui
{
    UIView *v1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 70)];
    v1.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:v1];
    
    
    //  创建 CAGradientLayer 对象
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    //  设置 gradientLayer 的 Frame
    gradientLayer.frame = CGRectMake(0, 0, ScreenWidth, 70);
    //  gradientLayer.cornerRadius = 10;
    //  创建渐变色数组，需要转换为CGColor颜色
    gradientLayer.colors = @[(id)UIColorFromRGB(0xff2d66).CGColor,
                             (id)UIColorFromRGB(0xff4452).CGColor,
                             (id)UIColorFromRGB(0xff5d3b).CGColor];
    //  设置三种颜色变化点，取值范围 0.0~1.0
    gradientLayer.locations = @[@(0.1f) ,@(0.5f),@(1.0f)];
    
    //  设置渐变颜色方向，左上点为(0,0), 右下点为(1,1)
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 0);
    
    //  添加渐变色到创建的 UIView 上去
    [v1.layer addSublayer:gradientLayer];
    
    UIView *nameview = [[UIView alloc]initWithFrame:CGRectMake(16, 20+10, ScreenWidth-16-16-16-29, 31)];
    nameview.backgroundColor = [UIColor whiteColor];
    nameview.layer.cornerRadius = 4;
    [v1 addSubview:nameview];
    
    UIImageView *sousuoimageview = [[UIImageView alloc]initWithFrame:CGRectMake(8, 8, 17, 17)];
    sousuoimageview.image = [UIImage imageNamed:@"搜索-gray"];
    [nameview addSubview:sousuoimageview];
    
    UIButton *cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth-16-29, 38, 29, 14)];
    [cancelBtn setTitle:@"取消" forState:0];
    [cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setTintColor:UIColorFromRGB(WhiteColorValue)];
    cancelBtn.titleLabel.font = APPFONT(14);
    [v1 addSubview:cancelBtn];
    
    _inputTF = [[UITextField alloc]initWithFrame:CGRectMake(33, 8, nameview.size.width-33, 15)];
    _inputTF.placeholder = @"输入产品名称";
    _inputTF.textColor = UIColorFromRGB(0x434a54);
    _inputTF.font = APPFONT(15);
    _inputTF.delegate = self;
    _inputTF.keyboardAppearance=UIKeyboardAppearanceDefault;
    _inputTF.textAlignment = NSTextAlignmentLeft;
    _inputTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    _inputTF.clearButtonMode = UITextFieldViewModeAlways;
    _inputTF.returnKeyType = UIReturnKeyDone;
    [nameview addSubview:_inputTF];
    [self.view addSubview:self.resultTableView];
    

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 152;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
        static NSString *oncellId = @"oncell";
        waTableTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:oncellId];
        if (!cell) {
            cell = [[waTableTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:oncellId];
            cell.delegate = self;
            
            
        }
        cell.type = 3;
        cell.model = _dataArr[indexPath.row];
        return cell;
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    waTableTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSArray *itemArr = cell.model.itemList;
    
    if (itemArr.count<=0) {
        return;
    }
    GItemModel *itemModel = itemArr[0];
    GoodsDetailViewController *deVC= [[GoodsDetailViewController alloc]init];
    ItemsModel *model = [[ItemsModel alloc]init];
    model.itemId = itemModel.itemID;
    deVC.itemModel = model;
    [self.navigationController  pushViewController:deVC animated:YES];
}



-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField.text.length <=0) {
        [self showTextHud:@"请输入搜索内容"];
        return YES;
    }
    _currpage1 = 1;
    _searchStr = textField.text;
    self.loadWay = RELOAD_DADTAS;

    [self loadData];
    [textField resignFirstResponder];
    return YES;
}


- (void)loadData{
    
    
    NSDictionary *infoDic = @{@"pageNum":[NSString stringWithFormat:@"%ld",(long)_currpage1],
                              @"name":_searchStr,
                              @"categoryId":@"",
                              @"status":@"",
                              @"isSample":@""
                              };
    
    [GoodsItemsPL UserGetHisMasterProWithGoodsInfo:infoDic ReturnBlock:^(id returnValue) {
        NSDictionary *resultDic = returnValue[@"data"];
        self.loadArray = [MasterProModel mj_objectArrayWithKeyValuesArray:resultDic[@"products"]];
        [self loadSuccess];
        [self endLoading];
    } andErrorBlock:^(NSString *msg) {
        [self showTextHud:msg];
        [self endLoading];
    }];
    
    
}


- (void)loadSuccess{
    if (self.loadArray.count > 0 )
    {
        if (self.loadWay != LOAD_MORE_DATAS)
        {
            _currpage1 = 1;
        }
        _currpage1 ++;
    }
    
    if (self.loadWay == START_LOAD_FIRST || self.loadWay == RELOAD_DADTAS) {
        [_dataArr  removeAllObjects];
    }
    
    [_dataArr addObjectsFromArray:self.loadArray];
    [_resultTableView reloadData];
    if (self.loadArray.count < 30) {
        _resultTableView.mj_footer.hidden = YES;
    } else {
        _resultTableView.mj_footer.hidden = NO;
    }
    
}

- (void)endLoading{
    
    [_resultTableView.mj_header endRefreshing];
    [_resultTableView.mj_footer endRefreshing];
    
}
#pragma mark ======== 上拉加载，下拉刷新
/**
 上拉加载
 */
- (void)loadMoreData{
        self.loadWay = LOAD_MORE_DATAS;
        [self loadData];
   
    }
- (void)reLoadData{
    _currpage1 = 1;
    self.loadWay = RELOAD_DADTAS;

    [self loadData];
    
    
}
#pragma mark ======== GoodsManageCellDelegate
/**
 编辑
 
 @param cell cell
 */
-(void)didselectedEditBtnWithCell:(waTableTableViewCell *)cell{
    
    ProEditViewController   *editVc = [[ProEditViewController alloc]init];
    editVc.idStr  = [NSString stringWithFormat:@"%ld",(long)cell.model.masterId];
    [self.navigationController pushViewController:editVc animated:YES];
    
}





/**
 下架/上架
 
 @param cell cell
 */
-(void)didselectedDownBtnWithCell:(waTableTableViewCell *)cell{
   
        if (cell.model.status == 0) {
            //仓库中
            [GoodsItemsPL UserOnSaleProductwithIProId:[NSString stringWithFormat:@"%ld",(long)cell.model.masterId ] ReturnBlock:^(id returnValue) {
                [self showTextHud:@"上架成功"];
                cell.model.status = 1;
                [_resultTableView reloadData];
            } andErrorBlock:^(NSString *msg) {
                [self showTextHud:msg];
            }];
            
        }else{
            //上架中
            [GoodsItemsPL UserNotSaleProductwithIProId:[NSString stringWithFormat:@"%ld",(long)cell.model.masterId ] ReturnBlock:^(id returnValue) {
                [self showTextHud:@"下架成功"];
                cell.model.status = 0;
                [_resultTableView reloadData];
            } andErrorBlock:^(NSString *msg) {
                [self showTextHud:msg];
                
            }];
            
        
        
    }
    
}

/**
 删除
 
 @param cell cell
 */
-(void)didselectedDeleteBtnWithCell:(waTableTableViewCell *)cell{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定删除么" preferredStyle:UIAlertControllerStyleAlert];
    [alert  addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [GoodsItemsPL UserDeleteProductwithIProId:[NSString stringWithFormat:@"%ld",(long)cell.model.masterId ] ReturnBlock:^(id returnValue) {
            [self showTextHud:@"删除成功"];
            [_dataArr removeObject:cell.model];
            [_resultTableView reloadData];
        } andErrorBlock:^(NSString *msg) {
            [self showTextHud:msg];
        }];
        
    }]];
    [alert  addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        
    }]];
    [self presentViewController:alert animated:YES completion:nil];
    
    
}

//打印

- (void)didselectedPrintBtnClickWithCell:(waTableTableViewCell *)cell
{
    if (!_myPrint) {
        [ShopSettingPL getTheShopSettingInfoWithReturnBlock:^(id returnValue) {
            if ([returnValue[@"isShopAllowUseAppPrinter"] boolValue]) {
                _myPrint = @"YES";
                [self printWithCell:cell];
                
            }else{
                _myPrint = @"NO";
                [self showTextHud:@"您没有打印权限，详情请联系客服"];
            }
        } andErrorBlock:^(NSString *msg) {
            [self showTextHud:msg];
        }];
        
    }else{
        if ([_myPrint isEqualToString:@"NO"]) {
            [self showTextHud:@"您没有打印权限，详情请联系客服"];
            return;
        }else{
            [self printWithCell:cell];
        }
        
    }
  
}
- (void)printWithCell:(waTableTableViewCell *)cell{
    [GoodsItemsPL UserGetHisMasterProDETAILWithProId:[NSString stringWithFormat:@"%ld",(long)cell.model.masterId] ReturnBlock:^(id returnValue) {
        ProEditModel *model = [ProEditModel mj_objectWithKeyValues:returnValue[@"data"][@"product"]];
        NSLog(@"%@",returnValue);
        NSMutableArray *chenfenArr = model.attributes;
        NSString *customBn= @"";
        NSString *Width=@"";
        NSString *bn=@"";
        NSString *ingredient=@"";
        for (AttributesModel *attModel in chenfenArr) {
            if ([attModel.attributeName isEqualToString:@"货号"]) {
                customBn = attModel.attributeDefaultValue;
            }
            if ([attModel.attributeName isEqualToString:@"门幅"]) {
                Width = attModel.attributeDefaultValue;
            }
            if ([attModel.attributeName isEqualToString:@"克重"]) {
                bn = attModel.attributeDefaultValue;
            }
            if ([attModel.attributeName isEqualToString:@"成分"]) {
                ingredient = attModel.attributeDefaultValue;
            }
        }
        GItemModel *itModel  = model.itemsInCurrentSpecification[0];
        NSDictionary *  printDic = @{@"url":[NSString stringWithFormat:@"%@/item/%@",kbaseUrl,itModel.itemID],
                                     @"title":model.name,
                                     @"customBn":customBn,             //货号
                                     @"Width":Width,                   //门幅
                                     @"bn":bn,                         //克重
                                     @"ingredient":ingredient          //成分
                                     };
        
        PrintQrNewViewController *prVc = [[PrintQrNewViewController alloc]init];
        prVc.infoDic = printDic;
        [self.navigationController pushViewController:prVc animated:YES];
    } andErrorBlock:^(NSString *msg) {
        [self showTextHud:msg];
    }];
    
}
@end
