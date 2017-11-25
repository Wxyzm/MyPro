//
//  MyPriceDetailViewController.m
//  FyhNewProj
//
//  Created by yh f on 2017/7/26.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "MyPriceDetailViewController.h"
#import "OfferViewController.h"
#import "SDCycleScrollView.h"
#import "PublicWantPL.h"
#import "xxxxViewController.h"
#import "RCTokenPL.h"

@interface MyPriceDetailViewController ()<SDCycleScrollViewDelegate>

@property (nonatomic , strong)  SDCycleScrollView  *sdcycleView;

@property (nonatomic , strong) UIScrollView *bgScrollView;

@end

@implementation MyPriceDetailViewController{

    CGFloat     _originY;
    YLButton    *_openBtn;
    UIView      *_unView;
    UIView      *_priceView;
    SubBtn      *_lookBtn;
    CGFloat    _ViewOriginY;
    CGFloat    _unHeight;
    NSDictionary *_infoDic;
    NSMutableArray    *_priceArr;
    
    BOOL        _isOpen;

}

-(UIScrollView *)bgScrollView{
    if (!_bgScrollView) {
        _bgScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight )];
        _bgScrollView.backgroundColor = UIColorFromRGB(WhiteColorValue);
    }
    return _bgScrollView;
    
}

-(SDCycleScrollView *)sdcycleView{
    if (!_sdcycleView) {
        _sdcycleView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, _originY , ScreenWidth, ScreenWidth*2/3) imageURLStringsGroup:nil]; // 模拟网络延时情景
        _sdcycleView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        _sdcycleView.delegate = self;
        _sdcycleView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [backBtn setImage:[UIImage imageNamed:@"back-item"] forState:UIControlStateNormal];
        [_sdcycleView addSubview:backBtn];
        backBtn.frame = CGRectMake(20, 20, 40, 40);
        [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _sdcycleView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self LoadNeedsDeyail];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}


/**
 返回
 */
- (void)backBtnClick{
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)LoadNeedsDeyail{
    [PublicWantPL SellerGetHisNeedDetailwithDic:_needId WithReturnBlock:^(id returnValue) {
        NSLog(@"%@",returnValue);
        _infoDic = returnValue[@"data"];
        [self initUI];
        
    } andErrorBlock:^(NSString *msg) {
        [self showTextHud:msg];
        [self.navigationController popViewControllerAnimated:YES];
    }];
}


