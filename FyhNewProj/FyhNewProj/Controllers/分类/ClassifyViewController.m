//
//  ClassifyViewController.m
//  FyhNewProj
//
//  Created by yh f on 2017/3/4.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "ClassifyViewController.h"
#import "PrintQrcodeViewController.h"
#import "MemberLoginController.h"
//二维码扫描
#import "SubLBXScanViewController.h"
//#import "MyQRViewController.h"
#import "LBXScanView.h"
#import <objc/message.h>
#import "ScanResultViewController.h"
#import "LBXScanResult.h"
#import "LBXScanWrapper.h"
#import "SideView.h"
#import "ClassifyCell.h"

#import "GoodsPL.h"
#import "GoodsLVOneModel.h"
#import "GoodsLvTwoModel.h"
#import "GoodsLvThreeModel.h"
#import "ThreeClassifyViewController.h"
#import "SearchResultViewController.h"
#import "GoodItemsNetModel.h"

@interface ClassifyViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate,UINavigationControllerDelegate,ComplainCellDelegate,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,ClassifyCellDelegate>

@property (nonatomic, strong) SideView    *sideView;

@property (nonatomic , strong) UITableView *BuyersTbv;

@end

@implementation ClassifyViewController{
    YLButton        *_typeBtn;
    UITextField     *_searchTF;
    NSMutableArray  *_lvOneArr;
    NSMutableArray  *_lvTwoArr;
    NSMutableArray  *_lvThreeArr;
    
    NSMutableArray *_dataArr;

}

-(UITableView *)BuyersTbv{
    if (!_BuyersTbv) {
        _BuyersTbv = [[UITableView alloc]initWithFrame:CGRectMake(0, 80, ScreenWidth, ScreenHeight-80-TABBAR_HEIGHT) style:UITableViewStylePlain];
        _BuyersTbv.delegate = self;
        _BuyersTbv.dataSource = self;
        _BuyersTbv.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    return _BuyersTbv;
}


#pragma mark   ======= 页面 周期
- (void)viewDidLoad {
    [super viewDidLoad];
    self.sideView.baseVC = self;
    self.sideView.delegate = self;
    self.navigationController.delegate =self;
    _lvOneArr = [NSMutableArray array];
    _lvTwoArr = [NSMutableArray array];
    _lvThreeArr = [NSMutableArray array];
    _dataArr = [NSMutableArray arrayWithCapacity:0];
    [self setupUI];
    [self loadDatas];
}

-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    [viewController viewWillAppear:animated];
        if ([[viewController class] isEqual:[ClassifyViewController class]]) {
            self.navigationController.navigationBar.hidden = YES;

        }
}

-(void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    [viewController viewDidAppear:animated];
    if ([[viewController class] isEqual:[ClassifyViewController class]]) {
        self.navigationController.navigationBar.hidden = YES;

        
    }

}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
     [self.sideView dismiss];
    
}


#pragma mark ========= 侧滑抽屉

- (SideView *)sideView
{
    if (!_sideView) {
        _sideView = [SideView new];
    }
    return _sideView;
}

- (void)showSideView
{
    [self.sideView show];
}


#pragma mark ========= 界面

