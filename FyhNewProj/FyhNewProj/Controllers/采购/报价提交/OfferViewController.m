//
//  OfferViewController.m
//  FyhNewProj
//
//  Created by yh f on 2017/4/19.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "OfferViewController.h"
#import "SDCycleScrollView.h"
#import "PublicWantPL.h"
#import "MyNeedsModel.h"
#import "NeedsDetailModel.h"
#import "OfferView.h"
#import "MenueView.h"
#import "AppDelegate.h"
#import "DOTabBarController.h"
#import "xxxxViewController.h"
#import "ChatListViewController.h"
#import "RCTokenPL.h"
#import "UserWantPL.h"

@interface OfferViewController ()<SDCycleScrollViewDelegate,OfferViewDelegate,MenueViewDelegate>

@property (nonatomic , strong)  SDCycleScrollView  *sdcycleView;

@property (nonatomic , strong) UIScrollView *bgScrollView;

@property (nonatomic , strong) OfferView *offView;

@property (nonatomic , strong) MenueView *menuView;

@end

@implementation OfferViewController{

    CGFloat             _originY;
    NeedsDetailModel   *_detailModel;
    NSString *stutas;
    YLButton *_collectBtn;

}
-(MenueView *)menuView{
    if (!_menuView) {
        _menuView = [[MenueView alloc]init];
        _menuView.delegate = self;
    }
    
    return _menuView;
    
}
-(SDCycleScrollView *)sdcycleView{
    if (!_sdcycleView) {
        _sdcycleView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, _originY , ScreenWidth, ScreenWidth) imageURLStringsGroup:nil]; // 模拟网络延时情景
        _sdcycleView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        _sdcycleView.delegate = self;
        _sdcycleView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [backBtn setImage:[UIImage imageNamed:@"need_back"] forState:UIControlStateNormal];
        [self.view addSubview:backBtn];
        backBtn.frame = CGRectMake(8, 32, 28, 28);
        [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton* rightbutton = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth - 36, 32, 28, 28)];
        // [button setBackgroundImage:backImg forState:UIControlStateNormal];
        [rightbutton setImage:[UIImage imageNamed:@"need_mesg"] forState:UIControlStateNormal];
        [rightbutton addTarget:self action:@selector(rightButtonClickEvent) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:rightbutton];

        }
    return _sdcycleView;
}

- (OfferView *)offView
{
    if (!_offView) {
        _offView = [OfferView new];
        _offView.delegate = self;
    }
    return _offView;
}

-(UIScrollView *)bgScrollView{
    if (!_bgScrollView) {
        _bgScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight -50)];
        _bgScrollView.backgroundColor = UIColorFromRGB(WhiteColorValue);
        _bgScrollView.bounces = YES;
        NSLog(@"sss%f",[[UIDevice currentDevice] systemVersion].floatValue);
            if (@available(iOS 11.0, *)) {
                _bgScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            } else {
                // Fallback on earlier versions
            }
           

        
       
    }
    return _bgScrollView;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(WhiteColorValue);
    self.edgesForExtendedLayout = UIRectEdgeNone;

    _detailModel = [[NeedsDetailModel alloc]init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshView)
                                                 name:@"userHaveLoginIn" object:nil];
    [self loadpurChasingNeedDetail];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    self.navigationController.navigationBar.hidden = NO;

}
- (void)refreshView{
    
    [self newloadpurChasingNeedDetail];

    
}

