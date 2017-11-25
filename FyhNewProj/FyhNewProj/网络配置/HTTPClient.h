//
//  HTTPClient.h
//  mry
//
//  Created by apple on 16/1/27.
//  Copyright © 2016年 mibao. All rights reserved.
//

#import "AFNetworking.h"

#define PageSize          10    //分页加载时  每页的数量
#define NET_TIME_OUT      30

// NetWorkReturn
typedef void (^PLReturnValueBlock) (id returnValue);
typedef void (^PLErrorCodeBlock) (NSString *msg);
//定义返回请求数据的block类型
typedef void (^ReturnBlock) (id returnValue, NSString *errormsg);      //网络请求成功
typedef void (^ErrorBlock) ();                                         //网络请求失败


@interface HTTPClient : NSObject

//获取登录后存于本地的  FYH-Session-Id
+ (NSString *)getUserSessiond;

+ (HTTPClient *)sharedHttpClient;

- (instancetype)initWithBaseUrl:(NSString *)baseUrl;

//get方式获取
- (void)GET:(NSString *)url
       dict:(NSDictionary *)dict
    success:(void(^)(NSDictionary *resultDic))successBlock
    failure:(void(^)(AFHTTPRequestOperation *operation, NSError *error))failureBlock;

- (void)GET:(NSString *)url
       dict:(NSDictionary *)dict
htmlSuccess:(void(^)(id returnValue))successBlock
    failure:(void(^)(AFHTTPRequestOperation *operation, NSError *error))failureBlock;

//post方式获取
- (void)POST:(NSString *)url
        dict:(NSDictionary *)dict
     success:(void(^)(NSDictionary *resultDic))successBlock
     failure:(void(^)(AFHTTPRequestOperation *operation, NSError *error))failureBlock;




//json解析
+ (id)valueWithJsonString:(NSString *)jsonString;


////////////////////////////////////////////用户相关///////////////////////////////////////
#pragma mark - ⭐️ ⭐️ ⭐️ ⭐️ ⭐️户相关 ⭐️ ⭐️ ⭐️ ⭐️ ⭐️

#pragma mark - 查看当前session登陆状态
- (void)lookUserLoginStatuswithReturnBlock:(PLReturnValueBlock)ReturnBlock
                             andErrorBlock:(PLErrorCodeBlock)errorCodeBlock;


#pragma mark - 用户登录
- (void)userLoginName:(NSString *)loginName
             Password:(NSString *)password
      withReturnBlock:(PLReturnValueBlock)ReturnBlock
        andErrorBlock:(PLErrorCodeBlock)errorCodeBlock;

#pragma mark - 用户登出
- (void)userLogoutwithReturnBlock:(PLReturnValueBlock)ReturnBlock
        andErrorBlock:(PLErrorCodeBlock)errorCodeBlock;

#pragma mark - 获取用户id
- (void)usergetIdwithReturnBlock:(PLReturnValueBlock)ReturnBlock
                    andErrorBlock:(PLErrorCodeBlock)errorCodeBlock;

#pragma mark - 用户注册前获取subSession
- (void)getUserSubSessionwithReturnBlock:(PLReturnValueBlock)ReturnBlock
                    andErrorBlock:(PLErrorCodeBlock)errorCodeBlock;

#pragma mark - 发送注册的短信
- (void)sendRegisterSMSWuthInfoDic:(NSDictionary *)infoDic
                   withReturnBlock:(PLReturnValueBlock)ReturnBlock
                     andErrorBlock:(PLErrorCodeBlock)errorCodeBlock;


#pragma mark - 注册
- (void)UserRegisterWithInfoDic:(NSDictionary *)infoDic
                withReturnBlock:(PLReturnValueBlock)ReturnBlock
                  andErrorBlock:(PLErrorCodeBlock)errorCodeBlock;


#pragma mark - 获取重置密码的subSession
- (void)getUserRetrievePasswordSubSessionwithReturnBlock:(PLReturnValueBlock)ReturnBlock
                                           andErrorBlock:(PLErrorCodeBlock)errorCodeBlock;


#pragma mark - 发送重置密码的短信
- (void)sendRetrievePasswordSMSWuthInfoDic:(NSDictionary *)infoDic
                           withReturnBlock:(PLReturnValueBlock)ReturnBlock
                             andErrorBlock:(PLErrorCodeBlock)errorCodeBlock;


