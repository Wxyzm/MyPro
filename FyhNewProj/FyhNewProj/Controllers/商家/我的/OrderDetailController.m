//
//  OrderDetailController.m
//  FyhNewProj
//
//  Created by yh f on 2017/7/18.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "OrderDetailController.h"
#import "SellerOrderModel.h"
#import "itemOrdersDataModel.h"

#import "AcceptAdressCell.h"
#import "MemoCell.h"
#import "ConnectBuyerCell.h"
#import "OrderNumberCell.h"
#import "SellerTopCell.h"
#import "SellerBoomCell.h"
#import "SellerOrderCell.h"
#import "MakeSureSentView.h"
#import "xxxxViewController.h"
#import "RCTokenPL.h"
#import "OrderPL.h"
#import "xxxxViewController.h"
#import "RCTokenPL.h"


@interface OrderDetailController ()<UITableViewDelegate,UITableViewDataSource,MakeSureSentViewDelegate>

@property (nonatomic,strong)UITableView *AllTabView;//全部

@property (nonatomic , strong) SubBtn *cancleBtn;

@property (nonatomic , strong) SubBtn *payBtn;

@property (nonatomic , assign) NSInteger Type;

@property (nonatomic,strong)MakeSureSentView *SentView;          //已关闭


@end

@implementation OrderDetailController{
    CGRect leftButtonFrame;
    CGRect rightButtonFrame;
}


-(MakeSureSentView *)SentView{
    if (!_SentView) {
        _SentView = [[MakeSureSentView alloc]init];
        _SentView.delegate = self;
    }
    
    return _SentView;
}
-(UITableView *)AllTabView{
    
    if (!_AllTabView) {
        _AllTabView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth,ScreenHeight-64-40) style:UITableViewStylePlain];
        _AllTabView.delegate = self;
        _AllTabView.dataSource = self;
        _AllTabView.backgroundColor = UIColorFromRGB(PlaColorValue);
        _AllTabView.separatorStyle = UITableViewCellSeparatorStyleNone;
       
        
    }
    return _AllTabView;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单详情";
    [self setBarBackBtnWithImage:nil];
    [self initUI];
}

- (void)initUI{

    [self.view addSubview:self.AllTabView];
    [self.AllTabView reloadData];
    
    UIView *boomView = [BaseViewFactory viewWithFrame:CGRectMake(0, ScreenHeight - 64 - 40, ScreenWidth, 40) color:UIColorFromRGB(WhiteColorValue)];
    [self.view addSubview:boomView];
    
    rightButtonFrame = CGRectMake(ScreenWidth - 90, 5, 70, 30);
    _payBtn = [SubBtn buttonWithtitle:@"确认发货" titlecolor:UIColorFromRGB(WhiteColorValue) cornerRadius:15 andtarget:self action:@selector(payBtnClick) andframe:rightButtonFrame];
    _payBtn.titleLabel.font = APPFONT(13);
    [boomView addSubview:_payBtn];
    
    leftButtonFrame = CGRectMake(ScreenWidth-180, 5, 70, 30);
    _cancleBtn = [SubBtn buttonWithtitle:@"联系买家" backgroundColor:UIColorFromRGB(PlaColorValue) titlecolor:UIColorFromRGB(WhiteColorValue) cornerRadius:15 andtarget:self action:@selector(cancleBtnClick)];
    _cancleBtn.frame = leftButtonFrame;
    _cancleBtn.titleLabel.font = APPFONT(13);
    [boomView addSubview:_cancleBtn];

    itemOrdersDataModel *itemsModel = _model.itemOrdersData[0];

    switch ([itemsModel.status intValue]) {
        case 0:{
            //未付款
            [self showButton:self.cancleBtn withTitle:@"联系买家" frame:rightButtonFrame];
            self.payBtn.hidden = YES;
            self.Type = 0;
            break;
        }
        case 1:{
            //已支付，待发货
            [self showButton:self.cancleBtn withTitle:@"联系买家" frame:leftButtonFrame];
            [self showButton:self.payBtn withTitle:@"确认发货" frame:rightButtonFrame];
            self.Type = 1;
            break;
        }
        case 2:{
            [self showButton:self.cancleBtn withTitle:@"联系买家" frame:rightButtonFrame];
            self.payBtn.hidden = YES;
            self.Type = 2;
            break;
        }
        case 3:{
            [self showButton:self.payBtn withTitle:@"查看物流" frame:rightButtonFrame];
            self.cancleBtn.hidden = YES;
            self.Type = 3;
            break;
        }
        case 4:{
            [self showButton:self.cancleBtn withTitle:@"联系买家" frame:leftButtonFrame];
            [self showButton:self.payBtn withTitle:@"删除订单" frame:rightButtonFrame];
            self.Type = 4;
            break;
        }
        default:
            break;
    }

}


