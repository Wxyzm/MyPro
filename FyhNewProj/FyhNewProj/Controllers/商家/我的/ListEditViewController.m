//
//  ListEditViewController.m
//  FyhNewProj
//
//  Created by yh f on 2017/7/12.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "ListEditViewController.h"
#import "IdeaCellModel.h"
#import "IdeaGoodsListCell.h"
#import "UpImagePL.h"
#import "AccessListCell.h"
#import "IdeaCellModel.h"
#import "AccessCellModel.h"

@interface ListEditViewController ()<UITableViewDelegate,UITableViewDataSource,IdeaGoodsListCellDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate,UINavigationControllerDelegate,AccessListCellDelegate,IdeaGoodsListCellDelegate  >

@property (nonatomic,strong)UITableView *goodsTabView;           //商品


@end

@implementation ListEditViewController{

    YLButton *btn;
    BOOL _isopen;
    UIImagePickerController *_imagePicker;
    BOOL                     _isChoiceCamera;
    UpImagePL               *_upImagePL;                     //上传图片
    NSMutableArray *_tabArr;
    NSInteger       _type;

}

-(UITableView *)goodsTabView{
    
    if (!_goodsTabView) {
        _goodsTabView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth,ScreenHeight-64) style:UITableViewStylePlain];
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
    self.title = @"商品列表";
    [self setBarBackBtnWithImage:nil];
    _tabArr = [NSMutableArray arrayWithCapacity:0];
    _upImagePL = [[UpImagePL alloc]init];
    [self loadDatas];
    [self.view addSubview:self.goodsTabView];
    [self.goodsTabView reloadData];
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
    
    SubBtn *boomBtn = [SubBtn buttonWithtitle:@"确认" titlecolor:UIColorFromRGB(WhiteColorValue) cornerRadius:5 andtarget:self action:@selector(boomBtnClick) andframe:CGRectMake(20, 200, ScreenWidth - 40, 40)];
    [self.view addSubview:boomBtn];
    

    
}


- (void)loadDatas{
    NSArray *arr = [_infoDic[@"categoryDescription"] componentsSeparatedByString:@"/"];
    if ([arr[0] isEqualToString:@"创意设计"]) {
        _type = 0;
        //2行
        IdeaCellModel *model = [[IdeaCellModel alloc]init];
        model.image = nil;
        model.mainImageUrl = _infoDic[@"imageUrlList"][0];
        NSArray *speArr = _infoDic[@"specificationValues"];
        model.kind =  speArr[1][@"name"];
        model.use =  speArr[0][@"name"];
        model.stock = [_infoDic[@"stock"] integerValue];
        model.price = _infoDic[@"price"];
        [_tabArr addObject:model];
    }else{
        _type = 1;
        //3行
        AccessCellModel *model = [[AccessCellModel alloc]init];
        model.image = nil;
        model.mainImageUrl = _infoDic[@"imageUrlList"][0];
        NSArray *speArr = _infoDic[@"specificationValues"];
        model.kind =  speArr[2][@"name"];
        model.color =  speArr[1][@"name"];
        model.state =  speArr[0][@"name"];
        model.stock = [_infoDic[@"stock"] integerValue];
        if (NULL_TO_NIL(_infoDic[@"minBuyQuantity"])) {
            NSLog(@"%@",NULL_TO_NIL(_infoDic[@"minBuyQuantity"]));

            model.minBuy = [_infoDic[@"minBuyQuantity"] integerValue];

        }else{
            model.minBuy = -1;
        }
        if (NULL_TO_NIL(_infoDic[@"limitUserTotalBuyQuantity"])) {
            NSLog(@"%@",NULL_TO_NIL(_infoDic[@"limitUserTotalBuyQuantity"]));
            model.limitBuy = [_infoDic[@"limitUserTotalBuyQuantity"] integerValue];
            
        }else{
            model.limitBuy = -1;
        }
        model.price = _infoDic[@"price"];
        [_tabArr addObject:model];

    }
}

- (void)boomBtnClick{
    [self saveGoods];
}


- (void)respondToLeftButtonClickEvent{

    [self saveGoods];
}


