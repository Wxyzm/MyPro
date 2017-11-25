//
//  MyBuyListViewController.m
//  FyhNewProj
//
//  Created by yh f on 2017/7/24.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "MyBuyListViewController.h"
#import "PublicWantPL.h"
#import "xxxxViewController.h"
@interface MyBuyListViewController ()<UIScrollViewDelegate>

@property (strong,nonatomic)UIPageControl *pagecontrol;//分页控制控件对象

@property (nonatomic , strong) UIScrollView *bgScrollView;

@end

@implementation MyBuyListViewController{

    NSMutableArray *_dataArr;
    NSInteger       _currpage;
}

-(UIScrollView *)bgScrollView{
    if (!_bgScrollView) {
        _bgScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight )];
        _bgScrollView.backgroundColor = UIColorFromRGB(LineColorValue);
        _bgScrollView.pagingEnabled = YES;
        _bgScrollView.delegate = self;
    }
    return _bgScrollView;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBarBackBtnWithImage:nil];
    self.title = @"商家报价单";
    [self initUI];
    
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)initUI{

    _dataArr = [self splitArray:_listArr withSubSize:4];
    NSLog(@"%@",_dataArr);
    [self.view addSubview:self.bgScrollView];
    for (int i = 0; i<_dataArr.count; i++) {
        NSArray *arr = _dataArr[i];
        for (int j = 0 ; j< arr.count; j++) {
            NSDictionary *priceDic = arr[j];
            
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(23 +ScreenWidth *i, 10+120 *j, ScreenWidth - 46, 110)];
            [self.bgScrollView addSubview:imageView];
            imageView.image = [UIImage imageNamed:@"block"];
            imageView.userInteractionEnabled = YES;
            
            UILabel *nameLab = [BaseViewFactory labelWithFrame:CGRectMake(25, 11, imageView.width, 12) textColor:UIColorFromRGB(BlackColorValue) font:APPFONT(12) textAligment:NSTextAlignmentLeft andtext:[NSString stringWithFormat:@"用户：%@",priceDic[@"supplierInfo"]]];
            [imageView addSubview:nameLab];
            [self createLineWithColor:UIColorFromRGB(LineColorValue) frame:CGRectMake(25, 30, imageView.width - 115, 1) Super:imageView];
            
            UILabel *memoLab = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(BlackColorValue) font:APPFONT(12) textAligment:NSTextAlignmentLeft andtext:[NSString stringWithFormat:@"备注：%@",priceDic[@"memo"]]];
            [imageView addSubview:memoLab];
            memoLab.sd_layout.leftEqualToView(nameLab).topSpaceToView(imageView,36).widthIs(imageView.width - 115).autoHeightRatio(0);
            [memoLab setMaxNumberOfLinesToShow:2];
            
            SubBtn *rightBtn = [SubBtn buttonWithtitle:priceDic[@"price"] titlecolor:UIColorFromRGB(WhiteColorValue) cornerRadius:25 andtarget:nil action:nil andframe:CGRectMake(imageView.width - 70, 30, 50, 50)];
            rightBtn.titleLabel.font = APPFONT(12);
            [imageView addSubview:rightBtn];
            
            [self createLabelWith:UIColorFromRGB(WhiteColorValue) Font:APPFONT(10) WithSuper:rightBtn Frame:CGRectMake(0, 32, 50, 14) Alignment:NSTextAlignmentCenter Text:[NSString stringWithFormat:@"元/%@",_unitStr?_unitStr:@""]];
            
            
            SubBtn *chatBtn = [SubBtn buttonWithtitle:@"洽谈" backgroundColor:UIColorFromRGB(0x9ac2fa) titlecolor:UIColorFromRGB(WhiteColorValue) cornerRadius:12 andtarget:self action:@selector(chatBtnClick:)];
            chatBtn.titleLabel.font = APPFONT(11);
            chatBtn.frame = CGRectMake(44, 77, 60, 24);
            [imageView addSubview:chatBtn];
            chatBtn.tag = 2000+j;
            SubBtn *acceptBtn;
            switch ([priceDic[@"status"] intValue]) {
                case 1:{
                    acceptBtn  = [SubBtn buttonWithtitle:@"接受报价" titlecolor:UIColorFromRGB(WhiteColorValue) cornerRadius:12 andtarget:self action:@selector(acceptBtnClick:) andframe: CGRectMake(chatBtn.right + 44, 77, 60, 24)];
                    break;
                }
                case 2:{
                    acceptBtn  = [SubBtn buttonWithtitle:@"已接受" backgroundColor:UIColorFromRGB(PlaColorValue) titlecolor:UIColorFromRGB(WhiteColorValue) cornerRadius:12 andtarget:self action:@selector(acceptBtnClick:)];
                    break;
                }
                case 3:{
                    acceptBtn  = [SubBtn buttonWithtitle:@"接受报价" titlecolor:UIColorFromRGB(WhiteColorValue) cornerRadius:12 andtarget:self action:@selector(acceptBtnClick:) andframe: CGRectMake(chatBtn.right + 44, 77, 60, 24)];
                    break;
                      }
                default:
                    break;
            }
            acceptBtn.tag = 1000+j;
            
            acceptBtn.titleLabel.font = APPFONT(11);
            acceptBtn.frame = CGRectMake(chatBtn.right + 44, 77, 60, 24);
            [imageView addSubview:acceptBtn];

            
            
        }
    }
    self.bgScrollView.contentSize  = CGSizeMake(ScreenWidth *_dataArr.count, 500);

    
    //创建初始化并设置PageControl
         self.pagecontrol = [[UIPageControl alloc]initWithFrame:CGRectMake(0,ScreenHeight - 120, ScreenWidth, 50)];
         self.pagecontrol.center = CGPointMake(ScreenWidth/2, ScreenHeight - 120);
         self.pagecontrol.numberOfPages = _dataArr.count; //因为有5张图片，所以设置分页数为5
         self.pagecontrol.currentPage  = 0; //默认第一页页数为0
         //设置分页控制点颜色
         self.pagecontrol.pageIndicatorTintColor = [UIColor lightGrayColor];//未选中的颜色
         self.pagecontrol.currentPageIndicatorTintColor = [UIColor whiteColor];//选中时的颜色
         //添加分页控制事件用来分页
       //  [self.pagecontrol addTarget:self action:@selector(pageControlChanged:) forControlEvents:UIControlEventValueChanged];
         //将分页控制视图添加到视图控制器视图中
         [self.view addSubview:self.pagecontrol];
    _currpage = 0;
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setImage:[UIImage imageNamed:@"right_next_big"] forState:UIControlStateNormal];
    [self.view addSubview:leftBtn];
    leftBtn.center = CGPointMake(30, (ScreenHeight -64)/2 - 50);
    leftBtn.bounds  = CGRectMake(0, 0, 44, 44);
    [leftBtn addTarget:self action:@selector(leftBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setImage:[UIImage imageNamed:@"left_next_big"] forState:UIControlStateNormal];
    [self.view addSubview:rightBtn];
    rightBtn.center = CGPointMake(ScreenWidth - 30, (ScreenHeight -64)/2 - 50);
    rightBtn.bounds  = CGRectMake(0, 0, 44, 44);
    [rightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];

}



