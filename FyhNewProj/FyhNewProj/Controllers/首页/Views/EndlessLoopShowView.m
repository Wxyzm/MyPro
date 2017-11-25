//
//  EndlessLoopShowView.m
//  EndlessLoopShowView
//
//  Created by apple on 16/9/26.
//  Copyright © 2016年 李重阳. All rights reserved.
//

#import "EndlessLoopShowView.h"
#import "EndLessView.h"
/*无限循环的视图 **/
@interface EndlessLoopShowView ()<UIScrollViewDelegate,EndLessViewDelegate>

@property (nonatomic,strong) UIScrollView * scrollView;

@property (nonatomic,strong) EndLessView *leftImageView;
@property (nonatomic,strong) EndLessView *centerImageView;
@property (nonatomic,strong) EndLessView *rightImageView;

@property (nonatomic,assign) NSInteger currentIndex;/* 当前滑动到了哪个位置**/
@property (nonatomic,assign) NSInteger imageCount;/* 图片的总个数 **/


//http://www.cnblogs.com/kenshincui/p/3913885.html#ImageViewer
@end

@implementation EndlessLoopShowView{
    
    CGFloat   _WIdth;
    
}

#pragma mark - 生命周期

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        _WIdth = 300;
        if (iPad) {
            _WIdth = 300 *TimeScaleY;
        }
        [self setupView];
    }
    return self;
}

- (void)setupView {
    
    _currentIndex = -1;
    [self addSubview:self.scrollView];
    //添加图片控件
    [self addImageViews];
}


- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    self.scrollView.frame = self.bounds;
    CGFloat imageW = CGRectGetWidth(self.scrollView.bounds) ;
    CGFloat imageH = 289;
    if (iPad) {
        imageW = CGRectGetWidth(self.scrollView.bounds);
        imageH = 289*TimeScaleY;
    }
    
    self.leftImageView.frame   = CGRectMake(imageW-305, 0, _WIdth, imageH);
    self.leftImageView.backgroundColor = [UIColor whiteColor];
    
    self.centerImageView.frame = CGRectMake(imageW+10, 0, _WIdth, imageH);
    self.centerImageView.backgroundColor = [UIColor whiteColor];

    self.rightImageView.frame  = CGRectMake(_WIdth+20+imageW , 0, _WIdth, imageH);
    self.rightImageView.backgroundColor = [UIColor whiteColor];

    self.scrollView.contentSize= CGSizeMake(imageW*3, 0);
    
    self.currentIndex = 0;
    [self setScrollViewContentOffsetCenter];
}


#pragma mark - 私有方法

#pragma mark - get/set方法
- (UIScrollView *)scrollView {
    
    if (_scrollView == nil) {
        
        _scrollView=[[UIScrollView alloc]init];
        //设置代理
        _scrollView.delegate=self;
        //设置分页
        _scrollView.pagingEnabled=YES;
        //去掉滚动条
        _scrollView.showsHorizontalScrollIndicator=NO;
    }
    return _scrollView;
}

/* 重写 setCurrent 方法 并且赋值 **/
- (void)setCurrentIndex:(NSInteger)currentIndex {
    
    if (_currentIndex != currentIndex) {
        
        _currentIndex = currentIndex;
        
        NSInteger leftImageIndex = (currentIndex+_imageCount-1)%_imageCount;
        NSInteger rightImageIndex= (currentIndex+1)%_imageCount;
//        _centerImageView.image =[UIImage imageNamed:self.imageDataArr[currentIndex]];
//        _leftImageView.image   =[UIImage imageNamed:self.imageDataArr[leftImageIndex]];
//        _rightImageView.image  =[UIImage imageNamed:self.imageDataArr[rightImageIndex]];
        
        _centerImageView.dataDic = _imageDataArr[currentIndex];
        _leftImageView.dataDic = _imageDataArr[leftImageIndex];
        _rightImageView.dataDic = _imageDataArr[rightImageIndex];

        
        [self setScrollViewContentOffsetCenter];
        
        if ([self.delegate respondsToSelector:@selector(endlessLoop:scrollToIndex:)]) {
            
            [self.delegate endlessLoop:self scrollToIndex:currentIndex];
        }
        
    }
}

