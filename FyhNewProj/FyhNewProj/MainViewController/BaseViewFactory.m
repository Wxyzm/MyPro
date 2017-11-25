//
//  BaseViewFactory.m
//  task
//
//  Created by apple on 16/1/14.
//  Copyright © 2016年 nixinyue. All rights reserved.
//

#import "BaseViewFactory.h"

@implementation BaseViewFactory

+ (UILabel *)labelWithFrame:(CGRect)frame
                  textColor:(UIColor *)color
                       font:(UIFont* )font
               textAligment:(NSTextAlignment)textalignment
                    andtext:(NSString*)str{
    
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    label.textColor = color;
    label.font = font;
    label.textAlignment = textalignment;
    label.text = str;
    return label;
}


+ (UIView *)viewWithFrame:(CGRect)frame color:(UIColor *)color
{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = color?color:[UIColor clearColor];
    return view;
}

+ (UIScrollView *)scrollViewWithFrame:(CGRect)frame color:(UIColor *)color delegate:(id<UIScrollViewDelegate>)delegate
{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:frame];
    scrollView.backgroundColor = color?color:[UIColor clearColor];
    scrollView.delegate = delegate;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    return scrollView;
}

+ (UITextField *)textFieldWithFrame:(CGRect)frame
                               font:(UIFont *)font
                        placeholder:(NSString *)placeholder
                          textColor:(UIColor *)color
                   placeholderColor:(UIColor *)placeholderColor
                           delegate:(id<UITextFieldDelegate>)delegate
{
    UITextField *textField = [[UITextField alloc] initWithFrame:frame];
    textField.font = font;
    textField.textColor = color;
    textField.placeholder = placeholder;
    textField.delegate = delegate;
    
    if (placeholderColor)
        textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder attributes:@{NSForegroundColorAttributeName:placeholderColor}];
    [textField setAutocorrectionType:UITextAutocorrectionTypeNo];
    [textField setAutocapitalizationType:UITextAutocapitalizationTypeNone];

    

    return textField;
}

+ (UIButton *)buttonWithFrame:(CGRect)frame
                         font:(UIFont *)font
                        title:(NSString *)title
                   titleColor:(UIColor *)titleColor
                    backColor:(UIColor *)backColor
{
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    button.titleLabel.font = font;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    if (backColor) {
        button.backgroundColor = backColor;
    } else {
        button.backgroundColor = [UIColor clearColor];
    }
    return button;
}

+ (UIButton *)buttonWithHeight:(CGFloat)height imagePath:(NSString *)imagePath
{
    UIImage *image = [UIImage imageNamed:imagePath];
    CGFloat width = image.size.width*height/image.size.height;
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    return button;
}

+ (UIButton *)buttonWithWidth:(CGFloat)width imagePath:(NSString *)imagePath
{
    UIImage *image = [UIImage imageNamed:imagePath];
    CGFloat height = image.size.height*width/image.size.width;
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    return button;
}
+ (UIButton *)setImagebuttonWithWidth:(CGFloat)width imagePath:(NSString *)imagePath
{
    UIImage *image = [UIImage imageNamed:imagePath];
    CGFloat height = image.size.height*width/image.size.width;
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    [button setImage:image forState:UIControlStateNormal];
    return button;
}

//导航栏按钮创建
+ (UIBarButtonItem *)barItemWithTitle:(NSString *)title
                           titleColor:(UIColor *)titleColor
                               target:(id)target
                               action:(SEL)action
{
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 10, 44)];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = APPFONT(16);
    if (titleColor) {
        [button setTitleColor:titleColor forState:UIControlStateNormal];
    } else {
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    [button sizeToFit];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    return item;
}

+ (UIBarButtonItem *)barItemWithImagePath:(NSString *)imgPath
                                   target:(id)target
                                   action:(SEL)action
{
    UIImage *image = [UIImage imageNamed:imgPath];
    if (!image) return nil;
    CGFloat imgHeight = 20;
    CGFloat imgWidth = image.size.width*imgHeight/image.size.height;
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, imgWidth, imgHeight)];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    return item;
}

+ (UIBarButtonItem *)barItemWithImagePath:(NSString *)imgPath
                                   height:(CGFloat)height
                                   target:(id)target
                                   action:(SEL)action
{
    UIImage *image = [UIImage imageNamed:imgPath];
    if (!image) return nil;
    CGFloat imgHeight = height;
    CGFloat imgWidth = image.size.width*imgHeight/image.size.height;
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, imgWidth, imgHeight)];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    return item;
}

+ (UIBarButtonItem *)spaceItemWithWidth:(CGFloat)width
{
    UIBarButtonItem *negativeSeperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSeperator.width = width;
    return negativeSeperator;
}

//获取一个logo图标
+ (UIImageView *)icomWithHeight:(CGFloat)height imagePath:(NSString *)imagePath
{
    UIImage *image = [UIImage imageNamed:imagePath];
    if (!image) return nil;
    CGFloat width = image.size.width*height/image.size.height;
    UIImageView *logo = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    logo.image = image;
    return logo;
}

+ (UIImageView *)icomWithWidth:(CGFloat)width imagePath:(NSString *)imagePath
{
    UIImage *image = [UIImage imageNamed:imagePath];
    if (!image) return nil;
    CGFloat height = image.size.height*width/image.size.width;
    UIImageView *logo = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    logo.image = image;
    return logo;
}

//获取一个view 前面带标题
+ (UIView *)viewWithFrame:(CGRect)frame title:(NSString *)title textField:(UITextField *)textField withLine:(BOOL)line
{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor whiteColor];
    [view addSubview:textField];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, ScreenWidth/2, frame.size.height)];
    label.font = APPFONT(15);
    label.textColor = UIColorFromRGB(BlackColorValue);
    label.text = title;
    [view addSubview:label];
    if (textField) [view addSubview:textField];
    if (line) {
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(14.5, view.height-0.5, view.width-14.5, 0.5)];
        line.backgroundColor = UIColorFromRGB(LineColorValue);
        [view addSubview:line];
    }
    return view;
}

@end
