//
//  AccessGoodsListController.m
//  FyhNewProj
//
//  Created by yh f on 2017/6/20.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "AccessGoodsListController.h"
#import "AccessCellModel.h"
#import "AccessListCell.h"
#import "UnitModel.h"
#import "PublishGoodsPL.h"
#import "CompleteSpecificationModel.h"
#import "SpecificationModel.h"
#import <AVFoundation/AVFoundation.h>
#import "UpImagePL.h"
#import "BatchView.h"


@interface AccessGoodsListController ()<UITableViewDelegate,UITableViewDataSource,AccessListCellDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate,UINavigationControllerDelegate>

@property (nonatomic,strong)UITableView *goodsTabView;           //商品

@property (nonatomic,strong)BatchView *batcView;           //商品

@end


@implementation AccessGoodsListController{
    
    NSMutableArray *_tabArr;
    BOOL _isopen;
    YLButton *btn;
    NSMutableArray *_kindArr;
    NSMutableArray *_colorArr;
    NSMutableArray *_stateArr;
    UIImagePickerController *_imagePicker;
    BOOL                     _isChoiceCamera;
    UpImagePL               *_upImagePL;                     //上传图片
    
    AccessCellModel *_setModel;
    NSString   *_editstatus;

}

-(BatchView *)batcView{
    if (!_batcView) {
        _batcView = [[BatchView alloc]init];
        [_batcView.sureBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];

    }
    
    return  _batcView;
}

-(UITableView *)goodsTabView{
    
    if (!_goodsTabView) {
        _goodsTabView = [[UITableView alloc] initWithFrame:CGRectMake(0, 30, ScreenWidth,ScreenHeight-64-30-56) style:UITableViewStylePlain];
        _goodsTabView.bounces = NO;
        _goodsTabView.delegate = self;
        _goodsTabView.dataSource = self;
        _goodsTabView.backgroundColor = UIColorFromRGB(WhiteColorValue);
        _goodsTabView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    return _goodsTabView;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBarBackBtnWithImage:nil];
    if (!_tabArr) {
        _tabArr = [NSMutableArray arrayWithCapacity:0];

    }
    self.title = @"商品列表";
    _kindArr = [NSMutableArray  arrayWithCapacity:0];
    _stateArr = [NSMutableArray arrayWithCapacity:0];
    _upImagePL = [[UpImagePL alloc]init];
    _colorArr = [NSMutableArray arrayWithCapacity:0];
    [self initUI];
    [self loadDatas];
    [self createNavagationItem];
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

    
    SubBtn *boomBtn = [SubBtn buttonWithtitle:@"确认" titlecolor:UIColorFromRGB(WhiteColorValue) cornerRadius:5 andtarget:self action:@selector(boomBtnClick) andframe:CGRectMake(20, ScreenHeight - 64-48, ScreenWidth - 40, 40)];
    [self.view addSubview:boomBtn];

    [self.view addSubview:self.goodsTabView];
}
- (void)loadDatas{
    
    if (_tabArr.count>0) {
        for (int i = 0; i<_dataArr.count; i++) {
            NSArray *arr = _dataArr[i];
            
            UnitModel * famodel0 =arr[0];
            
            UnitModel * famodel1 =arr[1];
            
            UnitModel * famodel2 =arr[2];
            
            if (![_kindArr containsObject:famodel0.name]) {
                [_kindArr addObject:famodel0.name];
            }
            if (![_colorArr containsObject:famodel1.name]) {
                [_colorArr addObject:famodel1.name];
            }
            if (![_stateArr containsObject:famodel2.name]) {
                [_stateArr addObject:famodel2.name];
            }
        }

    }else{
        for (int i = 0; i<_dataArr.count; i++) {
            NSArray *arr = _dataArr[i];
            AccessCellModel *model = [[AccessCellModel alloc]init];
            model.image = _imageArr[0];
            
            UnitModel * famodel0 =arr[0];
            model.kind = famodel0.name;
            
            UnitModel * famodel1 =arr[1];
            model.color = famodel1.name;
            
            UnitModel * famodel2 =arr[2];
            model.state = famodel2.name;
            
            model.mainImageUrl = @"";
            model.stock = -1;
            model.minBuy = -1;
            model.limitBuy = -1;
            
            model.price = @"-1";
            [_tabArr addObject:model];
            if (![_kindArr containsObject:famodel0.name]) {
                [_kindArr addObject:famodel0.name];
            }
            if (![_colorArr containsObject:famodel1.name]) {
                [_colorArr addObject:famodel1.name];
            }
            if (![_stateArr containsObject:famodel2.name]) {
                [_stateArr addObject:famodel2.name];
            }
        }

    
    }
    
        [self.goodsTabView reloadData];
    
}

