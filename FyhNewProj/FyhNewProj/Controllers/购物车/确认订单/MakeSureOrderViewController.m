//
//  MakeSureOrderViewController.m
//  FyhNewProj
//
//  Created by yh f on 2017/4/17.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "MakeSureOrderViewController.h"
#import "AdministrationaddViewController.h"
#import "OrderAdressView.h"
#import "ShopCartTopCell.h"
#import "ShopBuyCell.h"
#import "ShopCartModel.h"
#import "ShopBoomCell.h"
#import "ShopCartDataModel.h"
#import "AdressModel.h"
#import "AcceptAdressPL.h"
#import "PayWayView.h"
#import "PayPL.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
#import "MyOrderController.h"
#import "BusinessesShopViewController.h"

@interface MakeSureOrderViewController ()<UITableViewDelegate,UITableViewDataSource,ShopCartTopCellDelegate,PayWayViewDelegate>

@property (nonatomic,strong)UITableView *OrderTabView;

@property (nonatomic,strong)OrderAdressView *adressView;

@property (nonatomic,strong)UIView *settleView;                //底部结算View

@property (nonatomic , strong) PayWayView *payWayView;

@end

@implementation MakeSureOrderViewController{

    NSMutableArray  *_dataArr;
    SubBtn  *_settleBtn;
    UILabel *_moneyLab;
    BOOL    _isSelectedAdress;
    AdressModel *_model;
    CGFloat _Height;
}


-(UITableView *)OrderTabView{
    
    if (!_OrderTabView) {
        _OrderTabView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth,ScreenHeight-NaviHeight64-iPhoneX_DOWNHEIGHT-40) style:UITableViewStylePlain];
        _OrderTabView.bounces = NO;
        _OrderTabView.delegate = self;
        _OrderTabView.dataSource = self;
        _OrderTabView.backgroundColor = UIColorFromRGB(WhiteColorValue);
        _OrderTabView.separatorStyle = UITableViewCellSeparatorStyleNone;
        if (@available(iOS 11.0, *)) {
            _OrderTabView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
    }
    return _OrderTabView;
    
}
-(UIView *)settleView{
    if (!_settleView) {
        _settleView = [BaseViewFactory viewWithFrame:CGRectMake(0, ScreenHeight-NaviHeight64-iPhoneX_DOWNHEIGHT-40, ScreenWidth, 40) color:UIColorFromRGB(WhiteColorValue)];
        
        [self createLineWithColor:UIColorFromRGB(PlaColorValue) frame:CGRectMake(0, 0, ScreenWidth, 0.5) Super:_settleView];
        
        _settleBtn = [SubBtn buttonWithtitle:@"提交订单" titlecolor:UIColorFromRGB(WhiteColorValue) cornerRadius:0 andtarget:self action:@selector(setupGoosInfo) andframe:CGRectMake(ScreenWidth-103, 0, 103, 40)];
        _settleBtn.titleLabel.font = APPFONT(15);
        [_settleView addSubview:_settleBtn];
        
        
        _moneyLab = [BaseViewFactory labelWithFrame:CGRectMake(0, 0, ScreenWidth-123, 40) textColor:UIColorFromRGB(RedColorValue) font:APPFONT(15) textAligment:NSTextAlignmentRight andtext:@"合计："];
        NSString *str1 = @"合计：";
        NSRange range1 = [_moneyLab.text rangeOfString:str1];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:_moneyLab.text];
        [str addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(PlaColorValue) range:range1];
        [str addAttribute:NSFontAttributeName value:APPFONT(13) range:range1];

        _moneyLab.attributedText = str;
        [_settleView addSubview:_moneyLab];
        
    }
    
    return _settleView;
}

-(OrderAdressView *)adressView{
    if (!_adressView) {
        _adressView = [[OrderAdressView alloc]initWithFrame:CGRectZero];
        _adressView.hidden = NO;
    }
    return _adressView;
}