#pragma mark - 重置密码
- (void)userRetrievePasswordWuthInfoDic:(NSDictionary *)infoDic
                        withReturnBlock:(PLReturnValueBlock)ReturnBlock
                        andErrorBlock:(PLErrorCodeBlock)errorCodeBlock;

////////////////////////////////////////////协议///////////////////////////////////////
#pragma mark - ⭐️ ⭐️ ⭐️ ⭐️ ⭐️协议 ⭐️ ⭐️ ⭐️ ⭐️ ⭐️

#pragma mark - 注册协议网页地址
#pragma mark - 入驻协议网页地址

////////////////////////////////////////////实名认证//////////////////////////////////////
#pragma mark - ⭐️ ⭐️ ⭐️ ⭐️ ⭐️实名认证 ⭐️ ⭐️ ⭐️ ⭐️ ⭐️

#pragma mark - 获取实名认证状态
- (void)userGetcertifiCationStatusReturnBlock:(PLReturnValueBlock)returnBlock
                                andErrorBlock:(PLErrorCodeBlock)errorBlick;
#pragma mark - 个人实名认证
#pragma mark - 企业实名认证
#pragma mark - 获取实名认证状态
- (void)bussuserGetcertifiCationStatusReturnBlock:(PLReturnValueBlock)returnBlock
                                    andErrorBlock:(PLErrorCodeBlock)errorBlick;
////////////////////////////////////////////设置自定义数据///////////////////////////////////////
#pragma mark - ⭐️ ⭐️ ⭐️ ⭐️ ⭐️店铺设置相关⭐️ ⭐️ ⭐️ ⭐️ ⭐️

#pragma mark - 获取当前店铺的设置信息
- (void)getUserShopInfoWithReturnBlock:(PLReturnValueBlock)ReturnBlock
                            andErrorBlock:(PLErrorCodeBlock)errorCodeBlock;

#pragma mark - 设置自定义数据
- (void)UserSetCustomInfoWithInfoDic:(NSDictionary *)infoDic
                     withReturnBlock:(PLReturnValueBlock)ReturnBlock
                           andErrorBlock:(PLErrorCodeBlock)errorCodeBlock;


#pragma mark - 获取自定义数据
- (void)UserGetustomInfoWithInfoDic:(NSDictionary *)infoDic
                    withReturnBlock:(PLReturnValueBlock)ReturnBlock
                           andErrorBlock:(PLErrorCodeBlock)errorCodeBlock;


#pragma mark - 设置店铺名

#pragma mark - 设置店铺Logo图片地址

#pragma mark - 设置店铺店招图片地址

#pragma mark - 设置店铺地址

#pragma mark - 设置店铺所在地

#pragma mark - 批量设置店铺信息
- (void)userSettingShopInfoWithinfoDic:(NSDictionary *)infoDic ReturnBlock:(PLReturnValueBlock)ReturnBlock
                             andErrorBlock:(PLErrorCodeBlock)errorCodeBlock;


////////////////////////////////////////////店铺页面///////////////////////////////////////
#pragma mark - ⭐️ ⭐️ ⭐️ ⭐️ ⭐️店铺页面⭐️ ⭐️ ⭐️ ⭐️ ⭐️

#pragma mark - 搜索店铺

#pragma mark - 买家查看店铺信息
- (void)getShopInfoWiId:(NSString *)shopid andDic:(NSDictionary *)dic andReturnBlock:(PLReturnValueBlock)ReturnBlock andErrorBlock:(PLErrorCodeBlock)errorCodeBlock;



////////////////////////////////////////////用户购物车相关///////////////////////////////////////
#pragma mark - ⭐️ ⭐️ ⭐️ ⭐️ ⭐️用户购物车相关⭐️ ⭐️ ⭐️ ⭐️ ⭐️

#pragma mark - 获取购物车数据
- (void)userGetShopCartDatasWithReturnBlock:(PLReturnValueBlock)ReturnBlock andErrorBlock:(PLErrorCodeBlock)errorCodeBlock;


#pragma mark - 添加一个商品到购物车
- (void)UserAddGoodsIetmsIntoBuyCaryWithGoodsNumber:(NSString *)number andid:(NSString *)goodsid ReturnBlock:(PLReturnValueBlock)ReturnBlock andErrorBlock:(PLErrorCodeBlock)errorCodeBlock;