- (void)deleteGoods{
    
    _isopen = !_isopen;
    if (_isopen) {
        for (AccessCellModel *model in _tabArr) {
            model.isopen = YES;
        }
        [btn setTitle:@"完成" forState:UIControlStateNormal];
        
    }else{
        for (AccessCellModel *model in _tabArr) {
            model.isopen = NO;
        }
        [btn setTitle:@"删除" forState:UIControlStateNormal];
        NSMutableArray *removeArr = [_tabArr mutableCopy];
        for (AccessCellModel *model  in removeArr) {
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
            AccessCellModel *model = _tabArr[i];
            if (model.stock <0||[model.price floatValue]<0 ) {
                _editstatus = @"1";

                           return NO;
            }
            if (model.minBuy <0&&model.limitBuy < 0) {
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
    NSString *colorStr = [_colorArr componentsJoinedByString:@","];
    NSString *stateStr = [_stateArr componentsJoinedByString:@","];
    
    NSDictionary *infoDic = @{@"specificationName":@"类型",
                              @"specificationValues":kindStr,
                              @"memo":@"",
                              };
    NSDictionary *infoDic1 = @{@"specificationName":@"颜色",
                               @"specificationValues":colorStr,
                               @"memo":@"",
                               };
    NSDictionary *infoDic2 = @{@"specificationName":@"状态",
                               @"specificationValues":stateStr,
                               @"memo":@"",
                               };
    
    NSArray *infoArr = @[[self dictionaryToJson:infoDic],[self dictionaryToJson:infoDic1],[self dictionaryToJson:infoDic2]];
    NSDictionary *setDic = @{@"completeSpecificationList":[NSString stringWithFormat:@"[%@,%@,%@]",infoArr[0],infoArr[1],infoArr[2]]};
    
    [PublishGoodsPL batchspecificationWithInfoDic:setDic ReturnBlock:^(id returnValue) {
        NSLog(@"%@",returnValue);
        NSDictionary *AllDic = returnValue[@"data"];
        NSArray *completeSpecificationList = AllDic[@"completeSpecificationList"];
        NSArray *arr = [CompleteSpecificationModel  mj_objectArrayWithKeyValuesArray:completeSpecificationList];
        NSLog(@"%@",arr);
        NSMutableArray *specificationValueIds = [NSMutableArray arrayWithCapacity:0];
        CompleteSpecificationModel *model0 = arr[0];
        CompleteSpecificationModel *model1 = arr[1];
        CompleteSpecificationModel *model2 = arr[2];
        
        for (int i = 0; i<_tabArr.count; i++) {
            AccessCellModel *model = _tabArr[i];
            NSString *kindId = @"";
            NSString *colorId = @"";
            NSString *stateId = @"";
            
            for (SpecificationModel *specificatioModel in model0.specificationValueList) {
                if ([model.kind isEqualToString:specificatioModel.name]) {
                    kindId = specificatioModel.kindId;
                }
            }
            for (SpecificationModel *specificatioModel in model1.specificationValueList) {
                if ([model.color isEqualToString:specificatioModel.name]) {
                    colorId = specificatioModel.kindId;
                }
            }
            for (SpecificationModel *specificatioModel in model2.specificationValueList) {
                if ([model.state isEqualToString:specificatioModel.name]) {
                    stateId = specificatioModel.kindId;
                }
            }
            NSDictionary *goodDic = @{@"specificationValueIds":[NSString stringWithFormat:@"%@,%@,%@",kindId,colorId,stateId],
                                      @"price":model.price,
                                      @"stock":[NSString stringWithFormat:@"%ld",(long)model.stock],
                                      @"minBuyQuantity":model.minBuy>0?[NSString stringWithFormat:@"%ld",(long)model.minBuy]:@"",
                                      @"limitUserTotalBuyQuantity":model.limitBuy>0?[NSString stringWithFormat:@"%ld",(long)model.limitBuy]:@"",
                                      @"mainImageUrl":model.mainImageUrl
                                      };
            [specificationValueIds addObject:[self dictionaryToJson:goodDic]];
            
        }
        NSString *goodStr = [specificationValueIds componentsJoinedByString:@","];
        NSString *specificationIds = [NSString stringWithFormat:@"%@,%@,%@",model0.specification.kindId,model1.specification.kindId,model2.specification.kindId];
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



- (void)batchBtnClick{
    
    if (_kindArr.count<=0) {
        return;
    }
    
    if ([_kindArr containsObject:@"批发"]||[_kindArr containsObject:@"零售"]) {
        if (_kindArr.count==2) {
            self.batcView.type = 3;
            
        }else{
            if ([_kindArr containsObject:@"批发"]) {
                self.batcView.type = 1;
                
            }else{
                self.batcView.type = 2;
                
            }
            
            
        }

    }else{
        if (_kindArr.count>1) {
            
            if ([_kindArr containsObject:@"大货"]) {
                self.batcView.type = 3;
            }else{
                self.batcView.type = 2;
                
            }
            
        }else{
            if ([_kindArr containsObject:@"大货"]) {
                self.batcView.type = 1;
            }else{
                self.batcView.type = 2;
            }
        }

    }
    
    
    

    
    
    [self.batcView showinView:self.view];
    
}
/**
 底部确定按钮
 */
- (void)boomBtnClick{
    
        for (int i = 0; i<_tabArr.count; i++) {
            AccessCellModel *model = _tabArr[i];
            if (model.stock <0||[model.price floatValue]<0 ) {
                [self showTextHud:[NSString stringWithFormat:@"第%d行商品数据未填写完整",i+1]];
                           return;
            }
            if (model.minBuy <0&&model.limitBuy < 0) {
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
    
    
    for (AccessCellModel *model in _tabArr) {
        if (self.batcView.stocktxt.text.length >0) {
            model.stock = [self.batcView.stocktxt.text integerValue];
        }
        
        if (self.batcView.pricetxt.text.length >0) {
            model.price = self.batcView.pricetxt.text;
        }
        if (self.batcView.mintxt.text.length >0) {
            if ([model.kind isEqualToString:@"大货"]||[model.kind isEqualToString:@"批发"]) {
                model.minBuy = [self.batcView.mintxt.text integerValue];

            }
        }
        
        if (self.batcView.maxtxt.text.length >0) {
            
            if (![model.kind isEqualToString:@"大货"]&&![model.kind isEqualToString:@"批发"]) {
                model.limitBuy = [self.batcView.maxtxt.text integerValue];
                
            }
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








/**
 添加图片

 @param model model description
 */
-(void)didSelectedAccessListCellUpImagedBtnWithModel:(AccessCellModel *)model{

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
    AccessListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[AccessListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        
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
        _setModel.image = image;
        _setModel.cndUrl = imageDic[@"cdnUrl"];

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