-(PayWayView *)payWayView{
    if (!_payWayView) {
        _payWayView = [[PayWayView alloc]init];
        _payWayView.delegate  = self;
    }
    return _payWayView;
}


#pragma mark ======= viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBarBackBtnWithImage:nil];
    self.view.backgroundColor = UIColorFromRGB(WhiteColorValue);
    self.navigationItem.title = @"确认订单";
    _isSelectedAdress = NO;
    [self loadAllAdress];
    //支付结果通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ailPayComPleted:)
                                                 name:@"ailPayComPleted"  object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(weixinPayComPleted:)
                                                 name:@"weixinPayComPleted"  object:nil];

    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
}


- (void)initUI{
    
    for (int i = 0; i<_dataArr.count; i++) {
        ShopCartDataModel *model = _dataArr[i];
        if (!model.memo) {
            model.memo = @"";
        }

    }
    

    [self.view addSubview:self.OrderTabView];
    [self.view addSubview:self.settleView];

    CGFloat AllMoney = 0.00f;
    for (int i = 0; i<_dataArr.count; i++) {
        ShopCartDataModel *model = _dataArr[i];
        
        CGFloat a = 0.00f;
        for (int i = 0; i<model.cartItems.count; i++) {
            ShopCartModel *cartModel = model.cartItems[i];
            a += [cartModel.price floatValue] *[cartModel.quantity floatValue];
        }
        model.money = [NSString stringWithFormat:@"%.2f",a];
        
        AllMoney += [model.money floatValue];
        
    }
    _moneyLab .text = [NSString stringWithFormat:@"合计：￥%.2f",AllMoney];
    NSString *str1 = @"合计：";
    NSRange range1 = [_moneyLab.text rangeOfString:str1];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:_moneyLab.text];
    [str addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(PlaColorValue) range:range1];
    [str addAttribute:NSFontAttributeName value:APPFONT(13) range:range1];
    
    _moneyLab.attributedText = str;

    
    
   

    
}
#pragma  mark =======  提交订单
/**
 提交订单
 */
- (void)setupGoosInfo{
    if (!_model.addressid) {
        [self showTextHud:@"请选择地址"];
        return;
    }
    [self.payWayView showinView:self.view];

}


/**
 关闭订单
 */
-(void)didSelectedCloseBtn{
    
    if (!_model.addressid) {
        [self showTextHud:@"请选择地址"];
        return;
    }
    NSMutableArray *proIdArr = [NSMutableArray  arrayWithCapacity:0];
    NSMutableArray *memoArr = [NSMutableArray  arrayWithCapacity:0];
    
    for (int i = 0; i <_dataArr.count; i++) {
        ShopCartDataModel *model = _dataArr[i];
        NSDictionary *dic = @{@"sellerId":model.sellerId,
                              @"memo":model.memo
                              };
        [memoArr addObject:[self dictionaryToJson:dic]];
        
        for (int j = 0; j<model.cartItems.count; j++) {
            ShopCartModel  *cartMoel = model.cartItems[j];
            [proIdArr addObject:cartMoel.proId];
        }
    }

    if (_type == 0) {
        ShopCartDataModel *model = _dataArr[0];
        ShopCartModel *itemModel =model.cartItems[0];
        NSDictionary *infoDic = @{@"quantity":itemModel.quantity,
                                  @"memo":[NSString stringWithFormat:@"[%@]",[memoArr componentsJoinedByString:@","]],
                                  @"addressId":_model.addressid
                                  };
        
        [PayPL payAtOnceWithId:itemModel.itemId andDic:infoDic andReturnBlock:^(id returnValue) {
            MyOrderController *orderVc = [[MyOrderController alloc]init];
            orderVc.btnType = BTN_UNPAID;
            orderVc.backType = 1;

            [self.navigationController pushViewController:orderVc animated:YES];

        } andErrorBlock:^(NSString *msg) {
            [self showTextHud:msg];
            
        }];
    }else{
        NSDictionary *infoDic = @{@"checkoutCartItemIdString":[proIdArr componentsJoinedByString:@","],
                                  @"memo":[NSString stringWithFormat:@"[%@]",[memoArr componentsJoinedByString:@","]],
                                  @"addressId":_model.addressid
                                  };
        
        [PayPL payForShopCartWithDic:infoDic andReturnBlock:^(id returnValue) {
            MyOrderController *orderVc = [[MyOrderController alloc]init];
            orderVc.backType = 1;

            orderVc.btnType = BTN_UNPAID;
            [self.navigationController pushViewController:orderVc animated:YES];

        } andErrorBlock:^(NSString *msg) {
            [self showTextHud:msg];
        }];
        
    }
}


