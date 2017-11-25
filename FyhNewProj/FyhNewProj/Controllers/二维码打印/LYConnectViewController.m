//
//  LYConnectViewController.m
//  FyhNewProj
//
//  Created by yh f on 2017/6/2.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "LYConnectViewController.h"
#import "BaseViewFactory.h"
#import "ISSCButton.h"
#import "BLKWrite.h"
#import "deviceInfo.h"
#import "AppDelegate.h"

@interface LYConnectViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>

@property (nonatomic,strong)UITableView *nameTabView;           //打印机名称

@end

@implementation LYConnectViewController{

    NSTimer *refreshDeviceListTimer;//刷新设备列表计时器
    
    int connectionStatus;//连接状态
    //Derek
    DeviceInfo *deviceInfo;//设备信息
    MyPeripheral *controlPeripheral;//控制外设
    NSMutableArray *connectedDeviceInfo;//连接设备信息 stored for DeviceInfo object存储设备信息对象
    NSMutableArray *connectingList;//连接列表stored for MyPeripheral object存储我的设备对象

    UUIDSettingViewController *uuidSettingViewController;//UUID视图控制器
    
//    UILabel *_nameLab;

}
#pragma - mark getter
-(UITableView *)nameTabView{
    
    if (!_nameTabView) {
        _nameTabView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0,300,300) style:UITableViewStylePlain];
        _nameTabView.delegate = self;
        _nameTabView.dataSource = self;
        _nameTabView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    return _nameTabView;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"二维码打印";
    self.view.backgroundColor = UIColorFromRGB(0xccd1d9);
    connectedDeviceInfo = [NSMutableArray new];//连接设备信息
    connectingList = [NSMutableArray new];//连接列表
    
    deviceInfo = [[DeviceInfo alloc]init];//设备信息
    refreshDeviceListTimer = nil;//刷新设备列表指示器
    uuidSettingViewController = nil;//UUID设置视图控制器
    [self setConnectionStatus:LE_STATUS_IDLE];//连接状态

    [self initUI];

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self createBackItem];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    //判断连接设备信息
    if([connectedDeviceInfo count] == 0) {
        if (uuidSettingViewController.isUUIDAvailable) {//是否为UUID可用标签
            [self configureTransparentServiceUUID:uuidSettingViewController.transServiceUUIDStr txUUID:uuidSettingViewController.transTxUUIDStr rxUUID:uuidSettingViewController.transRxUUIDStr];
        }
        else
            [self configureTransparentServiceUUID:nil txUUID:nil rxUUID:nil];
        
        if (uuidSettingViewController.isDISUUIDAvailable) {
            if (uuidSettingViewController.disUUID2Str) {
                [self configureDeviceInformationServiceUUID:uuidSettingViewController.disUUID1Str UUID2:uuidSettingViewController.disUUID2Str];
            }
            else
                [self configureDeviceInformationServiceUUID:uuidSettingViewController.disUUID1Str UUID2:nil];
            
        }
        else
            [self configureDeviceInformationServiceUUID:nil UUID2:nil];
        
    }
    [self startScan];
}

//查看
- (void)viewDidUnload
{
    
    _nameTabView = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)createBackItem{
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }

    UIImage *backImg = [UIImage imageNamed:@"back-white"];
    CGFloat height = 17;
    CGFloat width = height * backImg.size.width / backImg.size.height;
    
    UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    // [button setBackgroundImage:backImg forState:UIControlStateNormal];
    [button setImage:backImg forState:UIControlStateNormal];
    [button addTarget:self action:@selector(respondToLeftButtonClickEvent) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    self.navigationItem.leftBarButtonItem = left;


}


- (void)respondToLeftButtonClickEvent{

    [self.navigationController popViewControllerAnimated:YES];

}

- (void)initUI{

    UILabel *leftLab = [BaseViewFactory labelWithFrame:CGRectMake(15, 20, ScreenWidth, 16) textColor:UIColorFromRGB(0x434a54) font:APPFONT(15) textAligment:NSTextAlignmentLeft andtext:@"选择配对设备"];
    [self.view addSubview:leftLab];
    
    
    UIView *view = [BaseViewFactory viewWithFrame:CGRectMake((ScreenWidth-300)/2, 55, 300, 300) color:UIColorFromRGB(0xffffff)];
    view.layer.cornerRadius = 5;
    view.clipsToBounds = YES;
    [self.view addSubview:view];
    [view addSubview:self.nameTabView];
    
    
//    _nameLab= [BaseViewFactory labelWithFrame:CGRectMake(15, 375, ScreenWidth, 16) textColor:UIColorFromRGB(0x434a54) font:APPFONT(15) textAligment:NSTextAlignmentLeft andtext:@"已配对设备："];
//    [self.view addSubview:_nameLab];

    
}