#pragma mark 添加图片三个控件
-(void)addImageViews {
    
    _leftImageView=[[EndLessView alloc]init];
   // _leftImageView.contentMode=UIViewContentModeScaleAspectFill;
    _leftImageView.layer.cornerRadius = 3;
    _leftImageView.layer.borderColor = UIColorFromRGB(0xe6e9ed).CGColor;
    _leftImageView.layer.borderWidth = 1;
    _leftImageView.clipsToBounds = YES;
    _leftImageView.delegate = self;
    [_scrollView addSubview:_leftImageView];
    
    _centerImageView=[[EndLessView alloc]init];
   // _centerImageView.contentMode=UIViewContentModeScaleAspectFill;
    _centerImageView.layer.cornerRadius = 3;
    _centerImageView.layer.borderColor = UIColorFromRGB(0xe6e9ed).CGColor;
    _centerImageView.layer.borderWidth = 1;
    _centerImageView.clipsToBounds = YES;
    _centerImageView.delegate = self;
     [_scrollView addSubview:_centerImageView];
    
    _rightImageView=[[EndLessView alloc]init];
   // _rightImageView.contentMode=UIViewContentModeScaleAspectFill;
    _rightImageView.layer.cornerRadius = 3;
    _rightImageView.layer.borderColor = UIColorFromRGB(0xe6e9ed).CGColor;
    _rightImageView.layer.borderWidth = 1;
    _rightImageView.clipsToBounds = YES;
    _rightImageView.delegate = self;
    [_scrollView addSubview:_rightImageView];
}


/* 把scrollView 偏移到中心位置 **/
- (void)setScrollViewContentOffsetCenter {
    
    [self.scrollView setContentOffset:CGPointMake(CGRectGetWidth(self.scrollView.bounds), 0) animated:NO];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    CGFloat imageW = CGRectGetWidth(self.scrollView.bounds) ;
    CGFloat imageH = CGRectGetHeight(self.scrollView.bounds);
    
    self.rightImageView.frame  =  CGRectMake(_WIdth+20+imageW, 0, _WIdth, imageH);

    
    CGPoint offset=[_scrollView contentOffset];
    if (offset.x>CGRectGetWidth(scrollView.frame)) { //向右滑动
        self.currentIndex=(self.currentIndex+1)%_imageCount;
    }else if(offset.x<CGRectGetWidth(scrollView.frame)){ //向左滑动
        self.currentIndex=(self.currentIndex+_imageCount-1)%_imageCount;
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
   

}
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    CGFloat imageW = CGRectGetWidth(self.scrollView.bounds) ;
    CGFloat imageH = CGRectGetHeight(self.scrollView.bounds);
    
    self.rightImageView.frame  = CGRectMake(imageW *2 +10  , 0, _WIdth, imageH);
    self.leftImageView.frame   = CGRectMake(imageW-_WIdth-5, 0, _WIdth, imageH);
//CGRectMake(imageW-305, 0, _WIdth, imageH)

}
#pragma mark -EndLessViewDelegate

-(void)didSelectedBtnWithDic:(NSDictionary *)itemDic{

    if ([self.delegate respondsToSelector:@selector(didSelectedGoodsWithDIc:)]) {
        [self.delegate didSelectedGoodsWithDIc:itemDic];
    }

}

-(void)didSelectedBtnWithEndLessViewDic:(NSDictionary *)dataDic{

    if (!dataDic) {
        return;
    }
    if ([self.delegate respondsToSelector:@selector(didSelectedEndlessLoopShowViewWithDIc:)]) {
        [self.delegate didSelectedEndlessLoopShowViewWithDIc:dataDic];
    }

}

#pragma mark - 公共方法
- (void)setImageDataArr:(NSArray *)imageDataArr {
    NSMutableArray *dataArr = [NSMutableArray arrayWithCapacity:0];
    [dataArr addObjectsFromArray:imageDataArr];

    if (imageDataArr.count==1) {
        [dataArr addObjectsFromArray:imageDataArr];
        [dataArr addObjectsFromArray:imageDataArr];

    }else if (imageDataArr.count==1){
        [dataArr addObjectsFromArray:imageDataArr];

    }
    _imageDataArr = dataArr;
    self.imageCount = dataArr.count;
    self.currentIndex = 0;
}

@end
