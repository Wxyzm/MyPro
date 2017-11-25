//
//  ShopTypeView.m
//  FyhNewProj
//
//  Created by yh f on 2017/5/10.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "ShopTypeView.h"

@interface ShopTypeView ()<UITableViewDelegate ,UITableViewDataSource,UIGestureRecognizerDelegate>


@property (nonatomic , strong) UITableView *showTableview;

@property (nonatomic , strong) UIImageView *rightImageView;

@end

@implementation ShopTypeView{

    BOOL _isShowInView;

}

-(UIImageView *)rightImageView{
    if (!_rightImageView) {
        _rightImageView = [[UIImageView alloc]init];
        _rightImageView.frame = CGRectMake(70, 14, 8, 5);

    }
    
    return _rightImageView;
}

-(UITableView *)showTableview{

    if (!_showTableview) {
        _showTableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 0) style:UITableViewStylePlain];
        _showTableview .separatorStyle = UITableViewCellSeparatorStyleNone;
        _showTableview.delegate = self;
        _showTableview.dataSource = self;
        UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelPicker)];
        tapGr.cancelsTouchesInView = NO;
        tapGr.delegate = self;
        [_showTableview addGestureRecognizer:tapGr];
    }
    return _showTableview;
}


-(instancetype)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];

    if (self) {
        _dataArr = [[NSMutableArray alloc]initWithCapacity:0];
        //self.backgroundColor = [UIColor orangeColor];
        [self setup];
    
    }
    return self;
}

- (void)setup{

    self.frame = CGRectMake(0, 40, ScreenWidth, ScreenHeight -64-40);
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:btn];
    btn.frame =CGRectMake(0, 0, ScreenWidth, ScreenHeight -64-40);
    [btn addTarget:self action:@selector(cancelPicker) forControlEvents:UIControlEventTouchUpInside];
}

-(void)setDataArr:(NSMutableArray *)dataArr{

    _dataArr = dataArr;
    [self.showTableview reloadData];

}


#pragma mark ============= tableview

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return _dataArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

   
    return 33;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *cellid = @"cellid";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    if ([_nameStr isEqualToString:_dataArr[indexPath.row]]) {
        
        [self.rightImageView removeFromSuperview];
        [cell.contentView addSubview:self.rightImageView];
        self.rightImageView.image = [UIImage imageNamed:@"need_selected"];
    }
    
    cell.textLabel.text = _dataArr[indexPath.row];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    NSLog(@"%ld",(long)indexPath.row);
    
    if (_shoptype == 0) {
        if ([self.delegate respondsToSelector:@selector(didSelectedtableviewRow:)]) {
            [self.delegate didSelectedtableviewRow:indexPath.row];
        }

    }else if (_shoptype == 1){
    //分类
        if ([self.delegate respondsToSelector:@selector(didSelectedtableviewRow:)]) {
            [self.delegate didSelectedtableviewRow:indexPath.row];
        }
    }else if (_shoptype == 2){
    //数量单位
        if ([self.delegate respondsToSelector:@selector(didSelectedunitRow:)]) {
            [self.delegate didSelectedunitRow:indexPath.row];
        }
    }
    


}

#pragma mark - animation


//显示
- (void)UserWantshowInView:(UIView *)view withFrame:(CGRect )frame
{
    if (_isShowInView) return;
    self.frame = CGRectMake(0, 0, self.frame.size.width, ScreenHeight);
    self.showTableview.frame = CGRectMake(0, frame.origin.y+frame.size.height, self.width, 0);
    [self addSubview:self.showTableview];

    [view addSubview:self];
    
    [UIView animateWithDuration:0.1 animations:^{
        self.showTableview.frame = CGRectMake(0, frame.origin.y+frame.size.height, self.width, ScreenHeight-frame.origin.y-frame.size.height-64);
    }];
    _isShowInView = YES;
}
//消失
- (void)UserWantcancelPicker
{
    if (!_isShowInView) return;
//    if ([self.delegate respondsToSelector:@selector(didSelectedcancelPickerBtn)]) {
//        [self.delegate didSelectedcancelPickerBtn];
//    }
    CGRect frame = self.showTableview.frame;
    frame.size.height = 0;
    [UIView animateWithDuration:0.1
                     animations:^{
                         self.showTableview.frame =frame;
                         
                     }
                     completion:^(BOOL finished){
//                         self.frame = CGRectMake(0, self.frame.origin.y+self.frame.size.height, self.frame.size.width, self.frame.size.height);
                         [self.showTableview removeFromSuperview];
                         [self removeFromSuperview];
                         
                     }];
    _isShowInView = NO;
}


//显示
- (void)showInView:(UIView *) view
{
    if (_isShowInView) return;
    self.frame = CGRectMake(0, 40, self.frame.size.width, self.frame.size.height);
    [view addSubview:self];
    [self addSubview:self.showTableview];

    [UIView animateWithDuration:0.1 animations:^{
       self.showTableview.frame = CGRectMake(0, 0, self.width, _dataArr.count *33);
    }];
    _isShowInView = YES;
}

//消失
- (void)cancelPicker
{
    if (!_isShowInView) return;
//    if ([self.delegate respondsToSelector:@selector(didSelectedcancelPickerBtn)]) {
//        [self.delegate didSelectedcancelPickerBtn];
//    }
    CGRect frame = self.showTableview.frame;
    frame.size.height = 0;
    [UIView animateWithDuration:0.1
                     animations:^{
                          self.showTableview.frame = frame;
                         
                     }
                     completion:^(BOOL finished){
                         self.frame = CGRectMake(0, self.frame.origin.y+self.frame.size.height, self.frame.size.width, self.frame.size.height);
                         [self.showTableview removeFromSuperview];
                         [self removeFromSuperview];
                         
                     }];
    _isShowInView = NO;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isKindOfClass:[UITableView class]]) {
        return YES;
    }
    
    return  NO;
}
@end