- (void)initUI{
    _originY = 0;
    [self.view addSubview:self.bgScrollView];
    [self.bgScrollView addSubview:self.sdcycleView];
    self.sdcycleView.imageURLStringsGroup = _detailModel.imageUrlList;
    _originY += ScreenWidth;
    
    UILabel *nameLab = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(BlackColorValue) font:APPFONT(18) textAligment:NSTextAlignmentLeft andtext:_detailModel.title];
    nameLab.numberOfLines = 2;
    [self.bgScrollView addSubview:nameLab];
    nameLab.sd_layout.
    leftSpaceToView(self.bgScrollView,16).
    topSpaceToView(self.sdcycleView,12).
    rightSpaceToView(self.bgScrollView,98).
    autoHeightRatio(0);
    [nameLab setMaxNumberOfLinesToShow:2];

    
    UILabel *kindLab = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(0xaab2bd) font:APPFONT(12) textAligment:NSTextAlignmentLeft andtext:[NSString stringWithFormat:@"分类：%@",_detailModel.categoryName]];
    [self.bgScrollView addSubview:kindLab];
    kindLab.sd_layout.
    leftSpaceToView(self.bgScrollView,16).
    topSpaceToView(nameLab,18).widthIs(200).
    heightIs(13);
    
    
    if ([_detailModel.status intValue] == 1) {
        stutas = @"状态：审核中";
    }else if ([_detailModel.status intValue] == 3){
     stutas = @"状态：审核未通过";
    }else if ([_detailModel.status intValue] == 4){
        stutas = @"状态：进行中";
    }else if ([_detailModel.status intValue] == 6){
        stutas = @"状态：报价中";
    }else if ([_detailModel.status intValue] ==9 ){
        stutas = @"状态：已完成";
    }else{
        
         stutas = @"状态：已删除";
    }
    
    NSMutableAttributedString *textStr = [[NSMutableAttributedString alloc] initWithString:stutas];
    
    [textStr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xaab2bd) range:NSMakeRange(0, 3)];//从0位置开始的长度为2的红色
    
    
    UILabel *statesLab = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(RedColorValue) font:APPFONT(12) textAligment:NSTextAlignmentLeft andtext:@""];
    [statesLab setAttributedText:textStr];
    [self.bgScrollView addSubview:statesLab];
    statesLab.sd_layout.
    leftSpaceToView(self.bgScrollView,100).
    topEqualToView(kindLab).
    widthIs(200).
    heightIs(13);
