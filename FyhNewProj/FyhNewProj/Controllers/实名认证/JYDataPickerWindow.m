//
//  JYDataPickerWindow.m
//  Pindai
//
//  Created by admin on 16/7/18.
//  Copyright © 2016年 jytec. All rights reserved.
//

#import "JYDataPickerWindow.h"
#import "UIView+SDAutoLayout.h"
#import "ProjectMacro.h"
#import "SubBtn.h"
static const NSInteger MAIN_BODY_HEIGHT = 260;


@interface JYDataPickerWindow ()<UIPickerViewDataSource,UIPickerViewDelegate>
{
    BOOL isShowInView;
    UIView *backgroundView;
    UIView *mainBodyView;
    SubBtn *_baocunBtn;
    NSInteger _ci;
}

@property(strong, nonatomic) NSMutableArray * yearsArr;
@property(strong, nonatomic) NSMutableArray * mouthsArr;
@property(strong, nonatomic) NSMutableArray * datesArr;
@property(strong, nonatomic) NSMutableArray * timesArr;


@end


@implementation JYDataPickerWindow


-(instancetype)init{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        self.backgroundColor = [UIColor clearColor];

    }
   
    backgroundView = [[UIView alloc] initWithFrame:self.frame];
    backgroundView.backgroundColor = [UIColor blackColor];
    backgroundView.alpha = 0;
    [self addSubview:backgroundView];
    [self initDataSource];
    [self initMainBodyView];
    return self;
}
- (void)initDataSource
{
    self.yearsArr = [[NSMutableArray alloc]init];
    for (int i = 1980; i<2149; i ++) {
        [self.yearsArr addObject:[NSString stringWithFormat:@"%d",i]];
    }
    self.mouthsArr = [[NSMutableArray alloc]init];
    for (int i = 1; i <13; i ++) {
        [self.mouthsArr addObject:[NSString stringWithFormat:@"%d",i]];
    }
    self.datesArr = [[NSMutableArray alloc]init];
    for (int i = 1; i <32; i ++) {
        [self.datesArr addObject:[NSString stringWithFormat:@"%d",i]];
    }
    
   
   NSString *today =  [self loadtoday];
   NSArray *timearr = [today componentsSeparatedByString:@"-"];
    self.yearIndex = [timearr[0] integerValue] -1980;
    self.mouthIndex = [timearr[1] integerValue] - 1;
    self.dateIndex = [timearr[2] integerValue] - 1;
    
}