#pragma mark - 删除购物车里的某个商品
- (void)deleteShopCartItemWithId:(NSString *)itemId
                  andReturnBlock:(PLReturnValueBlock)ReturnBlock
                   andErrorBlock:(PLErrorCodeBlock)errorCodeBlock;



#pragma mark - 批量修改购物车商品数量与勾选
- (void)changeShopCartItemWithId:(NSString *)itemStr
                  andReturnBlock:(PLReturnValueBlock)ReturnBlock
                   andErrorBlock:(PLErrorCodeBlock)errorCodeBlock;

#pragma mark - 修改购物车某个商品的勾选状态

////////////////////////////////////////////商品相关///////////////////////////////////////
#pragma mark - ⭐️ ⭐️ ⭐️ ⭐️ ⭐️商品相关 ⭐️ ⭐️ ⭐️ ⭐️ ⭐️

#pragma mark - 公共页面获取已经上架的商品
- (void)GETGoodsIetmsWithDic:(NSDictionary *)dic ReturnBlock:(PLReturnValueBlock)ReturnBlock andErrorBlock:(PLErrorCodeBlock)errorCodeBlock;


#pragma mark - 获取商品类目数据

- (void)getGoodsCategorywithReturnBlock:(PLReturnValueBlock)ReturnBlock
                          andErrorBlock:(PLErrorCodeBlock)errorCodeBlock;

#pragma mark - 获取发布商品类目数据
- (void)getFabuGoodsCategorywithReturnBlock:(PLReturnValueBlock)ReturnBlock
                              andErrorBlock:(PLErrorCodeBlock)errorCodeBlock;


#pragma mark - 公共页面获取某个的商品数据

- (void)clientgetGoodsdetailwithGoodsId:(NSString *)GoodsId  ReturnBlock:(PLReturnValueBlock)ReturnBlock
                          andErrorBlock:(PLErrorCodeBlock)errorCodeBlock;

#pragma mark - 获取用户创建的商品
- (void)userGetHisGoodsWithDic:(NSDictionary *)dic ReturnBlock:(PLReturnValueBlock)ReturnBlock andErrorBlock:(PLErrorCodeBlock)errorCodeBlock;



#pragma mark - 创建一个新商品

#pragma mark - 获取要拷贝一个原先已经创建的商品数据，为拷贝并创建新商品准备

#pragma mark - 查看某个创建了的商品数据

#pragma mark - 获取要被修改更新的商品数据
- (void)userGetEditGoodsInfoWithId:(NSString *)itemId
                       ReturnBlock:(PLReturnValueBlock)ReturnBlock
                     andErrorBlock:(PLErrorCodeBlock)errorCodeBlock;


#pragma mark - 修改更新商品数据
- (void)userupdataGoodsInfoId:(NSString *)itemId
                     Withinfo:(NSDictionary *)infoDic
                  ReturnBlock:(PLReturnValueBlock)ReturnBlock
                andErrorBlock:(PLErrorCodeBlock)errorCodeBlock;


#pragma mark - 删除创建的商品
- (void)userDeleteHisGoodsWithGoodsid:(NSString *)goodsId
                          ReturnBlock:(PLReturnValueBlock)returnBlock
                        andErrorBlock:(PLErrorCodeBlock)errorBlock;

#pragma mark - 修改商品上架
- (void)userUpHisGoodsWithGoodsid:(NSString *)goodsId
                      ReturnBlock:(PLReturnValueBlock)returnBlock
                    andErrorBlock:(PLErrorCodeBlock)errorBlock;

#pragma mark - 修改商品下架
- (void)userDownHisGoodsWithGoodsid:(NSString *)goodsId
                        ReturnBlock:(PLReturnValueBlock)returnBlock
                      andErrorBlock:(PLErrorCodeBlock)errorBlock;

////////////////////////////////////////////多规格商品相关///////////////////////////////////////
#pragma mark - ⭐️ ⭐️ ⭐️ ⭐️ ⭐️多规格商品相关 ⭐️ ⭐️ ⭐️ ⭐️ ⭐️

#pragma mark - 创建规格

#pragma mark - 批量创建规格
- (void)batchSomeSpecificationwithinfoDic:(NSDictionary *)infodic
                          ReturnBlock:(PLReturnValueBlock)ReturnBlock
                          andErrorBlock:(PLErrorCodeBlock)errorCodeBlock;

#pragma mark - 修改规格的memo

