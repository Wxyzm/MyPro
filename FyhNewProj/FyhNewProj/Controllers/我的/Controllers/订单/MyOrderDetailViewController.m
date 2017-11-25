//
//  MyOrderDetailViewController.m
//  FyhNewProj
//
//  Created by yh f on 2017/7/27.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "MyOrderDetailViewController.h"
#import "BusinessesShopViewController.h"
#import "GoodsDetailViewController.h"
#import "UserOrder.h"
#import "ItemsModel.h"
#import "OrderOtherModel.h"
#import "OrderOtherItemModel.h"
#import "OrderSellerItems.h"
#import "OrderItems.h"
#import "AcceptAdressCell.h"
#import "UserOrderTopCell.h"
#import "UserOrderOneCell.h"
#import "UserMemoCell.h"
#import "ConnectBuyerCell.h"
#import "OrderNumberCell.h" 
#import "PayWayView.h"
#import "OrderPL.h"
#import "PayPL.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
#import "xxxxViewController.h"
#import "ViewLogisticsControllerViewController.h"
@interface MyOrderDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UserOrderOneCellDelegate,PayWayViewDelegate,UserOrderTopCellDelegate,ConnectBuyerCellDelegate>

@property (nonatomic,strong)UITableView *AllOrderTabView;           //全部

@property (nonatomic , strong) SubBtn *cancleBtn;

@property (nonatomic , strong) SubBtn *payBtn;

@property (nonatomic , strong) PayWayView *payWayView;



@end

@implementation MyOrderDetailViewController{
    CGRect leftButtonFrame;
    CGRect rightButtonFrame;
    NSString *_userOrderID;
    
}
-(PayWayView *)payWayView{
    if (!_payWayView) {
        _payWayView = [[PayWayView alloc]init];
        _payWayView.delegate  = self;
    }
    return _payWayView;
}

-(UITableView *)AllOrderTabView{
    
    if (!_AllOrderTabView) {
        _AllOrderTabView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth,ScreenHeight-64-40) style:UITableViewStylePlain];
        _AllOrderTabView.delegate = self;
        _AllOrderTabView.dataSource = self;
        _AllOrderTabView.backgroundColor = UIColorFromRGB(LineColorValue);
        _AllOrderTabView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    return _AllOrderTabView;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBarBackBtnWithImage:nil];
    self.navigationItem.title = @"订单详情";
    [self initUI];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
