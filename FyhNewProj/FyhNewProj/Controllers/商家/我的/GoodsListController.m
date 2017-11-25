//
//  GoodsListController.m
//  FyhNewProj
//
//  Created by yh f on 2017/6/16.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "GoodsListController.h"
#import "IdeaCellModel.h"
#import "IdeaGoodsListCell.h"
#import "UnitModel.h"
#import "PublishGoodsPL.h"
#import "CompleteSpecificationModel.h"
#import "SpecificationModel.h"
#import <AVFoundation/AVFoundation.h>
#import "UpImagePL.h"
#import "BatchView.h"


@interface GoodsListController ()<UITableViewDelegate,UITableViewDataSource,IdeaGoodsListCellDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate,UINavigationControllerDelegate>

@property (nonatomic,strong)UITableView *goodsTabView;           //商品

@property (nonatomic,strong)BatchView *batcView;           //商品

@end

@implementation GoodsListController{

    BOOL _isopen;
    YLButton *btn;
    NSMutableArray *_kindArr;
    NSMutableArray *_useArr;
    UIImagePickerController *_imagePicker;
    BOOL                     _isChoiceCamera;
    UpImagePL               *_upImagePL;                     //上传图片

    IdeaCellModel *_setModel;
    
    NSString   *_editstatus;
    
}
-(UITableView *)goodsTabView{
    
    if (!_goodsTabView) {
        _goodsTabView = [[UITableView alloc] initWithFrame:CGRectMake(0, 30, ScreenWidth,ScreenHeight-64-30-56) style:UITableViewStylePlain];
        _goodsTabView.bounces = NO;
        _goodsTabView.delegate = self;
        _goodsTabView.dataSource = self;
        _goodsTabView.backgroundColor = UIColorFromRGB(LineColorValue);
        _goodsTabView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    return _goodsTabView;
    
}
-(BatchView *)batcView{
    if (!_batcView) {
        _batcView = [[BatchView alloc]init];
        [_batcView.sureBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return  _batcView;
}




- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBarBackBtnWithImage:nil];
    if (!_tabArr) {
        _tabArr = [NSMutableArray arrayWithCapacity:0];

    }
    self.title = @"商品列表";
    _kindArr = [NSMutableArray  arrayWithCapacity:0];
    _useArr = [NSMutableArray arrayWithCapacity:0];
    _upImagePL = [[UpImagePL alloc]init];
    [self initUI];
    [self loadDatas];
    [self createNavagationItem];
}


- (void)initUI{

    self.view.backgroundColor = UIColorFromRGB(LineColorValue);
    UIImageView *leftima = [[UIImageView alloc]init];
    leftima.image = [UIImage imageNamed:@"batchedit"];
    [self.view addSubview:leftima];
    leftima.frame = CGRectMake(20, 10, 14, 10);
    [self createLabelWith:UIColorFromRGB(BlackColorValue) Font:APPFONT(13) WithSuper:self.view Frame:CGRectMake(40, 0, 100, 30) Alignment:NSTextAlignmentLeft Text:@"批量设置"];
    
    UIButton *batchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    batchBtn.frame = CGRectMake(0, 0, ScreenWidth, 30);
    [self.view addSubview:batchBtn];
    [batchBtn addTarget:self action:@selector(batchBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.goodsTabView];
    
    SubBtn *boomBtn = [SubBtn buttonWithtitle:@"确认" titlecolor:UIColorFromRGB(WhiteColorValue) cornerRadius:5 andtarget:self action:@selector(boomBtnClick) andframe:CGRectMake(20, ScreenHeight - 64-48, ScreenWidth - 40, 40)];
    [self.view addSubview:boomBtn];
    
    
}
- (void)createNavagationItem
{
    btn = [YLButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"删除" forState:UIControlStateNormal];
    btn.titleLabel.font = APPFONT(15);
    [btn setTitleColor:UIColorFromRGB(WhiteColorValue) forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(deleteGoods) forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(0, 0, 40, 40);
    UIBarButtonItem * choiceCityBtn = [[UIBarButtonItem alloc] initWithCustomView:btn];

    self.navigationItem.rightBarButtonItem = choiceCityBtn;
}





- (void)loadDatas{
    
    if (_tabArr.count>0) {
        for (int i = 0; i<_dataArr.count; i++) {
            NSArray *arr = _dataArr[i];
            UnitModel * famodel0 =arr[0];
            UnitModel * famodel1 =arr[1];
            if (![_kindArr containsObject:famodel0.name]) {
                [_kindArr addObject:famodel0.name];
            }
            if (![_useArr containsObject:famodel1.name]) {
                [_useArr addObject:famodel1.name];
            }
        }
        
    }else{
        for (int i = 0; i<_dataArr.count; i++) {
            NSArray *arr = _dataArr[i];
            IdeaCellModel *model = [[IdeaCellModel alloc]init];
            model.image = _imageArr[0];
            
            UnitModel * famodel0 =arr[0];
            model.kind = famodel0.name;
            
            UnitModel * famodel1 =arr[1];
            model.use = famodel1.name;
            model.mainImageUrl = @"";
            model.stock = -1;
            model.price = @"-1";
            [_tabArr addObject:model];
            if (![_kindArr containsObject:famodel0.name]) {
                [_kindArr addObject:famodel0.name];
            }
            if (![_useArr containsObject:famodel1.name]) {
                [_useArr addObject:famodel1.name];
            }
        }
    }

    [self.goodsTabView reloadData];

}

/**
 删除按钮
 */
- (void)deleteGoods{
    
    _isopen = !_isopen;
    if (_isopen) {
        for (IdeaCellModel *model in _tabArr) {
            model.isopen = YES;
        }
        [btn setTitle:@"完成" forState:UIControlStateNormal];

    }else{
        for (IdeaCellModel *model in _tabArr) {
            model.isopen = NO;
        }
        [btn setTitle:@"删除" forState:UIControlStateNormal];
        NSMutableArray *removeArr = [_tabArr mutableCopy];
        for (IdeaCellModel *model  in removeArr) {
            if (model.select) {
                [_tabArr removeObject:model];
            }
        }
        
    }
    [self.goodsTabView reloadData];



}

/**
 是否编辑完成

 @return return value description
 */
- (BOOL)isAllGoodsEditComplete{

       for (int i = 0; i<_tabArr.count; i++) {
                IdeaCellModel *model = _tabArr[i];
                if (model.stock <0 ||[model.price integerValue]<0) {
                    _editstatus = @"1";
                    return NO;
                }
            }
    _editstatus = @"2";
    return YES;
}


- (void)saveGoods{

    [self.view endEditing:YES];
    NSString *kindStr = [_kindArr componentsJoinedByString:@","];
    NSString *useStr = [_useArr componentsJoinedByString:@","];
    
    NSDictionary *infoDic = @{@"specificationName":@"类型",
                              @"specificationValues":kindStr,
                              @"memo":@"",
                              };
    NSDictionary *infoDic1 = @{@"specificationName":@"状态",
                               @"specificationValues":useStr,
                               @"memo":@"",
                               };
    NSArray *infoArr = @[[self dictionaryToJson:infoDic],[self dictionaryToJson:infoDic1]];
    NSDictionary *setDic = @{@"completeSpecificationList":[NSString stringWithFormat:@"[%@,%@]",infoArr[0],infoArr[1]]};
    [PublishGoodsPL batchspecificationWithInfoDic:setDic ReturnBlock:^(id returnValue) {
        NSLog(@"%@",returnValue);
        NSDictionary *AllDic = returnValue[@"data"];
        NSArray *completeSpecificationList = AllDic[@"completeSpecificationList"];
        NSArray *arr = [CompleteSpecificationModel  mj_objectArrayWithKeyValuesArray:completeSpecificationList];
        NSLog(@"%@",arr);
        NSMutableArray *specificationValueIds = [NSMutableArray arrayWithCapacity:0];
        CompleteSpecificationModel *model0 = arr[0];
        CompleteSpecificationModel *model1 = arr[1];
        
        for (int i = 0; i<_tabArr.count; i++) {
            IdeaCellModel *model = _tabArr[i];
            NSString *kindId = @"";
            NSString *useId = @"";
            for (SpecificationModel *specificatioModel in model0.specificationValueList) {
                if ([model.kind isEqualToString:specificatioModel.name]) {
                    kindId = specificatioModel.kindId;
                }
            }
            for (SpecificationModel *specificatioModel in model1.specificationValueList) {
                if ([model.use isEqualToString:specificatioModel.name]) {
                    useId = specificatioModel.kindId;
                }
            }
            NSDictionary *goodDic = @{@"specificationValueIds":[NSString stringWithFormat:@"%@,%@",kindId,useId],
                                      @"price":model.price,
                                      @"stock":[NSString stringWithFormat:@"%ld",model.stock],
                                      @"minBuyQuantity":@"",
                                      @"limitUserTotalBuyQuantity":@"",
                                      @"mainImageUrl":model.mainImageUrl
                                      };
            [specificationValueIds addObject:[self dictionaryToJson:goodDic]];
            
        }
        NSString *goodStr = [specificationValueIds componentsJoinedByString:@","];
        NSString *specificationIds = [NSString stringWithFormat:@"%@,%@",model0.specification.kindId,model1.specification.kindId];
        NSDictionary *returndic = @{@"goodStr":goodStr,
                                    @"specificationIds":specificationIds,
                                    @"listArr":_tabArr,
                                    @"edit":_editstatus
                                    };
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UserHavesetupGoodsList" object:returndic];
        
        
        [self.navigationController  popViewControllerAnimated:YES];
        
    } andErrorBlock:^(NSString *msg) {
        [self showTextHud:msg];
    }];

}

/**
 返回
 */
-(void)respondToLeftButtonClickEvent{
    if ([self isAllGoodsEditComplete]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否保存已编辑的内容" preferredStyle:UIAlertControllerStyleAlert];
        [alert  addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self saveGoods];
            }]];
        [alert  addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [self presentViewController:alert animated:YES completion:nil];
        

    }else{
    
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"还未完成所有商品编辑" preferredStyle:UIAlertControllerStyleAlert];
        [alert  addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self saveGoods];
            
        }]];
        [alert  addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [self presentViewController:alert animated:YES completion:nil];

    }

    
    
    
    
}




