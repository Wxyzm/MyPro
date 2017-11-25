//
//  AddaddressViewController.m
//  FyhNewProj
//
//  Created by yh f on 2017/4/10.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "AddaddressViewController.h"
#import <AddressBookUI/AddressBookUI.h>
#import "AdressPickerView.h"
#import "AcceptAdressPL.h"
#import "AdressModel.h"

@interface AddaddressViewController ()<UIScrollViewDelegate,ABPeoplePickerNavigationControllerDelegate,AdressPickerDelegate>

@property (nonatomic , strong) UITextField *nameTF;

@property (nonatomic , strong) UITextField *phoneTF;

//@property (nonatomic , strong) UITextField *ZipcodeTF;


@property (nonatomic , strong) UITextField *StreetTF;

@property (nonatomic , strong) UITextField *AddTF;


@property (nonatomic,strong) UISwitch *switchview;

@property (nonatomic , strong) ABPeoplePickerNavigationController *picker;


@end

@implementation AddaddressViewController{
    
    NSMutableArray  *_proviceArr;   //省
    NSMutableArray  *_cityArr;      //市
    NSMutableArray  *_areas;        //区
    AdressPickerView        *_areaPicker;       //地址选择器
    BOOL                    _areaPickIsShow;
    
    NSString      *_proviceNumStr;
    NSString      *_cityNumeStr;
    NSString      *__areasNumStr;
    UIButton *_placeBtn;
    NSString *_code1;
    NSString *_code2;
    NSString *_code3;

    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBarBackBtnWithImage:nil];
    self.title = @"添加新地址";
    _proviceArr = [NSMutableArray array];
    _cityArr = [NSMutableArray array];
    _cityArr = [NSMutableArray array];
    [self setUI];
    [self initDatas];
}

-(void)setUI