- (void)willPresentAlertView:(UIAlertView *)alertView{
    alertView.title = @"提示";
    alertView.message = @"蓝牙不可用";
    NSArray *arr = alertView.subviews;
    NSLog(@"%@",arr);
    [devicesList removeAllObjects];
    [connectedDeviceInfo removeAllObjects];
    [_nameTabView reloadData];
    // return;
    // NSLog(@"hahaha");
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self.navigationController popViewControllerAnimated:YES];

}

//更新我周围的新连接
- (void)updateMyPeripheralForNewConnected:(MyPeripheral *)myPeripheral {
    
    [[BLKWrite Instance] setPeripheral:myPeripheral];
    
    NSLog(@"[ConnectViewController] updateMyPeripheralForNewConnected");
    DeviceInfo *tmpDeviceInfo = [[DeviceInfo alloc]init];
    //    tmpDeviceInfo.mainViewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    //    tmpDeviceInfo.mainViewController.connectedPeripheral = myPeripheral;
    tmpDeviceInfo.myPeripheral = myPeripheral;
    tmpDeviceInfo.myPeripheral.connectStaus = myPeripheral.connectStaus;
    
    /*Connected List Filter*/
    bool b = FALSE;
    for (int idx =0; idx< [connectedDeviceInfo count]; idx++) {
        DeviceInfo *tmpDeviceInfo = [connectedDeviceInfo objectAtIndex:idx];
        if (tmpDeviceInfo.myPeripheral == myPeripheral) {
            b = TRUE;
            break;
        }
    }
    if (!b) {
        [connectedDeviceInfo addObject:tmpDeviceInfo];
    }
    else{
        NSLog(@"Connected List Filter!");
    }
    
    for (int idx =0; idx< [connectingList count]; idx++) {
        MyPeripheral *tmpPeripheral = [connectingList objectAtIndex:idx];
        if (tmpPeripheral == myPeripheral) {
            //NSLog(@"connectingList removeObject:%@",tmpPeripheral.advName);
            [connectingList removeObjectAtIndex:idx];
            break;
        }
    }
    
    for (int idx =0; idx< [devicesList count]; idx++) {
        MyPeripheral *tmpPeripheral = [devicesList objectAtIndex:idx];
        if (tmpPeripheral == myPeripheral) {
            //NSLog(@"devicesList removeObject:%@",tmpPeripheral.advName);
            [devicesList removeObjectAtIndex:idx];
            break;
        }
    }
    [self displayDevicesList];
 //   [self updateButtonType];
}
//断开我的连接
- (void)updateMyPeripheralForDisconnect:(MyPeripheral *)myPeripheral {
    NSLog(@"updateMyPeripheralForDisconnect");//, %@", myPeripheral.advName);
    if (myPeripheral == controlPeripheral) {
        [NSTimer scheduledTimerWithTimeInterval:0.03 target:self selector:@selector(popToRootPage) userInfo:nil repeats:NO];
    }
    
    for (int idx =0; idx< [connectedDeviceInfo count]; idx++) {
        DeviceInfo *tmpDeviceInfo = [connectedDeviceInfo objectAtIndex:idx];
        if (tmpDeviceInfo.myPeripheral == myPeripheral) {
            [connectedDeviceInfo removeObjectAtIndex:idx];
            //NSLog(@"updateMyPeripheralForDisconnect1");
            break;
        }
    }
    
    for (int idx =0; idx< [connectingList count]; idx++) {
        MyPeripheral *tmpPeripheral = [connectingList objectAtIndex:idx];
        if (tmpPeripheral == myPeripheral) {
            [connectingList removeObjectAtIndex:idx];
            //NSLog(@"updateMyPeripheralForDisconnect2");
            break;
        }
        else{
            //NSLog(@"updateMyPeripheralForDisconnect3 %@, %@", tmpPeripheral.advName, myPeripheral.advName);
        }
        
    }
    
    [self displayDevicesList];
   // [self updateButtonType];
   
    if(connectionStatus == LE_STATUS_SCANNING){
        [self stopScan];
        [self startScan];
        [_nameTabView reloadData];
    }
}
-(void)popToRootPage {
}
#pragma - mark DataSource methods

// DataSource methods

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 47;
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //NSLog(@"[ConnectViewController] numberOfRowsInSection,device count = %d", [devicesList count]);
    switch (section) {
        case 0:
            return [connectedDeviceInfo count];
            
        case 1:
            return [devicesList count];
        default:
            return 0;
    }
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
    
    switch (indexPath.section) {
        case 0:
        {
            //NSLog(@"[ConnectViewController] CellForRowAtIndexPath section 0, Row = %d",[indexPath row]);
            cell = [tableView dequeueReusableCellWithIdentifier:@"connectedList"];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"connectedList"] ;
            }
            DeviceInfo *tmpDeviceInfo = [connectedDeviceInfo objectAtIndex:indexPath.row];
            cell.imageView.image = [UIImage imageNamed:@"print"];
            cell.textLabel.text = tmpDeviceInfo.myPeripheral.advName;
            cell.detailTextLabel.text = @"已连接";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//            if (tmpDeviceInfo.myPeripheral.advName.length>0) {
