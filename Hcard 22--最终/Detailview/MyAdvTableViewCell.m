//
//  MyAdvTableViewCell.m
//  详情页demo
//
//  Created by 黄传家 on 16/5/12.
//  Copyright © 2016年 黄传家. All rights reserved.
//

#import "MyAdvTableViewCell.h"

@implementation MyAdvTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style  reuseIdentifier:reuseIdentifier]) {
        [self creatUI];
        
    }
    return self;
}
-(void)creatUI{
    self.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, [UIScreen mainScreen].bounds.size.width-5, 50)];
    self.contextLabel = [[UILabel alloc]initWithFrame:CGRectMake(5,50, [UIScreen mainScreen].bounds.size.width-5, 100)];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.contextLabel];
}
@end