- (void)initUI{
    [self.view addSubview:self.AllOrderTabView];
    [self.AllOrderTabView reloadData];
    
    leftButtonFrame = CGRectMake(ScreenWidth-180, 5, 70, 30);
    rightButtonFrame = CGRectMake(ScreenWidth - 90, 5, 70, 30);

    
    UIView *boomView = [BaseViewFactory viewWithFrame:CGRectMake(0, ScreenHeight -64 -40, ScreenWidth, 40) color:UIColorFromRGB(WhiteColorValue)];
    [self.view addSubview:boomView];
    _payBtn = [SubBtn buttonWithtitle:@"确认发货" titlecolor:UIColorFromRGB(WhiteColorValue) cornerRadius:15 andtarget:self action:@selector(payBtnClick) andframe:rightButtonFrame];
    _payBtn.titleLabel.font = APPFONT(13);
    [boomView addSubview:_payBtn];
    
    _cancleBtn = [SubBtn buttonWithtitle:@"联系买家" backgroundColor:UIColorFromRGB(PlaColorValue) titlecolor:UIColorFromRGB(WhiteColorValue) cornerRadius:15 andtarget:self action:@selector(cancleBtnClick)];
    _cancleBtn.frame = leftButtonFrame;
    _cancleBtn.titleLabel.font = APPFONT(13);
    [boomView addSubview:_cancleBtn];
    
    int status;
    if (_type == 0) {
        OrderSellerItems *itemsModel = _order.sellerItemOrders[0];
        _userOrderID = _order.orderId;
        OrderItems *item = itemsModel.itemOrders[0];
        status = [item.status intValue];
    }else{
        OrderOtherItemModel *model =  _otherModel.itemOrders[0];
        NSArray *arr = [_otherModel.userOrderIdAndSellerId componentsSeparatedByString:@"_"];
        if (arr.count >0) {
            _userOrderID = arr[0];
        }else{
            [self showTextHud:@"订单获取失败"];
            [self.navigationController popViewControllerAnimated:YES];
        }
        
        status = [model.status  intValue];
    
    }
    

    switch (status) {
        case 0:{
            //未付款
            [self showButton:self.cancleBtn withTitle:@"取消订单" frame:leftButtonFrame];
            [self showButton:self.payBtn withTitle:@"付款" frame:rightButtonFrame];
            
            break;
        }
        case 1:{
            //已支付，待发货
            self.cancleBtn.hidden = YES;
            self.payBtn.hidden = YES;
            break;
        }
        case 2:{
            //卖家已发货
            [self showButton:self.cancleBtn withTitle:@"查看物流" frame:leftButtonFrame];
            [self showButton:self.payBtn withTitle:@"确认收货" frame:rightButtonFrame];
            
            break;
        }
        case 3:{
            //交易成功   ，确认收货后
            [self showButton:self.cancleBtn withTitle:@"查看物流" frame:leftButtonFrame];
            [self showButton:self.payBtn withTitle:@"评价" frame:rightButtonFrame];
            break;
        }
        case 4:{
            //交易关闭
            [self showButton:self.cancleBtn withTitle:@"删除订单" frame:rightButtonFrame];
            self.payBtn.hidden = YES;
            
            break;
        }
        default:
        break;    }


}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    if (_type == 0) {
        return _order.sellerItemOrders.count + 1;
    }else{
        
        return 2;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        return 1;
    }else{
        //memo有没有  //0全部、未支付     1其他
        if (_type == 0) {
            OrderSellerItems *sellItem = _order.sellerItemOrders[section - 1];
            OrderItems *item = sellItem.itemOrders[0];
            if (item.memo.length >0) {
                return sellItem.itemOrders.count +4;
            }else{
                return sellItem.itemOrders.count +3;
            }
            
        }else{
            OrderOtherItemModel *item = _otherModel.itemOrders[0];
            NSData *jsonData = [item.userOrderMemo dataUsingEncoding:NSUTF8StringEncoding];
            NSMutableArray *dicArr = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                     options:NSJSONReadingMutableContainers
                                                                       error:nil];
            item.memo = dicArr[0][@"memo"];
            if (item.memo.length >0) {
                return _otherModel.itemOrders.count +4;
            }else{
                return _otherModel.itemOrders.count +3;
            }
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.section == 0) {
        return 70;
    }else{
        if (indexPath.row == 0) {
            return 52;
        }else{
        
            if (_type == 0) {
                OrderSellerItems *sellItem = _order.sellerItemOrders[indexPath.section - 1];
                if (indexPath.row <= sellItem.itemOrders.count) {
                    return 100;
                }
                return 70;
                
            }else{
                if (indexPath.row <= _otherModel.itemOrders.count) {
                    return 100;
                }
                return 70;
            }

        }
        
    }
    
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {//1

    if (indexPath.section == 0) {
        static NSString *adressCellid = @"adressCellid";
        AcceptAdressCell *cell = [tableView dequeueReusableCellWithIdentifier:adressCellid];
        if (!cell) {
            cell = [[AcceptAdressCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:adressCellid];
        }
        NSDictionary *adressDic;
        if (_type == 0) {
            adressDic = _order.address;
        }else{
            OrderOtherItemModel *item = _otherModel.itemOrders[0];

            adressDic = item.userOrderAddress;

        }
        cell.adressDic = adressDic;
        
        return cell;

    }
    
    
        if (_type == 0) {
            
            OrderSellerItems *sellItem = _order.sellerItemOrders[indexPath.section - 1];
            if (indexPath.row == 0) {
                static NSString *cellid = @"topcellid";
                UserOrderTopCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
                if (!cell) {
                    cell = [[UserOrderTopCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];

                }
                cell.tag = 1200 + indexPath.section;
                cell.model = _order;
                cell.delegate = self;
                cell.nameLab.text = sellItem.sellerInfo;
                return cell;
            }else if (indexPath.row <= sellItem.itemOrders.count){
                static NSString *cellid = @"orderoncecell";
                UserOrderOneCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
                if (!cell) {
                    cell = [[UserOrderOneCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
                }
                cell.ItemsModel = sellItem.itemOrders[indexPath.row - 1];
                [cell hiddenboomView];
                cell.delegate = self;
                return cell;
            }else{
                OrderItems *item = sellItem.itemOrders[0];
                if (item.memo.length >0){
                    if (indexPath.row == sellItem.itemOrders.count +1) {
                            static NSString *memoCellid = @"memoCellid";
                            UserMemoCell *cell = [tableView dequeueReusableCellWithIdentifier:memoCellid];
                            if (!cell) {
                                cell = [[UserMemoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:memoCellid];
                            }
                        if (item.memo.length >0) {
                            [cell setMemoStr:item.memo];

                        }
                            return cell;
                            
                    }else if (indexPath.row == sellItem.itemOrders.count +2){
                        static NSString *conCellid = @"conCellid";
                        ConnectBuyerCell *cell = [tableView dequeueReusableCellWithIdentifier:conCellid];
                        if (!cell) {
                            cell = [[ConnectBuyerCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:conCellid];
                        }
                        CGFloat logistics = 0.00f;
                        CGFloat payAmount = 0.00f;
                        for (OrderItems *theitem in sellItem.itemOrders) {
                            logistics += [theitem.logisticsAmount floatValue];
                            payAmount += [theitem.payAmount floatValue];
                            cell.accountId = theitem.sellerId;

                        }
                        cell.sellerinfo = sellItem.sellerInfo;
                        [cell setTheLogPay:logistics andAmountPay:payAmount];
                        cell.delegate = self;
                        return cell;
                    }else{
                        static NSString *numCellid = @"numCellid";
                        OrderNumberCell *cell = [tableView dequeueReusableCellWithIdentifier:numCellid];
                        if (!cell) {
                            cell = [[OrderNumberCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:numCellid];
                        }
                        [cell setOrderNumber:item.theId andcreateTime:item.createTime];
                        return cell;

                    }

                
                }else{
                    if (indexPath.row == sellItem.itemOrders.count +1) {
                        static NSString *conCellid = @"conCellid";
                        ConnectBuyerCell *cell = [tableView dequeueReusableCellWithIdentifier:conCellid];
                        if (!cell) {
                            cell = [[ConnectBuyerCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:conCellid];
                        }
                        CGFloat logistics = 0.00f;
                        CGFloat payAmount = 0.00f;
                        for (OrderItems *theitem in sellItem.itemOrders) {
                            logistics += [theitem.logisticsAmount floatValue];
                            payAmount += [theitem.payAmount floatValue];
                            cell.accountId = theitem.sellerId;
                        }
                        cell.sellerinfo = sellItem.sellerInfo;

                        [cell setTheLogPay:logistics andAmountPay:payAmount];
                        cell.delegate = self;

                        return cell;
                        
                        
                        
                    }else if (indexPath.row == sellItem.itemOrders.count +2){
                        static NSString *numCellid = @"numCellid";
                        OrderNumberCell *cell = [tableView dequeueReusableCellWithIdentifier:numCellid];
                        if (!cell) {
                            cell = [[OrderNumberCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:numCellid];
                        }
                        [cell setOrderNumber:item.theId andcreateTime:item.createTime];
                        return cell;

                    }
                   
    
                
                }
            
            }
        }else{
            
            if (indexPath.row == 0) {
                static NSString *cellid = @"topcellid";
                UserOrderTopCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
                if (!cell) {
                    cell = [[UserOrderTopCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
                }
                cell.oterModel = _otherModel;
                cell.delegate = self;
                // cell.RightLab.text = @"买家已付款";
                return cell;
            }else if (indexPath.row <= _otherModel.itemOrders.count){
                static NSString *cellid = @"orderoncecell";
                UserOrderOneCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
                if (!cell) {
                    cell = [[UserOrderOneCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
                }
                //            cell.ItemsModel = model.itemOrders[0];
                cell.otherModel = _otherModel.itemOrders[indexPath.row - 1];
                [cell hiddenboomView];
                cell.delegate = self;
                return cell;
            }else{//2
                OrderOtherItemModel *model =  _otherModel.itemOrders[0];
                if (model.memo.length >0){
                    if (indexPath.row == _otherModel.itemOrders.count +1) {
                        static NSString *memoCellid = @"memoCellid";
                        UserMemoCell *cell = [tableView dequeueReusableCellWithIdentifier:memoCellid];
                        if (!cell) {
                            cell = [[UserMemoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:memoCellid];
                        }
                        [cell setMemoStr:model.memo];
                        return cell;
                        
                    }else if (indexPath.row == _otherModel.itemOrders.count +2){
                        static NSString *conCellid = @"conCellid";
                        ConnectBuyerCell *cell = [tableView dequeueReusableCellWithIdentifier:conCellid];
                        if (!cell) {
                            cell = [[ConnectBuyerCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:conCellid];
                        }
                        CGFloat logistics = 0.00f;
                        CGFloat payAmount = 0.00f;
                        for (OrderOtherItemModel *theitem in _otherModel.itemOrders) {
                           // logistics += [theitem.logistics floatValue];
                            payAmount += [theitem.payAmount floatValue];
                            cell.accountId = theitem.sellerId;

                        }
                        logistics = [_otherModel.logisticsAmount floatValue];
                        cell.sellerinfo = _otherModel.sellerInfo;

                        [cell setTheLogPay:logistics andAmountPay:payAmount];
                        cell.delegate = self;

                        return cell;
                    }else{
                        static NSString *numCellid = @"numCellid";
                        OrderNumberCell *cell = [tableView dequeueReusableCellWithIdentifier:numCellid];
                        if (!cell) {
                            cell = [[OrderNumberCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:numCellid];
                        }
                        [cell setOrderNumber:model.theId andcreateTime:model.createTime];
                        return cell;
                        
                    }
                }else{
                    if (indexPath.row == _otherModel.itemOrders.count +1){
                        static NSString *conCellid = @"conCellid";
                        ConnectBuyerCell *cell = [tableView dequeueReusableCellWithIdentifier:conCellid];
                        if (!cell) {
                            cell = [[ConnectBuyerCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:conCellid];
                        }
                        CGFloat logistics = 0.00f;
                        CGFloat payAmount = 0.00f;
                        for (OrderOtherItemModel *theitem in _otherModel.itemOrders) {
                          //  logistics += [theitem.logistics floatValue];
                            payAmount += [theitem.payAmount floatValue];
                            cell.accountId = theitem.sellerId;

                        }
                        logistics = [_otherModel.logisticsAmount floatValue];

                        cell.sellerinfo = _otherModel.sellerInfo;

                        [cell setTheLogPay:logistics andAmountPay:payAmount];
                        cell.delegate = self;

                        return cell;
                    }else{
                        static NSString *numCellid = @"numCellid";
                        OrderNumberCell *cell = [tableView dequeueReusableCellWithIdentifier:numCellid];
                        if (!cell) {
                            cell = [[OrderNumberCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:numCellid];
                        }
                        [cell setOrderNumber:model.theId andcreateTime:model.createTime];
                        return cell;
                        
                    }
                }

        }//2
   }//1
    static NSString *numCellid = @"numCellid";
    OrderNumberCell *cell = [tableView dequeueReusableCellWithIdentifier:numCellid];
    if (!cell) {
        cell = [[OrderNumberCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:numCellid];
    }
    return cell;

}






-(void)didselectedconnectbtnWithId:(NSString *)sellerId andsellinfo:(NSString *)sellinfo{

    xxxxViewController *chat =[[xxxxViewController alloc] init];
    //设置会话的类型，如单聊、讨论组、群聊、聊天室、客服、公众服务会话等
    chat.conversationType = ConversationType_PRIVATE;
    //设置会话的目标会话ID。（单聊、客服、公众服务会话为对方的ID，讨论组、群聊、聊天室为会话的ID）
    chat.targetId = sellerId;
    
    //设置聊天会话界面要显示的标题
    chat.title = sellinfo;
        
    
    //显示聊天会话界面
    [self.navigationController pushViewController:chat animated:YES];

    
    

}


/**
 点击商家按钮

 @param shopId 商家id
 */
-(void)didselectedShopbtnWithId:(NSString *)shopId{

    BusinessesShopViewController *bussVc = [[BusinessesShopViewController alloc]init];
    bussVc.shopId = shopId;
    [self.navigationController pushViewController:bussVc animated:YES];


}


- (void)didselectedUserOrderOneCellOnBtnWithItemId:(NSString *)itemid{

    ItemsModel  *model = [[ItemsModel alloc]init];
    model.itemId = itemid;
    GoodsDetailViewController *devc = [[GoodsDetailViewController  alloc]init];
    devc.itemModel = model;
    [self.navigationController pushViewController:devc animated:YES];
}

/**
 付款收货等
 */
- (void)payBtnClick{

    int status;
    if (_type == 0) {
        OrderSellerItems *itemsModel = _order.sellerItemOrders[0];
        OrderItems *item = itemsModel.itemOrders[0];
        status = [item.status intValue];
    }else{
        OrderOtherItemModel *model =  _otherModel.itemOrders[0];
        status = [model.status  intValue];
        
    }
    
    
    switch (status) {
        case 0:{
            //未付款
            //未付款    付款
            [self.payWayView showinView:self.view];
            break;
        }
        case 1:{
            //已支付，待发货
                     break;
        }
        case 2:{
            
            if (_type == 0) {
                OrderSellerItems *itemsModel = _order.sellerItemOrders[0];
                [self makeSureAcceptGoodsWithOrder:itemsModel];

            }else{
                [self makeSureAcceptGdidselectedUserOrderOneCellPayBtnWithModel:_otherModel];

                
                
            }
            
            
            break;
        }
        case 3:{
            //交易成功   ，确认收货后
//            [self makeSureAcceptGoodsWithOrder:_order.sellerItemOrders];
            [self showTextHud:@"暂未开放"];
            break;
        }
        case 4:{
            //交易关闭
            break;
        }
        default:
        break;    }


}





- (void)cancleBtnClick{
    int status;
    if (_type == 0) {
        OrderSellerItems *itemsModel = _order.sellerItemOrders[0];
        OrderItems *item = itemsModel.itemOrders[0];
        status = [item.status intValue];
    }else{
        OrderOtherItemModel *model =  _otherModel.itemOrders[0];
        status = [model.status  intValue];
        
    }
    
    
    switch (status) {
        case 0:{
            //未付款
            //未付款    付款
            [self cancleOrderWithId:_userOrderID];
            break;
        }
        case 1:{
            //已支付，待发货
            break;
        }
        case 2:{
            //卖家已发货
            if (_type == 0) {
                OrderSellerItems *itemsModel = _order.sellerItemOrders[0];
                OrderItems *item = itemsModel.itemOrders[0];
                status = [item.status intValue];
                if (!item.logistics) {
                    return;
                }
                [self gotoLogistVcWithLogistNumber:item.logistics[@"logisticsNumber"]];

            }else{
                OrderOtherItemModel *model =  _otherModel.itemOrders[0];
                status = [model.status  intValue];
                if (!model.logistics) {
                    return;
                }
                [self gotoLogistVcWithLogistNumber:model.logistics[@"logisticsNumber"]];

            }
            
            
            break;
        }
        case 3:{
            //交易成功   ，确认收货后
            
            
            break;
        }
        case 4:{
            //交易关闭
            [self deleteOrderWithId:_userOrderID];
            break;
        }
        default:
        break;    }


}


- (void)showButton:(UIButton*)button withTitle:(NSString*)title frame:(CGRect)frame
{
    button.hidden = NO;
    button.frame = frame;
    [button setTitle:title forState:UIControlStateNormal];
}


-(void)makeSureAcceptGoodsWithOrder:(OrderSellerItems*)sellerItems{
    NSMutableArray *itemIdArr = [NSMutableArray arrayWithCapacity:0];
    for (OrderItems *item in sellerItems.itemOrders) {
        [itemIdArr addObject:item.theId];
    }
    NSDictionary *dic = @{@"itemOrderIds":[itemIdArr componentsJoinedByString:@","]};
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定已收到商品？" preferredStyle:UIAlertControllerStyleAlert];
    [alert  addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [OrderPL BuyersmakeSureAcceptedGoodsWithinfoDic:dic ReturnBlock:^(id returnValue) {
            [self showTextHud:@"商品已确认收货"];
            [self performSelector:@selector(back) withObject:nil afterDelay:0.5];
            
        } andErrorBlock:^(NSString *msg) {
            [self showTextHud:msg];
        }];
        
    }]];
    [alert  addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }]];
    [self presentViewController:alert animated:YES completion:nil];
    
}
-(void)makeSureAcceptGdidselectedUserOrderOneCellPayBtnWithModel:(OrderOtherModel *)model{
    
    NSMutableArray *itemIdArr = [NSMutableArray arrayWithCapacity:0];
    for (OrderOtherItemModel *item in model.itemOrders) {
        [itemIdArr addObject:item.theId];
    }
    NSDictionary *dic = @{@"itemOrderIds":[itemIdArr componentsJoinedByString:@","]};
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定已收到商品？" preferredStyle:UIAlertControllerStyleAlert];
    [alert  addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [OrderPL BuyersmakeSureAcceptedGoodsWithinfoDic:dic ReturnBlock:^(id returnValue) {
            [self showTextHud:@"商品已确认收货"];
            [self performSelector:@selector(back) withObject:nil afterDelay:0.5];
            
        } andErrorBlock:^(NSString *msg) {
            [self showTextHud:msg];
        }];
        
    }]];
    [alert  addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }]];
    [self presentViewController:alert animated:YES completion:nil];
    
}
- (void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark ======== 取消订单收货等

- (void)cancleOrderWithId:(NSString *)orderId{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否取消该订单？" preferredStyle:UIAlertControllerStyleAlert];
    [alert  addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [OrderPL BuyersCancleOrderWithorderID:orderId ReturnBlock:^(id returnValue) {
            [self showTextHud:@"取消成功"];
            [self performSelector:@selector(respondToLeftButtonClickEvent) withObject:nil afterDelay:0.5];
            
        } andErrorBlock:^(NSString *msg) {
            [self showTextHud:msg];
        }];
        
    }]];
    [alert  addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }]];
    [self presentViewController:alert animated:YES completion:nil];
    
    
}


#pragma mark ======== payWayViewDelegate  微信、支付宝支付
/**
 获取订单号
 */
-(void)didSelectedSetUpBtn{
    
    if (self.payWayView.isAilPayWay) {
        //支付宝
        [self ailPayAtOncewithId:_userOrderID];
        
    }else{
        //微信
        [self weixinPayAtOncewithId:_userOrderID];
    }
    
    
}
/**
 支付宝支付
 */
- (void)ailPayAtOncewithId:(NSString *)orderid{
    [PayPL ailPayWithOrderId:orderid andReturnBlock:^(id returnValue) {
        NSString *orderStr = returnValue[@"orderStr"];
        [[AlipaySDK defaultService] payOrder:orderStr fromScheme:@"fyhapp" callback:^(NSDictionary *resultDic) {
            NSLog(@"%@",resultDic);
            NSLog(@"%@",resultDic);
            // [self.delegate finishedAlipayPaymentWithResult:resultDic];
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

//查看物流
- (void)gotoLogistVcWithLogistNumber:(NSString *)number{
    ViewLogisticsControllerViewController *vc = [[ViewLogisticsControllerViewController alloc]init];
    vc.logistNumber = number;
    [self.navigationController pushViewController:vc animated:YES];
}

//删除订单
- (void)deleteOrderWithId:(NSString *)orderId{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定删除订单？" preferredStyle:UIAlertControllerStyleAlert];
    [alert  addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [OrderPL BuyersDeleteOrderWithorderID:orderId ReturnBlock:^(id returnValue) {
            [self showTextHud:@"删除成功"];
            [self performSelector:@selector(respondToLeftButtonClickEvent) withObject:nil afterDelay:0.5];

        } andErrorBlock:^(NSString *msg) {
            [self showTextHud:msg];
        }];
        
    }]];
    [alert  addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }]];
    [self presentViewController:alert animated:YES completion:nil];
    
}
@end
