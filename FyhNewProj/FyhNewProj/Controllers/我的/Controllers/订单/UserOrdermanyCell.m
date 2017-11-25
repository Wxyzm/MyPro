//
//  UserOrdermanyCell.m
//  FyhNewProj
//
//  Created by yh f on 2017/7/14.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "UserOrdermanyCell.h"
#import "UserOrderCollectionViewCell.h"
#import "OrderItems.h"
#import "OrderSellerItems.h"
#import "UserOrder.h"

@interface UserOrdermanyCell()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic , strong) UICollectionView *collectionView;

@property (nonatomic , strong) UIView  *boomView;

@property (nonatomic , strong) UILabel *traLab;

@property (nonatomic , strong) UILabel *priceLab;

@property (nonatomic , strong) UILabel *numbrLab;

@property (nonatomic , strong) UILabel *staterLab;


@end

@implementation UserOrdermanyCell{
    CGRect leftButtonFrame;
    CGRect rightButtonFrame;
}

-(UIView *)boomView{

    if (!_boomView) {
        _boomView = [BaseViewFactory viewWithFrame:CGRectMake(0, 100, ScreenWidth, 80) color:UIColorFromRGB(WhiteColorValue)];
        UIView *topLine = [BaseViewFactory viewWithFrame:CGRectMake(0, 0, ScreenWidth, 1) color:UIColorFromRGB(LineColorValue)];
        [_boomView addSubview:topLine];
        
        UIView *topLine1 = [BaseViewFactory viewWithFrame:CGRectMake(0, 39, ScreenWidth, 1) color:UIColorFromRGB(LineColorValue)];
        [_boomView addSubview:topLine1];
        
        rightButtonFrame = CGRectMake(ScreenWidth - 90, 45, 70, 30);
        _payBtn = [SubBtn buttonWithtitle:@"付款" titlecolor:UIColorFromRGB(WhiteColorValue) cornerRadius:15 andtarget:self action:@selector(payBtnClick) andframe:rightButtonFrame];
        _payBtn.titleLabel.font = APPFONT(12);
        [_boomView addSubview:_payBtn];
        
        leftButtonFrame = CGRectMake(ScreenWidth-180, 45, 70, 30);
        _cancleBtn = [SubBtn buttonWithtitle:@"取消订单" backgroundColor:UIColorFromRGB(PlaColorValue) titlecolor:UIColorFromRGB(WhiteColorValue) cornerRadius:15 andtarget:self action:@selector(cancleBtnClick)];
        _cancleBtn.frame = leftButtonFrame;
        _cancleBtn.titleLabel.font = APPFONT(12);
        [_boomView addSubview:_cancleBtn];
        
        _traLab = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(LineColorValue) font:APPFONT(13) textAligment:NSTextAlignmentRight andtext:@""];
        [_boomView addSubview:_traLab];
        
        _priceLab = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(RedColorValue) font:APPFONT(15) textAligment:NSTextAlignmentRight andtext:@""];
        [_boomView addSubview:_priceLab];
        
        _numbrLab = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(BlackColorValue) font:APPFONT(13) textAligment:NSTextAlignmentRight andtext:@""];
        [_boomView addSubview:_numbrLab];

        _staterLab = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(RedColorValue) font:APPFONT(13) textAligment:NSTextAlignmentLeft andtext:@""];
        _staterLab.frame = CGRectMake(20, 0, 180, 40);
        [_boomView addSubview:_staterLab];

        _traLab.sd_layout.rightSpaceToView(_boomView,20).topSpaceToView(_boomView,0).heightIs(40);
        [_traLab setSingleLineAutoResizeWithMaxWidth:200];
        
        _priceLab.sd_layout.rightSpaceToView(_traLab,0).topSpaceToView(_boomView,0).heightIs(40);
        [_priceLab setSingleLineAutoResizeWithMaxWidth:200];
        
        _numbrLab.sd_layout.rightSpaceToView(_priceLab,0).topSpaceToView(_boomView,0).heightIs(40);
        [_numbrLab setSingleLineAutoResizeWithMaxWidth:200];

    }


    return _boomView;
}


-(UICollectionView *)collectionView{

    if (!_collectionView) {
        //确定是水平滚动，还是垂直滚动
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        
        _collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 100) collectionViewLayout:flowLayout];
        _collectionView.dataSource=self;
        _collectionView.delegate=self;
        _collectionView.backgroundColor = [UIColor clearColor];
        //注册Cell，必须要有
        [_collectionView registerClass:[UserOrderCollectionViewCell class] forCellWithReuseIdentifier:@"UserOrderCollectionViewCell"];

    }

    return _collectionView;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = UIColorFromRGB(WhiteColorValue);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _dataArr = [NSMutableArray arrayWithCapacity:0];
        self.clipsToBounds = YES;
        [self setUP];
    }
    return self;
}

- (void)setUP{

    [self.contentView addSubview:self.collectionView];
    UIView *lineview =[BaseViewFactory viewWithFrame:CGRectMake(0, 0, ScreenWidth, 1) color:UIColorFromRGB(PlaColorValue)   ];
    [self.contentView addSubview:lineview];
    [self.contentView addSubview:self.boomView];
    self.boomView.hidden = YES;
    
   

}

- (void)showboomView{
    self.boomView.hidden = NO;

}
- (void)hiddenboomView{
    self.boomView.hidden = YES;
    
}