/**
 批量编辑
 */
- (void)batchBtnClick{
    self.batcView.type = 0;
    [self.batcView showinView:self.view];

}

/**
 底部确定按钮
 */
- (void)boomBtnClick{

        for (int i = 0; i<_tabArr.count; i++) {
            IdeaCellModel *model = _tabArr[i];
            if (model.stock <0 ||[model.price floatValue]<0) {
                [self showTextHud:[NSString stringWithFormat:@"第%d行商品数据未填写完整",i+1]];
                return;
            }
        }
    _editstatus = @"2";
    [self saveGoods];

}


/**
 确定
 */
- (void)sureBtnClick{

    for (IdeaCellModel *model in _tabArr) {
        if (self.batcView.stocktxt.text.length >0) {
            model.stock = [self.batcView.stocktxt.text integerValue];
        }
        
        if (self.batcView.pricetxt.text.length >0) {
            model.price = self.batcView.pricetxt.text;
        }
    }
    [self.batcView dismiss];
    [_goodsTabView reloadData];
    
}



//词典转换为字符串
- (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}





-(void)didSelectedUpImagedBtnWithModel:(IdeaCellModel *)model{

    _setModel = model;
    [self chosePhoto];
}




-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return _tabArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 112;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *cellid = @"cellid";
    IdeaGoodsListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[IdeaGoodsListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    
    }
    cell.delegate = self;
    cell.model = _tabArr[indexPath.row];
    if (cell.model.mainImageUrl.length >0   ) {
[cell.faceImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",cell.model.cndUrl,cell.model.mainImageUrl]] placeholderImage:[UIImage imageNamed:@"loding"]];
    }
    return cell;

}
#pragma mark  ================  选取照片