/**
 获取订单号
 */
-(void)didSelectedSetUpBtn{
    if (!_model.addressid) {
        [self showTextHud:@"请选择地址"];
        return;
    }
    NSMutableArray *proIdArr = [NSMutableArray  arrayWithCapacity:0];
    NSMutableArray *memoArr = [NSMutableArray  arrayWithCapacity:0];

    for (int i = 0; i <_dataArr.count; i++) {
        ShopCartDataModel *model = _dataArr[i];
        NSDictionary *dic = @{@"sellerId":model.sellerId,
                              @"memo":model.memo
                              };
        [memoArr addObject:[self dictionaryToJson:dic]];

        for (int j = 0; j<model.cartItems.count; j++) {
            ShopCartModel  *cartMoel = model.cartItems[j];
            [proIdArr addObject:cartMoel.proId];
        }
    }
    
    if (_type == 0) {
        ShopCartDataModel *model = _dataArr[0];
        ShopCartModel *itemModel =model.cartItems[0];
        NSDictionary *infoDic = @{@"quantity":itemModel.quantity,
                                  @"memo":[NSString stringWithFormat:@"[%@]",[memoArr componentsJoinedByString:@","]],
                                  @"addressId":_model.addressid
                                  };

        [PayPL payAtOnceWithId:itemModel.itemId andDic:infoDic andReturnBlock:^(id returnValue) {
            NSLog(@"%@",returnValue);
            NSString *orderId = returnValue[@"userOrderId"];
            MyOrderController *orderVc = [[MyOrderController alloc]init];
            orderVc.btnType = BTN_ALL;
            orderVc.backType = 1;
            [self.navigationController pushViewController:orderVc animated:YES];
            
            if (self.payWayView.isAilPayWay) {
                //支付宝
                [self ailPayAtOncewithId:orderId];
                
            }else{
                //微信
                [self weixinPayAtOncewithId:orderId];
            }

        } andErrorBlock:^(NSString *msg) {
            [self showTextHud:msg];

        }];
    }else{
        NSDictionary *infoDic = @{@"checkoutCartItemIdString":[proIdArr componentsJoinedByString:@","],
                                  @"memo":[NSString stringWithFormat:@"[%@]",[memoArr componentsJoinedByString:@","]],
                                  @"addressId":_model.addressid
                                  };
        [PayPL payForShopCartWithDic:infoDic andReturnBlock:^(id returnValue) {
            NSLog(@"%@",returnValue);
            NSString *orderId = returnValue[@"userOrderId"];
           
           if (self.payWayView.isAilPayWay) {
                //支付宝
                [self ailPayAtOncewithId:orderId];
                
            }else{
                //微信
                [self weixinPayAtOncewithId:orderId];
            }
      
        } andErrorBlock:^(NSString *msg) {
            [self showTextHud:msg];
        }];

    }
    
    

}

/**
 支付宝支付
 */