#pragma mark -- 将数组拆分成固定长度

/**
 *  将数组拆分成固定长度的子数组
 *
 *  @param array 需要拆分的数组
 *
 *  @param subSize 指定长度
 *
 */
- (NSMutableArray *)splitArray: (NSArray *)array withSubSize : (int)subSize{
    //  数组将被拆分成指定长度数组的个数
    unsigned long count = array.count % subSize == 0 ? (array.count / subSize) : (array.count / subSize + 1);
    //  用来保存指定长度数组的可变数组对象
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    
    //利用总个数进行循环，将指定长度的元素加入数组
    for (int i = 0; i < count; i ++) {
        //数组下标
        int index = i * subSize;
        //保存拆分的固定长度的数组元素的可变数组
        NSMutableArray *arr1 = [[NSMutableArray alloc] init];
        //移除子数组的所有元素
        [arr1 removeAllObjects];
        
        int j = index;
        //将数组下标乘以1、2、3，得到拆分时数组的最大下标值，但最大不能超过数组的总大小
        while (j < subSize*(i + 1) && j < array.count) {
            [arr1 addObject:[array objectAtIndex:j]];
            j += 1;
        }
        //将子数组添加到保存子数组的数组中
        [arr addObject:[arr1 copy]];
    }
    
    return [arr mutableCopy];
}