//                _nameLab.text = [NSString stringWithFormat:@"已配对设备：%@",tmpDeviceInfo.myPeripheral.advName];
//
//            }
            cell.accessoryView = nil;
            if (cell.textLabel.text == nil)
                cell.textLabel.text = @"未知设备";
            
            UIButton *accessoryButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [accessoryButton addTarget:self action:@selector(actionButtonDisconnect:)  forControlEvents:UIControlEventTouchUpInside];
            accessoryButton.tag = indexPath.row;
            [accessoryButton setTitle:@"断开连接" forState:UIControlStateNormal];
            [accessoryButton setFrame:CGRectMake(0,0,100,35)];
            cell.accessoryView  = accessoryButton;
        }
            break;
            
        case 1:
        {
            //NSLog(@"[ConnectViewController] CellForRowAtIndexPath section 1, Row = %d",[indexPath row]);
            
            cell = [tableView dequeueReusableCellWithIdentifier:@"devicesList"];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"devicesList"];
            }
            MyPeripheral *tmpPeripheral = [devicesList objectAtIndex:indexPath.row];
            cell.imageView.image = [UIImage imageNamed:@"print"];
            cell.textLabel.text = tmpPeripheral.advName;
            cell.detailTextLabel.text = @"";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryView = nil;
            if (tmpPeripheral.connectStaus == MYPERIPHERAL_CONNECT_STATUS_CONNECTING) {
                cell.detailTextLabel.text = @"正在连接...";
                UIButton *accessoryButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                [accessoryButton addTarget:self action:@selector(actionButtonCancelConnect:)  forControlEvents:UIControlEventTouchUpInside];
                accessoryButton.tag = indexPath.row;
                [accessoryButton setTitle:@"取消" forState:UIControlStateNormal];
                [accessoryButton setFrame:CGRectMake(0,0,100,35)];
                cell.accessoryView  = accessoryButton;
                
            }else{
                UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                [button setTitle:@"取消" forState:UIControlStateNormal];

                UIColor *nomalColor = [button titleColorForState:UIControlStateNormal];
                UILabel *lab = [BaseViewFactory labelWithFrame:CGRectMake(0,0,100,35) textColor:nomalColor font:APPFONT(14) textAligment:NSTextAlignmentCenter andtext:@"点击连接"];
//                UIButton *accessoryButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//                accessoryButton.tag = indexPath.row;
//                [accessoryButton setTitle:@"点击连接" forState:UIControlStateNormal];
//                [accessoryButton setFrame:CGRectMake(0,0,100,35)];
                cell.accessoryView  = lab;

            }
            
            if (cell.textLabel.text == nil)
                cell.textLabel.text = @"未知设备";
        }
            break;
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    NSString *title = nil;
    switch (section) {
        case 0:
            title = @"已连接设备:";
            break;
        case 1:
            title = @"蓝牙设备:";
            break;
            
        default:
            break;
    }
    return title;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 30;
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
        {
            //NSLog(@"[ConnectViewController] didSelectRowAtIndexPath section 0, Row = %d",[indexPath row]);
            deviceInfo = [connectedDeviceInfo objectAtIndex:indexPath.row];
            controlPeripheral = deviceInfo.myPeripheral;
            [self stopScan];
            [self setConnectionStatus:LE_STATUS_IDLE];
           // [activityIndicatorView stopAnimating];
            if (refreshDeviceListTimer) {
                [refreshDeviceListTimer invalidate];
                refreshDeviceListTimer = nil;
            }
            //            [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(switchToMainFeaturePage) userInfo:nil repeats:NO];
        }
            break;
        case 1:
        {
            //Derek
            if (connectedDeviceInfo.count>=1) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"最多只能连接一台设备" preferredStyle:UIAlertControllerStyleAlert];
                [alert  addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                }]];
                [self presentViewController:alert animated:YES completion:nil];

                return;
            }
            NSLog(@"[ConnectViewController] didSelectRowAtIndexPath section 1, Row = %ld",(long)[indexPath row]);
            int count = [devicesList count];
            if ((count != 0) && count > indexPath.row) {
                MyPeripheral *tmpPeripheral = [devicesList objectAtIndex:indexPath.row];
                if (tmpPeripheral.connectStaus != MYPERIPHERAL_CONNECT_STATUS_IDLE) {
                    //NSLog(@"Device is not idle - break");
                    break;
                }
                [self connectDevice:tmpPeripheral];
                tmpPeripheral.connectStaus = MYPERIPHERAL_CONNECT_STATUS_CONNECTING;
                [devicesList replaceObjectAtIndex:indexPath.row withObject:tmpPeripheral];
                [connectingList addObject:tmpPeripheral];
                [self displayDevicesList];
              
               // [self updateButtonType];
            }
            break;
        }
        default:
            break;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (int) connectionStatus {
    return connectionStatus;
}

