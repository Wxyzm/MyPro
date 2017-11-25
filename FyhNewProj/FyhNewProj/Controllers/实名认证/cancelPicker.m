//
//  JYAreaPickerView.m
//  JYAreaPickerView
//
//  Created by nixinyue on 14-8-13.
//  Copyright (c) 2014年 nixinyue. All rights reserved.
//

#import "JYAreaPickerView.h"
#import "ProjectMacro.h"
#import <QuartzCore/QuartzCore.h>


@interface JYAreaPickerView()<UIPickerViewDataSource,UIPickerViewDelegate>
{
    BOOL _isShowInView;
}
@end

@implementation JYAreaPickerView

- (id)initWithFrame:(CGRect)frame type:(NSInteger)type
{
    self = [super initWithFrame:frame];
    if (self) {
        self.type = type;
        // Initialization code
        //创建页面加载数据
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
        
        //数据类的实例化
        self.locate = [[JYLocation alloc] init];
        //数据加载
        if (self.type == AreaWithBuXian){
            _provinces = [[NSMutableArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"area1.plist" ofType:nil]];
        } else {
            _provinces = [[NSMutableArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"area_with_all.plist" ofType:nil]];
        }
    
        _cities = [[_provinces objectAtIndex:0] objectForKey:@"cities"];
        
        self.locate.state = [[_provinces objectAtIndex:0] objectForKey:@"state"];
        self.locate.city = [[_cities objectAtIndex:0] objectForKey:@"city"];
        
        _areas = [[_cities objectAtIndex:0] objectForKey:@"areas"];
        if ([_areas count] <= 0)
        {
            [_areas addObject:@""];
        }
        if (_areas.count > 0) {
            self.locate.district = [_areas objectAtIndex:0];
        } else {
            self.locate.district = @"";
        }
        self.backgroundColor = [UIColor whiteColor];
    }
    [self addRemoveBtn:YES];
    return self;
}

