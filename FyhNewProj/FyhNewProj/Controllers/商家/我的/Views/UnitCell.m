//
//  UnitCell.m
//  FyhNewProj
//
//  Created by yh f on 2017/6/15.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "UnitCell.h"
#import "AttributesModel.h"

@interface UnitCell ()<UITextFieldDelegate>

@end


@implementation UnitCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setUP];
        
        
    }
    return self;

}


- (void)setUP{

    _rightText = [BaseViewFactory textFieldWithFrame:CGRectMake(ScreenWidth - 215, 0, 200, 50) font:APPFONT(15) placeholder:@"请输入" textColor:UIColorFromRGB(0x434a54) placeholderColor:UIColorFromRGB(LineColorValue) delegate:self];
    _rightText.textAlignment = NSTextAlignmentRight; 
    [self.contentView addSubview:_rightText];


}

-(void)setAttModel:(AttributesModel *)attModel{

    _attModel = attModel;
    self.textLabel.text = attModel.attributeName;
    if (attModel.attributeValue.length >0) {
        _rightText.text = attModel.attributeValue;

    }else{
        _rightText.text = attModel.attributeDefaultValue;

    }
}


-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{

    
    _attModel.attributeDefaultValue = textField.text;
    return YES;
}



@end
