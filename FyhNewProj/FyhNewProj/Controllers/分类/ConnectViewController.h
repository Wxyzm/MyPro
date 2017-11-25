//
//  ConnectViewController.h
//  BLETR
//
//  Created by D500 user on 12/9/26.
//  Copyright (c) 2012 ISSC Technologies Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CBController.h"
#import "UUIDSettingViewController.h"
#import "DeviceInfo.h"

@interface ConnectViewController : CBController<UITableViewDataSource, UITextViewDelegate, UITableViewDelegate>
{
    IBOutlet UITableView *devicesTableView;//列表视图
    UIActivityIndicatorView *activityIndicatorView;//活动指示器视图
    UILabel *statusLabel;//状态标签
    UUIDSettingViewController *uuidSettingViewController;//UUID视图控制器

    NSTimer *refreshDeviceListTimer;//刷新设备列表计时器

    int connectionStatus;//连接状态
    //Derek
    DeviceInfo *deviceInfo;//设备信息
    MyPeripheral *controlPeripheral;//控制外设
    NSMutableArray *connectedDeviceInfo;//连接设备信息 stored for DeviceInfo object存储设备信息对象
    NSMutableArray *connectingList;//连接列表stored for MyPeripheral object存储我的设备对象

    UIBarButtonItem *refreshButton;//刷新按钮
    UIBarButtonItem *scanButton;//搜索按钮
    UIBarButtonItem *cancelButton;//取消按钮
    UIBarButtonItem *uuidSettingButton;//UUID设置按钮
}
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityIndicatorView;//活动指示器视图
@property (nonatomic, retain) IBOutlet UILabel *statusLabel;//状态标签
@property (assign) int connectionStatus;//连接状态
@property (retain, nonatomic) IBOutlet UILabel *versionLabel;//版本标签

- (IBAction)refreshDeviceList:(id)sender;//刷新设备列表方法
- (IBAction)actionButtonCancelScan:(id)sender;//动作按钮取消扫描按钮
- (IBAction)manualUUIDSetting:(id)sender;//手动设置UUID方法
- (IBAction)actionButtonDisconnect:(id)sender;//动作按钮断开
- (IBAction)actionButtonCancelConnect:(id)sender;//动作按钮取消连接
@end