- (void)setupUI{

    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 80)];
    [self.view addSubview:topView];
    //  创建 CAGradientLayer 对象
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    //  设置 gradientLayer 的 Frame
    gradientLayer.frame = topView.bounds;
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
    [topView.layer addSublayer:gradientLayer];

    _typeBtn = [YLButton buttonWithType:UIButtonTypeCustom];
    [topView addSubview:_typeBtn];
    _typeBtn.frame = CGRectMake(0, 20, 120, 60);
    _typeBtn.titleLabel.font = APPFONT(15);
    [_typeBtn setTitle:@"" forState:UIControlStateNormal];
    [_typeBtn setTitleColor:UIColorFromRGB(WhiteColorValue) forState:UIControlStateNormal];
    [_typeBtn setImage:[UIImage imageNamed:@"btn-white"] forState:UIControlStateNormal];
    [_typeBtn setImageRect:CGRectMake(20, 25, 16, 11)];
    [_typeBtn setTitleRect:CGRectMake(41, 0, 79, 60)];
    [_typeBtn addTarget:self  action:@selector(typeBtnclick) forControlEvents:UIControlEventTouchUpInside];
    
    
    CGFloat searchViewWidth = ScreenWidth-140;
    UIView *searchView = [[UIView alloc]initWithFrame:CGRectMake(120, 30, searchViewWidth, 40)];
    searchView.layer.cornerRadius = 5;
    searchView.backgroundColor = UIColorFromRGB(WhiteColorValue);
    searchView.clipsToBounds = YES;
    [topView addSubview:searchView];
    
    UIButton *searchImageBtn = [BaseViewFactory buttonWithWidth:25 imagePath:@"search"];
    [searchView addSubview:searchImageBtn];
    searchImageBtn.frame = CGRectMake(10, 7.5, 25, 25);
    
    UIButton *camBtn = [BaseViewFactory buttonWithWidth:25 imagePath:@"camera"];
    [searchView addSubview:camBtn];
    camBtn.frame = CGRectMake(searchViewWidth - 35, 10.5, 25, 19);

    _searchTF = [BaseViewFactory textFieldWithFrame:CGRectMake(45, 0, searchViewWidth - 90, 40) font:APPFONT(15) placeholder:@"寻找感兴趣的商品" textColor:UIColorFromRGB(BlackColorValue) placeholderColor:UIColorFromRGB(PlaColorValue) delegate:self];
    _searchTF.returnKeyType =UIReturnKeyDone;
    [searchView addSubview:_searchTF];
    
    [self.view addSubview:self.BuyersTbv];
    
}


- (BOOL)textFieldShouldReturn:(UITextField *)aTextfield {
    
    if (_searchTF.text.length>0) {
        SearchResultViewController *resultVc = [[SearchResultViewController alloc]init];
        resultVc.searchStr = _searchTF.text;
        [self.navigationController pushViewController:resultVc animated:YES];
    }
     [aTextfield resignFirstResponder];//关闭键盘
    return YES;
}


- (void )loadDatas{
    [GoodsPL getGoodsCategorywithReturnBlock:^(id returnValue) {
        NSDictionary *dic = returnValue;
        NSLog(@"%@",dic);
        NSDictionary *lvDic = dic[@"data"];
        NSArray *lvArr = lvDic[@"leveledCategoryList"];
//        return ;
        _lvOneArr = [GoodsLVOneModel mj_objectArrayWithKeyValuesArray:lvArr[0]];
        _lvTwoArr = [GoodsLvTwoModel mj_objectArrayWithKeyValuesArray:lvArr[1]];
        for (GoodsLvTwoModel *model in _lvTwoArr) {
            model.threeModelArr = [[NSMutableArray alloc]initWithCapacity:0];
        }
        _lvThreeArr  = [GoodsLvThreeModel mj_objectArrayWithKeyValuesArray:lvArr[2]];
        self.sideView.dataArr = _lvOneArr;
        
        [_dataArr removeAllObjects];
        GoodsLVOneModel *model = _lvOneArr[0];
       
        [_typeBtn setTitle:[model.name substringToIndex:2] forState:UIControlStateNormal];

        for (GoodsLvTwoModel *twoModel in _lvTwoArr) {
            if ([twoModel.parentId isEqualToString:model.categoryId]) {
                [twoModel.threeModelArr removeAllObjects];
                [_dataArr addObject:twoModel];
            }
        }
        
        for (GoodsLvTwoModel *twoModel in _dataArr) {
            for (GoodsLvThreeModel *threeModel in _lvThreeArr) {
                if ([threeModel.parentId isEqualToString:twoModel.categoryId]) {
                    [twoModel.threeModelArr addObject:threeModel];
                }
            }
        }
        
        NSLog(@"%@",_dataArr);
        [self.BuyersTbv reloadData];

        
    } andErrorBlock:^(NSString *msg) {
        [self showTextHud:msg];
    }];
}


#pragma mark ======= 打开分类

- (void)typeBtnclick{

    [self.sideView show];

    
}


#pragma mark ======= 点击主分类

