//
//  ShoppingCarViewController.m
//  FyhNewProj          
//
//  Created by yh f on 2017/3/4.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "ShoppingCarViewController.h"
#import "MakeSureOrderViewController.h"
#import "BusinessesShopViewController.h"
#import "ShopCartModel.h"
#import "ShopCartitemsModel.h"
#import "ShopCartCell.h"
#import "ShopCartTopCell.h"
#import "GoForShoppingView.h"
#import "ShopCartPL.h"
#import "ShopCartDataModel.h"
#import "GoodsDetailViewController.h"
#import "ItemsModel.h"
#import "MBProgressHUD+Add.h"
#import "AppDelegate.h"
#import "DOTabBarController.h"


@interface ShoppingCarViewController ()<UITableViewDelegate,UITableViewDataSource,ShopCartCellDelegate,ShopCartTopCellDelegate>

@property (nonatomic,strong)UITableView *AllTabView;           //全部

@property (nonatomic,strong)UIView *settleView;                //底部结算View

@property (nonatomic,strong)UIView *noGoodsView;                //底部结算View

@end

@implementation ShoppingCarViewController{
    
    NSMutableArray      *_dataArr;                  //数据
    GoForShoppingView   *_goView;                   //逛一逛阿牛
    YLButton            *_allSelectBtn;             //全选
    UILabel             *_moneyLab;                 //结算总价
    SubBtn              *_settleBtn;                //结算按钮
    NSMutableArray      *_settlementArr;            //结算
}

#pragma mark   ======  get

-(UITableView *)AllTabView{
    
    if (!_AllTabView) {
        _AllTabView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth,ScreenHeight-64-60-40) style:UITableViewStylePlain];
//        _AllTabView.bounces = NO;
        _AllTabView.delegate = self;
        _AllTabView.dataSource = self;
        _AllTabView.backgroundColor = UIColorFromRGB(WhiteColorValue);
        _AllTabView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    return _AllTabView;
    
}
-(UIView *)settleView{
    if (!_settleView) {
        _settleView = [BaseViewFactory viewWithFrame:CGRectMake(0, ScreenHeight-64-60-40, ScreenWidth, 40) color:UIColorFromRGB(WhiteColorValue)];
    
        [self createLineWithColor:UIColorFromRGB(PlaColorValue) frame:CGRectMake(0, 0, ScreenWidth, 0.5) Super:_settleView];
        
        _allSelectBtn = [YLButton buttonWithType:UIButtonTypeCustom];
        [_allSelectBtn setTitle:@"全选" forState:UIControlStateNormal];
        [_allSelectBtn setTitleColor:UIColorFromRGB(BlackColorValue) forState:UIControlStateNormal];
        [_allSelectBtn setImage:[UIImage imageNamed:@"circle-40"] forState:UIControlStateNormal];
        [_allSelectBtn setTitleRect:CGRectMake(30, 0, 60, 40)];
        [_allSelectBtn setImageRect:CGRectMake(0, 10, 20, 20)];
        _allSelectBtn.titleLabel.font = APPFONT(13);
        _allSelectBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
        [_settleView  addSubview:_allSelectBtn];
        _allSelectBtn.frame =CGRectMake(20, 0, 100, 40);
        [_allSelectBtn addTarget:self action:@selector(seletedAllTheGoodItems) forControlEvents:UIControlEventTouchUpInside];
        
        _settleBtn = [SubBtn buttonWithtitle:@"结算(0)" titlecolor:UIColorFromRGB(WhiteColorValue) cornerRadius:0 andtarget:self action:@selector(setupGoosInfo) andframe:CGRectMake(ScreenWidth-62.5, 0, 62.5, 40)];
        _settleBtn.titleLabel.font = APPFONT(12);
        [_settleView addSubview:_settleBtn];
        
        
        _moneyLab = [BaseViewFactory labelWithFrame:CGRectMake(120, 0, ScreenWidth-212.5, 40) textColor:UIColorFromRGB(RedColorValue) font:APPFONT(13) textAligment:NSTextAlignmentRight andtext:@"合计：￥0(不含运费)"];
        NSString *str1 = @"合计：";
        NSString *str2 = @"(不含运费)";
        NSRange range1 = [_moneyLab.text rangeOfString:str1];
        NSRange range2 = [_moneyLab.text rangeOfString:str2];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:_moneyLab.text];
        [str addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(BlackColorValue) range:range1];
        [str addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(PlaColorValue) range:range2];
        _moneyLab.attributedText = str;
        [_settleView addSubview:_moneyLab];
    
    }

    return _settleView;
}