- (id)initWithFrame:(CGRect)frame type:(NSInteger)type includeContory:(BOOL)includeContory
{
    self = [super initWithFrame:frame];
    if (self) {
        self.type = type;
        self.provinceIndex = 0;
        self.cityIndex = 0;
        self.districtIndex = 0;
        // Initialization code
        //创建页面加载数据
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
        
        //数据类的实例化
        self.locate = [[JYLocation alloc] init];
        //数据加载
        if (self.type == AreaWithBuXian){
            _provinces = [[NSMutableArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"area1.plist" ofType:nil]];
        } else {
            if (includeContory) {
                _provinces = [[NSMutableArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"area2.plist" ofType:nil]];
            } else {
                _provinces = [[NSMutableArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"area.plist" ofType:nil]];
            }
        }
        _cities = [[_provinces objectAtIndex:0] objectForKey:@"cities"];
        self.locate.state = [[_provinces objectAtIndex:0] objectForKey:@"state"];
        self.locate.city = [[_cities objectAtIndex:0] objectForKey:@"city"];
        _areas = [[_cities objectAtIndex:0] objectForKey:@"areas"];
        if ([_areas count] <= 0)
        {
            [_areas addObject:@""];
        }
        if (_areas.count > 0) {
            self.locate.district = [_areas objectAtIndex:0];
        } else {
            self.locate.district = @"";
        }
        self.numberOfComponents = 3;
        self.backgroundColor = [UIColor whiteColor];
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
    [self cancelPicker]; // Hide the picker view.
    if ([self.delegate respondsToSelector:@selector(finishPickingLocation:)]) {
        [self.delegate finishPickingLocation:self];
    }
}

#pragma mark-picker Data Source Methods
- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return  self.numberOfComponents;
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
            return [[_provinces objectAtIndex:row] objectForKey:@"state"];
            break;
            
        case 1:
            return [[_cities objectAtIndex:row] objectForKey:@"city"];
            break;
            
        case 2:
            if (_areas.count > row) {
                return [_areas objectAtIndex:row];
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
        case 0:
            if (self.type == AreaNoAreas) {
                _cities = [[_provinces objectAtIndex:row] objectForKey:@"cities"]; // Update the array of city~
                [self.areaPicker selectRow:0 inComponent:1 animated:NO];
                [self.areaPicker reloadComponent:1];
                self.locate.state = [[_provinces objectAtIndex:row] objectForKey:@"state"];
                self.locate.city = [[_cities objectAtIndex:0] objectForKey:@"city"];
            } else {
                _cities = [[_provinces objectAtIndex:row] objectForKey:@"cities"];
                [self.areaPicker selectRow:0 inComponent:1 animated:NO];
                [self.areaPicker reloadComponent:1];
                
                _areas = [[_cities objectAtIndex:0] objectForKey:@"areas"];
                if ([_areas count] <= 0)
                {
                    [_areas addObject:@""];
                }
                [self.areaPicker selectRow:0 inComponent:2 animated:NO];
                [self.areaPicker reloadComponent:2];
                
                self.locate.state = [[_provinces objectAtIndex:row] objectForKey:@"state"];
                self.locate.city = [[_cities objectAtIndex:0] objectForKey:@"city"];
                if ([_areas count] > 0) {
                    self.locate.district = [_areas objectAtIndex:0];
                } else{
                    self.locate.district = @"";
                }
            }
            self.provinceIndex = row;
            break;
        case 1:
            if (self.type != AreaNoAreas) {
                _areas = [[_cities objectAtIndex:row] objectForKey:@"areas"];
                // 添加不限的选项
                if (self.type == AreaWithBuXian) {
                    if ([_areas count] > 0 && [(NSString *)_areas[0] compare:@"不限"] && [(NSString *)_areas[0] compare:@""]) {
                        [_areas insertObject:@"不限" atIndex:0];
                    }
                    else {
                        [_areas addObject:@""];
                    }
                }
                
                [self.areaPicker selectRow:0 inComponent:2 animated:NO];
                [self.areaPicker reloadComponent:2];
                
                self.locate.city = [[_cities objectAtIndex:row] objectForKey:@"city"];
                if ([_areas count] > 0) {
                    self.locate.district = _areas[0];
                } else{
                    self.locate.district = @"";
                }
            } else {
                self.locate.city = [[_cities objectAtIndex:row] objectForKey:@"city"];
            }
            self.cityIndex = row;
            break;
        case 2:
            if ([_areas count] > row) {
                self.locate.district = [_areas objectAtIndex:row];
                self.districtIndex = row;
            } else{
                self.locate.district = @"";
            }
            break;
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
    
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, view.frame.size.height - self.frame.size.height, self.frame.size.width, self.frame.size.height);
    }];
    _isShowInView = YES;
}

- (void)selectRowOf:(NSString*)province city:(NSString*)city district:(NSString *)district
{
    NSInteger provinceIndex = 0;
    NSInteger cityIndex = 0;
    NSInteger districtIndex = 0;
    for (NSDictionary *stateDic in _provinces) {
        if ([[stateDic objectForKey:@"state"] isEqualToString: province]) { // Catch the province.
            provinceIndex = [_provinces indexOfObject:stateDic];
            _cities = [stateDic objectForKey:@"cities"];
            for (NSDictionary *cityDictionary in _cities) {
                if ([[cityDictionary objectForKey:@"city"] isEqualToString: city]) { // Get to the city.
                    cityIndex = [_cities indexOfObject:cityDictionary];
                    if (district) { // Want to locate the district as well~
                        _areas = [cityDictionary objectForKey:@"areas"];
                        districtIndex = [_areas indexOfObject:district];
                        self.locate.district = district;
                    }
                    self.locate.state = province;
                    self.locate.city = city;
                    break;
                }
            }
            break;
        }
    }
    [self.areaPicker selectRow:provinceIndex inComponent:0 animated:NO];
    [self.areaPicker selectRow:cityIndex inComponent:1 animated:NO];
    
    self.provinceIndex = provinceIndex;
    self.cityIndex = cityIndex;
    self.districtIndex = districtIndex;
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