- (void)saveGoods{
    [self.view endEditing:YES];
    if (_type == 0) {
        for (int i = 0; i<_tabArr.count; i++) {
            IdeaCellModel *model = _tabArr[i];
            if (model.stock <0 ||[model.price integerValue]<0) {
                [self showTextHud:[NSString stringWithFormat:@"第%d行商品数据未填写完整",i+1]];
                return;
            }
        }
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否保存已编辑的内容" preferredStyle:UIAlertControllerStyleAlert];
        [alert  addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UserHaveChangeGoodsList" object:_tabArr[0]];
            [self.navigationController  popViewControllerAnimated:YES];
            
        }]];
        [alert  addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController  popViewControllerAnimated:YES];
            
        }]];
        [self presentViewController:alert animated:YES completion:nil];

        
    }else{
        for (int i = 0; i<_tabArr.count; i++) {
            AccessCellModel *model = _tabArr[i];
            if (model.stock <0||[model.price integerValue]<0 ) {
                [self showTextHud:[NSString stringWithFormat:@"第%d行商品数据未填写完整",i+1]];
                return;
            }
            if (model.minBuy <0&&model.limitBuy < 0) {
                [self showTextHud:[NSString stringWithFormat:@"第%d行商品数据未填写完整",i+1]];
                return;
            }
        }
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否保存已编辑的内容" preferredStyle:UIAlertControllerStyleAlert];
        [alert  addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UserHaveChangeGoodsList" object:_tabArr[0]];
            [self.navigationController  popViewControllerAnimated:YES];
            
        }]];
        [alert  addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController  popViewControllerAnimated:YES];
            
        }]];
        [self presentViewController:alert animated:YES completion:nil];
}
}

- (void)deleteGoods{
    
    _isopen = !_isopen;
    if (_isopen) {
        if (_type == 0) {
            for (IdeaCellModel *model in _tabArr) {
                model.isopen = YES;
            }

        }else{
            for (AccessCellModel *model in _tabArr) {
                model.isopen = YES;
            }

        }
        [btn setTitle:@"完成" forState:UIControlStateNormal];
        
    }else{
        if (_type == 0) {
            for (IdeaCellModel *model in _tabArr) {
                model.isopen = NO;
            }
            NSMutableArray *removeArr = [_tabArr mutableCopy];
            for (IdeaCellModel *model  in removeArr) {
                if (model.select) {
                    [_tabArr removeObject:model];
                }
            }
        }else{
            for (AccessCellModel *model in _tabArr) {
                model.isopen = NO;
            }
            NSMutableArray *removeArr = [_tabArr mutableCopy];
            for (AccessCellModel *model  in removeArr) {
                if (model.select) {
                    [_tabArr removeObject:model];
                }
            }

            
        }

      
        [btn setTitle:@"删除" forState:UIControlStateNormal];
        
        
    }
    [self.goodsTabView reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _tabArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 112;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellid = @"cellid";
    if (_type == 0) {
        IdeaGoodsListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        if (!cell) {
            cell = [[IdeaGoodsListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
            
        }
        cell.delegate = self;
        cell.model = _tabArr[indexPath.row];
        cell.faceImageView.image = _showImage;
        return cell;


    }else{
        AccessListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        if (!cell) {
            cell = [[AccessListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
            
        }
        cell.delegate = self;
        cell.model = _tabArr[indexPath.row];
        cell.faceImageView.image = _showImage;

        return cell;

    }
    
}


-(void)didSelectedAccessListCellUpImagedBtnWithModel:(AccessCellModel *)model{
    if (!_isChangeImage) {
        [self showTextHud:@"商品图片最多只有五张"];
        return;
    }

    [self chosePhoto];


}


-(void)didSelectedUpImagedBtnWithModel:(IdeaCellModel *)model{

    
    if (!_isChangeImage) {
        [self showTextHud:@"商品图片最多只有五张"];
        return;
    }
    [self chosePhoto];


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
    
    _showImage = image;
 //   __weak __typeof(self)weakSelf = self;
    if (_type == 0) {
        IdeaCellModel *model = _tabArr[0];
     //   model.mainImageUrl = arr[0];
        model.image = image;
    }else{
        AccessCellModel *model = _tabArr[0];
     //   model.mainImageUrl = arr[0];
        model.image = image;
        
    }
    [_goodsTabView reloadData];
    
//    [_upImagePL updateImg:image WithReturnBlock:^(id returnValue) {
//        NSDictionary *imageDic = returnValue;
//        NSArray *arr = imageDic[@"imageUrls"];
//        if (arr.count<=0) {
//            return ;
//        }
//        
//        
//    } withErrorBlock:^(NSString *msg) {
//        [weakSelf showTextHud:msg];
//    }];
    
    
    
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}


@end