- (void)initUI{

    [self.view addSubview:self.bgScrollView];
    [self.bgScrollView addSubview:self.sdcycleView];
    NSDictionary *dic = _infoDic[@"purchasingNeed"];

    self.sdcycleView.imageURLStringsGroup = dic[@"imageUrlList"];
    
    _originY += ScreenWidth*2/3;
    UILabel *nameLab = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(BlackColorValue) font:APPFONT(15) textAligment:NSTextAlignmentLeft andtext:dic[@"title"]];
    nameLab.numberOfLines = 2;
    [self.bgScrollView addSubview:nameLab];
    nameLab.sd_layout.leftSpaceToView(self.bgScrollView,20).topSpaceToView(self.sdcycleView,10).rightSpaceToView(self.bgScrollView,70).autoHeightRatio(0);
    [nameLab setMaxNumberOfLinesToShow:2];
    
    UILabel *seeLab = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(0xaab2bd) font:APPFONT(13) textAligment:NSTextAlignmentRight andtext:[NSString stringWithFormat:@"浏览:%@",dic[@"viewedCount"]?dic[@"viewedCount"]:@"0"]];
    [self.bgScrollView addSubview:seeLab];
    seeLab.sd_layout.rightSpaceToView(self.bgScrollView,20).topSpaceToView(self.sdcycleView,10).heightIs(14);
    [seeLab setSingleLineAutoResizeWithMaxWidth:200];
    
    UILabel *timeLab = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(0xaab2bd) font:APPFONT(13) textAligment:NSTextAlignmentRight andtext:[NSString stringWithFormat:@"%@", [self returnTheTimeWithNum:dic[@"updateTime"]]]];
    [self.bgScrollView addSubview:timeLab];
    timeLab.sd_layout.rightSpaceToView(self.bgScrollView,20).topSpaceToView(seeLab,10).heightIs(14);
    [timeLab setSingleLineAutoResizeWithMaxWidth:200];
    
    NSString *stutas;
    if ([dic[@"status"] intValue] == 1) {
        stutas = @"状态:审核中";
    }else if ([dic[@"status"] intValue]== 3){
        stutas = @"状态:审核未通过";
    }else if ([dic[@"status"] intValue] == 4){
        stutas = @"状态:进行中";
    }else if ([dic[@"status"] intValue] == 6){
        stutas = @"状态:报价中";
    }else if ([dic[@"status"] intValue] ==9 ){
        stutas = @"状态:已完成";
    }
    
    UILabel *statesLab = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(RedColorValue) font:APPFONT(13) textAligment:NSTextAlignmentLeft andtext:stutas];
    [self.bgScrollView addSubview:statesLab];
    statesLab.sd_layout.leftSpaceToView(self.bgScrollView,20).topSpaceToView(self.sdcycleView,49).widthIs(200).heightIs(13);
    _originY += 62;
    
    UILabel *kindLab = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(0xaab2bd) font:APPFONT(13) textAligment:NSTextAlignmentLeft andtext:[NSString stringWithFormat:@"分类:%@",dic[@"categoryName"]?dic[@"categoryName"]:@""]];
    [self.bgScrollView addSubview:kindLab];
    
    kindLab.sd_layout.leftSpaceToView(self.bgScrollView,20).topSpaceToView(statesLab,5).widthIs(200).heightIs(13);
    
    _openBtn = [YLButton buttonWithType:UIButtonTypeCustom];
    [_openBtn addTarget:self action:@selector(openBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_openBtn setImage:[UIImage imageNamed:@"spread"] forState:UIControlStateNormal];
    [self.bgScrollView addSubview:_openBtn];
    _openBtn.sd_layout.rightSpaceToView(self.bgScrollView,20).topSpaceToView(self.sdcycleView,49).heightIs(20).widthIs(20);
    
    _originY += 28;
    _ViewOriginY = _originY;
    
    
    _unHeight = 0;
    _unView = [BaseViewFactory viewWithFrame:CGRectZero color:UIColorFromRGB(WhiteColorValue)];
    [_unView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [self.bgScrollView addSubview:_unView];
    
    [self createLineWithColor:UIColorFromRGB(LineColorValue) frame:CGRectMake(0, _unHeight, ScreenWidth, 12) Super:_unView];
    
    _unHeight += 12;
    
    
    [self createLabelWith:UIColorFromRGB(0xaab2bd) Font:APPFONT(13) WithSuper:_unView Frame:CGRectMake(20, _unHeight+11, 70, 39) Alignment:NSTextAlignmentLeft Text:@"需求类目:"];
    [self createLabelWith:UIColorFromRGB(BlackColorValue) Font:APPFONT(15) WithSuper:_unView Frame:CGRectMake(100, _unHeight+11, ScreenWidth-120, 39) Alignment:NSTextAlignmentLeft Text:dic[@"categoryName"]?dic[@"categoryName"]:@""];
    _unHeight += 50;
    
    
    UIView *bgview1 = [BaseViewFactory viewWithFrame:CGRectMake(10, _unHeight, ScreenWidth-20, 39) color:UIColorFromRGB(LineColorValue)];
    bgview1.layer.cornerRadius = 5;
    
    [_unView addSubview:bgview1];
    [self createLabelWith:UIColorFromRGB(0xaab2bd) Font:APPFONT(13) WithSuper:_unView Frame:CGRectMake(20, _unHeight, 70, 39) Alignment:NSTextAlignmentLeft Text:@"需求数量:"];
    [self createLabelWith:UIColorFromRGB(BlackColorValue) Font:APPFONT(15) WithSuper:_unView Frame:CGRectMake(100, _unHeight, ScreenWidth-120, 39) Alignment:NSTextAlignmentLeft Text:[NSString stringWithFormat:@"%@%@",dic[@"quantity"]?dic[@"quantity"]:@"",dic[@"unit"]?dic[@"unit"]:@""]];
    _unHeight += 39;
    
    [self createLabelWith:UIColorFromRGB(0xaab2bd) Font:APPFONT(13) WithSuper:_unView Frame:CGRectMake(20, _unHeight, 70, 39) Alignment:NSTextAlignmentLeft Text:@"相似程度:"];
    NSString *sameStr;
    if ([dic[@"isSame"] boolValue]) {
        sameStr = @"和图一样";
    }else{
        sameStr = @"和图相似";
    }
    [self createLabelWith:UIColorFromRGB(BlackColorValue) Font:APPFONT(15) WithSuper:_unView Frame:CGRectMake(100, _unHeight, ScreenWidth-120, 39) Alignment:NSTextAlignmentLeft Text:sameStr];
    _unHeight += 39;
    
    UIView *bgview2 = [BaseViewFactory viewWithFrame:CGRectMake(10, _unHeight, ScreenWidth-20, 39) color:UIColorFromRGB(LineColorValue)];
    
    bgview2.layer.cornerRadius = 5;
    
    [_unView addSubview:bgview2];
    [self createLabelWith:UIColorFromRGB(0xaab2bd) Font:APPFONT(13) WithSuper:_unView Frame:CGRectMake(20, _unHeight, 70, 39) Alignment:NSTextAlignmentLeft Text:@"有效时间:"];
    NSString *timeStr =[self returnTheTimeWithNum:dic[@"expireTime"]?dic[@"expireTime"]:@""];
    [self createLabelWith:UIColorFromRGB(BlackColorValue) Font:APPFONT(15) WithSuper:_unView Frame:CGRectMake(100, _unHeight, ScreenWidth-120, 39) Alignment:NSTextAlignmentLeft Text:timeStr];
    _unHeight += 39;
    
    [self createLabelWith:UIColorFromRGB(0xaab2bd) Font:APPFONT(13) WithSuper:_unView Frame:CGRectMake(20, _unHeight, 70, 39) Alignment:NSTextAlignmentLeft Text:@"联系方式"];
    [self createLabelWith:UIColorFromRGB(BlackColorValue) Font:APPFONT(15) WithSuper:_unView Frame:CGRectMake(100, _unHeight, ScreenWidth-120, 39) Alignment:NSTextAlignmentLeft Text:dic[@"contact"]?dic[@"contact"]:@""];
    _unHeight += 39;
    
    
    CGFloat height = [self getSpaceLabelHeight:dic[@"description"]?dic[@"description"]:@"" withFont:APPFONT(15) withWidth:ScreenWidth - 40];
    UIView *bgview3 = [BaseViewFactory viewWithFrame:CGRectMake(10, _unHeight, ScreenWidth-20, height+39+12) color:UIColorFromRGB(LineColorValue)];
    bgview3.layer.cornerRadius = 5;
    [_unView addSubview:bgview3];
    [self createLabelWith:UIColorFromRGB(0xaab2bd) Font:APPFONT(13) WithSuper:_unView Frame:CGRectMake(20, _unHeight, 70, 39) Alignment:NSTextAlignmentLeft Text:@"描述要求:"];
    
    [self createLabelWith:UIColorFromRGB(BlackColorValue) Font:APPFONT(15) WithSuper:_unView Frame:CGRectMake(20, _unHeight+39, ScreenWidth -40, height) Alignment:NSTextAlignmentLeft Text:dic[@"description"]?dic[@"description"]:@""];
    _unHeight += height+39+12;
    
    _unView.frame = CGRectMake(0, _ViewOriginY, ScreenWidth, _unHeight);
    _unView.hidden = YES;

    _priceView = [BaseViewFactory viewWithFrame:CGRectZero color:UIColorFromRGB(LineColorValue)];
    [_priceView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [self.bgScrollView addSubview:_priceView];
    [self createLabelWith:UIColorFromRGB(BlackColorValue) Font:APPFONT(15) WithSuper:_priceView Frame:CGRectMake(0, 13, ScreenWidth-20, 15) Alignment:NSTextAlignmentCenter Text:@"我的报价单"];
    NSDictionary *peiceDic = _infoDic[@"quotation"];

    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(13, 38, ScreenWidth - 46, 110)];
    [_priceView addSubview:imageView];
    imageView.image = [UIImage imageNamed:@"block"];
    imageView.userInteractionEnabled = YES;
    
    UILabel *thenameLab = [BaseViewFactory labelWithFrame:CGRectMake(25, 11, imageView.width, 12) textColor:UIColorFromRGB(BlackColorValue) font:APPFONT(12) textAligment:NSTextAlignmentLeft andtext:[NSString stringWithFormat:@"用户：%@",peiceDic[@"supplierInfo"]]];
    [imageView addSubview:thenameLab];
    [self createLineWithColor:UIColorFromRGB(LineColorValue) frame:CGRectMake(25, 30, imageView.width - 115, 1) Super:imageView];
    
    UILabel *memoLab = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(BlackColorValue) font:APPFONT(12) textAligment:NSTextAlignmentLeft andtext:[NSString stringWithFormat:@"备注：%@",peiceDic[@"memo"]]];
    [imageView addSubview:memoLab];
    memoLab.sd_layout.leftEqualToView(nameLab).topSpaceToView(imageView,36).widthIs(imageView.width - 115).autoHeightRatio(0);
    [memoLab setMaxNumberOfLinesToShow:2];
    
    SubBtn *rightBtn = [SubBtn buttonWithtitle:peiceDic[@"price"] titlecolor:UIColorFromRGB(WhiteColorValue) cornerRadius:25 andtarget:nil action:nil andframe:CGRectMake(imageView.width - 70, 30, 50, 50)];
    rightBtn.titleLabel.font = APPFONT(12);
    [imageView addSubview:rightBtn];
    
    [self createLabelWith:UIColorFromRGB(WhiteColorValue) Font:APPFONT(11) WithSuper:rightBtn Frame:CGRectMake(0, 32, 50, 14) Alignment:NSTextAlignmentCenter Text:[NSString stringWithFormat:@"元/%@",dic[@"unit"]?dic[@"unit"]:@""]];
    
    
    SubBtn *chatBtn = [SubBtn buttonWithtitle:@"洽谈" backgroundColor:UIColorFromRGB(0x9ac2fa) titlecolor:UIColorFromRGB(WhiteColorValue) cornerRadius:12 andtarget:self action:@selector(chatBtnClick)];
    chatBtn.titleLabel.font = APPFONT(11);
    chatBtn.frame = CGRectMake(44, 77, 60, 24);
    [imageView addSubview:chatBtn];
    SubBtn *acceptBtn;
    switch ([peiceDic[@"status"] intValue]) {
        case 1:{
            acceptBtn  = [SubBtn buttonWithtitle:@"报价中" titlecolor:UIColorFromRGB(WhiteColorValue) cornerRadius:12 andtarget:self action:@selector(acceptBtnClick) andframe: CGRectMake(chatBtn.right + 44, 77, 60, 24)];
            break;
        }
        case 2:{
            acceptBtn  = [SubBtn buttonWithtitle:@"已接受" backgroundColor:UIColorFromRGB(PlaColorValue) titlecolor:UIColorFromRGB(WhiteColorValue) cornerRadius:12 andtarget:self action:@selector(comBtnClick)];
            break;
        }
        case 3:{
            acceptBtn  = [SubBtn buttonWithtitle:@"报价中" titlecolor:UIColorFromRGB(WhiteColorValue) cornerRadius:12 andtarget:self action:@selector(acceptBtnClick) andframe: CGRectMake(chatBtn.right + 44, 77, 60, 24)];
            break;
        }
        default:
            break;
    }
    
    acceptBtn.titleLabel.font = APPFONT(11);
    acceptBtn.frame = CGRectMake(chatBtn.right + 44, 77, 60, 24);
    [imageView addSubview:acceptBtn];

    _priceView.frame = CGRectMake(10, _originY, ScreenWidth - 20, 210);
    _isOpen = NO;
    _openBtn.imageView.transform = CGAffineTransformMakeRotation(M_PI);
    
    self.bgScrollView.contentSize = CGSizeMake(10, _priceView.bottom +20);

}