#pragma mark - 修改规格

#pragma mark - 获取规格

#pragma mark - 创建产品
- (void)newProductwithInfoDic:(NSDictionary *)infodic
                  ReturnBlock:(PLReturnValueBlock)ReturnBlock
                andErrorBlock:(PLErrorCodeBlock)errorCodeBlock;


#pragma mark - 编辑产品
- (void)userChangeProductwithInfoDic:(NSDictionary *)infodic
                           andItemId:(NSString *)itemId
                         ReturnBlock:(PLReturnValueBlock)ReturnBlock
                       andErrorBlock:(PLErrorCodeBlock)errorCodeBlock;

#pragma mark - 产品上架
- (void)userUpProductwithProId:(NSString *)proId
                   ReturnBlock:(PLReturnValueBlock)ReturnBlock
                 andErrorBlock:(PLErrorCodeBlock)errorCodeBlock;

#pragma mark - 产品下架
- (void)userDownProductwithProId:(NSString *)proId
                     ReturnBlock:(PLReturnValueBlock)ReturnBlock
                   andErrorBlock:(PLErrorCodeBlock)errorCodeBlock;

#pragma mark - 产品加入样品间
#pragma mark - 产品移出样品间

#pragma mark - 批量产品加入样品间
- (void)probatchsetissamplewithInfoDic:(NSDictionary *)infodic
                           ReturnBlock:(PLReturnValueBlock)ReturnBlock
                         andErrorBlock:(PLErrorCodeBlock)errorCodeBlock;

#pragma mark - 批量产品移出样品间
- (void)probatchsetnotsamplewithInfoDic:(NSDictionary *)infodic
                            ReturnBlock:(PLReturnValueBlock)ReturnBlock
                          andErrorBlock:(PLErrorCodeBlock)errorCodeBlock;
#pragma mark - 产品删除
- (void)userDeleteProductwithProId:(NSString *)proId
                       ReturnBlock:(PLReturnValueBlock)ReturnBlock
                     andErrorBlock:(PLErrorCodeBlock)errorCodeBlock;
#pragma mark - 覆盖编辑产品下商品的共有属性
#pragma mark - 获取产品下所有规格组合的商品状态
#pragma mark - 获取库存警报的产品
- (void)userGetInventoryAlertProductwithInfoDic:(NSDictionary *)infodic
                            ReturnBlock:(PLReturnValueBlock)ReturnBlock
                          andErrorBlock:(PLErrorCodeBlock)errorCodeBlock;


#pragma mark - 获取用户创建的产品
- (void)userGetMasterProductwithInfoDic:(NSDictionary *)infodic
                         ReturnBlock:(PLReturnValueBlock)ReturnBlock
                       andErrorBlock:(PLErrorCodeBlock)errorCodeBlock;




#pragma mark - 获取某个产品信息
- (void)userGetMasterProductDetailwithProId:(NSString *)proId
                                ReturnBlock:(PLReturnValueBlock)ReturnBlock
                              andErrorBlock:(PLErrorCodeBlock)errorCodeBlock;




#pragma mark - 从产品创建具体规格的商品

#pragma mark - 从产品根据规格组合批量创建商品
- (void)generateProductitemswithInfoDic:(NSDictionary *)infodic
                            ReturnBlock:(PLReturnValueBlock)ReturnBlock
                          andErrorBlock:(PLErrorCodeBlock)errorCodeBlock;



#pragma mark - 获取某产品下的商品

////////////////////////////////////////////商品收藏///////////////////////////////////////
#pragma mark - ⭐️ ⭐️ ⭐️ ⭐️ ⭐️商品收藏⭐️ ⭐️ ⭐️ ⭐️ ⭐️

#pragma mark - 收藏某个商品
- (void)userColectGoodsWithId:(NSString *)goodId
                  ReturnBlock:(PLReturnValueBlock)ReturnBlock
                andErrorBlock:(PLErrorCodeBlock)errorCodeBlock;



#pragma mark - 删除某个收藏
- (void)useracancleColectGoodsWithId:(NSString *)goodId
                  ReturnBlock:(PLReturnValueBlock)ReturnBlock
                andErrorBlock:(PLErrorCodeBlock)errorCodeBlock;
#pragma mark - 获取用户的商品收藏
- (void)getUserGoodsCollecteShopWithDic:(NSDictionary *)dic andReturnBlock:(PLReturnValueBlock)returnBlock andErrorBlock:(PLErrorCodeBlock)errorBlick;