-(void)setDataArr:(NSMutableArray *)dataArr{

    if (!_dataArr) {
        _dataArr = [NSMutableArray arrayWithCapacity:0];
    }
    [_dataArr removeAllObjects];
   
    CGFloat TraAmout = 0.00f;
    CGFloat payAmout = 0.00f;
    NSInteger  goodsNumber = 0;
    for (int i = 0; i<dataArr.count; i++) {
        OrderSellerItems *itemModel = dataArr[i];
        for (OrderItems *item in itemModel.itemOrders) {
            if ([item.itemId integerValue]!=-1) {
                [_dataArr addObject:item];
                goodsNumber += [item.quantity integerValue];
                payAmout += [item.payAmount floatValue];

            }else{
                TraAmout+= [item.payAmount floatValue];

            }
        }
       
}
    [self.collectionView reloadData];
    
     OrderSellerItems *item = dataArr[0];
    OrderItems *ItemsModel = item.itemOrders[0];
    switch ([ItemsModel.status intValue]) {
        case 0:{
            //未付款
            _staterLab.text = @"等待付款";
            [self showButton:self.cancleBtn withTitle:@"取消订单" frame:leftButtonFrame];
            [self showButton:self.payBtn withTitle:@"付款" frame:rightButtonFrame];

            break;
        }
        case 1:{
            //已支付，待发货
            _staterLab.text = @"买家已付款";
            self.cancleBtn.hidden = YES;
            self.payBtn.hidden = YES;
            break;
        }
        case 2:{
            //卖家已发货
            _staterLab.text = @"卖家已发货";
            [self showButton:self.cancleBtn withTitle:@"查看物流" frame:leftButtonFrame];
            [self showButton:self.payBtn withTitle:@"确认收货" frame:rightButtonFrame];
            break;
        }
        case 3:{
            //交易成功   ，确认收货后
            _staterLab.text = @"交易成功";
            [self showButton:self.cancleBtn withTitle:@"查看物流" frame:leftButtonFrame];
            [self showButton:self.payBtn withTitle:@"评价" frame:rightButtonFrame];
            break;
        }
            
            
        case 4:{
            //交易关闭
            _staterLab.text = @"交易关闭";
            [self showButton:self.cancleBtn withTitle:@"删除订单" frame:rightButtonFrame];
            self.payBtn.hidden = YES;
            break;
        }
        default:
            break;
    }

    _traLab.text = [NSString stringWithFormat:@"(含运费%.2f)",TraAmout];
    _priceLab.text = [NSString stringWithFormat:@"￥%.2f",payAmout];
    _numbrLab.text = [NSString stringWithFormat:@"共%ld件商品，小计：",(long)goodsNumber];

    _traLab.sd_layout.rightSpaceToView(_boomView,20).topSpaceToView(_boomView,0).heightIs(40);
    [_traLab setSingleLineAutoResizeWithMaxWidth:200];
    
    _priceLab.sd_layout.rightSpaceToView(_traLab,0).topSpaceToView(_boomView,0).heightIs(40);
    [_priceLab setSingleLineAutoResizeWithMaxWidth:200];
    
    _numbrLab.sd_layout.rightSpaceToView(_priceLab,0).topSpaceToView(_boomView,0).heightIs(40);
    [_numbrLab setSingleLineAutoResizeWithMaxWidth:200];

}
- (void)payBtnClick{
    OrderItems *item = _dataArr[0];
    if ([self.delegate respondsToSelector:@selector(didselectedUserOrdermanyCellPayBtnWithType:andArr:)]) {
        [self.delegate didselectedUserOrdermanyCellPayBtnWithType:[item.status intValue] andArr:_dataArr];
    }
}

- (void)cancleBtnClick{
    OrderItems *item = _dataArr[0];
    if ([self.delegate respondsToSelector:@selector(didselectedUserOrdermanyCellCancleBtnWithType:andArr:)]) {
        [self.delegate didselectedUserOrdermanyCellCancleBtnWithType:[item.status intValue] andArr:_dataArr];
    }
    
    
    
}


#pragma mark -- UICollectionViewDataSource
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataArr.count;
}


//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"UserOrderCollectionViewCell";
    UserOrderCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    [cell sizeToFit];
    if (!cell) {
        NSLog(@"无法创建CollectionViewCell时打印，自定义的cell就不可能进来了。");
    }
    
    cell.model = _dataArr[indexPath.row];
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout

//定义每个Item 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(75, 75);
}

//定义每个UICollectionView 的 margin//定义每个Section的四边间距

/*UIEdgeInsets UIEdgeInsetsMake (
 CGFloat top,
 CGFloat left,
 CGFloat bottom,
 CGFloat right
 );*/
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(12.5, 10, 12.5, 10);
}

//这个是两行cell之间的间距（上下行cell的间距）
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}

//两个cell之间的间距（同一行的cell的间距）
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
}
- (void)showButton:(UIButton*)button withTitle:(NSString*)title frame:(CGRect)frame
{
    button.hidden = NO;
    button.frame = frame;
    [button setTitle:title forState:UIControlStateNormal];
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    if ([self.delegate respondsToSelector:@selector(didselectedCollecTionViewWithArr:andModel: )]) {
        [self.delegate didselectedCollecTionViewWithArr:_dataArr andModel:_model];
    }

}

//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
//    if (point.y>0&&point.y<=100) {
//        return self;
//    }
//    
//    
//       return [super hitTest:point withEvent:event];
//}
@end