//    UILabel *seeLab = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(0xaab2bd) font:APPFONT(13) textAligment:NSTextAlignmentRight andtext:[NSString stringWithFormat:@"浏览：%@",_detailModel.viewedCount?_detailModel.viewedCount:@"0"]];
//    [self.bgScrollView addSubview:seeLab];
//    seeLab.sd_layout.rightSpaceToView(self.bgScrollView,20).topSpaceToView(self.sdcycleView,49).widthIs(200).heightIs(13);
    
    _collectBtn = [YLButton buttonWithType:UIButtonTypeCustom];
    [_collectBtn setTitle:@"收藏" forState:UIControlStateNormal];
    [_collectBtn setTitleColor:UIColorFromRGB(0x656d78) forState:UIControlStateNormal];
    _collectBtn.titleLabel.font = APPFONT(12);
    _collectBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    if (_detailModel.isUserCollectedPurchasingNeed) {
        [_collectBtn setImage:[UIImage imageNamed:@"collect-red"] forState:UIControlStateNormal];

    }else{
        [_collectBtn setImage:[UIImage imageNamed:@"collect-gray"] forState:UIControlStateNormal];

    }
    _collectBtn.imageRect = CGRectMake(10, 10, 18, 15);
    _collectBtn.titleRect = CGRectMake(0, 31, 38, 13);
    [self.bgScrollView addSubview:_collectBtn];
    [_collectBtn addTarget:self action:@selector(collectBtnClick) forControlEvents:UIControlEventTouchUpInside];
    _collectBtn.sd_layout.
    rightSpaceToView(self.bgScrollView,9).
    topSpaceToView(self.sdcycleView, 2).
    widthIs(38).
    heightIs(54);
    
    CGFloat namehetiht = [self getSpaceLabelHeight:_detailModel.title withFont:APPFONT(18) withWidth:ScreenWidth - 16 -98];

    _originY +=12 + namehetiht + 18 + 13 +18;

    
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:@"YYYY-MM-dd"]; // （@"YYYY-MM-dd hh:mm:ss"）----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    
    [formatter setTimeZone:timeZone];
    
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[_detailModel.updateTime integerValue]];
    
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];

    UILabel *timeLab = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(0xaab2bd) font:APPFONT(12) textAligment:NSTextAlignmentRight andtext:confromTimespStr];
    [self.bgScrollView addSubview:timeLab];
    timeLab.sd_layout.rightSpaceToView(self.bgScrollView,16).centerYEqualToView(kindLab).widthIs(200).heightIs(13);
    

    
    
    
    [self createLineWithColor:UIColorFromRGB(0xf5f7fa) frame:CGRectMake(0, _originY, ScreenWidth, 12) Super:self.bgScrollView];
    
    _originY += 12;

    [self createLabelWith:UIColorFromRGB(0xaab2bd) Font:APPFONT(13) WithSuper:self.bgScrollView Frame:CGRectMake(16, _originY, 70, 32) Alignment:NSTextAlignmentLeft Text:@"需求类目"];
    [self createLabelWith:UIColorFromRGB(0x434a54) Font:APPFONT(13 ) WithSuper:self.bgScrollView Frame:CGRectMake(100, _originY, ScreenWidth-120, 32) Alignment:NSTextAlignmentLeft Text:_detailModel.categoryName];
    
    UIView *line1 = [BaseViewFactory viewWithFrame:CGRectMake(16, _originY, ScreenWidth-16,0.5 ) color:UIColorFromRGB(0xf2f2f2)];
    [self.bgScrollView addSubview:line1];
    _originY += 32;


    
    [self createLabelWith:UIColorFromRGB(0xaab2bd) Font:APPFONT(13) WithSuper:self.bgScrollView Frame:CGRectMake(16, _originY, 70, 32) Alignment:NSTextAlignmentLeft Text:@"需求数量"];
    [self createLabelWith:UIColorFromRGB(0x434a54) Font:APPFONT(13) WithSuper:self.bgScrollView Frame:CGRectMake(100, _originY, ScreenWidth-120, 32) Alignment:NSTextAlignmentLeft Text:[NSString stringWithFormat:@"%@%@",_detailModel.quantity,_detailModel.unit]];
    UIView *line2 = [BaseViewFactory viewWithFrame:CGRectMake(16, _originY, ScreenWidth-16,0.5 ) color:UIColorFromRGB(0xf2f2f2)];
    [self.bgScrollView addSubview:line2];
    _originY += 32;
    
    [self createLabelWith:UIColorFromRGB(0xaab2bd) Font:APPFONT(13) WithSuper:self.bgScrollView Frame:CGRectMake(16, _originY, 70, 32) Alignment:NSTextAlignmentLeft Text:@"相似程度"];
    NSString *sameStr;
    if (_detailModel.isSame) {
        sameStr = @"和图一样";
    }else{
        sameStr = @"和图相似";
    }
    [self createLabelWith:UIColorFromRGB(0x434a54) Font:APPFONT(13) WithSuper:self.bgScrollView Frame:CGRectMake(100, _originY, ScreenWidth-120, 32) Alignment:NSTextAlignmentLeft Text:sameStr];
    UIView *line3 = [BaseViewFactory viewWithFrame:CGRectMake(16, _originY, ScreenWidth-16,0.5 ) color:UIColorFromRGB(0xf2f2f2)];
    [self.bgScrollView addSubview:line3];
    _originY += 32;
    
    
    [self createLabelWith:UIColorFromRGB(0xaab2bd) Font:APPFONT(13) WithSuper:self.bgScrollView Frame:CGRectMake(16, _originY, 70, 32) Alignment:NSTextAlignmentLeft Text:@"有效时间"];
    NSString *timeStr =[self timeWithTimeIntervalString:_detailModel.expireTime];
    [self createLabelWith:UIColorFromRGB(0x434a54) Font:APPFONT(13) WithSuper:self.bgScrollView Frame:CGRectMake(100, _originY, ScreenWidth-120, 32) Alignment:NSTextAlignmentLeft Text:timeStr];
    UIView *line4 = [BaseViewFactory viewWithFrame:CGRectMake(16, _originY, ScreenWidth-16,0.5 ) color:UIColorFromRGB(0xf2f2f2)];
    [self.bgScrollView addSubview:line4];
    _originY += 32;
    
    [self createLabelWith:UIColorFromRGB(0xaab2bd) Font:APPFONT(13) WithSuper:self.bgScrollView Frame:CGRectMake(16, _originY, 70, 32) Alignment:NSTextAlignmentLeft Text:@"联系方式"];
    [self createLabelWith:UIColorFromRGB(BlackColorValue) Font:APPFONT(13) WithSuper:self.bgScrollView Frame:CGRectMake(100, _originY, ScreenWidth-120, 32) Alignment:NSTextAlignmentLeft Text:_detailModel.contact];
    UIView *line5 = [BaseViewFactory viewWithFrame:CGRectMake(16, _originY, ScreenWidth-16,0.5 ) color:UIColorFromRGB(0xf2f2f2)];
    [self.bgScrollView addSubview:line5];
    _originY += 32;
    
    [self createLineWithColor:UIColorFromRGB(0xf5f7fa) frame:CGRectMake(0, _originY, ScreenWidth, 6) Super:self.bgScrollView];
    _originY += 6;

    //NSString *miaoshu = @"看见的撒不开机奥斯卡萨科技萨达是可敬的哈萨克和大叔大叔了肯德基奥斯陆大姐说了卡时间来看撒娇拉上看见啦";
    
    CGFloat height = [self getSpaceLabelHeight:_detailModel.NeedsDescription withFont:APPFONT(13) withWidth:ScreenWidth - 116];
    
    [self createLabelWith:UIColorFromRGB(0xaab2bd) Font:APPFONT(13) WithSuper:self.bgScrollView Frame:CGRectMake(16, _originY, 70, 32) Alignment:NSTextAlignmentLeft Text:@"描述要求"];

    [self createLabelWith:UIColorFromRGB(0x434a54) Font:APPFONT(13) WithSuper:self.bgScrollView Frame:CGRectMake(100, _originY+8, ScreenWidth -116, height) Alignment:NSTextAlignmentLeft Text:_detailModel.NeedsDescription];
    height+=8;
    
    if (height<32) {
        height = 32;
    }
    _originY += height+8;
    [self createLineWithColor:UIColorFromRGB(0xf5f7fa) frame:CGRectMake(0, _originY, ScreenWidth, 12) Super:self.bgScrollView];
    _originY += 12;
    if (_originY >ScreenHeight -20) {
        self.bgScrollView.contentSize = CGSizeMake(10, _originY);

    }else{
        
        self.bgScrollView.contentSize = CGSizeMake(10, ScreenHeight-20);

    }
    
    UIView *boomView = [BaseViewFactory viewWithFrame:CGRectMake(10, ScreenHeight - 45 -iPhoneX_DOWNHEIGHT, ScreenWidth - 20, 42) color:UIColorFromRGB(WhiteColorValue)];
    [self.view addSubview:boomView];
    boomView.layer.cornerRadius = 5;
    boomView.clipsToBounds = YES;
    boomView.layer.borderColor = UIColorFromRGB(RedColorValue).CGColor;
    boomView.layer.borderWidth = 1;
    
    SubBtn *talkBtn = [SubBtn buttonWithtitle:@"洽谈" titlecolor:UIColorFromRGB(WhiteColorValue) cornerRadius:0 andtarget:self action:@selector(talkBtnClick) andframe:CGRectMake(0, 1, boomView.width/2, 40)];
    talkBtn.titleLabel.font = APPFONT(13);
    [boomView addSubview:talkBtn];
    
    UIButton *priceBtn = [BaseViewFactory buttonWithFrame:CGRectMake(boomView.width/2, 1, boomView.width/2, 40) font:APPFONT(13) title:@"报价" titleColor:UIColorFromRGB(RedColorValue) backColor:UIColorFromRGB(WhiteColorValue)];
    [boomView addSubview:priceBtn];
    [priceBtn addTarget:self action:@selector(priceBtnClick) forControlEvents:UIControlEventTouchUpInside];
}