///////////////////////////////////////////店铺收藏///////////////////////////////////////
#pragma mark - ⭐️ ⭐️ ⭐️ ⭐️ ⭐️商品收藏⭐️ ⭐️ ⭐️ ⭐️ ⭐️
#pragma mark - 收藏某个店铺
- (void)userCollectShopWithShopDic:(NSDictionary *)dic
                       ReturnBlock:(PLReturnValueBlock)ReturnBlock
                     andErrorBlock:(PLErrorCodeBlock)errorCodeBlock;

#pragma mark - 取消收藏某个店铺
- (void)userCancelCollectShopWithShopDic:(NSDictionary *)dic
                       ReturnBlock:(PLReturnValueBlock)ReturnBlock
                     andErrorBlock:(PLErrorCodeBlock)errorCodeBlock;
#pragma mark - 获取用户收藏的店铺
- (void)getUserShopsCollecteShopWithDic:(NSDictionary *)dic andReturnBlock:(PLReturnValueBlock)returnBlock andErrorBlock:(PLErrorCodeBlock)errorBlick;

////////////////////////////////////////////用户轮廓相关///////////////////////////////////////
#pragma mark - ⭐️ ⭐️ ⭐️ ⭐️ ⭐️用户轮廓相关⭐️ ⭐️ ⭐️ ⭐️ ⭐️

#pragma mark - 获取用户轮廓信息
- (void)getUserInfowithReturnBlock:(PLReturnValueBlock)ReturnBlock
                           andErrorBlock:(PLErrorCodeBlock)errorCodeBlock;


#pragma mark - 设置更新轮廓信息

- (void)refreshUserInfoWithInfoDic:(NSDictionary *)infoDic withReturnBlock:(PLReturnValueBlock)ReturnBlock
                     andErrorBlock:(PLErrorCodeBlock)errorCodeBlock;



#pragma mark - 设置用户昵称

#pragma mark - 设置用户头像地址


////////////////////////////////////////////用户收货地址相关///////////////////////////////////////
#pragma mark - ⭐️ ⭐️ ⭐️ ⭐️ ⭐️用户收货地址相关⭐️ ⭐️ ⭐️ ⭐️ ⭐️

#pragma mark - 创建收货地址

- (void)usersetUpAcceptAdressWithDic:(NSDictionary *)infoDic withReturnBlock:(PLReturnValueBlock)ReturnBlock
                       andErrorBlock:(PLErrorCodeBlock)errorCodeBlock;



#pragma mark - 更新收货地址
- (void)userEditAdressWithAdressId:(NSString *)adressID
                        andInfoDic:(NSDictionary *)dic
                   WithReturnBlock:(PLReturnValueBlock)ReturnBlock
                     andErrorBlock:(PLErrorCodeBlock)errorCodeBlock;


#pragma mark - 获取某个收货地址数据

#pragma mark - 删除某收货地址
- (void)userdeleteAdressWithAdressId:(NSString *)adressID
                     WithReturnBlock:(PLReturnValueBlock)ReturnBlock
                       andErrorBlock:(PLErrorCodeBlock)errorCodeBlock;
#pragma mark - 获取用户所有收货地址
- (void)getUserAllAdressWithReturnBlock:(PLReturnValueBlock)ReturnBlock
                          andErrorBlock:(PLErrorCodeBlock)errorCodeBlock;


#pragma mark - 设置某个地址为默认地址
- (void)userSetdefaultAdressWithAdressId:(NSString *)adressID
                         WithReturnBlock:(PLReturnValueBlock)ReturnBlock
                           andErrorBlock:(PLErrorCodeBlock)errorCodeBlock;


#pragma mark - 获取默认收货地址




////////////////////////////////////////////订单相关///////////////////////////////////////
#pragma mark - ⭐️ ⭐️ ⭐️ ⭐️ ⭐️订单相关⭐️ ⭐️ ⭐️ ⭐️ ⭐️
#pragma mark - 卖家获取相关商品订单数目数据
- (void)sellersGetordercountsWithReturnBlock:(PLReturnValueBlock)returnBlock
                              andErrorBlock:(PLErrorCodeBlock)errorBlick;

