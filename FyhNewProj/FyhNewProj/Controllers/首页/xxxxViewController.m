//
//  xxxxViewController.m
//  FyhNewProj
//
//  Created by yh f on 2017/3/29.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "xxxxViewController.h"
#import "IQKeyboardManager.h"
#import "BusinessesShopViewController.h"
#import "DIYGoodsMessage.h"
#import "DIYGoodsMessageCell.h"
#import "OfferViewController.h"
#import "GoodsDetailViewController.h"
#import "BusinessesShopViewController.h"
#import "MyCollectionController.h"
#import "ItemsModel.h"

@interface xxxxViewController ()<RCMessageCellDelegate>

@end

@implementation xxxxViewController{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBarBackBtnWithImage:nil];
    [self registerClass:[DIYGoodsMessageCell class]forMessageClass:[DIYGoodsMessage class]];
    [self sendProMessage];
    
    [self.chatSessionInputBarControl.pluginBoardView removeItemAtIndex:2];
    [self.chatSessionInputBarControl.pluginBoardView insertItemWithImage:[UIImage imageNamed:@"chat_Comment"] title:@"收藏" atIndex:2 tag:2001];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(sentCollecTionWithDic:) name:@"sendCollection" object:nil];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
  //  [[IQKeyboardManager sharedManager] setEnable:NO];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

-(void)dealloc{
    
//    [[IQKeyboardManager sharedManager] setEnable:YES];

}




-(void)pluginBoardView:(RCPluginBoardView *)pluginBoardView clickedItemWithTag:(NSInteger)tag{
    [super pluginBoardView:pluginBoardView clickedItemWithTag:tag];
    if (tag == 2001) {
        NSLog(@"点击了收藏按钮");
        MyCollectionController *myVc = [[MyCollectionController  alloc]init];
        myVc.Type = 1;
        [self.navigationController pushViewController:myVc animated:YES];
    }
    
    
}
#pragma mark ====== 发送商品消息

- (void)sendProMessage{

    if (_infoDic) {
        if (_infoDic[@"type"]) {
            //初始化一个视频消息，传进去参数conten，为一个视频的url
            DIYGoodsMessage *videoMessage=[DIYGoodsMessage messageWithContent:_infoDic[@"content"] title:_infoDic[@"title"] imageUrl:_infoDic[@"imageUrl"] type:_infoDic[@"type"] proId:_infoDic[@"proId"] price:[NSString stringWithFormat:@"￥%@",_infoDic[@"price"]]];
            //发送消息
            [self sendMessage:videoMessage pushContent:nil];
            
        }
    }

}
-(void)sentCollecTionWithDic:(NSNotification *)noti{
    
    NSDictionary *idDic = noti.object;
    _infoDic = idDic;
    [self sendProMessage];
}

#pragma mark ====== cell


- (RCMessageBaseCell *)rcConversationCollectionView:(UICollectionView *)collectionView
                             cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    RCMessageModel *model =
    [self.conversationDataRepository objectAtIndex:indexPath.row];
    
    if (!self.displayUserNameInCell) {
        if (model.messageDirection == MessageDirection_RECEIVE) {
            model.isDisplayNickname = NO;
        }
    }
    RCMessageContent *messageContent = model.content;
    
    if ([messageContent isMemberOfClass:[DIYGoodsMessageCell class]])
    {
        DIYGoodsMessageCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"DIYGoodsMessageCell" forIndexPath:indexPath];
        [cell setDataModel:model];
        [cell setDelegate:self];
        return cell;
    }
    else {
        return [super rcConversationCollectionView:collectionView cellForItemAtIndexPath:indexPath];
    }
}


- (CGSize)rcConversationCollectionView:(UICollectionView *)collectionView
                                layout:(UICollectionViewLayout *)collectionViewLayout
                sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    RCMessageModel *model = [self.conversationDataRepository objectAtIndex:indexPath.row];
    RCMessageContent *messageContent = model.content;
    if ([messageContent isMemberOfClass:[RCRealTimeLocationStartMessage class]]) {
        if (model.isDisplayMessageTime) {
            return CGSizeMake(collectionView.frame.size.width, 66);
        }
        return CGSizeMake(collectionView.frame.size.width, 66);
    }   else if ([messageContent isMemberOfClass:[DIYGoodsMessageCell class]])
    {
        return CGSizeMake(collectionView.frame.size.width, 100);
    }
    else {
        return [super rcConversationCollectionView:collectionView layout:collectionViewLayout sizeForItemAtIndexPath:indexPath];
    }
}

#pragma mark ======= celldelegate

-(void)didLongTouchMessageCell:(RCMessageModel *)model inView:(UIView *)view{



}


-(void)didTapMessageCell:(RCMessageModel *)model{
    DIYGoodsMessage *_diyMessage = (DIYGoodsMessage *)model.content;
    if ([model.objectName isEqualToString:@"app:FYH"]) {
        if (!_diyMessage.type) {
            return;
        }
        
        if ([_diyMessage.type isEqualToString:@"detail"]) {
            ItemsModel *itemModel =[[ItemsModel alloc]init];
            itemModel.itemId = _diyMessage.proId;
            GoodsDetailViewController *deVC = [[GoodsDetailViewController alloc]init];
            deVC.itemModel = itemModel;
            [self.navigationController pushViewController:deVC animated:YES];
            
            
        }else if ([_diyMessage.type isEqualToString:@"quote"])
        {
            OfferViewController *offVc = [[OfferViewController alloc]init];
            offVc.needId = _diyMessage.proId;
            [self.navigationController  pushViewController:offVc animated:YES];
            
        }else if ([_diyMessage.type isEqualToString:@"shop"]){
            BusinessesShopViewController *shopVc = [[BusinessesShopViewController alloc]init];
            shopVc.shopId = _diyMessage.proId;
            [self.navigationController pushViewController:shopVc animated:YES];
            
            
        }
    }
    
    

}
#pragma mark ======= 返回按钮

- (void)setBarBackBtnWithImage:(UIImage *)image
{
    UIImage *backImg;
    if (image == nil) {
        backImg = [UIImage imageNamed:@"back-white"];
    } else {
        backImg = image;
    }
    CGFloat height = 17;
    CGFloat width = height * backImg.size.width / backImg.size.height;
    
    UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    // [button setBackgroundImage:backImg forState:UIControlStateNormal];
    [button setImage:backImg forState:UIControlStateNormal];
    [button addTarget:self action:@selector(respondToLeftButtonClickEvent) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    self.navigationItem.leftBarButtonItem = left;
    
//    UIImage *rightImg;
//    rightImg = [UIImage imageNamed:@"more-white"];
    
    UIButton* rightbutton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, height)];
    [rightbutton setTitle:@"进店" forState:UIControlStateNormal];
    rightbutton.titleLabel.font = APPFONT(14);
    [rightbutton addTarget:self action:@selector(respondToRightButtonClickEvent) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:rightbutton];
    
    self.navigationItem.rightBarButtonItem = right;

    
    
}
- (void)respondToLeftButtonClickEvent{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)respondToRightButtonClickEvent{
    BusinessesShopViewController  *bussVc = [[BusinessesShopViewController alloc]init];
    bussVc.shopId = self.targetId;
    [self.navigationController  pushViewController:bussVc animated:YES];

}

@end