{
    UIScrollView *myscrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64)];
    myscrollview.delegate = self;
    myscrollview.contentSize = CGSizeMake(ScreenWidth, 667-64);
    myscrollview.backgroundColor = UIColorFromRGB(0xe6e9ed);
    [self.view addSubview:myscrollview];
    
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
    view1.backgroundColor = [UIColor whiteColor];
    [myscrollview addSubview:view1];
    
    [self createLabelWith:UIColorFromRGB(BlackColorValue) Font:APPFONT(15) WithSuper:view1 Frame:CGRectMake(20, 17.5, 70, 15) Alignment:NSTextAlignmentLeft Text:@"收货人"];
    
    _nameTF = [BaseViewFactory textFieldWithFrame:CGRectMake(110, 5, ScreenWidth-130, 40) font:APPFONT(13) placeholder:@"输入联系人姓名" textColor:UIColorFromRGB(BlackColorValue) placeholderColor:UIColorFromRGB(LineColorValue) delegate:nil];
    [view1 addSubview:_nameTF];
    
    if (_model.consigneeName) {
        _nameTF.text = _model.consigneeName;
    }
    
    UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(0, 50, ScreenWidth, 50)];
    view2.backgroundColor = [UIColor whiteColor];
    [myscrollview addSubview:view2];
    
    [self createLabelWith:UIColorFromRGB(BlackColorValue) Font:APPFONT(15) WithSuper:view2 Frame:CGRectMake(20, 17.5, 70, 15) Alignment:NSTextAlignmentLeft Text:@"联系电话"];
    
    _phoneTF = [BaseViewFactory textFieldWithFrame:CGRectMake(110, 5, ScreenWidth-155, 40) font:APPFONT(13) placeholder:@"输入联系电话" textColor:UIColorFromRGB(BlackColorValue) placeholderColor:UIColorFromRGB(LineColorValue) delegate:nil];
    [view2 addSubview:_phoneTF];
    if (_model.mobile) {
        _phoneTF.text = _model.mobile;
    }
    _phoneTF.keyboardType = UIKeyboardTypePhonePad;
    
    UIButton *MailListBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    MailListBtn.frame = CGRectMake(ScreenWidth - 35, 15, 20, 20);
    [MailListBtn addTarget:self action:@selector(MailListBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [MailListBtn setImage:[UIImage imageNamed:@"add-contant"] forState:UIControlStateNormal];
    [view2 addSubview:MailListBtn];
    
    
    
    UIView *view4 = [[UIView alloc]initWithFrame:CGRectMake(0, 100, ScreenWidth, 50)];
    view4.backgroundColor = [UIColor whiteColor];
    [myscrollview addSubview:view4];
    
    [self createLabelWith:UIColorFromRGB(BlackColorValue) Font:APPFONT(15) WithSuper:view4 Frame:CGRectMake(20, 17.5, 70, 15) Alignment:NSTextAlignmentLeft Text:@"所在地址"];
    
    _AddTF = [BaseViewFactory textFieldWithFrame:CGRectMake(110, 5, ScreenWidth-130, 40) font:APPFONT(13) placeholder:@"请选择" textColor:UIColorFromRGB(BlackColorValue) placeholderColor:UIColorFromRGB(LineColorValue) delegate:nil];
    _AddTF.textAlignment=NSTextAlignmentLeft;
    _AddTF.userInteractionEnabled = NO;
    
    if (_model.province&&_model.city&&_model.area) {
        _AddTF.text = [NSString stringWithFormat:@"%@%@%@",_model.province,_model.city,_model.area];
        _code1 = _model.provinceCode;
        _code2 = _model.cityCode;
        _code3 = _model.areaCode;

    }
    
    
    [view4 addSubview:_AddTF];

    
   _placeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _placeBtn.frame = CGRectMake(110, 5, ScreenWidth-130, 40);
    [_placeBtn addTarget:self action:@selector(presentAreaPicker) forControlEvents:UIControlEventTouchUpInside];
    [view4 addSubview:_placeBtn];
    
    
    
    UIView *view5 = [[UIView alloc]initWithFrame:CGRectMake(0, 150, ScreenWidth, 50)];
    view5.backgroundColor = [UIColor whiteColor];
    [myscrollview addSubview:view5];
    
    [self createLabelWith:UIColorFromRGB(BlackColorValue) Font:APPFONT(15) WithSuper:view5 Frame:CGRectMake(20, 17.5, 70, 15) Alignment:NSTextAlignmentLeft Text:@"街道地址"];
    
    _StreetTF = [BaseViewFactory textFieldWithFrame:CGRectMake(110, 5, ScreenWidth-130, 40) font:APPFONT(13) placeholder:@"请填写详细地址，不少于5个字" textColor:UIColorFromRGB(BlackColorValue) placeholderColor:UIColorFromRGB(LineColorValue) delegate:nil];
    _StreetTF.textAlignment=NSTextAlignmentLeft;
    if (_model.consigneeAddress) {
        _StreetTF.text = _model.consigneeAddress;
    }
    
    [view5 addSubview:_StreetTF];
    

    UIView *view7 = [[UIView alloc]initWithFrame:CGRectMake(0, 200+14, ScreenWidth, 50)];
    view7.backgroundColor = [UIColor whiteColor];
    [myscrollview addSubview:view7];
    
    [self createLabelWith:UIColorFromRGB(BlackColorValue) Font:APPFONT(15) WithSuper:view7 Frame:CGRectMake(20, 17.5, 70, 15) Alignment:NSTextAlignmentLeft Text:@"设为默认"];
   
    _switchview = [[UISwitch alloc] initWithFrame:CGRectMake(ScreenWidth-70, 10, 60, 40)];
    [_switchview addTarget:self action:@selector(myswitch:) forControlEvents:UIControlEventValueChanged];
    if (_model.isDefaultAdress) {
        _switchview.on = YES;

    }else{
        _switchview.on = NO;

    }
    [view7 addSubview:_switchview];
    
    for (int i = 0; i<4; i++) {
        [self createLineWithColor:UIColorFromRGB(LineColorValue) frame:CGRectMake(0, 50*(i+1)-0.5, ScreenWidth, 1) Super:myscrollview ];
    }

    
    SubBtn *PreservationBtn =[SubBtn buttonWithtitle:@"保存" titlecolor:UIColorFromRGB(WhiteColorValue) cornerRadius:5 andtarget:self action:@selector(Preservation) andframe:CGRectMake(20, 400, ScreenWidth-40, 50)];
    PreservationBtn.titleLabel.font = APPFONT(18);
    [self.view addSubview:PreservationBtn];

}

/**
 初始化数据
 */
- (void)initDatas{
    
    NSString *path1 = [[NSBundle mainBundle] pathForResource:@"provinces" ofType:@"json"];
    NSString *path2 = [[NSBundle mainBundle] pathForResource:@"cities" ofType:@"json"];
    NSString *path3 = [[NSBundle mainBundle] pathForResource:@"areas" ofType:@"json"];

    NSData *fileData1 = [NSData dataWithContentsOfFile:path1];
    NSData *fileData2 = [NSData dataWithContentsOfFile:path2];
    NSData *fileData3 = [NSData dataWithContentsOfFile:path3];

    NSDictionary * AllproDic = [NSJSONSerialization JSONObjectWithData:fileData1 options:NSJSONReadingMutableLeaves error:nil];
    _proviceArr = AllproDic[@"provinces"];
    
    NSDictionary * AllcityDic= [NSJSONSerialization JSONObjectWithData:fileData2 options:NSJSONReadingMutableLeaves error:nil];
    _cityArr = AllcityDic[@"cities"];
    
    NSDictionary * AllareasDic= [NSJSONSerialization JSONObjectWithData:fileData3 options:NSJSONReadingMutableLeaves error:nil];
    _areas = AllareasDic[@"areas"];
    NSLog(@"%lu===%lu===%lu",(unsigned long)_proviceArr.count,(unsigned long)_cityArr.count,(unsigned long)_areas.count);
    

}






//保存地址
-(void)Preservation
{
    if (_nameTF.text.length<=0) {
        [self showTextHud:@"请输入收货人姓名"];
        return;
    }
    if ([self convertToByte:_nameTF.text]>8) {
        [self showTextHud:@"收货人姓名过长"];
        return;
    }
    if (_phoneTF.text.length<=0) {
        [self showTextHud:@"请输入收货人联系电话"];
        return;
    }
    if (![self isMobileNumber:_phoneTF.text]) {
        [self showTextHud:@"请输入正确的手机号"];
        return;
    }
    
    if (_AddTF.text.length<=0) {
        [self showTextHud:@"请输入所在地址"];
        return;
    }
    if (_StreetTF.text.length<=0) {
        [self showTextHud:@"请输入街道地址"];
        return;
    }

    NSDictionary *dic = @{@"consigneeName":_nameTF.text,
                          @"mobile":_phoneTF.text,
                          @"provinceCode": _code1,
                          @"cityCode":_code2,
                          @"areaCode":_code3,
                          @"streetCode":@"",
                          @"consigneeAddress":_StreetTF.text,
                          @"isDefault":_switchview.on?@"true":@"flase"
                          };
    
    
    if (_model.addressid) {
        //更新
        [AcceptAdressPL editAcceptAdressWithAdressid:_model.addressid andDic:dic withReturnBlock:^(id returnValue) {
            [self showTextHud:@"地址修改成功"];
//            if (_switchview.on) {
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"deautifultAdressChanged" object:returnValue[@"data"][@"address"][@"id"]];
//                
//            }else{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshAdress" object:nil];
                
//            }
            [self.navigationController popViewControllerAnimated:YES];
        } andErrorBlock:^(NSString *msg) {
            [self showTextHud:msg];

        }];
    }else{
        [AcceptAdressPL addAcceptAdressWithDic:dic withReturnBlock:^(id returnValue) {
            [self showTextHud:@"地址添加成功"];
//            if (_switchview.on) {
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"deautifultAdressChanged" object:returnValue[@"data"][@"address"][@"id"]];
//                
//            }else{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshAdress" object:nil];
                
//            }
            [self.navigationController popViewControllerAnimated:YES];
        } andErrorBlock:^(NSString *msg) {
            [self showTextHud:msg];
        }];
    }
    
}
-(void)myswitch:(UISwitch *)sender
{
    NSLog(@"ifReadOnly value: %@" ,sender.on?@"YES":@"NO");
    
    
}
#pragma mark ======== 地址选择