#pragma mark - 卖家获取分组后的商品订单
- (void)SellersGetHisGroupItemOrderwithInfoDic:(NSDictionary *)dic
                                andReturnBlock:(PLReturnValueBlock)ReturnBlock
                                 andErrorBlock:(PLErrorCodeBlock)errorCodeBlock;

#pragma mark - 卖家获取商品订单

#pragma mark - 卖家修改订单价格

#pragma mark - 获取物流公司列表


#pragma mark - 卖家批量添加物流信息并发货
- (void)SellersupdatelogisticswithInfoDic:(NSDictionary *)dic
                            andReturnBlock:(PLReturnValueBlock)ReturnBlock
                            andErrorBlock:(PLErrorCodeBlock)errorCodeBlock;



#pragma mark - 卖家添加商品订单memo

#pragma mark - 买家批量确认收货
- (void)buyersmakeSureAcceptedGoodsWithinfoDic:(NSDictionary *)infoDic
                                   ReturnBlock:(PLReturnValueBlock)returnBlock
                                 andErrorBlock:(PLErrorCodeBlock)errorBlick;


#pragma mark - 买家确认收货

#pragma mark - 买家获取相关商品订单数目数据
- (void)buyersGetordercountsWithReturnBlock:(PLReturnValueBlock)returnBlock
                              andErrorBlock:(PLErrorCodeBlock)errorBlick;

#pragma mark - 买家获取他按照卖家分组后的ItemOrder
- (void)buyersGetHisgroupItemOrderswithInfoDic:(NSDictionary *)dic
                          andReturnBlock:(PLReturnValueBlock)ReturnBlock
                           andErrorBlock:(PLErrorCodeBlock)errorCodeBlock;


#pragma mark - 买家获取他的ItemOrder
- (void)buyersGetHisItemOrderwithInfoDic:(NSDictionary *)dic
                          andReturnBlock:(PLReturnValueBlock)ReturnBlock
                           andErrorBlock:(PLErrorCodeBlock)errorCodeBlock;
#pragma mark - 买家获取他的UserOrder
- (void)buyersGetHisUserOrderwithInfoDic:(NSDictionary *)dic
                          andReturnBlock:(PLReturnValueBlock)ReturnBlock
                           andErrorBlock:(PLErrorCodeBlock)errorCodeBlock;
#pragma mark - 买家取消某个UserOrder
- (void)buyersCancleUserOrderwithorderID:(NSString *)orderId
                          andReturnBlock:(PLReturnValueBlock)ReturnBlock
                           andErrorBlock:(PLErrorCodeBlock)errorCodeBlock;

#pragma mark -买家取消他未付款的某个商品某个ItemOrder
#pragma mark - 买家删除某个UserOrder
- (void)buyersDeleteHisUserOrderwithOrderId:(NSString *)orderId
                             andReturnBlock:(PLReturnValueBlock)ReturnBlock
                              andErrorBlock:(PLErrorCodeBlock)errorCodeBlock;

////////////////////////////////////////////结算相关///////////////////////////////////////
#pragma mark - ⭐️ ⭐️ ⭐️ ⭐️ ⭐️协议结算相关⭐️ ⭐️ ⭐️ ⭐️ ⭐️

#pragma mark - 对某个商品结算创建订单（立即购买）
- (void)userPayAtOnceWithId:(NSString *)proId andDic:(NSDictionary *)dic andReturnBlock:(PLReturnValueBlock)returnBlock andErrorBlock:(PLErrorCodeBlock)errorBlick;
#pragma mark - 从购物车开始结算创建订单
- (void)settlementMoneyWithdic:(NSDictionary*)dic andReturnBlock:(PLReturnValueBlock)returnBlock andErrorBlock:(PLErrorCodeBlock)errorBlock;

////////////////////////////////////////////支付相关///////////////////////////////////////
#pragma mark - ⭐️ ⭐️ ⭐️ ⭐️ ⭐️支付相关 ⭐️ ⭐️ ⭐️ ⭐️ ⭐️

#pragma mark - 跳到支付网页页面

#pragma mark -  检查用户订单是否已经支付成功

#pragma mark - 获取调用支付宝APP支付SDK需要用到的orderStr参数
- (void)getAilPayOrderStrWithOrderId:(NSString *)orderStr andReturnBlock:(PLReturnValueBlock)returnBlock andErrorBlock:(PLErrorCodeBlock)errorBlock;