//连接状态
- (void) setConnectionStatus:(int)status {
    if (status == LE_STATUS_IDLE) {
    //    statusLabel.textColor = [UIColor redColor];
    }
    else {
     //   statusLabel.textColor = [UIColor blackColor];
    }
    connectionStatus = status;
    
    switch (status) {
        case LE_STATUS_IDLE:
           // statusLabel.text = @"Idle";
          //  [activityIndicatorView stopAnimating];
            break;
        case LE_STATUS_SCANNING:
            [_nameTabView reloadData];
         //   statusLabel.text = @"Scanning...";
          //  [activityIndicatorView startAnimating];
            break;
        default:
            break;
    }
   // [self updateButtonType];
}
//显示设备列表
- (void) displayDevicesList {
    [_nameTabView reloadData];
}
//更新发现外设
- (void)updateDiscoverPeripherals {
    [super updateDiscoverPeripherals];
    [_nameTabView reloadData];
}

#pragma mark ------- 开始扫描停止扫描
//开始扫描
- (void)startScan {
    [super startScan];
    if ([connectingList count] > 0) {
        for (int i=0; i< [connectingList count]; i++) {
            MyPeripheral *connectingPeripheral = [connectingList objectAtIndex:i];
            
            if (connectingPeripheral.connectStaus == MYPERIPHERAL_CONNECT_STATUS_CONNECTING) {
                //NSLog(@"startScan add connecting List: %@",connectingPeripheral.advName);
                [devicesList addObject:connectingPeripheral];
            }
            else {
                [connectingList removeObjectAtIndex:i];
                //NSLog(@"startScan remove connecting List: %@",connectingPeripheral.advName);
            }
        }
    }
    [self setConnectionStatus:LE_STATUS_SCANNING];
}
//停止扫描
- (void)stopScan {
    [super stopScan];
    if (refreshDeviceListTimer) {
        [refreshDeviceListTimer invalidate];
        refreshDeviceListTimer = nil;
    }
}

//刷新设备列表
- (IBAction)refreshDeviceList:(id)sender {
    NSLog(@"[ConnectViewController] refreshDeviceList");
    [self stopScan];
    [self startScan];
    [_nameTabView reloadData];
}
//手动设置UUID
- (IBAction)manualUUIDSetting:(id)sender {
    if (uuidSettingViewController == nil) {
        uuidSettingViewController = [[UUIDSettingViewController alloc] initWithNibName:@"UUIDSettingViewController" bundle:nil];
    }
//    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    if ([[[appDelegate navigationController] viewControllers] containsObject:uuidSettingViewController] == FALSE) {
//        [[appDelegate navigationController] pushViewController:uuidSettingViewController animated:YES];
//    }
}

//Derek 动作按钮断开
- (IBAction)actionButtonDisconnect:(id)sender {
    //NSLog(@"[ConnectViewController] actionButtonDisconnect idx = %d",[sender tag]);
    int idx = [sender tag];

    DeviceInfo *tmpDeviceInfo = [connectedDeviceInfo objectAtIndex:idx];
    [self disconnectDevice:tmpDeviceInfo.myPeripheral];
    [self displayDevicesList];
}

//Derek 动作按钮取消连接
- (IBAction)actionButtonCancelConnect:(id)sender {
    //NSLog(@"[ConnectViewController] actionButtonCancelConnect idx = %d",[sender tag]);
    int idx = [sender tag];
    MyPeripheral *tmpPeripheral = [devicesList objectAtIndex:idx];
    tmpPeripheral.connectStaus = MYPERIPHERAL_CONNECT_STATUS_IDLE;
    [devicesList replaceObjectAtIndex:idx withObject:tmpPeripheral];
    
    for (int idx =0; idx< [connectingList count]; idx++) {
        MyPeripheral *tmpConnectingPeripheral = [connectingList objectAtIndex:idx];
        if (tmpConnectingPeripheral == tmpPeripheral) {
            [connectingList removeObjectAtIndex:idx];
            break;
        }
    }
    
    [self disconnectDevice:tmpPeripheral];
    [self displayDevicesList];
   // [self updateButtonType];
}


@end
