//
//  TagLIstButtonView.h
//  FyhNewProj
//
//  Created by yh f on 2017/6/7.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UnitModel;


//typedef void (^DeleteBlock)(UnitModel *onemodel);

@interface TagLIstButtonView : UIView{
    CGRect previousFrame ;
    int totalHeight ;
    NSMutableArray*_tagArr;

}

/**
 * 整个view的背景色
 */
@property(nonatomic,retain)UIColor*GBbackgroundColor;
/**
 *  设置单一颜色
 */
@property(nonatomic)UIColor*signalTagColor;
///**
// *  回调统计选中tag
// */
@property(nonatomic,copy)void (^didselectStatusItemBlock)(UnitModel*selectedModel);

@property(nonatomic,copy)void (^didDeleteItemBlock)(UnitModel*onemodel);

//@property (nonatomic, copy) DeleteBlock myBlock;

//@property(nonatomic,copy)void (^didselectKindItemBlock)(UnitModel*selectedModel);

@property (nonatomic , assign) NSInteger type;      //0 颜色   1  状态   2  类型   3正常使用，不用删除

@property(nonatomic) BOOL canTouch;
/**
 *  标签文本赋值
 */
-(void)setTagWithTagArray:(NSArray*)arr;


@property (nonatomic , strong) NSMutableArray *modelArr;

@end