- (void)presentAreaPicker
{
    [self.view endEditing:YES];
    if (!_areaPicker) {
        _areaPicker = [[AdressPickerView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 168)];
        _areaPicker.delegate = self;
    }
    if (!_areaPickIsShow) {
        [_areaPicker showInView:self.view];
        _areaPickIsShow = YES;
        _placeBtn.userInteractionEnabled = NO;

        
    }}
- (void)hideKeyBoard{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    if (_areaPickIsShow) {
        [_areaPicker cancelPicker];
        _areaPickIsShow = NO;
        _placeBtn.userInteractionEnabled = YES;

    }
    
}

#pragma mark--------------------------------JYAreaPickerDelegate--------------------------------
- (void)pickerDidChaneStatus:(AdressPickerView *)picker
{
    if (picker == _areaPicker) {
        NSString *areaString = [NSString stringWithFormat:@"%@%@%@", _areaPicker.provinceDic, _areaPicker.cityDic,_areaPicker.areaDic];
        NSLog(@"选择地址===========%@",areaString);
        _code1 =  _areaPicker.provinceDic[@"code"];
        _code2 =  _areaPicker.cityDic[@"code"];
        _code3 =  _areaPicker.areaDic[@"code"];

        [_AddTF setText:[NSString stringWithFormat:@"%@%@%@", _areaPicker.provinceDic[@"name"], _areaPicker.cityDic[@"name"],_areaPicker.areaDic[@"name"]]];
        
    }
}

