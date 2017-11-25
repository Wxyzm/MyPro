//
//  AdressPickerView.m
//  FyhNewProj
//
//  Created by yh f on 2017/5/4.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "AdressPickerView.h"

@interface AdressPickerView()<UIPickerViewDataSource,UIPickerViewDelegate>
{
    BOOL _isShowInView;
    NSMutableArray *_ALLCitysArr;
    NSMutableArray *_ALLareasArr;
}


@end


@implementation AdressPickerView


- (id)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    if (self) {
        self.frame = CGRectMake(0, 0, ScreenWidth, 210);
        self.backgroundColor = [UIColor whiteColor];
        CGRect tempFram = self.bounds;
        tempFram.origin.y += 44;
        tempFram.size.height -= 44;
        self.areaPicker = [[UIPickerView alloc] initWithFrame:tempFram];
        self.areaPicker.delegate = self;
        self.areaPicker.dataSource = self;
        self.areaPicker.showsSelectionIndicator = YES;
        CALayer *viewLayer = self.areaPicker.layer;
        [viewLayer setBounds:CGRectMake(0.0, 0.0, ScreenWidth, 175)];
        
        //self.areaPicker = [[UIPickerView alloc] initWithFrame:self.bounds];
        //self.areaPicker.delegate = self;
        //self.areaPicker.dataSource = self;
        //self.areaPicker.showsSelectionIndicator = YES;
        //CALayer *viewLayer = self.areaPicker.layer;
        // [viewLayer setBounds:CGRectMake(0.0, 0.0, 320, 175)];
        [self addSubview:self.areaPicker];
        
        //加载数据
        NSString *path1 = [[NSBundle mainBundle] pathForResource:@"provinces" ofType:@"json"];
        NSString *path2 = [[NSBundle mainBundle] pathForResource:@"cities" ofType:@"json"];
        NSString *path3 = [[NSBundle mainBundle] pathForResource:@"areas" ofType:@"json"];
        
        NSData *fileData1 = [NSData dataWithContentsOfFile:path1];
        NSData *fileData2 = [NSData dataWithContentsOfFile:path2];
        NSData *fileData3 = [NSData dataWithContentsOfFile:path3];
        
        _provinces = [[NSMutableArray alloc]initWithCapacity:0];
        _cities = [[NSMutableArray alloc]initWithCapacity:0];
        _areas  = [[NSMutableArray alloc]initWithCapacity:0];
        NSDictionary * AllproDic = [NSJSONSerialization JSONObjectWithData:fileData1 options:NSJSONReadingMutableLeaves error:nil];
        _provinces = AllproDic[@"provinces"];
        
        NSDictionary * AllcityDic= [NSJSONSerialization JSONObjectWithData:fileData2 options:NSJSONReadingMutableLeaves error:nil];
        _ALLCitysArr = AllcityDic[@"cities"];
        
        NSDictionary * AllareasDic= [NSJSONSerialization JSONObjectWithData:fileData3 options:NSJSONReadingMutableLeaves error:nil];
        _ALLareasArr = AllareasDic[@"areas"];

        NSDictionary *proDic = [_provinces objectAtIndex:0];
        [_cities removeAllObjects];
        for (NSDictionary *cityDic in _ALLCitysArr) {
            if ([cityDic[@"parent_code"] isEqualToString:proDic[@"code"]]) {
                [_cities addObject:cityDic];
            }
        }
        NSDictionary *cityDic = [_cities objectAtIndex:0];
        [_areas removeAllObjects];
        for (NSDictionary *areaDic in _ALLareasArr) {
            if ([areaDic[@"parent_code"] isEqualToString:cityDic[@"code"]]) {
                [_areas addObject:areaDic];
            }
        }
        
        
        self.provinceDic = proDic;
        self.cityDic = cityDic;
        self.areaDic = _areas[0];

        
        

    }
     [self addRemoveBtn:YES];
    return self;
}
- (void) addRemoveBtn:(BOOL)followedOperation
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
    [self addSubview:view];
    
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth-66, 0, 50, 44)];
    [cancelBtn setTitle:@"确定" forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [cancelBtn setTitleColor:UIColorFromRGB(0xc61616) forState:UIControlStateNormal];
    if (followedOperation)
        [cancelBtn addTarget:self action:@selector(whenSelectionConfirmed) forControlEvents:UIControlEventTouchUpInside];
    else
        [cancelBtn addTarget:self action:@selector(cancelPicker) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:cancelBtn];
}

