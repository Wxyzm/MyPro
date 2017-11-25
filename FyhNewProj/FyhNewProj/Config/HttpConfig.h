//
//  HttpConfig.h
//  FyhNewProj
//
//  Created by yh f on 2017/3/29.
//  Copyright © 2017年 fyh. All rights reserved.
//

#ifndef HttpConfig_h
#define HttpConfig_h


//#define kbaseUrl         @"https://fyh88.com"         //正式环境
#define kbaseUrl        @"http://114.55.5.207:82"      //开发测试环境


////////////////////////////用户相关///////////////////////////

//1.0.1 查看当前session登陆状态
#define UserStatusURL @"/user/login/status"

//1.0.2 用户登录
#define UserLoginURL @"/user/login"

//1.0.3 用户登出
#define UserLogoutURL @"/user/logout"

//1.0.4 发送注册的短信
#define UserRegistSMSURL @"/user/register/send-sms"

//1.0.5 注册
#define UserRegistURL @"/user/register/do-register"

//1.0.6 获取重置密码的subSession
#define UserGetRePassWordSubSessionURL @"/user/retrieve-password"

//1.0.7 发送重置密码的短信
#define UserRePasswordSMSURL @"/user/retrieve-password/send-sms"

//1.0.8 重置密码
#define UserRePasswordURL @"/user/retrieve-password/do-retrieve-password"

//1.0.9 用户注册前获取subSession
#define UserGetRegrestSubSessionURL @"/user/register"




////////////////////////////用户购物车相关///////////////////////////

//1.1.1 获取购物车数据
#define ShoppingCartAllGoodsURL @"/user/cart"

//1.1.2 添加一个商品到购物车
#define ShoppingCartAddURL(str) @"/cart/item/{"#str"}/add"

//1.1.3 删除购物车里的某个商品
#define ShoppingCartDeleteURL(str)  @"/cart/cart-item/{"#str"}/delete"

//1.1.4 修改购物车某个商品的数量
#define ShoppingCartChangeNumberURL(str) @"/cart/cart-item/{@"#str"}/quantity"

//1.1.5 修改购物车某个商品的勾选状态
#define ShoppingCartCheckURL @"/cart/cart-item/{"#str"}/check"




////////////////////////////商品相关///////////////////////////

//1.2.1 公共页面获取已经上架的商品
#define ItemSalesURL @"/items?pageNum=1&title="

//1.2.2 公共页面获取某个的商品数据
#define ItemGoodDetailURL(str) @"/item/{"#str"}"

//1.2.3 获取用户创建的商品
#define ItemUserGoodsURL @"/user/items?pageNum=1&title=&status="

//1.2.4 创建一个新商品
#define ItemNewGoodURL @"/user/items/new"

//1.2.5 获取要拷贝一个原先已经创建的商品数据，为拷贝并创建新商品准备
#define ItemCopyGoodURL @"/user/items/new?duplicateItem="

//1.2.6 查看某个创建了的商品数据
#define ItemLookURL(str) @"/user/items/{"#str"}"

//1.2.7 获取要被修改更新的商品数据
#define ItemWillEditURL(str) @"/user/items/{"#str"}/edit"

//1.2.8 修改更新商品数据
#define ItemEditURL(str) @"/user/items/{"#str"}/edit"

//1.2.9 删除创建的商品
#define ItemDeleteURL(str) @"/user/items/{"#str"}/delete"

//1.2.10 修改商品上架
#define ItemOnSaleURL(str) @"/user/items/{"#str"}/on-sale"

//1.2.11修改商品下架
#define ItemNotSaleURL(str) @"/user/items/{"#str"}/not-sale"



////////////////////////////订单相关///////////////////////////

//1.3.1 卖家获取商品订单
#define OrderSellerGoodsURL @"/user/item-orders?pageNum=1&title=&status="

//1.3.2 卖家修改订单价格
#define OrderSellerChangePriceURL(str) @"/user/item-order/{"#str"}/update-pay-amount"

//1.3.3 卖家添加物流信息并发货
#define OrderSellerLogisticsURL(str) @"/user/item-order/{"#str"}/update-logistics-after-sent-item"

//1.3.4 买家确认收货
#define OrderBuyerReceiveURL(str) @"/user/item-order/{@""#str""}/receive"

//1.3.5 买家获取他的UserOrder
#define OrderBuyerUserURL @"/user/user-orders?pageNum=1&title=&status="

//1.3.6 用户取消某个UserOrder
#define OrderBuyerCancelURL(str) @"/user/item-order/{"#str"}/cancel"



////////////////////////////结算相关///////////////////////////

//1.4.1 对某个商品结算创建订单（立即购买）
#define SettlementCheckoutURL(str) @"/user/checkout/item/{"#str"}"

//1.4.2 从购物车开始结算创建订单
#define SettlementOrderCartURL @"/user/checkout/create-order-from-cart"



////////////////////////////支付相关///////////////////////////

//1.5.1 跳到支付网页页面
#define PayOrderURL(str) @"/user/pay-user-order/{"#str"}"







#endif /* HttpConfig_h */
