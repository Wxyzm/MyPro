//
//  DIYGoodsMessageCell.m
//  FyhNewProj
//
//  Created by yh f on 2017/9/7.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "DIYGoodsMessageCell.h"
#import "DIYGoodsMessage.h"

@implementation DIYGoodsMessageCell
+ (CGSize)sizeForMessageModel:(RCMessageModel *)model
      withCollectionViewWidth:(CGFloat)collectionViewWidth
         referenceExtraHeight:(CGFloat)extraHeight {
//    RCDTestMessage *message = (RCDTestMessage *)model.content;
//    CGSize size = [RCDTestMessageCell getBubbleBackgroundViewSize:message];
//    
//    CGFloat __messagecontentview_height = size.height;
//    __messagecontentview_height += extraHeight;
    
    return CGSizeMake(collectionViewWidth, 92+extraHeight);
}

- (NSDictionary *)attributeDictionary {
    if (self.messageDirection == MessageDirection_SEND) {
        return @{
                 @(NSTextCheckingTypeLink) : @{NSForegroundColorAttributeName : [UIColor blueColor]},
                 @(NSTextCheckingTypePhoneNumber) : @{NSForegroundColorAttributeName : [UIColor blueColor]}
                 };
    } else {
        return @{
                 @(NSTextCheckingTypeLink) : @{NSForegroundColorAttributeName : [UIColor blueColor]},
                 @(NSTextCheckingTypePhoneNumber) : @{NSForegroundColorAttributeName : [UIColor blueColor]}
                 };
    }
    return nil;
}

- (NSDictionary *)highlightedAttributeDictionary {
    return [self attributeDictionary];
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}
- (void)initialize {
    self.bubbleBackgroundView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.messageContentView addSubview:self.bubbleBackgroundView];
    self.bubbleBackgroundView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *longPress =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(longPressed:)];
    [self.bubbleBackgroundView addGestureRecognizer:longPress];
    
    self.nameLab = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.nameLab setFont:[UIFont systemFontOfSize:15]];
    self.nameLab.numberOfLines = 2;
    [self.nameLab setLineBreakMode:NSLineBreakByWordWrapping];
    [self.nameLab setTextAlignment:NSTextAlignmentLeft];
    [self.nameLab setTextColor:[UIColor blackColor]];
    [self.bubbleBackgroundView addSubview:self.nameLab];

    
    self.desLab = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.desLab setFont:[UIFont systemFontOfSize:13]];
    [self.desLab setLineBreakMode:NSLineBreakByWordWrapping];
    [self.desLab setTextAlignment:NSTextAlignmentLeft];
    [self.desLab setTextColor:[UIColor blackColor]];
    [self.bubbleBackgroundView addSubview:self.desLab];
    
    self.priceLab = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.priceLab setFont:[UIFont systemFontOfSize:13]];
    [self.priceLab setLineBreakMode:NSLineBreakByWordWrapping];
    [self.priceLab setTextAlignment:NSTextAlignmentRight];
    [self.priceLab setTextColor:UIColorFromRGB(RedColorValue)];
    [self.bubbleBackgroundView addSubview:self.priceLab];

    
    self.rightImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.rightImageView.layer.cornerRadius = 4;
    self.rightImageView.clipsToBounds = YES;
    [self.bubbleBackgroundView addSubview:self.rightImageView];

}

