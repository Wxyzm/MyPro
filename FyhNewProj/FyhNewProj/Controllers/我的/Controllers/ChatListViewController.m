//
//  ChatListViewController.m
//  FyhNewProj
//
//  Created by yh f on 2017/8/30.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "ChatListViewController.h"
#import "xxxxViewController.h"

@interface ChatListViewController ()

@end

@implementation ChatListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = UIColorFromRGB(WhiteColorValue);
    self.navigationController.navigationBar.translucent = NO;
    self.title = @"消息中心";
    //设置要显示的会话类型
    [self setDisplayConversationTypes:@[ @(ConversationType_PRIVATE),
                                         @(ConversationType_DISCUSSION),
                                         @(ConversationType_GROUP),
                                         @(ConversationType_SYSTEM)]];
    [self setBarBackBtnWithImage:nil];
    
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;


}


- (void)initUI{
    self.conversationListTableView.frame = CGRectMake(0,152, ScreenWidth, ScreenHeight -64 - 152);
    self.conversationListTableView.tableFooterView = [[UIView alloc]init];
    
    
    NSArray *imageNameArr = @[@"sys-mes",@"tran-mes"];
    NSArray *nameArr = @[@"系统消息",@"交易物流信息"];

    for (int i = 0; i<2; i++) {
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imageNameArr[i]]];
        [self.view addSubview:imageView];
        imageView.frame = CGRectMake(15, 13+70*i, 44, 44);
        
        UILabel *lab = [BaseViewFactory labelWithFrame:CGRectMake(75, 16+70*i, ScreenWidth - 90, 16) textColor:UIColorFromRGB(BlackColorValue) font:APPFONT(15) textAligment:NSTextAlignmentLeft andtext:nameArr[i]];
        [self.view addSubview:lab];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.view addSubview:btn];
        btn.tag = 1000+i;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];

    }
    
    
    
    UIView *lineView = [BaseViewFactory viewWithFrame:CGRectMake(0, 140, ScreenWidth, 12) color:UIColorFromRGB(LineColorValue)];
    [self.view addSubview:lineView];
    UIView *lineView1 = [BaseViewFactory viewWithFrame:CGRectMake(0, 69.5, ScreenWidth, 1) color:UIColorFromRGB(LineColorValue)];
    [self.view addSubview:lineView1];
}


//*********************插入自定义Cell*********************//

//插入自定义会话model
- (NSMutableArray *)willReloadTableData:(NSMutableArray *)dataSource {
    
    return dataSource;
}

/**
 *  点击进入会话界面
 *
 *  @param conversationModelType 会话类型
 *  @param model                 会话数据
 *  @param indexPath             indexPath description
 */
-(void)onSelectedTableRow:(RCConversationModelType)conversationModelType conversationModel:(RCConversationModel *)model atIndexPath:(NSIndexPath *)indexPath
{
    if (conversationModelType == RC_CONVERSATION_MODEL_TYPE_NORMAL) {
        
        if ( [[[NSUserDefaults standardUserDefaults] objectForKey:FYH_USER_ID] isEqualToString:[NSString stringWithFormat:@"%@",model.targetId]]   ) {
            [self showTextHud:@"您不能跟自己聊天对话哦"];

            return ;
        }
        
        xxxxViewController *_conversationVC = [[xxxxViewController alloc]init];
        _conversationVC.conversationType = model.conversationType;
        _conversationVC.targetId = model.targetId;
        _conversationVC.title = model.conversationTitle;
        _conversationVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:_conversationVC animated:YES];
    }
}

//重写空视图方法  隐藏会话为空时候的视图
- (void)showEmptyConversationView
{
    
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
    
//    UIButton* rightbutton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, width, height)];
//    [rightbutton setTitle:@"进店" forState:UIControlStateNormal];
//    [rightbutton addTarget:self action:@selector(respondToRightButtonClickEvent) forControlEvents:UIControlEventTouchUpInside];
//    
//    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:rightbutton];
//    
//    self.navigationItem.rightBarButtonItem = right;
    
    
    
}
- (void)respondToLeftButtonClickEvent{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)btnClick:(UIButton *)btn{

    [self showTextHud:@"暂未开放"];


}

- (void)showTextHud:(NSString*)msg {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.hidden = NO;
    hud.mode = MBProgressHUDModeText;
    hud.label.text = msg;
    hud.margin = 10.0f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:1.5];
    [self performSelector:@selector(hideHUD:) withObject:hud afterDelay:1.5];
}

-(void) hideHUD:(MBProgressHUD*) progress {
    __block MBProgressHUD* progressC = progress;
    dispatch_async(dispatch_get_main_queue(), ^{
        [progressC hideAnimated:YES afterDelay:0                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       ];
        
        [progressC hideAnimated:YES];
        progressC = nil;
    });
}

@end