- (void)ailPayAtOncewithId:(NSString *)orderid{
    
[PayPL ailPayWithOrderId:orderid andReturnBlock:^(id returnValue) {
    NSString *orderStr = returnValue[@"orderStr"];
        [[AlipaySDK defaultService] payOrder:orderStr fromScheme:@"fyhapp" callback:^(NSDictionary *resultDic) {
//            NSLog(@"%@",resultDic);
//            NSLog(@"%@",resultDic);
//            
//            MyOrderController *orderVc = [[MyOrderController alloc]init];
//            
//            NSString *strMsg;
//            if ([resultDic[@"resultStatus"] intValue]!=9000) {
//                orderVc.btnType = BTN_UNPAID;
//                strMsg = @"支付失败";
//            }else{
//                strMsg = @"支付成功";
//                orderVc.btnType = BTN_UNSENT;
//                
//            }
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//            [alert show];
//
//            [self.navigationController pushViewController:orderVc animated:YES];
//           // [self.delegate finishedAlipayPaymentWithResult:resultDic];
        }];

    
} andErrorBlock:^(NSString *msg) {
    [self showTextHud:msg];
}];


}
/**
 微信支付
 */
- (void)weixinPayAtOncewithId:(NSString *)orderid{
   [PayPL weixinPayWithOrderId:orderid andReturnBlock:^(id returnValue) {
       NSLog(@"%@",returnValue);
       PayReq *req =  [[PayReq alloc] init];
       req.partnerId = [returnValue objectForKey:@"partnerid"];
       req.prepayId = [returnValue objectForKey:@"prepayid"];
       req.nonceStr = [returnValue objectForKey:@"noncestr"];
       NSMutableString *stamp  = [returnValue objectForKey:@"timestamp"];
       req.timeStamp = stamp.intValue;
       req.package = [returnValue objectForKey:@"package"];
       req.sign = [returnValue objectForKey:@"sign"];
       [WXApi sendReq:req];

   } andErrorBlock:^(NSString *msg) {
       [self showTextHud:msg];
 
   }];
    
    
}

#pragma mark ====== 支付完成
- (void)ailPayComPleted:(NSNotification *)noti{
    
//    NSString *idStr = noti.object;
//    MyOrderController *orderVc = [[MyOrderController alloc]init];
//
//    NSString *strMsg;
//    if ([idStr intValue]!=9000) {
//        orderVc.btnType = BTN_UNPAID;
//        strMsg = @"支付失败";
//    }else{
//        strMsg = @"支付成功";
//        orderVc.btnType = BTN_UNSENT;
//
//    }
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//    [alert show];
//    [self.navigationController pushViewController:orderVc animated:YES];
}

- (void)weixinPayComPleted:(NSNotification *)noti{
    
//    NSString *idStr = noti.object;
//    MyOrderController *orderVc = [[MyOrderController alloc]init];
//    if ([idStr intValue]!=9000) {
//        orderVc.btnType = BTN_UNPAID;
//    }else{
//        orderVc.btnType = BTN_UNSENT;
//
//    }
//    [self.navigationController pushViewController:orderVc animated:YES];

}


- (void)rightBarItemClick{


}

