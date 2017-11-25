//
//  HTMLViewController.m
//  FyhNewProj
//
//  Created by yh f on 2017/6/10.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "HTMLViewController.h"
#import "UpImagePL.h"
#import "TZImagePickerController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "TZImageManager.h"
#import "TZVideoPlayerController.h"
#import "TZPhotoPreviewController.h"
#import "TZGifPhotoPreviewController.h"
#import "UIView+Layout.h"
#import "MBProgressHUD+Add.h"

@interface HTMLViewController ()<UIWebViewDelegate,
TZImagePickerControllerDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate,UINavigationControllerDelegate>

{
    NSString *_htmlString;//保存输出的富文本
    NSMutableArray *_imageArr;//保存添加的图片
    NSMutableArray *_AllimageArr;//保存添加的图片

}

@property (nonatomic,strong)UIWebView *webView;

@end

@implementation HTMLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"商品描述";
    [self setBarBackBtnWithImage:nil];
    UIBarButtonItem *save = [[UIBarButtonItem alloc]initWithTitle:@"save" style:UIBarButtonItemStyleDone target:self action:@selector(saveText)];
    self.navigationItem.rightBarButtonItem = save;
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64)];
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
    
    NSBundle *bundle = [NSBundle mainBundle];
    NSURL *indexFileURL = [bundle URLForResource:@"richTextEditor" withExtension:@"html"];
    
    [self.webView setKeyboardDisplayRequiresUserAction:NO];
    [self.webView loadRequest:[NSURLRequest requestWithURL:indexFileURL]];
    
    UIView *downView = [[UIView alloc]initWithFrame:CGRectMake(15, ScreenHeight - 64 -100, ScreenWidth - 30, 50)];
    downView.layer.cornerRadius = 5;
    downView.layer.borderWidth = 1;
    downView.layer.borderColor = UIColorFromRGB(RedColorValue).CGColor;
    downView.clipsToBounds = YES;
    [self.view addSubview:downView];
    
    SubBtn *addImBtn = [SubBtn buttonWithtitle:@"添加图片" titlecolor:UIColorFromRGB(WhiteColorValue) cornerRadius:0 andtarget:self action:@selector(addImage) andframe:CGRectMake(0, 0, downView.width/2, 50)];
    addImBtn.titleLabel.font = APPFONT(18);
    [downView addSubview:addImBtn];
    
    SubBtn *completebtn = [SubBtn buttonWithtitle:@"完成" backgroundColor:UIColorFromRGB(WhiteColorValue) titlecolor:UIColorFromRGB(RedColorValue) cornerRadius:0 andtarget:self action:@selector(completebtnclick)];
    [downView addSubview:completebtn ];
    completebtn.titleLabel.font = APPFONT(18);
    completebtn .frame = CGRectMake(downView.width/2, 0, downView.width/2, 50);
    
    

    
    _imageArr = [NSMutableArray arrayWithCapacity:0];
    _AllimageArr = [NSMutableArray arrayWithCapacity:0];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if (self.inHtmlString.length > 0)
    {
        NSString *place ;
        place = [NSString stringWithFormat:@"window.placeHTMLToEditor('%@')",self.inHtmlString];

        [webView stringByEvaluatingJavaScriptFromString:place];
    }
}


