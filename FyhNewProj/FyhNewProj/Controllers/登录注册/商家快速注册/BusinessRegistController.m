//
//  BusinessRegistController.m
//  FyhNewProj
//
//  Created by yh f on 2017/3/2.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "BusinessRegistController.h"
#import "BussChoseViewController.h"

@interface BusinessRegistController ()

@property (nonatomic,strong)UITextField *BusinName;  //店铺名称

@property (nonatomic,strong)UITextField *BusinMan;  //联系人

@end

@implementation BusinessRegistController{

    UILabel *_selectLab;
    NSString *_shopCatId;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"店铺信息";
    _shopCatId = @"";
    self.view.backgroundColor = UIColorFromRGB(0xf1f1f1);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(complectedWithshopCatId:)
                                                 name:@"BussLeiMuSelected" object:nil];
    [self setUP];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
- (void)setUP{

    UIView *bgview = [[UIView alloc]initWithFrame:CGRectMake(0, 12, ScreenWidth, 126)];
    [self.view addSubview:bgview];
    bgview.backgroundColor = [UIColor whiteColor];
    for (int i = 0; i <2; i++) {
        [self createLineWithColor:UIColorFromRGB(0xb3b3b3) frame:CGRectMake(0, 41.5+41.5*i, ScreenWidth, 0.5) Super:bgview];
        
    }
    [self createLabelWith:UIColorFromRGB(0x333333) Font:FSYSTEMFONT(13) WithSuper:bgview Frame:CGRectMake(15, 14, 200, 14) Alignment:NSTextAlignmentLeft Text:@"*店铺经营类目"];
    [self createLabelWith:UIColorFromRGB(0x333333) Font:FSYSTEMFONT(13) WithSuper:bgview Frame:CGRectMake(15, 56, 70, 14) Alignment:NSTextAlignmentLeft Text:@"*店铺名称"];
    [self createLabelWith:UIColorFromRGB(0x333333) Font:FSYSTEMFONT(13) WithSuper:bgview Frame:CGRectMake(15, 98, 70, 14) Alignment:NSTextAlignmentLeft Text:@"*联系人"];
    _BusinName=[[UITextField alloc] initWithFrame:CGRectMake(85,56,ScreenWidth-100, 14)];
    _BusinName.placeholder=@"请输入店铺名称";
    _BusinName.textColor=[UIColor blackColor];
    _BusinName.font=FSYSTEMFONT(13);
//    _BusinName.returnKeyType=UIReturnKeyDone;
    _BusinName.autocorrectionType=UITextAutocorrectionTypeNo;
    _BusinName.autocapitalizationType=UITextAutocapitalizationTypeNone;
   // _BusinName.delegate=self;
    [bgview addSubview:_BusinName];
    
    _BusinMan=[[UITextField alloc] initWithFrame:CGRectMake(85,98,ScreenWidth-100, 14)];
    _BusinMan.placeholder=@"请输入联系人姓名";
    _BusinMan.textColor=[UIColor blackColor];
    _BusinMan.font=FSYSTEMFONT(13);
    _BusinMan.autocorrectionType=UITextAutocorrectionTypeNo;
    _BusinMan.autocapitalizationType=UITextAutocapitalizationTypeNone;
   // _BusinMan.delegate=self;
    [bgview addSubview:_BusinMan];

    SubBtn *rigbtn = [SubBtn buttonWithtitle:@"" backgroundColor:[UIColor whiteColor] titlecolor:[UIColor clearColor] cornerRadius:0 andtarget:self action:@selector(rightBtnClick)];
    [bgview addSubview:rigbtn];
    rigbtn.frame = CGRectMake(ScreenWidth-100, 0, 100, 41);
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"箭头右x3018"]];
    imageView.frame = CGRectMake(70, 16, 15, 10);
    [rigbtn addSubview:imageView];
    
    _selectLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 70, 42)];
    _selectLab.text = @"请选择";
    _selectLab.textColor = UIColorFromRGB(0x333333);
    _selectLab.textAlignment = NSTextAlignmentRight;
    [rigbtn addSubview:_selectLab];
    
    [self createLabelWith:UIColorFromRGB(0xc61616) Font:FSYSTEMFONT(12) WithSuper:bgview Frame:CGRectMake(15, 138, 300, 14) Alignment:NSTextAlignmentLeft Text:@"店铺名称填写后无法修改，请慎重"];

  SubBtn *setBtn =   [SubBtn buttonWithtitle:@"提交" backgroundColor:UIColorFromRGB(0xc61616) titlecolor:UIColorFromRGB(0xffffff) cornerRadius:5 andtarget:self action:@selector(setBtnClick)];
    [self.view addSubview:setBtn];
    setBtn.frame = CGRectMake(15, 220, ScreenWidth - 30, 40);
}


- (void)rightBtnClick{

    BussChoseViewController *bussVc = [[BussChoseViewController alloc]init];
    [self.navigationController pushViewController:bussVc animated:YES];

}


#pragma 选择shopCatId完成
- (void)complectedWithshopCatId:(NSNotification *)note{
    NSDictionary *userInfo = note.userInfo;
    if (!userInfo[@"catIdArr"]) {
        return;
    }
    
    _shopCatId = [userInfo[@"catIdArr"] componentsJoinedByString:@","];
    _selectLab.text = @"已选择";
}

- (void)setBtnClick{

    if ([_shopCatId isEqualToString:@""]) {
        [self showTextHud:@"请选择经营类目"];
        return;
    }
    if ([_BusinName.text isEqualToString:@""]||!_BusinName.text) {
        [self showTextHud:@"请填写店铺名称"];
        return;
    }
    if ([_BusinMan.text isEqualToString:@""]||!_BusinMan.text) {
        [self showTextHud:@"请填写联系人"];
        return;
    }
    HTTPClient * Client = [HTTPClient sharedHttpClient];
    [Client POST:@"/gateway?api=userOpenShop" dict:@{@"shopName":_BusinName.text,@"shopCatId":_shopCatId,@"realName":_BusinMan.text} success:^(NSDictionary *resultDic) {
        if ([resultDic[@"code"] intValue] == 0) {
            [self showTextHud:@"商家注册成功"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"BussRegistSuccess" object:nil userInfo:nil];

            [self.navigationController popToRootViewControllerAnimated:YES];
        }else{
            [self showTextHud:resultDic[@"message"]];
            NSLog(@"%@",resultDic[@"message"]);

        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showTextHud:@"注册失败，请稍后再试"];
    }];
    
    
    

}

@end
