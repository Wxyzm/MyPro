//
//  MyNeedsNetModel.h
//  FyhNewProj
//
//  Created by yh f on 2017/5/15.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyNeedsNetModel : NSObject

@property (nonatomic , assign) NSInteger pageNum;     //第几页，可以空

@property (nonatomic , copy) NSString *title;       //搜索的标题，可以空

@property (nonatomic , copy) NSString *status;       //1表示待审核，3表示审核未通过，4表示审核通过与进行中，6表示有报价报价中，9表示已完成

@property (nonatomic , copy) NSString *categoryId;       //类目Id，可以为空

@property (nonatomic , copy) NSString *sort;       //排序

@end
