//
//  UILabel+Automatic.m
//  根据内容设置label高度
//
//  Created by 黄传家 on 16/4/12.
//  Copyright © 2016年 黄传家. All rights reserved.
//

#import "UILabel+Automatic.h"

@implementation UILabel (Automatic)
-(float)setTextIsAutomaticHeight:(NSString *)string{
    self.text = string;
    self.numberOfLines = 0;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:self.text];
//    创建一个可变风格
    NSMutableParagraphStyle *paragraStyle = [[NSMutableParagraphStyle alloc]init];
//    注意：每一行的行间距分为两部分
    [paragraStyle setLineSpacing:3.0f];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraStyle range:NSMakeRange(0, [self.text length])];
//    设置label的富文本
    self.attributedText = attributedString;
    CGSize size = [self sizeThatFits:CGSizeMake(self.frame.size.width, MAXFLOAT)];
//    设置空间原来的frame
    CGRect frame=self.frame;
//    设置高度
    frame.size.height = size.height;
//    设置高或宽，需要重新setFrame
    [self setFrame:frame];
    return frame.size.height;
    
}
@end
