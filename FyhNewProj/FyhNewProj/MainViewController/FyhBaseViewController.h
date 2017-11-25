//
//  FyhBaseViewController.h
//  FyhNewProj
//
//  Created by yh f on 2017/3/2.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseScrollView.h"
//加载的方式
typedef NS_ENUM(NSInteger, LoadWayType) {
    START_LOAD_FIRST         = 1,
    RELOAD_DADTAS            = 2,
    LOAD_MORE_DATAS          = 3
};


@interface FyhBaseViewController : UIViewController

@property (nonatomic, strong) BaseScrollView    *backView;


- (void)setBarBackBtnWithImage:(UIImage *)image;

- (void)hideBarbackBtn;
//词典转换为字符串
- (NSString*)thedictionaryToJson:(NSDictionary *)dic;


/**
 去登录页
 */
- (void)gotoLoginViewController;


/**
    创建lab
 */
- (void)createLabelWith: (UIColor *)color Font:(UIFont*) font WithSuper:(UIView *)superView Frame: (CGRect)frame Alignment:(NSTextAlignment)alignment Text:(NSString*)text;


/**
 创建直线view
 */
- (void)createLineWithColor:(UIColor *)color frame:(CGRect)frame Super: (UIView *)superView;


/**
 提示信息

 @param msg 信息
 */
- (void)showTextHud:(NSString*)msg;
- (void)showTextHudInSelfView:(NSString*)msg;


/**
 判断手机号的正则表达式

 @param mobileNum mobileNum description
 @return return value description
 */
- (BOOL)isMobileNumber:(NSString *)mobileNum;


/**
 身份证的正则表达式

 @param IDCardNumber IDCardNumber description
 @return return value description
 */
- (BOOL) IsIdentityCard:(NSString *)IDCardNumber;

/**
判断字符串是否包含空格

@param str 字符串
@return yes代表包含空格
*/
-(BOOL)isEmpty:(NSString *) str;

/**
 获取字符串的字节长度
 
 @param str 字符串
 @return int 字节长度
 */
- (int)convertToByte:(NSString*)str;

/**
 返回
 */
- (void)respondToLeftButtonClickEvent;


/**
 判断id是否是本人

 @param idStr idStr description
 @return return value description
 */
- (BOOL)ChatManiSHisSelfwithHisId:(NSString *)idStr;



//用scrollView 替换 self.view
- (void)createBackScrollView;


- (void)hideKeyBoard;

- (YLButton *)buttonWithtitle:(NSString *)title imagename:(NSString *)imageName andtextColor:(UIColor*)color font:(UIFont*)font textAli:(NSTextAlignment)Alignment titleFrame:(CGRect)titleFrame andImageFrame:(CGRect)imageFrame;

@end