#pragma mark ======== 通讯录选择联系人
/**
 通讯录选择联系人
 */
- (void)MailListBtnClick{
    
    if (!_picker) {
        _picker =[[ABPeoplePickerNavigationController alloc] init];
        _picker.peoplePickerDelegate = self;

    }
    [self requestAuthorizationAddressBook];


}
- (void)requestAuthorizationAddressBook {
    // 判断是否授权
  //  ABAuthorizationStatus authorizationStatus = ABAddressBookGetAuthorizationStatus();
   // if (authorizationStatus == kABAuthorizationStatusNotDetermined) {
        // 请求授权
        ABAddressBookRef addressBookRef = ABAddressBookCreate();
        ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error) {
            if (granted) { // 授权成功
                 [self presentViewController:_picker animated:YES completion:nil];
            } else {  // 授权失败
                NSLog(@"授权失败！");
            }
        });
  //  }
}
//这个方法在用户选择一个联系人后调用
-(void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker didSelectPerson:(ABRecordRef)person{
    [self displayPerson:person];
    [self dismissViewControllerAnimated:YES completion:^{}];
}

//获得选中person的信息
- (void)displayPerson:(ABRecordRef)person
{
    NSString *firstName = (__bridge_transfer NSString*)ABRecordCopyValue(person, kABPersonFirstNameProperty);
    NSString *middleName = (__bridge_transfer NSString*)ABRecordCopyValue(person, kABPersonMiddleNameProperty);
    NSString *lastname = (__bridge_transfer NSString*)ABRecordCopyValue(person, kABPersonLastNameProperty);
    NSMutableString *nameStr = [NSMutableString string];
    if (lastname!=nil) {
        [nameStr appendString:lastname];
    }
    if (middleName!=nil) {
        [nameStr appendString:middleName];
    }
    if (firstName!=nil) {
        [nameStr appendString:firstName];
    }
    
    NSString* phone = nil;
    ABMultiValueRef phoneNumbers = ABRecordCopyValue(person,kABPersonPhoneProperty);
    if (ABMultiValueGetCount(phoneNumbers) > 0) {
        phone = (__bridge_transfer NSString*)ABMultiValueCopyValueAtIndex(phoneNumbers, 0);
    } else {
        phone = @"[None]";
    }
    
    //可以把-、+86、空格这些过滤掉
    NSString *phoneStr = [phone stringByReplacingOccurrencesOfString:@"-" withString:@""];
    phoneStr = [phoneStr stringByReplacingOccurrencesOfString:@"+86" withString:@""];
    phoneStr = [phoneStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    
  
    [_phoneTF setText:phoneStr];
}

@end