- (void)chosePhoto{
    if (!_imagePicker) {
        _imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker.allowsEditing = YES;
        
        _imagePicker.delegate = self;
    }
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"拍照", @"从相册选取",nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
    
}
#pragma mark--------------------------------UIActionDelegate--------------------------------
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        return;
    }
    switch (buttonIndex) {
        case 0:
            // Take a photo directly!
            [self pickImageFromCamera];
            break;
        case 1:
            // Pick one from library.
            [self pickImageFromAlbum];
            break;
        default:
            break;
    }
}

#pragma mark 从摄像头获取活动图片
- (void)pickImageFromCamera
{
    _isChoiceCamera = YES;
    _imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    _imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    if (iPad) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self presentViewController:_imagePicker animated:YES completion:nil];
        }];
    }else{
        
        [self presentViewController:_imagePicker animated:YES completion:nil];
    }
}
#pragma mark 从用户相册获取活动图片
- (void)pickImageFromAlbum
{
    _isChoiceCamera= NO;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    _imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    _imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    if (iPad) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self presentViewController:_imagePicker animated:YES completion:nil];
        }];
    }else{
        
        [self presentViewController:_imagePicker animated:YES completion:nil];
    }
}

#pragma imagePicekr
//点击相册中的图片or照相机照完后点击use  后触发的方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    if (!image) {
        return;
    }
    __weak __typeof(self)weakSelf = self;
    
    [_upImagePL updateImg:image WithReturnBlock:^(id returnValue) {
        NSDictionary *imageDic = returnValue;
        NSArray *arr = imageDic[@"imageUrls"];
        if (arr.count<=0) {
            return ;
        }
        _setModel .mainImageUrl = arr[0];
        _setModel.cndUrl = imageDic[@"cdnUrl"];
        _setModel.image = image;
        [_goodsTabView reloadData];
    
    } withErrorBlock:^(NSString *msg) {
        [weakSelf showTextHud:msg];
    }];
    
    
    
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}


@end
