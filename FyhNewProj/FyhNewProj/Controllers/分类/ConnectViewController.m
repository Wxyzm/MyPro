//
//  ConnectViewController.m
//  BLETR
//
//  Created by D500 user on 12/9/26.
//  Copyright (c) 2012 ISSC Technologies Corporation. All rights reserved.
//
#import "AppDelegate.h"
#import "ConnectViewController.h"
#import "ISSCButton.h"
#import "BLKWrite.h"
#import "deviceInfo.h"

@interface ConnectViewController ()

@end

@implementation ConnectViewController

//@synthesize actionButton;
@synthesize activityIndicatorView;//活动指示器试图
@synthesize statusLabel;//状态标签
@synthesize connectionStatus;//连接状态
@synthesize versionLabel;//版本标签



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
            self.edgesForExtendedLayout = UIRectEdgeNone;
        }

        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] init];
        backButton.title = @"Back";
        self.navigationItem.backBarButtonItem = backButton;
        
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 28, 57, 57)];
        [titleLabel setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Icon_old"]]];
        [titleLabel setTextAlignment:NSTextAlignmentCenter];//aaa
        self.navigationItem.titleView = titleLabel;
        [titleLabel release];
        
        ISSCButton *button = [ISSCButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0.0f, 0.0f, 80.0f, 30.0f);
        [button addTarget:self action:@selector(refreshDeviceList:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:@"Refresh" forState:UIControlStateNormal];
        refreshButton = [[UIBarButtonItem alloc] initWithCustomView:button];
        //refreshButton = [[UIBarButtonItem alloc] initWithTitle:@"Refresh" style:UIBarButtonItemStyleBordered target:self action:@selector(refreshDeviceList:)];
        button = [ISSCButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0.0f, 0.0f, 80.0f, 30.0f);
        [button addTarget:self action:@selector(startScan) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:@"  Scan  " forState:UIControlStateNormal];
        scanButton = [[UIBarButtonItem alloc] initWithCustomView:button];
        //scanButton = [[UIBarButtonItem alloc] initWithTitle:@"  Scan  " style:UIBarButtonItemStyleBordered target:self action:@selector(actionButtonStartScan:)];
        button = [ISSCButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0.0f, 0.0f, 80.0f, 30.0f);
        [button addTarget:self action:@selector(actionButtonCancelScan:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:@"Cancel" forState:UIControlStateNormal];
        cancelButton = [[UIBarButtonItem alloc] initWithCustomView:button];
        //cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(actionButtonCancelScan:)];
        button = [ISSCButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0.0f, 0.0f, 90.0f, 30.0f);
        [button addTarget:self action:@selector(manualUUIDSetting:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:@"UUID Setting" forState:UIControlStateNormal];
        button.titleLabel.adjustsFontSizeToFitWidth = YES;
        uuidSettingButton = [[UIBarButtonItem alloc] initWithCustomView:button];
        //uuidSettingButton = [[UIBarButtonItem alloc] initWithTitle:@"UUID Setting" style:UIBarButtonItemStyleBordered target:self action:@selector(manualUUIDSetting:)];
        
        //refreshButton = [[UIBarButtonItem alloc] initWithTitle:@"Refresh" style:UIBarButtonItemStyleBordered target:self action:@selector(refreshDeviceList:)];
        //scanButton = [[UIBarButtonItem alloc] initWithTitle:@"  Scan  " style:UIBarButtonItemStyleBordered target:self action:@selector(startScan)];
        //cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(actionButtonCancelScan:)];

        connectedDeviceInfo = [NSMutableArray new];//连接设备信息
        connectingList = [NSMutableArray new];//连接列表

        deviceInfo = [[DeviceInfo alloc]init];//设备信息
        refreshDeviceListTimer = nil;//刷新设备列表指示器
        uuidSettingViewController = nil;//UUID设置视图控制器
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImage *   image = [UIImage imageNamed:@"返回白底"];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button addTarget:self action:@selector(respondToLeftButtonClickEvent) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = leftBarButton;

    // Do any additional setup after loading the view from its nib.
    [self setConnectionStatus:LE_STATUS_IDLE];//连接状态
    //版本标签
    [versionLabel setText:[NSString stringWithFormat:@"BLETR %@, %s",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"], __DATE__]];
    
}

- (void)viewDidAppear:(BOOL)animated {
    
//    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    [[appDelegate navigationController] setToolbarHidden:NO animated:NO];
//
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
    
    [devicesTableView release];
    devicesTableView = nil;
    [self setVersionLabel:nil];
    [refreshButton release];
    refreshButton = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)respondToLeftButtonClickEvent{

    [self.navigationController popViewControllerAnimated:YES];
}

//收到内存警告
- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    NSLog(@"[ConnectViewController] didReceiveMemoryWarning");
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)dealloc {
    [devicesTableView release];
    [versionLabel release];
    [refreshButton release];
    [cancelButton release];
    [scanButton release];
//    [uuidSettingViewController release];
    [uuidSettingButton release];
    [super dealloc];
}
//显示设备列表
- (void) displayDevicesList {
    [devicesTableView reloadData];
}

//切换至页面主要特征
- (void) switchToMainFeaturePage {
    NSLog(@"[ConnectViewController] switchToMainFeaturePage");

//    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    if ([[[appDelegate navigationController] viewControllers] containsObject:[deviceInfo mainViewController]] == FALSE) {
//        [[appDelegate navigationController] pushViewController:[deviceInfo mainViewController] animated:YES];
//    }
    
}

- (int) connectionStatus {
    return connectionStatus;
}

//连接状态
- (void) setConnectionStatus:(int)status {
    if (status == LE_STATUS_IDLE) {
        statusLabel.textColor = [UIColor redColor];
    }
    else {
        statusLabel.textColor = [UIColor blackColor];
    }
    connectionStatus = status;

    switch (status) {
        case LE_STATUS_IDLE:
            statusLabel.text = @"Idle";
            [activityIndicatorView stopAnimating];
            break;
        case LE_STATUS_SCANNING:
            [devicesTableView reloadData];
            statusLabel.text = @"Scanning...";
            [activityIndicatorView startAnimating];
            break;
        default:
            break;
    }
    [self updateButtonType];
}
//动作按钮取消扫描
- (IBAction)actionButtonCancelScan:(id)sender {
    NSLog(@"[ConnectViewController] actionButtonCancelScan");
    [self stopScan];
    [self setConnectionStatus:LE_STATUS_IDLE];
}
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
//弹出到根试图
-(void)popToRootPage {
//    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    if (appDelegate.pageTransition == FALSE) {
//        [[appDelegate navigationController] popToRootViewControllerAnimated:NO];
//    }
//    else {
//        [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(popToRootPage) userInfo:nil repeats:NO];
//    }
}
//更新发现外设
- (void)updateDiscoverPeripherals {
    [super updateDiscoverPeripherals];
    [devicesTableView reloadData];
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
    [self updateButtonType];
    
    if(connectionStatus == LE_STATUS_SCANNING){
        [self stopScan];
        [self startScan];
        [devicesTableView reloadData];
    }
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
    [self updateButtonType];
}

// DataSource methods
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

    UITableViewCell *cell;
    
    switch (indexPath.section) {
        case 0:
        {
            //NSLog(@"[ConnectViewController] CellForRowAtIndexPath section 0, Row = %d",[indexPath row]);
            cell = [tableView dequeueReusableCellWithIdentifier:@"connectedList"];
            if (cell == nil) {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"connectedList"] autorelease];
            }
            DeviceInfo *tmpDeviceInfo = [connectedDeviceInfo objectAtIndex:indexPath.row];
            
            cell.textLabel.text = tmpDeviceInfo.myPeripheral.advName;
            cell.detailTextLabel.text = @"connected";
            cell.accessoryView = nil;
            if (cell.textLabel.text == nil)
                cell.textLabel.text = @"Unknow";
            
            UIButton *accessoryButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [accessoryButton addTarget:self action:@selector(actionButtonDisconnect:)  forControlEvents:UIControlEventTouchUpInside];
            accessoryButton.tag = indexPath.row;
            [accessoryButton setTitle:@"Disonnect" forState:UIControlStateNormal];
            [accessoryButton setFrame:CGRectMake(0,0,100,35)];
            cell.accessoryView  = accessoryButton;           
        }
            break;
            
        case 1:
        {
            //NSLog(@"[ConnectViewController] CellForRowAtIndexPath section 1, Row = %d",[indexPath row]);
            
            cell = [tableView dequeueReusableCellWithIdentifier:@"devicesList"];
            if (cell == nil) {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"devicesList"] autorelease];
            }
            MyPeripheral *tmpPeripheral = [devicesList objectAtIndex:indexPath.row];
            cell.textLabel.text = tmpPeripheral.advName;
            cell.detailTextLabel.text = @"";
            cell.accessoryView = nil;
            if (tmpPeripheral.connectStaus == MYPERIPHERAL_CONNECT_STATUS_CONNECTING) {
                cell.detailTextLabel.text = @"connecting...";
                UIButton *accessoryButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                [accessoryButton addTarget:self action:@selector(actionButtonCancelConnect:)  forControlEvents:UIControlEventTouchUpInside];
                accessoryButton.tag = indexPath.row;
                [accessoryButton setTitle:@"Cancel" forState:UIControlStateNormal];
                [accessoryButton setFrame:CGRectMake(0,0,100,35)];
                cell.accessoryView  = accessoryButton;
                
            }
            
            if (cell.textLabel.text == nil)
                cell.textLabel.text = @"Unknow";
        }
            break;
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	
	NSString *title = nil;
	switch (section) {
        case 0:
            title = @"Connected Device:";
            break;
		case 1:
			title = @"Discovered Devices:";
			break;
            
		default:
			break;
	}
	return title;
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
            [activityIndicatorView stopAnimating];
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
            NSLog(@"[ConnectViewController] didSelectRowAtIndexPath section 0, Row = %ld",(long)[indexPath row]);
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
                [self updateButtonType];
            }
            break;
        }
        default:
            break;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