- (void)payBtnClick{

    if (self.Type == 0) {
        //未付款   联系买家
    }else if (self.Type == 1){
        //已支付，待发货  联系买家   确认发货
        self.SentView.model = _model;
        [self.SentView showinView:self.view];
    }else if (self.Type == 2){
        //已发货    联系买家

    }else if (self.Type == 3){
        //买家取消订单  联系买家 删除订单
    }else if (self.Type == 4){
        //交易结束  联系买家 删除订单
        
    }

}

- (void)cancleBtnClick{
    [self connectBuyer:_model];

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSArray *modelArr = _model.itemOrdersData;
    return modelArr.count - 1 +5;  //减掉运费  加收货地址、备注、头部、联系卖家、订单编号

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.row == 0) {
        return 70;
    }else if (indexPath.row == 1){
        itemOrdersDataModel *itemModel = _model.itemOrdersData[0];
        NSString *str;
        if (itemModel.userOrderMemo.length >0) {
            str = itemModel.userOrderMemo;
        }else{
            str = @"买家未填写备注";
        
        }
            CGFloat Hetiht = [self getSpaceLabelHeight:str withFont:APPFONT(13) withWidth:ScreenWidth - 70];
        if (_model.on) {
            if (Hetiht >20) {
                
                return Hetiht +56;
            }else{
                return 70;
            }
        }else{
            return 70;
        }
    }else if (indexPath.row == 2){
        return 62;
    }else if (indexPath.row == _model.itemOrdersData.count +2){
        return 70;
    }else if (indexPath.row == _model.itemOrdersData.count +3){
        return 72;
    }else{
        return 100;
    }


}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.row == 0) {
        static NSString *AcceptCellid = @"AcceptCellid";
        AcceptAdressCell *cell = [tableView dequeueReusableCellWithIdentifier:AcceptCellid];
        if (!cell) {
            cell = [[AcceptAdressCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AcceptCellid];
        }
        cell.model = _model;
        return cell;
    }else if (indexPath.row == 1){
        static NSString *memoCellid = @"memoCellid";
        MemoCell *cell = [tableView dequeueReusableCellWithIdentifier:memoCellid];
        if (!cell) {
            cell = [[MemoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:memoCellid];
        }
        [cell.selectBtn addTarget:self action:@selector(selectBtnClick) forControlEvents:UIControlEventTouchUpInside];
        cell.model = _model;
        return cell;

    }else if (indexPath.row == 2){
        static NSString *selltopCellid = @"selltopCellid";
        SellerTopCell *cell = [tableView dequeueReusableCellWithIdentifier:selltopCellid];
        if (!cell) {
            cell = [[SellerTopCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:selltopCellid];
        }
        cell.model = _model;
        return cell;
    }else if (indexPath.row == _model.itemOrdersData.count +2){
        static NSString *conCellid = @"conCellid";
        ConnectBuyerCell *cell = [tableView dequeueReusableCellWithIdentifier:conCellid];
        if (!cell) {
            cell = [[ConnectBuyerCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:conCellid];
        }
        cell.model = _model;
        return cell;
    }else if (indexPath.row == _model.itemOrdersData.count +3){
        static NSString *numCellid = @"numCellid";
        OrderNumberCell *cell = [tableView dequeueReusableCellWithIdentifier:numCellid];
        if (!cell) {
            cell = [[OrderNumberCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:numCellid];
        }
        cell.model = _model;
        return cell;

    }else{
        static NSString *Cellid = @"Cellid";
        SellerOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:Cellid];
        if (!cell) {
            cell = [[SellerOrderCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Cellid];
        }
        itemOrdersDataModel *model = _model.itemOrdersData[indexPath.row - 3];
        cell.model = model;
        return cell;

    }
}


- (void)selectBtnClick{

    _model.on = !_model.on;
    [self.AllTabView reloadData];

}



- (void)connectBuyer:(SellerOrderModel *)model{
    
    if (model.itemOrdersData.count<=0) {
        [self showTextHud:@"买家信息获取失败，请稍后再试"];
        return;
    }
    itemOrdersDataModel *themodel =  model.itemOrdersData[0];


    NSDictionary *dic = @{@"sellerIds":themodel.accountId};
    
    [RCTokenPL getRcsellersinfoWithdic:dic ReturnBlock:^(id returnValue) {
        
        
        xxxxViewController *chat =[[xxxxViewController alloc] init];
        
        //设置会话的类型，如单聊、讨论组、群聊、聊天室、客服、公众服务会话等
        chat.conversationType = ConversationType_PRIVATE;
        //设置会话的目标会话ID。（单聊、客服、公众服务会话为对方的ID，讨论组、群聊、聊天室为会话的ID）
        chat.targetId = [NSString stringWithFormat:@"%@",themodel.accountId] ;
        NSArray *arr = returnValue[@"shopInfoList"];
        NSDictionary *thedic = arr[0];
        
        //设置聊天会话界面要显示的标题
        if (NULL_TO_NIL(thedic[@"shopName"]) ) {
            chat.title = NULL_TO_NIL(thedic[@"shopName"]);
        }else if (NULL_TO_NIL(thedic[@"shopContact"])){
            chat.title = NULL_TO_NIL(thedic[@"shopContact"]);
        } else{
            chat.title = NULL_TO_NIL(thedic[@"sellerInfo"]);
        }
        //显示聊天会话界面
        [self.navigationController pushViewController:chat animated:YES];
        
    } andErrorBlock:^(NSString *msg) {
        [self showTextHud:msg];
    }];


}



/**
 确认发货
 
 @param model model
 */
-(void)DidSelectedMakeSureSentViewMakeSureBtnWithModel:(SellerOrderModel *)model{
    
    NSLog(@"%@",model);
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i<model.itemOrdersData.count; i++) {
        itemOrdersDataModel *theModel = model.itemOrdersData[i];
        if ([theModel.itemId intValue]!= -1) {
            [arr addObject:theModel.theId];
        }
    }
    if (arr.count <=0) {
        return;
    }
    NSDictionary *infoDic = @{@"itemOrderIds":[arr componentsJoinedByString:@","],
                              @"logisticsNumber":self.SentView.traNumbertxt.text,
                              @"corporationCode":@"",
                              @"corporationName":self.SentView.traNametxt.text
                              };
    [MBProgressHUD showMessag:nil toView:self.view];
    
    [OrderPL SellerupdatelogisticsItemWithinfoDic:infoDic ReturnBlock:^(id returnValue) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self showTextHud:@"发货成功"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshSellerOrder" object:nil];

        
        [self performSelector:@selector(backVc) withObject:nil afterDelay:1.5];
        //  [self reLoadData];
        
    } andErrorBlock:^(NSString *msg) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        [self showTextHud:msg];
    }];
    
}




- (void)backVc{

    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark =========== 获取高度
-(CGFloat)getSpaceLabelHeight:(NSString*)str withFont:(UIFont*)font withWidth:(CGFloat)width
{
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    // paraStyle.lineSpacing = 8; 行距
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle
                          };
    
    CGSize size = [str boundingRectWithSize:CGSizeMake(width, 0) options:\
                   NSStringDrawingTruncatesLastVisibleLine |
                   NSStringDrawingUsesLineFragmentOrigin |
                   NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
    return size.height;
}


- (void)showButton:(UIButton*)button withTitle:(NSString*)title frame:(CGRect)frame
{
    button.hidden = NO;
    button.frame = frame;
    [button setTitle:title forState:UIControlStateNormal];
}
- (void)CallPeopleWithmobile:(NSString *)phoneNumber{
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",phoneNumber];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
    
}

@end