- (void) initMainBodyView
{
    mainBodyView = [[UIView alloc] initWithFrame:CGRectMake(20, -MAIN_BODY_HEIGHT, ScreenWidth-40, MAIN_BODY_HEIGHT)];
    mainBodyView.backgroundColor = [UIColor whiteColor];
    mainBodyView.layer.cornerRadius = 10;
    mainBodyView.clipsToBounds = YES;
    [self addSubview:mainBodyView];
    
    self.picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 50, mainBodyView.frame.size.width, 150)];
    self.picker.delegate = self;
    self.picker.dataSource = self;
    self.picker.showsSelectionIndicator = YES;
    self.picker.backgroundColor = [UIColor whiteColor];
    [mainBodyView addSubview:self.picker];
    [self.picker selectRow:self.yearIndex inComponent:0 animated:YES];
    [self.picker selectRow:self.mouthIndex inComponent:1 animated:YES];
    [self.picker selectRow:self.dateIndex inComponent:2 animated:YES];

    _selectedYear = _yearsArr[_yearIndex];
    _selectedMonth  = _mouthsArr[_mouthIndex];
    _selectedDay = _datesArr[_dateIndex];
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 18, mainBodyView.frame.size.width, 18)];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.textAlignment = NSTextAlignmentCenter;
    headerLabel.text = @"选择日期";
    headerLabel.textColor = UIColorFromRGB(0x333333);
    headerLabel.font = FSYSTEMBLODFONTT(14);
    [mainBodyView addSubview:headerLabel];
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [mainBodyView addSubview:closeBtn];
    [closeBtn setBackgroundImage:[UIImage imageNamed:@"icon_cancels"] forState:UIControlStateNormal];
    closeBtn.sd_layout.rightSpaceToView(mainBodyView,20).widthIs(30).heightIs(30).topSpaceToView(mainBodyView,-15);
    [closeBtn addTarget:self action:@selector(closetheStand) forControlEvents:UIControlEventTouchUpInside];
    
    
    _dateLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 48, mainBodyView.frame.size.width, 18)];
    _dateLab.backgroundColor = [UIColor clearColor];
    _dateLab.textAlignment = NSTextAlignmentCenter;
    _dateLab.text = [NSString stringWithFormat:@"%@年%@月%@日",_yearsArr[_yearIndex],_mouthsArr[_mouthIndex],_datesArr[_dateIndex]];
    _dateLab.textColor = UIColorFromRGB(0x000000);
    _dateLab.font = FSYSTEMBLODFONTT(14);
    [mainBodyView addSubview:_dateLab];
    
    UIView *downview = [[UIView alloc]initWithFrame:CGRectMake(0, mainBodyView.frame.size.height - 40,  mainBodyView.frame.size.width, 20)];
    downview.backgroundColor = UIColorFromRGB(0x000000);
    [mainBodyView addSubview:downview];


    _baocunBtn = [SubBtn buttonWithtitle:@"保存" backgroundColor:UIColorFromRGB(RedColorValue) titlecolor:UIColorFromRGB(0xffffff) cornerRadius:0 andtarget:self action:@selector(baocunClick)];
    [mainBodyView addSubview:_baocunBtn];
    _baocunBtn.frame = CGRectMake(0, mainBodyView.frame.size.height - 40,  mainBodyView.frame.size.width, 40);
    
    
    

}


- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
        switch (component) {
            case 0:
                return [self.yearsArr count];
                break;
            case 1:
                return [self.mouthsArr count];
                break;
            case 2:
                return [self.datesArr count];
                break;
                
            default:
                return 0;
                break;
        }

    
    }

#pragma mark- Picker Delegate Methods
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
        switch (component) {
            case 0:
                return [NSString stringWithFormat:@"%@年",self.yearsArr[row]] ;
                break;
            case 1:
                return [NSString stringWithFormat:@"%@月",self.mouthsArr[row]];
                break;
            case 2:
                return [NSString stringWithFormat:@"%@日",self.datesArr[row]];
                break;
                
            default:
                return nil;
                break;
        }

   
    
    }
- (UIView*)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *textLabel = (UILabel*)view;
    if (!textLabel) {
        textLabel = [[UILabel alloc] init];
        textLabel.font = FSYSTEMBLODFONTT(14);
        textLabel.numberOfLines = 2;
        
        [textLabel setTextAlignment:NSTextAlignmentCenter];
        [textLabel setBackgroundColor:[UIColor clearColor]];
    }
    textLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    ((UIView *)[pickerView.subviews objectAtIndex:1]).backgroundColor = [UIColor clearColor];
    
    ((UIView *)[pickerView.subviews objectAtIndex:2]).backgroundColor = [UIColor clearColor];
        if (component == 0) {
            if (row == _yearIndex) {
                textLabel.textColor = UIColorFromRGB(0x000000);
            }
        }else if (component == 1){
            if (row == _mouthIndex) {
                textLabel.textColor = UIColorFromRGB(0x000000);
            }
        }else if (component == 2){
            if (row == _dateIndex) {
                textLabel.textColor = UIColorFromRGB(0x000000);
            }
        }

    
    
            return textLabel;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 50;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
        if (component == 0) {
            _yearIndex = row;
        }else if (component == 1){
            _mouthIndex = row;
        }else if (component == 2){
            _dateIndex = row;
        }
        [self.picker reloadAllComponents];
        _dateLab.text = [NSString stringWithFormat:@"%@年%@月%@日",_yearsArr[_yearIndex],_mouthsArr[_mouthIndex],_datesArr[_dateIndex]];
    _selectedYear = _yearsArr[_yearIndex];
    _selectedMonth  = _mouthsArr[_mouthIndex];
    _selectedDay = _datesArr[_dateIndex];
    
}