#pragma mark =========== 获取详情

- (void)loadpurChasingNeedDetail{

    [PublicWantPL PublicgetGtPurchasingNeedDetailWithneedId:self.needId ReturnBlock:^(id returnValue) {
        NSDictionary *dic = returnValue[@"data"];
        NSDictionary *resultDic = dic[@"purchasingNeed"];
        _detailModel = [NeedsDetailModel mj_objectWithKeyValues:resultDic];
        NSLog(@"%@",returnValue);
//        [self.bgScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self initUI];

    } andErrorBlock:^(NSString *msg) {
        [self showTextHud:msg];
    }];
}

- (void)newloadpurChasingNeedDetail{
    
    [PublicWantPL PublicgetGtPurchasingNeedDetailWithneedId:self.needId ReturnBlock:^(id returnValue) {
        NSDictionary *dic = returnValue[@"data"];
        NSDictionary *resultDic = dic[@"purchasingNeed"];
        _detailModel = [NeedsDetailModel mj_objectWithKeyValues:resultDic];
        if (_detailModel.isUserCollectedPurchasingNeed) {
            [_collectBtn setImage:[UIImage imageNamed:@"collect-red"] forState:UIControlStateNormal];
            
        }else{
            [_collectBtn setImage:[UIImage imageNamed:@"collect-gray"] forState:UIControlStateNormal];
            
        }
        
    } andErrorBlock:^(NSString *msg) {
        [self showTextHud:msg];
    }];
}


