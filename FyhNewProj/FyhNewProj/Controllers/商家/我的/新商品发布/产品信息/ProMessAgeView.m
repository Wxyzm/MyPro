//
//  ProMessAgeView.m
//  FyhNewProj
//
//  Created by yh f on 2017/10/30.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "ProMessAgeView.h"

@interface ProMessAgeView ()<UITextFieldDelegate>



@end


@implementation ProMessAgeView{
    
    UILabel     *_lengthLab;       //字符串长度显示lab
    
}

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorFromRGB(WhiteColorValue);
        [self setUp];
    }
    
    return self;
}

- (void)setUp
{
    
    
    UIView *topView = [BaseViewFactory  viewWithFrame:CGRectMake(0, 0, ScreenWidth, 39) color:UIColorFromRGB(0xe6e9ed)];
    [self addSubview:topView];
    
    UILabel *showLab = [BaseViewFactory labelWithFrame:CGRectMake(16, 0, ScreenWidth - 32, 39) textColor:UIColorFromRGB(0x434a54) font:APPFONT(15) textAligment:NSTextAlignmentLeft andtext:@"产品信息"];
    [self addSubview:showLab];


    UILabel *nameLab = [BaseViewFactory labelWithFrame:CGRectMake(16, 39, 100, 48) textColor:UIColorFromRGB(0x434a54) font:APPFONT(15) textAligment:NSTextAlignmentLeft andtext:@"产品标题"];
    [self addSubview:nameLab];
    
    UILabel *kindLab = [BaseViewFactory labelWithFrame:CGRectMake(16, 87, ScreenWidth - 32, 48) textColor:UIColorFromRGB(0x434a54) font:APPFONT(15) textAligment:NSTextAlignmentLeft andtext:@"类目"];
    [self addSubview:kindLab];
    
    UILabel *unitLab = [BaseViewFactory labelWithFrame:CGRectMake(16, 135, ScreenWidth - 32, 48) textColor:UIColorFromRGB(0x434a54) font:APPFONT(15) textAligment:NSTextAlignmentLeft andtext:@"产品规格"];
    [self addSubview:unitLab];
    
    _ProNameTxt = [BaseViewFactory textFieldWithFrame:CGRectMake(100, 39, ScreenWidth -165,48) font:APPFONT(15) placeholder:@"请输入商品标题(30字以内)" textColor:UIColorFromRGB(0x434a54) placeholderColor:UIColorFromRGB(LineColorValue) delegate:self];
    _ProNameTxt.textAlignment = NSTextAlignmentRight;
    [self addSubview:_ProNameTxt];
    [_ProNameTxt addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    _lengthLab = [BaseViewFactory labelWithFrame:CGRectMake(ScreenWidth -65, 39, 50, 48) textColor:UIColorFromRGB(BlackColorValue) font:APPFONT(15) textAligment:NSTextAlignmentCenter andtext:@"0/60"];
    [self addSubview:_lengthLab];
    
    UIImageView *imageView1 =[BaseViewFactory icomWithWidth:10 imagePath:@"right"];
    [self addSubview:imageView1];
    imageView1.frame = CGRectMake(ScreenWidth - 26, 87+16, 10, 16);
    
    UIImageView *imageView2 =[BaseViewFactory icomWithWidth:10 imagePath:@"right"];
    [self addSubview:imageView2];
    imageView2.frame = CGRectMake(ScreenWidth - 26, 135+16, 10, 16);
    
    _KindLab =[BaseViewFactory labelWithFrame:CGRectMake(100, 87, ScreenWidth -136,48) textColor:UIColorFromRGB(0xaab2bd) font:APPFONT(15) textAligment:NSTextAlignmentRight andtext:@"选择类目"];
    [self addSubview:_KindLab];
    
    _UnitLab =[BaseViewFactory labelWithFrame:CGRectMake(100, 135, ScreenWidth -136,48) textColor:UIColorFromRGB(RedColorValue) font:APPFONT(15) textAligment:NSTextAlignmentRight andtext:@"未编辑"];
    [self addSubview:_UnitLab];
    
    for (int i = 0; i<2; i++) {
        UIView *line = [BaseViewFactory viewWithFrame:CGRectMake(0, 39+48+48*i, ScreenWidth, 0.5) color:UIColorFromRGB(0xe6e9ed)];
        [self addSubview:line];
    }
    
    
}


//词典转换为字符串
- (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    //    if (textField == _goodNameTxt) {
    //        if ([string isEqualToString:@""]) {
    //            return YES;
    //        }
    //        if ([self convertToByte:_goodNameTxt.text]>30) {
    //            [self showTextHud:@"最多输入30个字符"];
    //            return NO;
    //        }
    //    }
    
    return YES;
    
}

- (void)textFieldDidChange:(UITextField *)textField {
    
    if (textField == _ProNameTxt){
        int count=[self textLength:_ProNameTxt.text];
        
        _lengthLab.text = [NSString stringWithFormat:@"%d/60",count];
        
        
    }
    
}
- (int)textLength:(NSString *)text//计算字符串长度
{
    int strlength = 0;
    char* p = (char*)[text cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[text lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
    }
    return strlength;
}

@end
