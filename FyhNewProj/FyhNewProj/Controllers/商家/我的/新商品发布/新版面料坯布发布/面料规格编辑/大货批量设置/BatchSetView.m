//
//  BatchSetView.m
//  FyhNewProj
//
//  Created by yh f on 2017/10/31.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "BatchSetView.h"
#import "BatchSetCell.h"
#import "BatchModel.h"
#import "UpImagePL.h"
@interface BatchSetView ()<UITableViewDelegate,UITableViewDataSource,BatchSetCellDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate,UINavigationControllerDelegate>

@property (nonatomic,strong) UITableView *unitTableView;

@end

@implementation BatchSetView{
    
    NSMutableArray *_showArr;
    UIImagePickerController *_imagePicker;
    UpImagePL               *_upImagePL;                     //上传图片
    BatchModel              *_cellModel;

}

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        _dataArr = [NSMutableArray arrayWithCapacity:0];
        _showArr = [NSMutableArray arrayWithCapacity:0];
        self.backgroundColor = UIColorFromRGB(WhiteColorValue);
        [self setUp];
    }
    
    return self;
}

- (void)setUp
{
    UIView *topView = [BaseViewFactory  viewWithFrame:CGRectMake(0, 0, ScreenWidth, 12) color:UIColorFromRGB(0xf5f7fa)];
    [self addSubview:topView];
    
    UIView *line1 = [BaseViewFactory  viewWithFrame:CGRectMake(0, 0, ScreenWidth, 0.5) color:UIColorFromRGB(0xe6e9ed)];
    [topView addSubview:line1];
    
    UIView *line2 = [BaseViewFactory  viewWithFrame:CGRectMake(0, 11.5, ScreenWidth, 0.5) color:UIColorFromRGB(0xe6e9ed)];
    [topView addSubview:line2];
    
    UIView *topView1 = [BaseViewFactory  viewWithFrame:CGRectMake(0, 12, ScreenWidth, 39) color:UIColorFromRGB(0xffffff)];
    [self addSubview:topView1];
    
    UIImageView *leftImageVeiw = [BaseViewFactory icomWithWidth:14 imagePath:@"Create_batch"];
    [topView1 addSubview:leftImageVeiw];
    leftImageVeiw.frame = CGRectMake(17, 14.5, 14, 10);
    
    UILabel *showLab = [BaseViewFactory labelWithFrame:CGRectMake(39, 0,200, 39) textColor:UIColorFromRGB(0xff5d38) font:APPFONT(15) textAligment:NSTextAlignmentLeft andtext:@"批量设置"];
    [topView1 addSubview:showLab];
    
    _batchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [topView1 addSubview:_batchBtn];
    _batchBtn.frame = CGRectMake(39, 0, ScreenWidth, 39);
    
    UIView *line3 = [BaseViewFactory  viewWithFrame:CGRectMake(0, 38.5, ScreenWidth, 0.5) color:UIColorFromRGB(0xe6e9ed)];
    [topView1 addSubview:line3];
    
    if (!_unitTableView) {
        _unitTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 51, ScreenWidth, _dataArr.count*112) style:UITableViewStylePlain];
        _unitTableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
        _unitTableView.delegate = self;
        _unitTableView.dataSource = self;
        _unitTableView.bounces = NO;
        _unitTableView.scrollEnabled = NO;
        [self addSubview:_unitTableView];
    }
    
    
}

-(void)setDataArr:(NSMutableArray *)dataArr{
    
    _dataArr = dataArr;
    [_showArr removeAllObjects];
    for (BatchModel *model in dataArr) {
        if (model.isOn) {
            [_showArr addObject:model];
        }
    }
    CGRect Frame = _unitTableView.frame;
    Frame.size.height = _showArr.count*112;
    _unitTableView.frame = Frame;
    [_unitTableView reloadData];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _showArr.count;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 112;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *batCellId =  @"batCell";
    BatchSetCell *cell = [tableView dequeueReusableCellWithIdentifier:batCellId];
    if (!cell) {
        cell = [[BatchSetCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:batCellId];
    }
    cell.model = _showArr[indexPath.row];
    cell.delegate = self;
    return cell;
}

- (void)didSelectedUpImagedBtnWithCell:(BatchSetCell *)cell{
    _cellModel = cell.model;
    [self chosePhoto];
    
    
}


-(void)ChangedBatchSetCellViewData{
    
    
    
}
#pragma mark  ================  选取照片

- (void)chosePhoto{
    if (!_imagePicker) {
        _imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker.allowsEditing = YES;
        
        _imagePicker.delegate = self;
    }
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"拍照", @"从相册选取",nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
    
}
#pragma mark--------------------------------UIActionDelegate--------------------------------
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        return;
    }
    switch (buttonIndex) {
        case 0:
            // Take a photo directly!
            [self pickImageFromCamera];
            break;
        case 1:
            // Pick one from library.
            [self pickImageFromAlbum];
            break;
        default:
            break;
    }
}

#pragma mark 从摄像头获取活动图片
- (void)pickImageFromCamera
{
    _imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    _imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    if (iPad) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [[self getCurrentVC] presentViewController:_imagePicker animated:YES completion:nil];
        }];
    }else{
        
        [[self getCurrentVC] presentViewController:_imagePicker animated:YES completion:nil];
    }
}
#pragma mark 从用户相册获取活动图片
- (void)pickImageFromAlbum
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    _imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    _imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    _imagePicker.allowsEditing = NO;

    if (iPad) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [[self getCurrentVC] presentViewController:_imagePicker animated:YES completion:nil];
        }];
    }else{
        
        [[self getCurrentVC] presentViewController:_imagePicker animated:YES completion:nil];
    }
}

#pragma imagePicekr
//点击相册中的图片or照相机照完后点击use  后触发的方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [[self getCurrentVC] dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    if (!image) {
        return;
    }
    __weak __typeof(self)weakSelf = self;
    if (!_upImagePL) {
        _upImagePL = [[UpImagePL alloc]init];
    }
    
    [_upImagePL updateImg:image WithReturnBlock:^(id returnValue) {
        NSDictionary *imageDic = returnValue;
        NSArray *arr = imageDic[@"imageUrls"];
        if (arr.count<=0) {
            return ;
        }
        _cellModel .minePictureStr = arr[0];
        _cellModel.minePicture = image;
        _cellModel.cndUrl = imageDic[@"cdnUrl"];
        [_unitTableView reloadData];
       
    } withErrorBlock:^(NSString *msg) {
        [weakSelf showTextHud:msg];
    }];
    
    
    
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [[self getCurrentVC] dismissViewControllerAnimated:YES completion:nil];
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

//获取当前屏幕显示的viewcontroller
- (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}
@end