#pragma mark =========== 按钮点击

/**
 提交报价
 */
-(void)didSelectedsubmitBtn{

    if (![[UserPL shareManager] userIsLogin]) {
        [self gotoLoginViewController];
        return;
    }

    
    if (self.offView.moneyTxt.text.length <= 0) {
        [self showTextHud:@"请输入报价"];
        return;
    }
    NSString *beizhu;
    if ([self.offView.remarkTxt.text isEqualToString:@"请输入您的报价说明不超过30字(选填)"]) {
        beizhu = @"";
    }else{
        beizhu = self.offView.remarkTxt.text;
    }
    NSDictionary *dic = @{
                          @"purchasingNeedId":_detailModel.needid,
                          @"price":self.offView.moneyTxt.text,
                          @"memo":beizhu
                          
                          };
    [PublicWantPL PublicSellerSubmitPriceWithDic:dic ReturnBlock:^(id returnValue) {
        [self showTextHud:@"报价提交成功"];
        [self.offView dismiss];

    } andErrorBlock:^(NSString *msg) {
        [self showTextHud:msg];
    }];


}


/**
 洽谈
 */
- (void)talkBtnClick{
    if (![[UserPL shareManager] userIsLogin]) {
        [self gotoLoginViewController];
        return;
    }
    if ([self ChatManiSHisSelfwithHisId:[NSString stringWithFormat:@"%@",_detailModel.accountId]]) {
        [self showTextHud:@"您不能跟自己聊天对话哦"];
        return;
    }
    NSDictionary *dic = @{@"sellerIds":_detailModel.accountId};
    [RCTokenPL getRcsellersinfoWithdic:dic ReturnBlock:^(id returnValue) {
        
        
        xxxxViewController *chat =[[xxxxViewController alloc] init];
        
        chat.infoDic = @{@"title":_detailModel.title,
                        @"proId":self.needId,
                        @"imageUrl":_detailModel.imageUrlList[0],
                        @"price":@"",
                        @"content":[NSString stringWithFormat:@"数量：%@%@",_detailModel.quantity,_detailModel.unit],
                        @"type":@"quote"
                                };
        
        //设置会话的类型，如单聊、讨论组、群聊、聊天室、客服、公众服务会话等
        chat.conversationType = ConversationType_PRIVATE;
        //设置会话的目标会话ID。（单聊、客服、公众服务会话为对方的ID，讨论组、群聊、聊天室为会话的ID）
        chat.targetId = _detailModel.accountId ;
        NSArray *arr = returnValue[@"shopInfoList"];
        NSDictionary *thedic = arr[0];

        //设置聊天会话界面要显示的标题
        if (NULL_TO_NIL(thedic[@"shopName"]) ) {
           chat.title = NULL_TO_NIL(thedic[@"shopName"]);
        }else{
            chat.title = NULL_TO_NIL(thedic[@"sellerInfo"]);
            
        }
        //显示聊天会话界面
        [self.navigationController pushViewController:chat animated:YES];

    } andErrorBlock:^(NSString *msg) {
        [self showTextHud:msg];
    }];

    
    

}