//刷新设备列表
- (IBAction)refreshDeviceList:(id)sender {
    NSLog(@"[ConnectViewController] refreshDeviceList");
        [self stopScan];
        [self startScan];
        [devicesTableView reloadData];
}
//手动设置UUID
- (IBAction)manualUUIDSetting:(id)sender {
    if (uuidSettingViewController == nil) {
        uuidSettingViewController = [[UUIDSettingViewController alloc] initWithNibName:@"UUIDSettingViewController" bundle:nil];
    }
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if ([[[appDelegate navigationController] viewControllers] containsObject:uuidSettingViewController] == FALSE) {
        [[appDelegate navigationController] pushViewController:uuidSettingViewController animated:YES];
    }
}

//Derek 动作按钮断开
- (IBAction)actionButtonDisconnect:(id)sender {
    //NSLog(@"[ConnectViewController] actionButtonDisconnect idx = %d",[sender tag]);
    int idx = [sender tag];
    DeviceInfo *tmpDeviceInfo = [connectedDeviceInfo objectAtIndex:idx];
    [self disconnectDevice:tmpDeviceInfo.myPeripheral];
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
    [self updateButtonType];
}

//更新按钮
- (void) updateButtonType {
    NSArray *toolbarItems = nil;
    switch (connectionStatus) {
        case LE_STATUS_IDLE:
            if (([connectedDeviceInfo count] > 0)||([connectingList count] > 0)) {
                toolbarItems = [[NSArray alloc] initWithObjects:scanButton, nil];
            }
            else {
                toolbarItems = [[NSArray alloc] initWithObjects:scanButton, uuidSettingButton, nil];
            }
            [self setToolbarItems:toolbarItems animated:NO];
            [toolbarItems release];
            break;
        case LE_STATUS_SCANNING:
            if (([connectedDeviceInfo count] > 0)||([connectingList count] > 0)) {
                toolbarItems = [[NSArray alloc] initWithObjects:refreshButton,cancelButton , nil];
            }
            else {
                toolbarItems = [[NSArray alloc] initWithObjects: refreshButton,cancelButton, uuidSettingButton, nil];
            }
            [self setToolbarItems:toolbarItems animated:NO];
            [toolbarItems release];
            break;
    }
}

@end