#pragma mark - 获取调用微信APP支付SDK需要用到的参数
- (void)getWeixinPayOrderStrWithOrderId:(NSString *)orderStr andReturnBlock:(PLReturnValueBlock)returnBlock andErrorBlock:(PLErrorCodeBlock)errorBlock;
////////////////////////////////////////////采购需求///////////////////////////////////////
#pragma mark - ⭐️ ⭐️ ⭐️ ⭐️ ⭐️采购需求 ⭐️ ⭐️ ⭐️ ⭐️ ⭐️

#pragma mark - 获取采购需求的类目
- (void)getpurchasingneedcategorylistwithReturnBlock:(PLReturnValueBlock)ReturnBlock
                     andErrorBlock:(PLErrorCodeBlock)errorCodeBlock;


#pragma mark - 公共页面查看采购需求详情

/**
 公共页面查看采购需求详情

 @param needId id
 @param ReturnBlock ReturnBlock description
 @param errorCodeBlock errorCodeBlock description
 */
- (void)PublicGetPurchasingNeedDetailithDic:(NSString   *)needId andReturnBlock:(PLReturnValueBlock)ReturnBlock
                             andErrorBlock:(PLErrorCodeBlock)errorCodeBlock;

#pragma mark - 用户创建采购需求
- (void)userUpGoodwithDic:(NSDictionary *)infoDic ReturnBlock:(PLReturnValueBlock)ReturnBlock
                                       andErrorBlock:(PLErrorCodeBlock)errorCodeBlock;


#pragma mark - 用户获取被编辑采购需求的数据
- (void)userGetPurchasingNeedWithNeedId:(NSString *)needId WithReturnBlock:(PLReturnValueBlock)ReturnBlock
                             andErrorBlock:(PLErrorCodeBlock)errorCodeBlock;
#pragma mark - 用户删除他的采购需求
- (void)userDeletePurchasingNeedWithNeedId:(NSString *)needId WithReturnBlock:(PLReturnValueBlock)ReturnBlock
                             andErrorBlock:(PLErrorCodeBlock)errorCodeBlock;

#pragma mark - 用户编辑采购需求
- (void)userEditPurchasingNeedWithNeedId:(NSString *)needId  andDic:(NSDictionary *)dic WithReturnBlock:(PLReturnValueBlock)ReturnBlock
                             andErrorBlock:(PLErrorCodeBlock)errorCodeBlock;

#pragma mark - 用户查看他创建的采购
- (void)userLookHisNeedwithDic:(NSDictionary *)infoDic WithReturnBlock:(PLReturnValueBlock)ReturnBlock
                 andErrorBlock:(PLErrorCodeBlock)errorCodeBlock;


#pragma mark - 公共页面查看采购需求
- (void)PublicGetPurchasingNeedListWithDic:(NSDictionary *)dic andReturnBlock:(PLReturnValueBlock)ReturnBlock
                             andErrorBlock:(PLErrorCodeBlock)errorCodeBlock;
#pragma mark - 公共页面查看过期的采购需求
#pragma mark - 供应商创建报价
- (void)PublicSellerSubmitPriceWithneedDic:(NSDictionary *)dic ReturnBlock:(PLReturnValueBlock)ReturnBlock andErrorBlock:(PLErrorCodeBlock)errorCodeBlock;

#pragma mark - 用户查看采购需求详情包括供应商的报价
- (void)userLookHisNeedwithPricewithId:(NSString *)needId
                       WithReturnBlock:(PLReturnValueBlock)ReturnBlock
                         andErrorBlock:(PLErrorCodeBlock)errorCodeBlock;


#pragma mark - 采购者接受供应商的报价
- (void)userAcceptNeedwithPricewithId:(NSString *)needId
                       WithReturnBlock:(PLReturnValueBlock)ReturnBlock
                         andErrorBlock:(PLErrorCodeBlock)errorCodeBlock;

#pragma mark - 供应商获取他报过的价
- (void)sellerLookHisNeedwithPricewithDic:(NSDictionary *)infoDic
                          WithReturnBlock:(PLReturnValueBlock)ReturnBlock
                            andErrorBlock:(PLErrorCodeBlock)errorCodeBlock;

#pragma mark - 供应商获取他某个报价详情
- (void)sellerGetHisNeedDetailwithDic:(NSString *)needId
                          WithReturnBlock:(PLReturnValueBlock)ReturnBlock
                            andErrorBlock:(PLErrorCodeBlock)errorCodeBlock;

