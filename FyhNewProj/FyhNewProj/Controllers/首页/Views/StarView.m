//
//  StarView.m
//  FyhNewProj
//
//  Created by yh f on 2017/9/25.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "StarView.h"
static const int numberOfPage = 3;

@implementation StarView{
    UIButton *dismissButton;
    
}

- (id)init
{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self initPageScrollView];
    }
    return self;
}

- (void)initPageScrollView
{
    UIScrollView *guideScrollView = [[UIScrollView alloc] initWithFrame:self.frame];
    guideScrollView.contentSize = CGSizeMake(ScreenWidth * numberOfPage, ScreenHeight);
    guideScrollView.backgroundColor = UIColorFromRGB(WhiteColorValue);
    guideScrollView.pagingEnabled = YES;
    guideScrollView.bounces = NO;
    guideScrollView.showsHorizontalScrollIndicator = NO;
    guideScrollView.delegate = self;
    [self addSubview:guideScrollView];
    NSArray *guideImageArray;
    if (iPad) {
        guideImageArray= @[@"ipad-1", @"ipad-2", @"ipad-3"];

    }else{
        guideImageArray= @[@"star_pic1", @"star_pic2", @"star_pic3"];

    }
    // ImageViews on scrollview to show each page.
    for (int index = 0; index < numberOfPage; ++index) {
        UIImage *images = [UIImage imageNamed:guideImageArray[index]];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(index*ScreenWidth, 0, ScreenWidth, images.size.height)];
//        NSString *imagePath = [[NSBundle mainBundle] pathForResource:[guideImageArray objectAtIndex:index] ofType:@"png"];
        imageView.image = images;
        [guideScrollView addSubview: imageView];
        
        
       
    }
    // A button to dismiss user guideline.
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth-85, 50, 80, 30)];
    btn.titleLabel.font = APPFONT(15);
    [btn setTitle:@"跳过" forState:UIControlStateNormal];
    [btn setTitleColor:UIColorFromRGB(0x444a55) forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(dismissCurrentWindow) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    
    if (!pageControl) {
        pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake((ScreenWidth-numberOfPage*20)/2, ScreenHeight-62, 20*numberOfPage, 20)];
        pageControl.numberOfPages = numberOfPage;
        pageControl.backgroundColor = [UIColor clearColor];
        pageControl.pageIndicatorTintColor = UIColorFromRGB(0xeae4e4);
        pageControl.currentPageIndicatorTintColor = UIColorFromRGB(RedColorValue);
        pageControl.currentPage = 0;
        pageControl.userInteractionEnabled = NO;
        [self addSubview:pageControl];
    }
    dismissButton = [[UIButton alloc] initWithFrame:CGRectMake((ScreenWidth-90)/2, ScreenHeight-74, 90, 30)];
    dismissButton.titleLabel.font = APPFONT(16);
    [dismissButton setTitle:@"立即体验" forState:UIControlStateNormal];
    [dismissButton setTitleColor:UIColorFromRGB(WhiteColorValue) forState:UIControlStateNormal];
    dismissButton.backgroundColor = UIColorFromRGB(RedColorValue);
    dismissButton.layer.cornerRadius = 5;
    dismissButton.clipsToBounds = YES;
    [dismissButton addTarget:self action:@selector(dismissCurrentWindow) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:dismissButton];
    dismissButton.hidden = YES;
}

- (void)showWinView
{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    self.alpha = 1;
    [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:IS_FIRST_LOAD];
}

- (void)dismissCurrentWindow
{
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished){
        [self setHidden: YES];
        [self removeFromSuperview];
    }];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int pageIndex = scrollView.contentOffset.x/ScreenWidth;
    float flopageIndex = scrollView.contentOffset.x/ScreenWidth;

    if (flopageIndex >1.5) {
        dismissButton.hidden = NO;

    }else{
        
        dismissButton.hidden = YES;

    }
    pageControl.currentPage = pageIndex;
}



@end
