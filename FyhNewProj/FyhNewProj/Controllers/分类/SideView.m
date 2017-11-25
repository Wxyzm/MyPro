
//  SideView.m
//  demo_sidemove
//
//  Created by nixinyue on 16/6/28.
//  Copyright © 2016年 nixinyue. All rights reserved.
//


#import "SideView.h"
#import "ProjectMacro.h"
#import "UIView+SDAutoLayout.h"
#import "KindModel.h"
#import "KindCell.h"
#import "GoodsLVOneModel.h"

@interface SideView()<UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIButton      *backButton;
@property (nonatomic, strong) UIView        *sideView;      //此view上面根据ui制作
@property (nonatomic, strong) NSDictionary *userInfo;

@property (nonatomic,strong)UITableView *kindTabView;           //分类


@end

@implementation SideView
{
    BOOL        _isShow;
    CGFloat     _viewWidth;     //侧滑实体的宽度
    CGFloat     _startOrginX;   //初始x坐标
   // NSMutableArray *_dataArr;
    
}


- (instancetype)init
{
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight-TABBAR_HEIGHT);
        self.backgroundColor = [UIColor clearColor];
        _dataArr = [[NSMutableArray alloc]initWithCapacity:0];
        [self setUp];
    }
    return self;
}

- (void)setUp
{
//    NSArray *imageArr = @[@"Half",@"grey fabric",@"factory",@"shell fabric",@"accessories ",@"clothes",@"curtain",@"exclusive "];
//    NSArray *titleArr = @[@"半漂布",@"胚布",@"找工厂",@"面料专区",@"辅料专区",@"服装服饰",@"窗帘家纺",@"创意设计"];
//    
//    for (int i = 0; i<8; i++) {
//        KindModel *model = [[KindModel alloc]init];
//        model.imageName = imageArr[i];
//        model.titleName = titleArr[i];
//        [_dataArr addObject:model];
//    }

   
    _viewWidth = ScreenWidth * 0.7;
    [self addSubview:self.backButton];
    [self addSubview:self.sideView];
    [self.sideView addSubview:self.kindTabView];

    
    //添加 侧边栏 手势
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognized:)];
    panGestureRecognizer.delegate = self;
    [self addGestureRecognizer:panGestureRecognizer];
}