-(UIView *)noGoodsView{
    if (!_noGoodsView) {
        _noGoodsView = [[UIView alloc]init];
        _noGoodsView.bounds = CGRectMake(0, 0, ScreenWidth, 188);
        _noGoodsView.center = CGPointMake(ScreenWidth/2, (ScreenHeight-64-60)/2);
        _noGoodsView.backgroundColor = UIColorFromRGB(WhiteColorValue);
        UIImageView *shopImV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cart-empty"]];
        [_noGoodsView addSubview:shopImV];
        shopImV.frame = CGRectMake(ScreenWidth/2 - 55.5, 0, 111, 88);
        UILabel *lab = [BaseViewFactory labelWithFrame:CGRectMake(0, 108, ScreenWidth, 15) textColor:UIColorFromRGB(BlackColorValue) font:APPFONT(14) textAligment:NSTextAlignmentCenter andtext:@"您的购物车是空的~"];
        [_noGoodsView addSubview:lab];
        
        SubBtn *btn = [SubBtn buttonWithtitle:@"去逛逛" titlecolor:UIColorFromRGB(WhiteColorValue) cornerRadius:5 andtarget:self action:@selector(gotoShoppingBtnClick) andframe:CGRectMake(15, 144, ScreenWidth - 30, 40)];
        [_noGoodsView addSubview:btn];
        [self.view addSubview:_noGoodsView];
        
    }

    return _noGoodsView;
}


#pragma mark   ======  viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArr = [NSMutableArray  array];
    _settlementArr = [NSMutableArray arrayWithCapacity:0];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shopcartShouldRefresh)
                                                 name:@"shopcartShouldRefresh"  object:nil];

    
    [self loadShopCartDatas];
    [self initUI];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;

    [self shopcartShouldRefresh];
}

#pragma mark   ======  initUI
- (void)initUI{
    _goView = [[GoForShoppingView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth,ScreenHeight-64-60)];
    [self.view addSubview:_goView];
    _goView.hidden = YES;
    [self.view addSubview:self.AllTabView];
    [self.view addSubview:self.settleView];
}

#pragma mark   ======  NETTOOL

- (void)loadShopCartDatas{

 [ShopCartPL getUserShopCartDataswithReturnBlock:^(id returnValue) {
     _dataArr = [ShopCartDataModel mj_objectArrayWithKeyValuesArray:returnValue[@"data"][@"cartItemsData"]];
     [self nothingShopCart];
     [self.AllTabView reloadData];
 } andErrorBlock:^(NSString *msg) {
     [self showTextHud:msg];
      [self nothingShopCart];
 }];
}

- (void)shopcartShouldRefresh{

    [_dataArr removeAllObjects];
    [self.AllTabView reloadData];
    [self settlementMoney];
    [self seletedAllTheGoodItems];
    [ShopCartPL getUserShopCartDataswithReturnBlock:^(id returnValue) {
        _dataArr = [ShopCartDataModel mj_objectArrayWithKeyValuesArray:returnValue[@"data"][@"cartItemsData"]];
         [self nothingShopCart];
        [self.AllTabView reloadData];
    } andErrorBlock:^(NSString *msg) {
        [self showTextHud:msg];
         [self nothingShopCart];
    }];
}