#pragma mark - 供应商删掉他已经被接受的报价
- (void)sellerDeleteHisNeedwithPricewithDic:(NSString *)needId
                          WithReturnBlock:(PLReturnValueBlock)ReturnBlock
                            andErrorBlock:(PLErrorCodeBlock)errorCodeBlock;

#pragma mark - 收藏某个采购需求
- (void)userCollectNeedWithDic:(NSDictionary *)dic
               WithReturnBlock:(PLReturnValueBlock)ReturnBlock
                 andErrorBlock:(PLErrorCodeBlock)errorCodeBlock;
#pragma mark - 取消收藏某个采购需求
- (void)userCancleCollectNeedWithDic:(NSDictionary *)dic
                     WithReturnBlock:(PLReturnValueBlock)ReturnBlock
                       andErrorBlock:(PLErrorCodeBlock)errorCodeBlock;
#pragma mark - 获取用户收藏的采购需求
- (void)getUserCollectNeedsWithDic:(NSDictionary *)dic
                   WithReturnBlock:(PLReturnValueBlock)ReturnBlock
                   andErrorBlock:(PLErrorCodeBlock)errorCodeBlock;

////////////////////////////////////////////其他///////////////////////////////////////
#pragma mark - ⭐️ ⭐️ ⭐️ ⭐️ ⭐️其他 ⭐️ ⭐️ ⭐️ ⭐️ ⭐️
#pragma mark 融云token

- (void)getRcTokenwithReturnBlock:(PLReturnValueBlock)ReturnBlock andErrorBlock:(PLErrorCodeBlock)errorCodeBlock;

#pragma mark 批量获取聊天对方数据
- (void)getRcsellersinfogetRcsellersinfoWithdic:(NSDictionary *)dic  withReturnBlock:(PLReturnValueBlock)ReturnBlock andErrorBlock:(PLErrorCodeBlock)errorCodeBlock;

#pragma mark 获取手机App首页配置数据
- (void)getHomePageDataswithReturnBlock:(PLReturnValueBlock)ReturnBlock andErrorBlock:(PLErrorCodeBlock)errorCodeBlock;



////////////////////////////////////////////财务相关///////////////////////////////////////
#pragma mark - ⭐️ ⭐️ ⭐️ ⭐️ ⭐️财务相关⭐️ ⭐️ ⭐️ ⭐️ ⭐️

#pragma mark 获取用户的银行卡
- (void)usergethisBankCardWithReturnBlock:(PLReturnValueBlock)returnBlock
                            andErrorBlock:(PLErrorCodeBlock)errorCodeBlock;



#pragma mark 添加银行卡
- (void)userAddbankcardwithInfoDic:(NSDictionary *)dic
                   WithReturnBlock:(PLReturnValueBlock)returnBlock
                     andErrorBlock:(PLErrorCodeBlock)errorCodeBlock;
#pragma mark 删除银行卡
- (void)userDeletehisBankCardWithCardId:(NSString *)cardId WithReturnBlock:(PLReturnValueBlock)returnBlock andErrorBlock:(PLErrorCodeBlock)errorBlcok;
#pragma mark 用户发起提现请求
- (void)userdrawalrequestWithDic:(NSDictionary *)dic withReturnBlock:(PLReturnValueBlock)returnBlock andErrorBlock:(PLErrorCodeBlock)errorBlcok;

#pragma mark 用户查看提现请求记录
- (void)usercheckdrawalrequestListWithDic:(NSDictionary *)dic withReturnBlock:(PLReturnValueBlock)returnBlock andErrorBlock:(PLErrorCodeBlock)errorBlcok;
#pragma mark 用户取消当前提现请求


////////////////////////////////////////////余额相关///////////////////////////////////////
#pragma mark - ⭐️ ⭐️ ⭐️ ⭐️ ⭐️余额相关⭐️ ⭐️ ⭐️ ⭐️ ⭐️

#pragma mark 获取账单
- (void)usergetbillrecordwithInfoDic:(NSDictionary *)dic
                     WithReturnBlock:(PLReturnValueBlock)returnBlock
                       andErrorBlock:(PLErrorCodeBlock)errorCodeBlock;



#pragma mark 获取余额
- (void)usergetbalanceWithReturnBlock:(PLReturnValueBlock)returnBlock
                        andErrorBlock:(PLErrorCodeBlock)errorCodeBlock;
















@end