- (void)setDataModel:(RCMessageModel *)model {
    [super setDataModel:model];
    
    [self setAutoLayout];
}
- (void)setAutoLayout {
    DIYGoodsMessage *_diyMessage = (DIYGoodsMessage *)self.model.content;
    if (_diyMessage) {
        self.nameLab.text = _diyMessage.title;
        self.desLab.text =  _diyMessage.content;
        if ([_diyMessage.price isEqualToString:@"￥"]) {
            self.priceLab.text = @"";

        }else{
            self.priceLab.text = _diyMessage.price;

        }
        if (IsEmptyStr(_diyMessage.imageUrl)) {
            self.rightImageView.image =[UIImage imageNamed:@"loding"];
        }else{
             [self.rightImageView sd_setImageWithURL:[NSURL URLWithString:_diyMessage.imageUrl] placeholderImage:[UIImage imageNamed:@"loding"]];
        }
       

    } else {
        //DebugLog(@”[RongIMKit]: RCMessageModel.content is NOT RCTextMessage object”);
    }
    // ios 7
//    CGSize __textSize ;
//    __textSize = CGSizeMake(ceilf(150), ceilf(100));
//    CGSize __labelSize = CGSizeMake(__textSize.width + 5, __textSize.height + 5);
//    
//    CGFloat __bubbleWidth = __labelSize.width + 15 + 20 < 50 ? 50 : (__labelSize.width + 15 + 20);
//    CGFloat __bubbleHeight = __labelSize.height + 5 + 5 < 35 ? 35 : (__labelSize.height + 5 + 5);
    
    CGSize __bubbleSize = CGSizeMake(250, 92);
    
    CGRect messageContentViewRect = self.messageContentView.frame;
    
    if (MessageDirection_RECEIVE == self.messageDirection) {
        messageContentViewRect.size.width = __bubbleSize.width;
        messageContentViewRect.size.height = __bubbleSize.height;

        self.messageContentView.frame = messageContentViewRect;
        
        self.bubbleBackgroundView.frame = CGRectMake(0, 0, __bubbleSize.width, __bubbleSize.height);
//        self.nameLab.frame = CGRectMake(80, 16, __bubbleSize.width-90, 40);
        self.rightImageView.frame = CGRectMake(20, 16, 60, 60);
        self.nameLab.sd_layout.leftSpaceToView(self.rightImageView, 10).topEqualToView( self.rightImageView).widthIs(__bubbleSize.width-100).autoHeightRatio(0);
        [self.nameLab setMaxNumberOfLinesToShow:2];
        self.priceLab.sd_layout.rightEqualToView(self.nameLab).bottomEqualToView( self.rightImageView).heightIs(14);
        [self.priceLab setSingleLineAutoResizeWithMaxWidth:180];
        self.desLab.sd_layout.rightSpaceToView(self.priceLab, 0).bottomEqualToView( self.rightImageView).heightIs(14).leftEqualToView(self.nameLab);

        
        self.bubbleBackgroundView.image = [self imageNamed:@"chat_from_bg_normal" ofBundle:@"RongCloud.bundle"];
        UIImage *image = self.bubbleBackgroundView.image;
        self.bubbleBackgroundView.image = [self.bubbleBackgroundView.image
                                           resizableImageWithCapInsets:UIEdgeInsetsMake(image.size.height * 0.8, image.size.width * 0.8,
                                                                                        image.size.height * 0.2, image.size.width * 0.2)];
    } else {
        messageContentViewRect.size.width = __bubbleSize.width;
        messageContentViewRect.size.height = __bubbleSize.height;

        messageContentViewRect.origin.x =
        self.baseContentView.bounds.size.width -
        (messageContentViewRect.size.width + 10 + [RCIM sharedRCIM].globalMessagePortraitSize.width + 10);
        self.messageContentView.frame = messageContentViewRect;
        
        self.bubbleBackgroundView.frame = CGRectMake(0, 0, __bubbleSize.width, __bubbleSize.height);
//        self.webView.frame=CGRectMake(15, 5, __labelSize.width, __labelSize.height);
        //        self.textLabel.frame = CGRectMake(15, 5, __labelSize.width, __labelSize.height);
       // self.nameLab.frame = CGRectMake(80, 16, __bubbleSize.width-90, 40);
        self.nameLab.sd_layout.leftSpaceToView(self.rightImageView, 10).topEqualToView( self.rightImageView).widthIs(__bubbleSize.width-100).autoHeightRatio(0);
        [self.nameLab setMaxNumberOfLinesToShow:2];        self.rightImageView.frame = CGRectMake(10, 16, 60, 60);
        self.priceLab.sd_layout.rightEqualToView(self.nameLab).bottomEqualToView( self.rightImageView).heightIs(14);
        [self.priceLab setSingleLineAutoResizeWithMaxWidth:180];
        self.desLab.sd_layout.rightSpaceToView(self.priceLab, 0).bottomEqualToView( self.rightImageView).heightIs(14).leftEqualToView(self.nameLab);
        
        
        self.bubbleBackgroundView.image = [self imageNamed:@"chat_to_bg_normal" ofBundle:@"RongCloud.bundle"];
        UIImage *image = self.bubbleBackgroundView.image;
        self.bubbleBackgroundView.image = [self.bubbleBackgroundView.image
                                           resizableImageWithCapInsets:UIEdgeInsetsMake(image.size.height * 0.8, image.size.width * 0.2,
                                                                                        image.size.height * 0.2, image.size.width * 0.8)];
    }
    
}
- (UIImage *)imageNamed:(NSString *)name ofBundle:(NSString *)bundleName {
    UIImage *image = nil;
    NSString *image_name = [NSString stringWithFormat:@"%@.png", name];
    NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
    NSString *bundlePath = [resourcePath stringByAppendingPathComponent:bundleName];
    NSString *image_path = [bundlePath stringByAppendingPathComponent:image_name];
    image = [[UIImage alloc] initWithContentsOfFile:image_path];
    
    return image;
}

- (void)longPressed:(id)sender {
//    UILongPressGestureRecognizer *press = (UILongPressGestureRecognizer *)sender;
//    if (press.state == UIGestureRecognizerStateEnded) {
//        //DebugLog(@”long press end”);
//        return;
//    } else if (press.state == UIGestureRecognizerStateBegan) {
//        [self.delegate didLongTouchMessageCell:self.model inView:self.bubbleBackgroundView];
//    }
    [self.delegate didTapMessageCell:self.model ];

}

@end