#pragma - mark getter
-(UITableView *)kindTabView{
    
    if (!_kindTabView) {
        _kindTabView = [[UITableView alloc] initWithFrame:CGRectMake(0, 87, _viewWidth,ScreenHeight-TABBAR_HEIGHT-87.5) style:UITableViewStylePlain];
        _kindTabView.bounces = NO;
        _kindTabView.delegate = self;
        _kindTabView.dataSource = self;
        _kindTabView.backgroundColor = UIColorFromRGB(WhiteColorValue);
        _kindTabView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    return _kindTabView;
    
}


- (UIButton *)backButton
{
    if (!_backButton) {
        _backButton = [[UIButton alloc] initWithFrame:self.bounds];
        _backButton.backgroundColor = [UIColor blackColor];
        _backButton.alpha = 0.3;
        [_backButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

- (UIView *)sideView
{
    if (!_sideView) {
        _sideView = [[UIView alloc] initWithFrame:CGRectMake(-ScreenWidth, 0, _viewWidth, ScreenHeight-TABBAR_HEIGHT-0.5)];
        _sideView.backgroundColor = [UIColor whiteColor];
        
        UIView *lineView =[BaseViewFactory viewWithFrame:CGRectMake(0, 75, _viewWidth, 12) color:UIColorFromRGB(PlaColorValue)];
        [_sideView addSubview:lineView];
        
        UIImageView *topImage = [BaseViewFactory icomWithWidth:20 imagePath:@"btn-gary"];
        [_sideView addSubview:topImage];
        topImage.frame = CGRectMake(20, 39.5, 20, 16);
        
        UILabel *fenleiLab = [BaseViewFactory labelWithFrame:CGRectMake(60, 20, _viewWidth - 60, 55) textColor:UIColorFromRGB(BlackColorValue) font:APPFONT(18) textAligment:NSTextAlignmentLeft andtext:@"所有分类"];
        [_sideView addSubview:fenleiLab];
        
        
    }
    return _sideView;
}

#pragma - mark setter
- (void)setBaseVC:(UIViewController *)baseVC
{
    _baseVC = baseVC;
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognized:)];
    
    panGestureRecognizer.delegate = self;
    [_baseVC.view addGestureRecognizer:panGestureRecognizer];
}

#pragma - mark public method
- (void)show
{
    if (_isShow) return;

    _isShow = YES;
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    _sideView.frame = CGRectMake(-_viewWidth, 0, _viewWidth, ScreenHeight-TABBAR_HEIGHT-0.5);
    
    [UIView animateWithDuration:0.2 animations:^{
        _sideView.frame = CGRectMake(0, 0, _viewWidth, ScreenHeight-TABBAR_HEIGHT-0.5);
    }];
}

- (void)dismiss
{
    if (!_isShow) return;
    
    _isShow = NO;
    
    //CGFloat duration = 0.4 * (ScreenWidth - _sideView.frame.origin.x)/_sideView.frame.size.width;
    
    [UIView animateWithDuration:0.2 animations:^{
        _sideView.frame = CGRectMake(-_viewWidth, 0, _viewWidth,  ScreenHeight-TABBAR_HEIGHT-0.5);
        _backButton.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        _backButton.alpha = 0.3;
    }];
}

#pragma mark - delegate for Gesture
//侧边栏 手势
- (void)panGestureRecognized:(UIPanGestureRecognizer *)recognizer
{
    CGPoint point = [recognizer translationInView:self.baseVC.view];
//    CGPoint point1 = [recognizer translationInView:self.baseVC.view];
//
//    if (point1.x>ScreenWidth/3) {
//        return;
//    }
    
    if (recognizer.state == UIGestureRecognizerStateBegan)
    {
        _startOrginX = _sideView.frame.origin.x;
        if (!_isShow) {
            [[UIApplication sharedApplication].keyWindow addSubview:self];
            _isShow = YES;
        }
    }
    
    if (recognizer.state == UIGestureRecognizerStateChanged)
    {
        NSLog(@"%f",_startOrginX);
          NSLog(@"%f",point.x);
        CGFloat orginX = _startOrginX + point.x;
        if (orginX<0 && -orginX < _viewWidth) {
            _sideView.frame = CGRectMake(orginX, 0, _viewWidth, _sideView.frame.size.height);

        }
//        if (orginX >= ScreenWidth - _viewWidth && orginX <= ScreenWidth) {
//            _sideView.frame = CGRectMake(orginX, 0, _viewWidth, _sideView.frame.size.height);
//        }
    }
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        
        CGFloat X = _viewWidth  * 0.5;
//        if (point.x > 0) {
//            //往右
//            X = ScreenWidth/2;
//        }
//         NSLog(@"%f",_sideView.frame.origin.x );
        if (-_sideView.frame.origin.x > X) {
            [self dismiss];
        } else {
            [UIView animateWithDuration:0.2 animations:^{
                _sideView.frame = CGRectMake(0, 0, _viewWidth, ScreenHeight-TABBAR_HEIGHT-0.5);
            }];
        }
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if (!_isShow) {
        CGPoint point = [touch locationInView:gestureRecognizer.view];
        if (point.x <  40) {
            return YES;
        } else {
            return NO;
        }
    }
    
    return YES;
}

- (void)setthedic:(NSDictionary *)dic{
    _yuyueInfo = dic;
}


#pragma mark ========= tableviewdelegate and datasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return _dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    static NSString *cellid = @"kindcell";
    KindCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[KindCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    GoodsLVOneModel*model = _dataArr[indexPath.row];
    cell.model = model;
    
    return cell;
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    GoodsLVOneModel*model = _dataArr[indexPath.row];
    if ([self.delegate respondsToSelector:@selector(didselectedRowWithModel:)]) {
        [self.delegate didselectedRowWithModel:model];
    }


}


-(void)setDataArr:(NSMutableArray *)dataArr{
    _dataArr = dataArr;
    [_kindTabView reloadData];

}

@end