- (void)whenSelectionConfirmed
{
    [self cancelPicker];


}


#pragma mark-picker Data Source Methods
- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return  3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (0 == component) {
        return _provinces.count;
    }else if (1 == component) {
        return _cities.count;
    }else {
        return _areas.count;
    }
}

#pragma mark- Picker Delegate Methods
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            return [[_provinces objectAtIndex:row] objectForKey:@"name"];
            break;
            
        case 1:
            return [[_cities objectAtIndex:row] objectForKey:@"name"];
            break;
            
        case 2:
            if (_areas.count > row) {
                return [[_areas objectAtIndex:row]objectForKey:@"name"];
                break;
            }
            
        default:
            return @"";
            break;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch (component) {
        case 0:{
            NSDictionary *proDic = [_provinces objectAtIndex:row];
            [_cities removeAllObjects];
            for (NSDictionary *cityDic in _ALLCitysArr) {
                if ([cityDic[@"parent_code"] isEqualToString:proDic[@"code"]]) {
                    [_cities addObject:cityDic];
                }
            }
            NSDictionary *cityDic = [_cities objectAtIndex:0];
            [_areas removeAllObjects];
            for (NSDictionary *areaDic in _ALLareasArr) {
                if ([areaDic[@"parent_code"] isEqualToString:cityDic[@"code"]]) {
                    [_areas addObject:areaDic];
                }
            }
            [self.areaPicker selectRow:0 inComponent:1 animated:NO];
            [self.areaPicker reloadComponent:1];
            [self.areaPicker selectRow:0 inComponent:2 animated:NO];
            [self.areaPicker reloadComponent:2];
            self.provinceIndex = row;
            self.provinceDic = proDic;
            self.cityDic = cityDic;
            self.areaDic = _areas[0];
            
            break;
        }
        case 1:{
            NSDictionary *cityDic = [_cities objectAtIndex:row];
            [_areas removeAllObjects];
            for (NSDictionary *areaDic in _ALLareasArr) {
                if ([areaDic[@"parent_code"] isEqualToString:cityDic[@"code"]]) {
                    [_areas addObject:areaDic];
                }
            }
            [self.areaPicker reloadComponent:2];
            [self.areaPicker selectRow:0 inComponent:2 animated:NO];
            self.cityIndex = row;
            self.cityDic = cityDic;
            self.areaDic = _areas[0];
            
            break;
        
        }
        case 2:{
            self.areaDic = _areas[row];
            break;
        }
        default:
            break;
    }
    //代理自动调用
    if ([self.delegate respondsToSelector:@selector(pickerDidChaneStatus:)]) {
        [self.delegate pickerDidChaneStatus:self];
    }

}

#pragma mark - animation

//显示
- (void)showInView:(UIView *) view
{
    if (_isShowInView) return;
    self.frame = CGRectMake(0, view.frame.size.height, self.frame.size.width, self.frame.size.height);
    [view addSubview:self];
    if ([self.delegate respondsToSelector:@selector(pickerDidChaneStatus:)]) {
        [self.delegate pickerDidChaneStatus:self];
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, view.frame.size.height - self.frame.size.height, self.frame.size.width, self.frame.size.height);
    }];
    _isShowInView = YES;
}

//消失
- (void)cancelPicker
{
    if (!_isShowInView) return;
    
    
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.frame = CGRectMake(0, self.frame.origin.y+self.frame.size.height, self.frame.size.width, self.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         [self removeFromSuperview];
                         
                     }];
    _isShowInView = NO;
}

@end