#pragma mark - animation

//显示
- (void)show
{
    if (isShowInView) return;
    [self makeKeyAndVisible];
    isShowInView = YES;
    
    
    
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = mainBodyView.frame;
        frame.origin.y = 100;
        mainBodyView.frame = frame;
        backgroundView.alpha = 0.75;
    } completion:^(BOOL finished) {
        [self setHidden:NO];
    }];
}
//消失
- (void)cancelPicker
{
    if (!isShowInView) return;
    isShowInView = NO;

    [UIView animateWithDuration:0.3
                     animations:^{
                         CGRect frame = mainBodyView.frame;
                         frame.origin.y = -MAIN_BODY_HEIGHT;
                         mainBodyView.frame = frame;
                         backgroundView.alpha = 0.75;
                     }
                     completion:^(BOOL finished){
                         [self setHidden:YES];
                     }];
}

//消失
- (void)aaaacancelPicker
{
    if (!isShowInView) return;
    isShowInView = NO;
   
    [UIView animateWithDuration:0.3
                     animations:^{
                         CGRect frame = mainBodyView.frame;
                         frame.origin.y = -MAIN_BODY_HEIGHT;
                         mainBodyView.frame = frame;
                         backgroundView.alpha = 0.75;
                     }
                     completion:^(BOOL finished){
                         [self setHidden:YES];
                     }];
}



- (void)baocunClick{
  //  int a = [self compareDate:[self aloadtoday] withDate:_dateLab.text];
        if ([self.delegate respondsToSelector:@selector(DataPickerWindowbaocunBtnCilck)]) {
        [self.delegate DataPickerWindowbaocunBtnCilck];
    }
}



- (void)closetheStand{

    [self aaaacancelPicker];
}

//比较时间大小
-(int)compareDate:(NSString*)date01 withDate:(NSString*)date02{
//    int ci;
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy年MM月dd日"];
    NSDate *dt1 = [[NSDate alloc] init];
    NSDate *dt2 = [[NSDate alloc] init];
    dt1 = [df dateFromString:date01];
    dt2 = [df dateFromString:date02];
    NSComparisonResult result = [dt1 compare:dt2];
    switch (result)
    {
            //date02比date01大
        case NSOrderedAscending: _ci=1; break;
            //date02比date01小
        case NSOrderedDescending: _ci=-1; break;
            //date02=date01
        case NSOrderedSame: _ci=0; break;
        default: NSLog(@"erorr dates %@, %@", dt2, dt1); break;
    }
    return _ci;
}


- (NSString *)loadtoday{
    NSDate *  senddate=[NSDate date];
    
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:@"YYYY年-MM月-dd日"];
    
    NSString *  locationString=[dateformatter stringFromDate:senddate];
    return locationString;
}
- (NSString *)loadtodayandtime{
    NSDate *  senddate=[NSDate date];
    
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:@"HH:MM"];
    
    NSString *  locationString=[dateformatter stringFromDate:senddate];
    return locationString;
}
- (NSString *)aloadtoday{
    NSDate *  senddate=[NSDate date];
    
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:@"YYYY年MM月dd日"];
    
    NSString *  locationString=[dateformatter stringFromDate:senddate];
    return locationString;
}

- (NSString *)loadtime{
    NSDate *  senddate=[NSDate date];
    
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:@"HH:MM"];
    
    NSString *  locationString=[dateformatter stringFromDate:senddate];
    return locationString;
}
@end
