//
//  ThreeClassifyViewController.m
//  FyhNewProj
//
//  Created by yh f on 2017/5/8.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "ThreeClassifyViewController.h"
#import "SearchResultViewController.h"
#import "GoodsLvTwoModel.h"
#import "GoodsLvThreeModel.h"
#import "ThreeClassifyCell.h"
#import "GoodItemsNetModel.h"
@interface ThreeClassifyViewController ()<UITableViewDelegate,UITableViewDataSource,ThreeClassifyCellDelegate>

@property (nonatomic , strong) UITableView *catoryTbv;

@end

@implementation ThreeClassifyViewController{

    NSArray *_dataArr;
}
-(UITableView *)catoryTbv{
    if (!_catoryTbv) {
        _catoryTbv = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-TABBAR_HEIGHT) style:UITableViewStylePlain];
        _catoryTbv.delegate = self;
        _catoryTbv.dataSource = self;
        _catoryTbv.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    return _catoryTbv;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBarBackBtnWithImage:nil];
    self.navigationItem.title = _model.name;
    
    [self initDatas];
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)initDatas{
    NSArray *arr = _model.threeModelArr;
    _dataArr = [NSArray array];
    _dataArr = [self splitArray:arr withSubSize:4];
    
}

- (void)initUI{
    [self.view addSubview:self.catoryTbv];
    [self.catoryTbv reloadData];

}


#pragma mark ========== tableview

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArr.count + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 40;
    }else{
        return 120;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        static NSString *topcellid = @"topcellid";
        UITableViewCell *topcell = [tableView dequeueReusableCellWithIdentifier:topcellid];
        if (!topcell) {
            topcell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:topcellid  ];
            [self createLabelWith:UIColorFromRGB(BlackColorValue) Font:APPFONT(15) WithSuper:topcell.contentView Frame:CGRectMake(20, 0, 200, 40) Alignment:NSTextAlignmentLeft Text:_model.name];
            
        }
        return topcell;
    }else{
    static NSString *cellid = @"cellid";
        ThreeClassifyCell *cell = [[ThreeClassifyCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        NSArray *arr = _dataArr[indexPath.row - 1];
        cell.dataArr = arr;
        cell.delegate = self;
        return cell;
    }



}


/**
 选中按钮

 @param button button description
 @param cell cell description
 */
-(void)didselectedItemWithBtn:(YLButton *)button andcell:(ThreeClassifyCell *)cell{

    SearchResultViewController *seVc = [[SearchResultViewController alloc]init];
    seVc.searchStr = @"";
    seVc.netModel = [[GoodItemsNetModel alloc]init];
    seVc.netModel.sort = @"";
    GoodsLvThreeModel *model = cell.dataArr[button.tag - 30000];
    seVc.netModel.categoryId = model.categoryId;
    seVc.netModel.pageNum = 1;
    
    [self.navigationController pushViewController:seVc animated:YES];
    

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
- (NSArray *)splitArray: (NSArray *)array withSubSize : (int)subSize{
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
    
    return [arr copy];  
}

@end