/**
 报价
 */
- (void)priceBtnClick{
    if (![[UserPL shareManager] userIsLogin]) {
        [self gotoLoginViewController];
        return;
    }
    self.offView.unitLabl.text = [NSString stringWithFormat:@"元/%@",_detailModel.unit];
    [self.offView showinView:self.view];
    if (_detailModel.expectUnitPrice.length>0) {
        [self.offView setthetxtpLa:_detailModel.expectUnitPrice];
    }
}

/**
 返回
 */
- (void)backBtnClick{

    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightButtonClickEvent{

    self.menuView.OriginY = 75;
    [self.menuView show];
}




-(void)didselectedBtnWithButton:(UIButton *)btn{
    if (btn.tag ==1001) {
        if (![[UserPL shareManager] userIsLogin]) {
            [self gotoLoginViewController];
            return;
        }
        ChatListViewController *chVc = [[ChatListViewController alloc] init];
        [self.navigationController pushViewController:chVc animated:YES];
        return;
    }

    
    AppDelegate *app = (AppDelegate *)[[UIApplication  sharedApplication] delegate];
    switch (btn.tag) {
        case 1000:
            [self.navigationController popToRootViewControllerAnimated:NO];
            app.mainController.selectedIndex = 0;
            break;
        
        case 1002:
            if (![[UserPL shareManager] userIsLogin]) {
                [self gotoLoginViewController];
            }else{
                [self.navigationController popToRootViewControllerAnimated:NO];
                app.mainController.selectedIndex = 4;
            }
            break;
        case 1003:
            if (![[UserPL shareManager] userIsLogin]) {
                [self gotoLoginViewController];
                break;
            }else{
                [self.navigationController popToRootViewControllerAnimated:NO];
                app.mainController.selectedIndex = 3;
            }

            break;
        case 1004:
            [self.navigationController popToRootViewControllerAnimated:NO];
            app.mainController.selectedIndex = 1;
            break;
            
        default:
            break;
    }
    
}



/**
 收藏
 */
- (void)collectBtnClick{
    if (![[UserPL shareManager] userIsLogin]) {
        [self gotoLoginViewController];
        return;
    }
    if (_detailModel.isUserCollectedPurchasingNeed) {
        NSDictionary *dic = @{@"purchasingNeedId":_detailModel.needid,
                              };
        [UserWantPL userCancleCollectNeedWithDic:dic andReturnBlock:^(id returnValue) {
            [self showTextHud:@"已取消收藏"];
            _detailModel.isUserCollectedPurchasingNeed = NO;
            if (_detailModel.isUserCollectedPurchasingNeed) {
                [_collectBtn setImage:[UIImage imageNamed:@"collect-red"] forState:UIControlStateNormal];
                
            }else{
                [_collectBtn setImage:[UIImage imageNamed:@"collect-gray"] forState:UIControlStateNormal];
                
            }
        } andErrorBlock:^(NSString *msg) {
            [self showTextHud:msg];
        }];
    }else{
        NSDictionary *dic = @{@"purchasingNeedId":_detailModel.needid};
        [UserWantPL userCollectNeedWithDic:dic andReturnBlock:^(id returnValue) {
            [self showTextHud:@"收藏成功"];
            _detailModel.isUserCollectedPurchasingNeed = YES;
            if (_detailModel.isUserCollectedPurchasingNeed) {
                [_collectBtn setImage:[UIImage imageNamed:@"collect-red"] forState:UIControlStateNormal];
                
            }else{
                [_collectBtn setImage:[UIImage imageNamed:@"collect-gray"] forState:UIControlStateNormal];
                
            }
        } andErrorBlock:^(NSString *msg) {
            [self showTextHud:msg];
            
        }];
        
    }
    
    
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

- (NSString *)timeWithTimeIntervalString:(NSString *)timeString
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:@"YYYY-MM-dd"]; // （@"YYYY-MM-dd hh:mm:ss"）----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    
    [formatter setTimeZone:timeZone];
    
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[timeString integerValue]];
    
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    return confromTimespStr;
}

@end