- (void)addImage
{
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:5 columnNumber:5 delegate:self pushPhotoPickerVc:YES];
    
    
#pragma mark - 四类个性化设置，这些参数都可以不传，此时会走默认设置
    imagePickerVc.isSelectOriginalPhoto = NO;
    
    //    if (_urlPhotos.count>0) {
    //
    //    }else{
    //        imagePickerVc.selectedAssets = _selectedAssets; // 目前已经选中的图片数组
    //
    //    }
    
    imagePickerVc.allowTakePicture = NO; // 在内部显示拍照按钮
    
    // 2. Set the appearance
    // 2. 在这里设置imagePickerVc的外观
    imagePickerVc.navigationBar.barTintColor = UIColorFromRGB(RedColorValue);
    imagePickerVc.oKButtonTitleColorDisabled = UIColorFromRGB(RedColorValue);
    imagePickerVc.oKButtonTitleColorNormal = UIColorFromRGB(RedColorValue);
    imagePickerVc.navigationBar.translucent = NO;
    
    // 3. Set allow picking video & photo & originalPhoto or not
    // 3. 设置是否可以选择视频/图片/原图
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingImage = YES;
    imagePickerVc.allowPickingOriginalPhoto = NO;
    imagePickerVc.allowPickingGif = NO;
    
    // 4. 照片排列按修改时间升序
    imagePickerVc.sortAscendingByModificationDate = YES;
    
    // imagePickerVc.minImagesCount = 3;
    // imagePickerVc.alwaysEnableDoneBtn = YES;
    
    // imagePickerVc.minPhotoWidthSelectable = 3000;
    // imagePickerVc.minPhotoHeightSelectable = 2000;
    
    /// 5. Single selection mode, valid when maxImagesCount = 1
    /// 5. 单选模式,maxImagesCount为1时才生效
    imagePickerVc.showSelectBtn = NO;
    imagePickerVc.allowCrop = YES;
    imagePickerVc.needCircleCrop =NO;
    imagePickerVc.circleCropRadius = 100;
    /*
     [imagePickerVc setCropViewSettingBlock:^(UIView *cropView) {
     cropView.layer.borderColor = [UIColor redColor].CGColor;
     cropView.layer.borderWidth = 2.0;
     }];*/
    
    //imagePickerVc.allowPreview = NO;
#pragma mark - 到这里为止
    
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
//    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
//
//    }];

    if (iPad) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self presentViewController:imagePickerVc animated:YES completion:nil];
        }];
    }else{
        
        [self presentViewController:imagePickerVc animated:YES completion:nil];
    }
}



- (void)completebtnclick{

    [self printHTML];

}