/**
 打开关闭
 */
- (void)openBtnClick{
    
    _isOpen = !_isOpen;
    if (!_isOpen) {
        [UIView animateWithDuration:0.1 animations:^{
            _openBtn.imageView.transform = CGAffineTransformMakeRotation(M_PI);
            _unView.hidden = YES;
            _unView.frame = CGRectMake(0, _ViewOriginY, ScreenWidth, _unHeight);
            _priceView.frame = CGRectMake(10, _ViewOriginY, ScreenWidth - 20, 210);
            self.bgScrollView.contentSize = CGSizeMake(10, _priceView.bottom +20);
        }];
        
        
        
    }
    else
    {
        [UIView animateWithDuration:0.1 animations:^{
            _openBtn.imageView.transform = CGAffineTransformIdentity;
            _unView.hidden = NO;
            _unView.frame = CGRectMake(0, _ViewOriginY, ScreenWidth, _unHeight);
            _priceView.frame = CGRectMake(10, _ViewOriginY + _unHeight +12 , ScreenWidth - 20, 210);
            self.bgScrollView.contentSize = CGSizeMake(10, _priceView.bottom +32);
        }];
    }
}

#pragma mark =========== 聊天
/**
 聊天
 */
- (void)chatBtnClick{
    NSDictionary *dic = @{@"sellerIds":_infoDic[@"purchasingNeed"][@"accountId"]};
    [RCTokenPL getRcsellersinfoWithdic:dic ReturnBlock:^(id returnValue) {
        NSArray *arr = returnValue[@"shopInfoList"];
        NSDictionary *dic = arr[0];
        xxxxViewController *chat =[[xxxxViewController alloc] init];
        //    //设置会话的类型，如单聊、讨论组、群聊、聊天室、客服、公众服务会话等
        chat.conversationType = ConversationType_PRIVATE;
        //    //设置会话的目标会话ID。（单聊、客服、公众服务会话为对方的ID，讨论组、群聊、聊天室为会话的ID）
        chat.targetId = [NSString stringWithFormat:@"%@", _infoDic[@"purchasingNeed"][@"accountId"]];
        //
        //    //设置聊天会话界面要显示的标题
        //    chat.title = dic[@"supplierInfo"];
        //
        if (NULL_TO_NIL(dic[@"shopName"]) ) {
            chat.title = dic[@"shopName"];
        }else{
            chat.title= dic[@"sellerInfo"];
            
        }
        //
        //    //显示聊天会话界面
        [self.navigationController pushViewController:chat animated:YES];
        
    } andErrorBlock:^(NSString *msg) {
        [self showTextHud:@"聊天对象获取失败"];
    }];
}



/**
   报价中
 */
- (void)acceptBtnClick{

    OfferViewController *deVc = [[OfferViewController alloc]init];
    deVc.needId = _infoDic[@"purchasingNeed"][@"id"];
    [self.navigationController pushViewController:deVc animated:YES];

}

/**
 已完成
 */
- (void)comBtnClick{

    
    


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
- (NSString *)returnTheTimeWithNum:(NSString *)numStr{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:@"YYYY-MM-dd"]; // （@"YYYY-MM-dd hh:mm:ss"）----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    
    [formatter setTimeZone:timeZone];
    
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[numStr integerValue]];
    
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    return confromTimespStr;
    
}

@end