#pragma mark - scrollView的代理方法
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
   //计算pagecontroll相应地页(滚动视图可以滚动的总宽度/单个滚动视图的宽度=滚动视图的页数)
    NSInteger currentPage = (int)(scrollView.contentOffset.x) / (int)(self.view.frame.size.width);
    _currpage = currentPage;
     self.pagecontrol.currentPage = currentPage;//将上述的滚动视图页数重新赋给当前视图页数,进行分页
}


- (void)leftBtnClick{
    NSInteger currentPage = (int)(self.bgScrollView.contentOffset.x) / (int)(self.view.frame.size.width);
    if (currentPage<=0) {
        return;
    }
    currentPage --;
    [self.bgScrollView setContentOffset:CGPointMake(ScreenWidth *currentPage, 0) animated:YES];

}


- (void)rightBtnClick{
    NSInteger currentPage = (int)(self.bgScrollView.contentOffset.x) / (int)(self.view.frame.size.width);
    if (currentPage >= _dataArr.count-1) {
        return;
    }
    currentPage ++;
    [self.bgScrollView setContentOffset:CGPointMake(ScreenWidth *currentPage, 0) animated:YES];


}


/**
 接受报价
 
 @param btn btn
 */
- (void)acceptBtnClick:(SubBtn *)btn{
    
    NSMutableArray *arr = _dataArr[_currpage];
    NSDictionary *dic = arr[btn.tag - 1000];
    
    switch ([dic[@"status"] intValue]) {
        case 1:{
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定接受商家报价？" preferredStyle:UIAlertControllerStyleAlert];
            [alert  addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [PublicWantPL UserAcceptNeedwithPricewithId:dic[@"id"] WithReturnBlock:^(id returnValue) {
                    [self showTextHud:@"您已成功接受商家报价"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"HaveReceivePrice" object:nil userInfo:nil];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"userNeedsHaveChanged" object:nil userInfo:nil];
                    [self.navigationController popViewControllerAnimated:YES];

                } andErrorBlock:^(NSString *msg) {
                    [self showTextHud:msg];
                }];
                
            }]];
            [alert  addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                
            }]];
            [self presentViewController:alert animated:YES completion:nil];
            break;
        }
        case 2:{
            break;
        }
        case 3:{
            break;
        }
        default:
            break;
    }

    
    
    
}

- (void)chatBtnClick:(SubBtn *)btn{
    NSMutableArray *arr = _dataArr[_currpage];
    NSDictionary *dic = arr[btn.tag - 2000];
    
    NSString * status;
    if ([_infoDic[@"status"] intValue] == 1) {
        status = @"状态:审核中";
    }else if ([_infoDic[@"status"] intValue] == 3){
        status = @"状态:审核未通过";
    }else if ([_infoDic[@"status"] intValue] == 4){
        status = @"状态:进行中";
    }else if ([_infoDic[@"status"] intValue] == 6){
        status = @"状态:报价中";
    }else if ([_infoDic[@"status"] intValue] ==9 ){
        status = @"状态:已完成";
    }
    
    xxxxViewController *chat =[[xxxxViewController alloc] init];
    //    //设置会话的类型，如单聊、讨论组、群聊、聊天室、客服、公众服务会话等
    chat.conversationType = ConversationType_PRIVATE;
    //    //设置会话的目标会话ID。（单聊、客服、公众服务会话为对方的ID，讨论组、群聊、聊天室为会话的ID）
    chat.targetId = [NSString stringWithFormat:@"%@",dic[@"accountId"]];
    //
    //    //设置聊天会话界面要显示的标题
    chat.title = dic[@"supplierInfo"];
    chat.infoDic = @{@"title":_infoDic[@"title"],
                     @"proId":_infoDic[@"id"],
                     @"imageUrl":_infoDic[@"imageUrlList"][0],
                     @"type":@"quote",
                     @"content":[NSString stringWithFormat:@"%@ 分类:%@",status,_infoDic[@"categoryName"]],
                     @"price":@""
                     };
    //
    //
    //    //显示聊天会话界面
    [self.navigationController pushViewController:chat animated:YES];


}

@end
