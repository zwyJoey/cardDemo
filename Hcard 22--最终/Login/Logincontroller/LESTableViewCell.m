//
//  LESTableViewCell.m
//  cardCase
//
//  Created by zhaowanyu on 16/5/24.
//  Copyright © 2016年 黄传家. All rights reserved.
//

#import "LESTableViewCell.h"

@implementation LESTableViewCell

//创建单元格代码
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //        [self createUI];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

@end
