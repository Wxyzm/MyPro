//
//  PhotoSearchResultViewController.m
//  FyhNewProj
//
//  Created by yh f on 2017/3/12.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "PhotoSearchResultViewController.h"
#import "SearchProductCollectionCell.h"
#import "ProDetailController.h"
#import "MBProgressHUD+Add.h"
@interface PhotoSearchResultViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionview;


/**
 *  产品数组
 */
@property (nonatomic, strong) NSMutableArray *productArray;


@end

@implementation PhotoSearchResultViewController

-(UICollectionView *)collectionview
{
    if (_collectionview == nil)
    {
        //确定是水平滚动，还是垂直滚动
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        
        _collectionview=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64) collectionViewLayout:flowLayout];
        //[self.view addSubview:_collectionview];
        _collectionview.dataSource=self;
        _collectionview.backgroundColor = [UIColor clearColor];
        _collectionview.delegate=self;
        //        _collectionview.bounces = NO;
        //注册Cell，必须要有
        [_collectionview registerClass:[SearchProductCollectionCell class] forCellWithReuseIdentifier:@"SearchProductCollectionCell"];
        
    }
    return _collectionview;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"相似商品";

    self.view.backgroundColor = UIColorFromRGB(0xf1f1f1);
    [self setUpUI];
    [self searchTheImage:self.searchImage];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

-(void)setUpUI{

    [self.view addSubview:self.collectionview];
   
}


#pragma mark -- UICollectionViewDataSource
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.productArray.count;
    
    
}


//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"SearchProductCollectionCell";
    SearchProductCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    [cell sizeToFit];
    if (!cell) {
        NSLog(@"无法创建CollectionViewCell时打印，自定义的cell就不可能进来了。");
    }
    NSDictionary *dic = self.productArray[indexPath.row];
    [cell setDataDic:dic];
   // cell.productByFidModel = self.productArray[indexPath.row];
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout

//定义每个Item 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat itemW = (ScreenWidth-36)/2;
    return CGSizeMake(itemW, 283);
}

//定义每个UICollectionView 的 margin
/*UIEdgeInsets UIEdgeInsetsMake (
 CGFloat top,
 CGFloat left,
 CGFloat bottom,
 CGFloat right
 );*/
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(12, 12, 0, 12);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    NSDictionary *strDic = self.productArray[indexPath.row];
    ProDetailController *proVc = [[ProDetailController alloc]init];
    proVc.urlStr = strDic[@"url"];
    [self.navigationController pushViewController:proVc animated:YES];


}

#pragma mark --搜索图片


- (void)searchTheImage:(UIImage *)image{

    NSData * imageData = [self scaleImage:image toKb:1024];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *str = [formatter stringFromDate:[NSDate date]];
    NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
    NSDictionary *dataDict = @{@"image":imageData};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [MBProgressHUD showMessag:@"正在搜索相似商品" toView:self.view];
    [manager POST:[NSString stringWithFormat:@"%@/gateway?api=searchItemsByImageFile",kbaseUrl] parameters:dataDict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:imageData name:@"image" fileName:fileName mimeType:@"image/jpeg"];
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSDictionary *jsonDic = [NSJSONSerialization  JSONObjectWithData:responseObject options:0 error:nil];
        NSDictionary *iteams = jsonDic[@"data"];
        self.productArray = iteams[@"items"];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (self.productArray.count >0) {
            
            [self.collectionview  reloadData];
        }else{
            [self weifaxianPro];
        }
        NSLog(@"%@",jsonDic);
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self weifaxianPro];


    }];
}

- (void)weifaxianPro{

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"未发现相似商品" preferredStyle:UIAlertControllerStyleAlert];
    [alert  addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController  popViewControllerAnimated:YES];
        
    }]];
   
        [self presentViewController:alert animated:YES completion:nil];
}






/**
 压缩图片返回base64编码
 
 @param image 传入图片
 @param kb 压缩至1M（1024kb）
 @return 压缩后的图片转化的base64编码
 */
- (NSData *)scaleImage:(UIImage *)image toKb:(NSInteger)kb{
    
    kb*=1024;
    CGFloat compression = 0.9f;
    CGFloat maxCompression = 0.1f;
    NSData *imageData = UIImageJPEGRepresentation(image, compression);
    NSLog(@"原始大小:%fkb",(float)[imageData length]/1024.0f);
    while ([imageData length] > kb && compression > maxCompression) {
        compression -= 0.1;
        imageData = UIImageJPEGRepresentation(image, compression);
    }
    NSLog(@"当前大小:%fkb",(float)[imageData length]/1024.0f);
    //    UIImage *compressedImage = [UIImage imageWithData:imageData];
    
    
    
    return imageData;
    
    
    
}

@end