#pragma  mark ======= tableViewdelegate and datasource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return _dataArr.count;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    ShopCartDataModel *model = _dataArr[section];
    return model.cartItems.count +1;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    ShopCartDataModel *model = _dataArr[indexPath.section];
    if (indexPath.row == 0) {
        return 40;
    }else if (indexPath.row ==model.cartItems.count ){
        return 112;
    }
    return 100;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    if (indexPath.section ==0&&indexPath.row == 0) {
//        static NSString *cellid = @"onetopcellid";
//        ShopCartTopCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
//        if (!cell) {
//            cell = [[ShopCartTopCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//           
//
//            for (UIView * view in cell.contentView.subviews) {
//                CGRect frame = view.frame;
//                frame.origin.y -= 12;
//                view.frame = frame;
//            }
//        }
//       
//        cell.delegate = self;
//        cell.model = _dataArr[indexPath.section];
//       
//        return cell;
//    }else{
        if (indexPath.row == 0) {
            static NSString *cellid = @"topcellid";
            
            ShopCartTopCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
            if (!cell) {
                cell = [[ShopCartTopCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell.delegate = self;
            cell.model = _dataArr[indexPath.section];
            return cell;
        }else{
            static NSString *cellid = @"ordercell";
            ShopCartCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
            if (!cell) {
                cell = [[ShopCartCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell.delegate = self;
            
            ShopCartDataModel *model = _dataArr[indexPath.section];
            cell.model = model.cartItems[indexPath.row-1];
            return cell;
        }
//    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        
//        ShopCartDataModel *model = _dataArr[indexPath.section];
//        BusinessesShopViewController  *bussVc = [[BusinessesShopViewController  alloc]init];
//        bussVc.shopId = model.sellerId;
//        [self.navigationController pushViewController:bussVc animated:YES];
        
        return;
    }
    
    ShopCartDataModel *model = _dataArr[indexPath.section];
    ShopCartModel *cartModel = model.cartItems[indexPath.row-1];

    ItemsModel  *itemModel = [[ItemsModel alloc]init];;
    itemModel.price = cartModel.price;
    itemModel.title = cartModel.itemTitle;
    itemModel.itemId = cartModel.itemId;
    GoodsDetailViewController *devc = [[GoodsDetailViewController alloc]init];
    if ([itemModel.shopCertificationType isEqualToString:@"1"]||!itemModel.shopCertificationType||[itemModel.shopCertificationType isEqualToString:@""]) {
        devc.shopType = 1; //个人
    }else{
        devc.shopType = 2; //商家
    }
    devc.itemModel = itemModel;
    [self.navigationController pushViewController:devc animated:YES];

}

#pragma mark ========== shopCartGoodBtnClick购物车选中
/**
 删除按钮

 @param cell 点击的cell
 */
-(void)shopDeleteBtnClickWithCell:(ShopCartCell *)cell{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确认删除商品？" preferredStyle:UIAlertControllerStyleAlert];
    [alert  addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [ShopCartPL DeleteShopCartItemsWithItemId:cell.model.proId andReturnBlock:^(id returnValue) {
            
            for (ShopCartDataModel *model in _dataArr) {
                NSMutableArray *arr = [model.cartItems mutableCopy];
                for (ShopCartModel *cartModel in arr) {
                    if ([cartModel.proId isEqualToString:cell.model.proId]) {
                        NSInteger index = [arr indexOfObject:cartModel];
                        [model.cartItems removeObjectAtIndex:index];
                    }
                }
            }
            NSMutableArray *DataModelArr = [_dataArr mutableCopy];
            for (ShopCartDataModel *model in DataModelArr) {
                if (model.cartItems.count<=0) {
                    NSInteger index = [DataModelArr indexOfObject:model];
                    [_dataArr removeObjectAtIndex:index];
                }
            }
            
            [self settlementMoney];
            [self isSelecTedAllGoods];
            [self.AllTabView reloadData];
            [self nothingShopCart];
        } andErrorBlock:^(NSString *msg) {
            [self showTextHud:msg];
            [self nothingShopCart];
        }];

    }]];
    [alert  addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }]];
    [self presentViewController:alert animated:YES completion:nil];

    

}

/**
 购物车选中
 
 @param cell 购物车Item
 */
- (void)shopBtnTabVClick:(ShopCartCell *)cell{
    

    
    [self isSelectedTheItemswithCell:cell];
    
    if ([self isSelecTedAllGoods]) {
        [_allSelectBtn setImage:[UIImage imageNamed:@"iv_cart_chose"] forState:UIControlStateNormal];

    }else{
        [_allSelectBtn setImage:[UIImage imageNamed:@"circle-40"] forState:UIControlStateNormal];

    }
    
    [self.AllTabView reloadData];
    [self settlementMoney];

    
}
#pragma mark ========== 商家选中

/**
 是否已全选
 */
- (BOOL)isSelecTedAllGoods{
    for (ShopCartDataModel *model in _dataArr) {
        NSMutableArray *arr = [model.cartItems mutableCopy];
        for (ShopCartModel *cartModel in arr) {
            if (!cartModel.selected) {
                return NO;
            }
            
        }
    }
    return YES;
}


/**
 点击子商品时判断商家子商品是否全选

 @param cell 子商品对应cell
 */
- (void)isSelectedTheItemswithCell:(ShopCartCell *)cell{

    for (ShopCartDataModel *model in _dataArr) {
        NSMutableArray *arr = [model.cartItems mutableCopy];
        for (ShopCartModel *cartModel in arr) {
            if ([cartModel.proId isEqualToString:cell.model.proId]) {
                for (ShopCartModel *cartselectedModel in model.cartItems) {
                    if (!cartselectedModel.selected) {
                        model.selected = NO;
                        return;

                    }else{
                        model.selected = YES;
                    }
                }
                
            }
        }
    }
    [self settlementMoney];

}


/**
 选中

 @param cell 商家cell
 */
-(void)shopTopLeftBtnClick:(ShopCartTopCell *)cell{
    cell.model.selected = !cell.model.selected;
    if (cell.model.selected) {
        //选中
        for (ShopCartModel *cartModel in cell.model.cartItems) {
            cartModel.selected = YES;
        }
    }else{
        for (ShopCartModel *cartModel in cell.model.cartItems) {
            cartModel.selected = NO;
        }
    }
    if ([self isSelecTedAllGoods]) {
        [_allSelectBtn setImage:[UIImage imageNamed:@"iv_cart_chose"] forState:UIControlStateNormal];
        
    }else{
        [_allSelectBtn setImage:[UIImage imageNamed:@"circle-40"] forState:UIControlStateNormal];
        
    }
    [self.AllTabView reloadData];
    [self settlementMoney];


}

-(void)shopTopReceiveBtnClick:(ShopCartTopCell *)cell{

    [self showTextHud:@"暂未开放"];

}

-(void)shopTopEditBtnClick:(ShopCartTopCell *)cell{
    
    ShopCartDataModel *model = cell.model;
    if (model.edit) {
        for (ShopCartModel *cartmodel in model.cartItems) {
            cartmodel.edit = YES;
        }
        [self.AllTabView reloadData];
        [self settlementMoney];

    }else{
        
        
        
        
        NSIndexPath *theindexPath = [self.AllTabView indexPathForCell:cell];
        if (theindexPath) {
            ShopCartDataModel *model = _dataArr[theindexPath.section];
            NSMutableArray *setArr = [NSMutableArray arrayWithCapacity:0];
            [MBProgressHUD showMessag:@"" toView:self.view];

            for (int i = 0; i<model.cartItems.count; i++) {
                ShopCartModel *netModel = model.cartItems[i];
                NSIndexPath *newindexPath = [NSIndexPath indexPathForRow:theindexPath.row + (i+1) inSection:theindexPath.section];
                ShopCartCell *newcell = [self.AllTabView cellForRowAtIndexPath:newindexPath];
                newcell.model.quantity = newcell.numTxt.text;
                for (ShopCartModel *cartmodel in model.cartItems) {
                    cartmodel.edit = NO;
                }
                [self.AllTabView reloadData];
                [self settlementMoney];
                NSDictionary *infoDic = @{
                                          @"id":netModel.proId,
                                          @"quantity":netModel.quantity,
                                          @"isChecked":@"false"
                                          };
                [setArr addObject:[self dictionaryToJson:infoDic]];

            }
            NSString *setStr = [NSString stringWithFormat:@"[%@]",[setArr componentsJoinedByString:@","]];
            
            
            [ShopCartPL ChangeShopCartItemsWithItemId:setStr andReturnBlock:^(id returnValue) {
                NSLog(@"groupQueue中的任务 都执行完成,回到主线程更新UI======%@",setStr);
                [MBProgressHUD hideHUDForView:self.view animated:YES];

            } andErrorBlock:^(NSString *msg) {
                [self showTextHud:msg];
                [MBProgressHUD hideHUDForView:self.view animated:YES];

            }];
            
            
           
            
        }
    }

}

-(void)shopTopshopBtnClick:(ShopCartTopCell *)cell{



}


- (void)shopGoTopShopBtnClick:(ShopCartTopCell *)cell{
            BusinessesShopViewController  *bussVc = [[BusinessesShopViewController  alloc]init];
            bussVc.shopId = cell.model.sellerId;
            [self.navigationController pushViewController:bussVc animated:YES];

}

#pragma mark========= 全选

/**
 全选
 */
- (void)seletedAllTheGoodItems{
    
    
    if ([self isSelecTedAllGoods]) {
        for (ShopCartDataModel *model in _dataArr) {
            model.selected = NO;
            for (ShopCartModel *cartModel in model.cartItems) {
                cartModel.selected = NO;
                
            }
        }
        [_allSelectBtn setImage:[UIImage imageNamed:@"circle-40"] forState:UIControlStateNormal];

    }else{
        for (ShopCartDataModel *model in _dataArr) {
            model.selected = YES;
            for (ShopCartModel *cartModel in model.cartItems) {
                cartModel.selected = YES;
                
            }
        }
        [_allSelectBtn setImage:[UIImage imageNamed:@"iv_cart_chose"] forState:UIControlStateNormal];
    }
    [self settlementMoney];
    [self.AllTabView reloadData];

}

#pragma mark========= 结算

- (void)setupGoosInfo{

    
    
    
    NSMutableArray *buyArr = [NSMutableArray arrayWithCapacity:0];
    for (ShopCartDataModel *model in _dataArr) {
        ShopCartDataModel *newmodel = [[ShopCartDataModel alloc]init];
        for (ShopCartModel *cartModel in model.cartItems) {
            if (cartModel.edit) {
                [self showTextHud:@"商品编辑完成后才可结算"];
                return;
            }
            
            if (cartModel.selected) {
                newmodel.sellerInfo = model.sellerInfo;
                newmodel.sellerId = model.sellerId;
                [newmodel.cartItems addObject:cartModel];
                
            }
        }
        if (newmodel.cartItems.count >0) {
            [buyArr addObject:newmodel];

        }
    }
    if (buyArr.count <=0) {
        
        return;
    }
    
    
    MakeSureOrderViewController  *makeVc = [[MakeSureOrderViewController alloc]init];
    makeVc.type = 1;
    makeVc.dataArr = buyArr;
    [self.navigationController pushViewController:makeVc animated:YES];
    
}


/**
 去逛逛
 */
- (void)gotoShoppingBtnClick{

    AppDelegate *app = (AppDelegate *)[[UIApplication  sharedApplication] delegate];
    app.mainController.selectedIndex = 0;
    


}



- (void)settlementMoney{
    [_settlementArr removeAllObjects];
    CGFloat   totleMoney = 0;

    for (ShopCartDataModel *model in _dataArr) {
        for (ShopCartModel *cartModel in model.cartItems) {
            if (cartModel.selected) {
                [_settlementArr addObject:cartModel];
                CGFloat money = [cartModel.quantity  floatValue]*[cartModel.price floatValue];
                totleMoney += money;
            }
        }
    }
    _moneyLab.text = [NSString stringWithFormat:@"合计：￥%.2f(不含运费)",totleMoney];
    [_settleBtn setTitle:[NSString stringWithFormat:@"结算(%lu)",(unsigned long)_settlementArr.count] forState:UIControlStateNormal];

}


- (void)nothingShopCart{

    if (_dataArr.count<=0) {
        self.noGoodsView.hidden = NO;
        self.settleView.hidden = YES;
        _AllTabView.frame =CGRectMake(0, 0, ScreenWidth,ScreenHeight-64-60);
    }else{
        self.noGoodsView.hidden =YES ;
        self.settleView.hidden = NO;
        _AllTabView.frame =CGRectMake(0, 0, ScreenWidth,ScreenHeight-64-60-40);
    
    }
    
}

//词典转换为字符串
- (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}
@end