#pragma  mark ======= tableViewdelegate and datasource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return _dataArr.count + 1;
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    ShopCartDataModel *model = _dataArr[section-1];
    return model.cartItems.count+2;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section ==0&&indexPath.row == 0) {
        if (!_isSelectedAdress) {
            
            return 140;

        }
        NSString *str = [NSString stringWithFormat:@"地址:%@-%@-%@  %@",_model.province,_model.city,_model.area,_model.consigneeAddress];
        CGFloat height = [GlobalMethod heightForString:str andWidth:ScreenWidth - 70 andFont:APPFONT(13)];  //42+height
        _Height =  height +42;
        return height +42;
    }else{
        ShopCartDataModel *model = _dataArr[indexPath.section-1];

        if (indexPath.row == 0) {
            return 40;
        }else if (indexPath.row == model.cartItems.count+1){
            return 150;
        }
        return 100;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    if (indexPath.section ==0&&indexPath.row == 0) {
        static NSString *cellid = @"onetopcellid";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.contentView addSubview:self.adressView];

        }
        UIButton *topBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [topBtn addTarget:self action:@selector(selectedAdress) forControlEvents:UIControlEventTouchUpInside];
         [cell.contentView addSubview:topBtn];
        if (_model) {
            self.adressView.model = _model;
        }
        if (_isSelectedAdress) {
             self.adressView.frame = CGRectMake(0, 0, ScreenWidth, _Height);
                topBtn.frame = CGRectMake(0, 0, ScreenWidth, _Height);
            [self.adressView showAdress];

        }else{
            self.adressView.frame = CGRectMake(0, 0, ScreenWidth, 140);
            topBtn.frame = CGRectMake(0, 0, ScreenWidth, 140);
            [self.adressView showAddAdressView];

        }
       
        return cell;
    }else{
        ShopCartDataModel *model = _dataArr[indexPath.section-1];

        if (indexPath.row == 0) {
            static NSString *cellid = @"topcellid";
            
            ShopCartTopCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
            if (!cell) {
                cell = [[ShopCartTopCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell.selectBtn.hidden = YES;
            [cell sdlayoutBuyTopView];
             cell.delegate = self;
            cell.model = _dataArr[indexPath.section-1];
            return cell;
        }else if (indexPath.row == model.cartItems.count+1){
            static NSString *cellid = @"bommcellid";
            ShopBoomCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
            if (!cell) {
                cell = [[ShopBoomCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            ShopCartDataModel *model = _dataArr[indexPath.section-1];
            
             cell.model = model;
            return cell;

            
            
        }else{
            static NSString *cellid = @"ordercell";
            ShopBuyCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
            if (!cell) {
                cell = [[ShopBuyCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
           // cell.delegate = self;
            ShopCartDataModel *model = _dataArr[indexPath.section-1];

            cell.model = model.cartItems[indexPath.row-1];
            return cell;
        }
    }
}


/**
 选择地址
 */
- (void)selectedAdress{

    AdministrationaddViewController *admin = [[AdministrationaddViewController  alloc]init];
    admin.selectedType = 1;
    admin.title = @"选择地址";
    [self.navigationController pushViewController:admin animated:YES];
    WeakSelf(self);
    [admin setDidselectAdressBlock:^(AdressModel *model) {
        _model = model;
        NSLog(@"%@",model.addressid);
        _isSelectedAdress = YES;
        NSString *str = [NSString stringWithFormat:@"地址:%@-%@-%@  %@",_model.province,_model.city,_model.area,_model.consigneeAddress];
        CGFloat height = [GlobalMethod heightForString:str andWidth:ScreenWidth - 70 andFont:APPFONT(13)];  //42+height
        _Height =  height +42;
        [weakself.OrderTabView reloadData];

    }];
}

/**
 加载地址
 */
- (void)loadAllAdress{

    [AcceptAdressPL getUserAllAdresswithReturnBlock:^(id returnValue) {
        
        NSMutableArray *arr = [AdressModel mj_objectArrayWithKeyValuesArray:returnValue[@"data"][@"addresses"]];
        if (arr.count >0) {
           _model = arr[0];
            _model.isDefaultAdress = YES;
            _isSelectedAdress = YES;
            NSString *str = [NSString stringWithFormat:@"地址:%@-%@-%@  %@",_model.province,_model.city,_model.area,_model.consigneeAddress];
            CGFloat height = [GlobalMethod heightForString:str andWidth:ScreenWidth - 70 andFont:APPFONT(13)];  //42+height
            _Height =  height +42;
        }
        [self initUI];
        [self.OrderTabView reloadData];
    } andErrorBlock:^(NSString *msg) {
        [self initUI];
        [self showTextHud:msg];
        
    }];
}


- (void)shopGoTopShopBtnClick:(ShopCartTopCell *)cell{
    BusinessesShopViewController *buVc = [[BusinessesShopViewController alloc]init];
//buVc.shopId = cell.model.cartItems.

}

//词典转换为字符串
- (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}


@end