- (void)printHTML
{
    NSString *title = [self.webView stringByEvaluatingJavaScriptFromString:@"document.getElementById('title-input').value"];
    NSString *html = [self.webView stringByEvaluatingJavaScriptFromString:@"document.getElementById('content').innerHTML"];
    NSString *script = [self.webView stringByEvaluatingJavaScriptFromString:@"window.alertHtml()"];
    [self.webView stringByEvaluatingJavaScriptFromString:script];
    NSLog(@"Title: %@", title);
    NSLog(@"Inner HTML: %@", html);
    
    if (html.length == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入内容" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"好", nil];
        [alert show];
    }
    else
    {
        _htmlString = html;
        //对输出的富文本进行处理后上传
        NSString *yahaha = [self filterHTML:_htmlString];
        NSLog(@"正则去除网络标签 ==== %@",yahaha);
        NSArray *yahahaArr = [self getImageurlFromHtml:_htmlString];
        NSLog(@"正 ==== %@",yahahaArr);
        for (int i = 0; i<_imageArr.count; i++) {
            NSDictionary *dic = _imageArr[i];
            if ([yahahaArr containsObject:dic[@"url"]]) {
                [_AllimageArr addObject:dic[@"image"]];
            }
        }
        if (_AllimageArr.count<=0) {
            NSString *oldHtml = [self changeString:_htmlString];
            oldHtml = [oldHtml stringByReplacingOccurrencesOfString:@"<div>" withString:@"<p>"];
            oldHtml = [oldHtml stringByReplacingOccurrencesOfString:@"</div>" withString:@"</p>"];
            oldHtml = [oldHtml stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
            oldHtml = [oldHtml stringByReplacingOccurrencesOfString:@"<p><br></p>" withString:@""];
            oldHtml = [oldHtml stringByReplacingOccurrencesOfString:@"<br>" withString:@""];
            NSLog(@"%@",oldHtml);
            
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UserHavesetupGoodsHTML" object:oldHtml];
            
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
        UpImagePL *upPl = [[UpImagePL alloc]init];
        [upPl shopUpdateToByGoodsImgArr:_AllimageArr WithReturnBlock:^(id returnValue) {
            NSLog(@"%@",returnValue);
            NSString *oldHtml = [self changeString:_htmlString];
            NSArray *imageurlArr = returnValue[@"imageUrls"];
            int b = 0;
            for (int i = 0; i<yahahaArr.count; i++) {
                NSString *theImagestr = yahahaArr[i];
                if([theImagestr rangeOfString:@"test.xxx.com"].location !=NSNotFound)//_roaldSearchText
                {
                    //将提取出的 未上传的图片URL添加到图片数组中
                    NSString *imageStr = [NSString stringWithFormat:@"%@/%@",returnValue[@"cdnUrl"],imageurlArr[b]];
                    oldHtml = [oldHtml stringByReplacingOccurrencesOfString:theImagestr withString:imageStr];
                    b++;
                }
               
            }
            oldHtml = [oldHtml stringByReplacingOccurrencesOfString:@"<div>" withString:@"<p>"];
            oldHtml = [oldHtml stringByReplacingOccurrencesOfString:@"</div>" withString:@"</p>"];
            oldHtml = [oldHtml stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
            oldHtml = [oldHtml stringByReplacingOccurrencesOfString:@"<p><br></p>" withString:@""];
            oldHtml = [oldHtml stringByReplacingOccurrencesOfString:@"<br>" withString:@""];
            NSLog(@"%@",oldHtml);
           
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"newUserHavesetupGoodsHTML" object:oldHtml];

            [self.navigationController popViewControllerAnimated:YES];
           
            
        } withErrorBlock:^(NSString *msg) {
            [self showTextHud:msg];
        }];

        
        
        NSLog(@"%@",[self changeString:_htmlString]);
    
    }
    
}

#pragma mark - ImagePickerController Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{

    [picker dismissViewControllerAnimated:YES completion:nil];

    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSDate *now = [NSDate date];
    NSString *imageName = [NSString stringWithFormat:@"iOS%@.jpg", [self stringFromDate:now]];
    NSString *imagePath = [documentsDirectory stringByAppendingPathComponent:imageName];
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    UIImage *image;
    if ([mediaType isEqualToString:@"public.image"])
    {
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
        NSData *imageData = UIImageJPEGRepresentation(image, 1);
        [imageData writeToFile:imagePath atomically:YES];
    }
   // [_AllimageArr addObject:image];
    NSInteger userid = 12345;
    //对应自己服务器的处理方法,
    //此处是将图片上传ftp中特定位置并使用时间戳命名 该图片地址替换到html文件中去
    NSString *url = [NSString stringWithFormat:@"http://test.xxx.com/apps/kanghubang/%@/%@/%@",[NSString stringWithFormat:@"%ld",userid%1000],[NSString stringWithFormat:@"%ld",(long)userid ],imageName];
    
    NSString *script = [NSString stringWithFormat:@"window.insertImage('%@', '%@')", url, imagePath];
    NSDictionary *dic = @{@"url":url,@"image":image,@"name":imageName};
    [_imageArr addObject:dic];
    
    [self.webView stringByEvaluatingJavaScriptFromString:script];

    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    
    for (int i = 0; i<photos.count; i++) {

        NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
        NSTimeInterval a=[dat timeIntervalSince1970];
        
        NSString *dataStr = [NSString stringWithFormat:@"%.0f", a*1000+i*100];
        NSString *imageName = [NSString stringWithFormat:@"iOS%@.jpg", dataStr];

        NSString *imagePath = [documentsDirectory stringByAppendingPathComponent:imageName];
        // NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
         UIImage *image = photos[i];
        NSData *imageData = UIImageJPEGRepresentation(image, 1);
        [imageData writeToFile:imagePath atomically:YES];
        
        NSInteger userid = 12345;
        //对应自己服务器的处理方法,
        //此处是将图片上传ftp中特定位置并使用时间戳命名 该图片地址替换到html文件中去
        NSString *url = [NSString stringWithFormat:@"http://test.xxx.com/apps/kanghubang/%@/%@/%@",[NSString stringWithFormat:@"%ld",userid%1000],[NSString stringWithFormat:@"%ld",(long)userid ],imageName];
        
        NSString *script = [NSString stringWithFormat:@"window.insertImage('%@', '%@')", url, imagePath];
        NSDictionary *dic = @{@"url":url,@"image":image,@"name":imageName};
        [_imageArr addObject:dic];
        
        [self.webView stringByEvaluatingJavaScriptFromString:script];
        
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];

    
//    UIImage *image;
//    if ([mediaType isEqualToString:@"public.image"])
//    {
//        image = [info objectForKey:UIImagePickerControllerOriginalImage];
//        NSData *imageData = UIImageJPEGRepresentation(image, 1);
//        [imageData writeToFile:imagePath atomically:YES];
//    }
    // [_AllimageArr addObject:image];
    
    // 1.打印图片名字
//    [self printAssetsName:assets];
}


/// 打印图片名字
- (void)printAssetsName:(NSArray *)assets {
    
    
    NSString *fileName;
    for (id asset in assets) {
        if ([asset isKindOfClass:[PHAsset class]]) {
            PHAsset *phAsset = (PHAsset *)asset;
            fileName = [phAsset valueForKey:@"filename"];
        } else if ([asset isKindOfClass:[ALAsset class]]) {
            ALAsset *alAsset = (ALAsset *)asset;
            fileName = alAsset.defaultRepresentation.filename;;
        }
        NSLog(@"图片名字:%@",fileName);
    }
}




- (void)saveText
{
        [self printHTML];
}


#pragma mark - Method
-(NSString *)changeString:(NSString *)str
{
    
    NSMutableArray * marr = [NSMutableArray arrayWithArray:[str componentsSeparatedByString:@"\""]];
    
    for (int i = 0; i < marr.count; i++)
    {
        NSString * subStr = marr[i];
        if ([subStr hasPrefix:@"/var"] || [subStr hasPrefix:@" id="])
        {
            [marr removeObject:subStr];
            i --;
        }
    }
    NSString * newStr = [marr componentsJoinedByString:@"\""];
    return newStr;
    
}

- (NSString *)stringFromDate:(NSDate *)date
{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%.0f", a];
    return timeString;
}



//正则去除网络标签
-(NSString *)filterHTML:(NSString *)html
{
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    while([scanner isAtEnd]==NO)
    {
        //找到标签的起始位置
        [scanner scanUpToString:@"<" intoString:nil];
        //找到标签的结束位置
        [scanner scanUpToString:@">" intoString:&text];
        //替换字符
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
    }
    //    NSString * regEx = @"<([^>]*)>";
    //    html = [html stringByReplacingOccurrencesOfString:regEx withString:@""];
    return html;
}
//获取html中的所有图片链接地址
- (NSArray *) getImageurlFromHtml:(NSString *) webString
{
    NSMutableArray * imageurlArray = [NSMutableArray arrayWithCapacity:1];
    
    //标签匹配
    NSString *parten = @"<img(.*?)>";
    NSError* error = NULL;
    NSRegularExpression *reg = [NSRegularExpression regularExpressionWithPattern:parten options:0 error:&error];
    
    NSArray* match = [reg matchesInString:webString options:0 range:NSMakeRange(0, [webString length] - 1)];
    
    
    for (NSTextCheckingResult * result in match) {
        
        //过去数组中的标签
        NSRange range = [result range];
        NSString * subString = [webString substringWithRange:range];
        
        
        //从图片中的标签中提取ImageURL
        NSRegularExpression *subReg = [NSRegularExpression regularExpressionWithPattern:@"http://(.*?)\"" options:0 error:NULL];
        NSArray* match = [subReg matchesInString:subString options:0 range:NSMakeRange(0, [subString length] - 1)];
        if (match.count<=0) {
            return match;
        }
        NSTextCheckingResult * subRes = match[0];
        NSRange subRange = [subRes range];
        subRange.length = subRange.length -1;
        NSString * imagekUrl = [subString substringWithRange:subRange];
        
        [imageurlArray addObject:imagekUrl];

    }
    
    return imageurlArray;
}


@end
