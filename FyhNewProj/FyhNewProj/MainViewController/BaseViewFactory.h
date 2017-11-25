//
//  BaseViewFactory.h
//  task
//
//  Created by apple on 16/1/14.
//  Copyright © 2016年 nixinyue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface BaseViewFactory : NSObject

+ (UILabel *)labelWithFrame:(CGRect)frame
                    textColor:(UIColor *)color
                       font:(UIFont *)font
               textAligment:(NSTextAlignment)textalignment
                    andtext:(NSString*)str;


+ (UIView *)viewWithFrame:(CGRect)frame
                    color:(UIColor *)color;

+ (UIScrollView *)scrollViewWithFrame:(CGRect)frame
                                color:(UIColor *)color
                             delegate:(id<UIScrollViewDelegate>)delegate;

+ (UITextField *)textFieldWithFrame:(CGRect)frame
                               font:(UIFont *)font
                        placeholder:(NSString *)placeholder
                          textColor:(UIColor *)color
                   placeholderColor:(UIColor *)placeholderColor
                           delegate:(id<UITextFieldDelegate>)delegate;

+ (UIButton *)buttonWithHeight:(CGFloat)height imagePath:(NSString *)imagePath;
+ (UIButton *)buttonWithWidth:(CGFloat)width imagePath:(NSString *)imagePath;

+ (UIButton *)buttonWithFrame:(CGRect)frame
                         font:(UIFont *)font
                        title:(NSString *)title
                   titleColor:(UIColor *)titleColor
                    backColor:(UIColor *)backColor;

+ (UIButton *)setImagebuttonWithWidth:(CGFloat)width imagePath:(NSString *)imagePath;

//导航栏baritem
+ (UIBarButtonItem *)barItemWithTitle:(NSString *)title
                           titleColor:(UIColor *)titleColor
                               target:(id)target
                               action:(SEL)action;

+ (UIBarButtonItem *)barItemWithImagePath:(NSString *)imgPath
                                   target:(id)target
                                   action:(SEL)action;

+ (UIBarButtonItem *)barItemWithImagePath:(NSString *)imgPath
                                   height:(CGFloat)height
                                   target:(id)target
                                   action:(SEL)action;

+ (UIBarButtonItem *)spaceItemWithWidth:(CGFloat)width;

//获取一个logo图标
+ (UIImageView *)icomWithHeight:(CGFloat)height imagePath:(NSString *)imagePath;
+ (UIImageView *)icomWithWidth:(CGFloat)width imagePath:(NSString *)imagePath;

//获取一个view 前面带标题
+ (UIView *)viewWithFrame:(CGRect)frame title:(NSString *)title textField:(UITextField *)textField withLine:(BOOL)line;

@end