- (void)didselectedRowWithModel:(GoodsLVOneModel *)model{

    [_typeBtn setTitle:[model.name substringToIndex:2] forState:UIControlStateNormal];
    [self.sideView dismiss];
    
    
    NSLog(@"%@",model);
    [_dataArr removeAllObjects];
    for (GoodsLvTwoModel *twoModel in _lvTwoArr) {
        if ([twoModel.parentId isEqualToString:model.categoryId]) {
            [twoModel.threeModelArr removeAllObjects];
            [_dataArr addObject:twoModel];
        }
    }
    
    for (GoodsLvTwoModel *twoModel in _dataArr) {
        for (GoodsLvThreeModel *threeModel in _lvThreeArr) {
            if ([threeModel.parentId isEqualToString:twoModel.categoryId]) {
                [twoModel.threeModelArr addObject:threeModel];
            }
        }
    }

    NSLog(@"%@",_dataArr);
    [self.BuyersTbv reloadData];
    



}


#pragma mark ======= tableviewdelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    //return 20;
    return _dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    CGFloat imageWidth = (ScreenWidth - 50)/4;

    return 91+imageWidth;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static   NSString *cellid = @"cellid";
    
    ClassifyCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[ClassifyCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    cell.delegate = self;
    GoodsLvTwoModel *model = _dataArr[indexPath.row];
    cell.goodModel = model;
    return cell;

}



#pragma mark ======= ClassifyCellDelegate


-(void)didselectedItemWithBtn:(YLButton *)button andcell:(ClassifyCell *)cell{
    
    
    NSArray *threeArr = cell.goodModel.threeModelArr;
    
    SearchResultViewController *seVc = [[SearchResultViewController alloc]init];
    seVc.searchStr = @"";
    seVc.netModel = [[GoodItemsNetModel alloc]init];
    seVc.netModel.sort = @"";
  //  seVc.netModel.categoryId = ;
    GoodsLvThreeModel *model = threeArr[button.tag - 10000];
    seVc.netModel.categoryId = model.categoryId;
    seVc.netModel.pageNum = 1;

//    switch (button.tag - 10000) {
//        case 0:{
//            
//            break;
//        }
//        case 1:{
//            
//            break;
//        }
//        case 2:{
//            
//            break;
//        }
//        case 3:{
//            
//            break;
//        }
//        default:
//            break;
//    }

    [self.navigationController pushViewController:seVc animated:YES];

}

- (void)didselectedMoreBtnwithcell:(ClassifyCell *)cell{

    ThreeClassifyViewController *clVc = [[ThreeClassifyViewController alloc]init];
    clVc.model = cell.goodModel;
    [self.navigationController pushViewController:clVc animated:YES];

}





#pragma mark - 扫码模仿qq界面
- (void)qqStyle
{
    //设置扫码区域参数设置
    
    //创建参数对象
    LBXScanViewStyle *style = [[LBXScanViewStyle alloc]init];
    
    //矩形区域中心上移，默认中心点为屏幕中心点
    style.centerUpOffset = 44;
    
    //扫码框周围4个角的类型,设置为外挂式
    style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle_Outer;
    
    //扫码框周围4个角绘制的线条宽度
    style.photoframeLineW = 6;
    
    //扫码框周围4个角的宽度
    style.photoframeAngleW = 24;
    
    //扫码框周围4个角的高度
    style.photoframeAngleH = 24;
    
    //扫码框内 动画类型 --线条上下移动
    style.anmiationStyle = LBXScanViewAnimationStyle_LineMove;
    
    //线条上下移动图片
    style.animationImage = [UIImage imageNamed:@"qrcode_scan_light_green"];
    
    //SubLBXScanViewController继承自LBXScanViewController
    //添加一些扫码或相册结果处理
    SubLBXScanViewController *vc = [SubLBXScanViewController new];
    vc.style = style;
    
    vc.isQQSimulator = YES;
    vc.isVideoZoom = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 判断照相机权限
 
 @return 是否
 */
- (BOOL)cameraPemission
{
    
    BOOL isHavePemission = NO;
    if ([AVCaptureDevice respondsToSelector:@selector(authorizationStatusForMediaType:)])
    {
        AVAuthorizationStatus permission =
        [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        
        switch (permission) {
            case AVAuthorizationStatusAuthorized:
                isHavePemission = YES;
                break;
            case AVAuthorizationStatusDenied:
            case AVAuthorizationStatusRestricted:
                break;
            case AVAuthorizationStatusNotDetermined:
                isHavePemission = YES;
                break;
        }
    }
    
    return isHavePemission;
}






@end
