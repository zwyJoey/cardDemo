//
//  SynchronizeTableViewCell.m
//  详情页demo
//
//  Created by 黄传家 on 16/4/28.
//  Copyright © 2016年 黄传家. All rights reserved.
//

#import "SynchronizeTableViewCell.h"

@implementation SynchronizeTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self creatUI];
    }
    return self;
}
- (void)creatUI{
    self.label = [[UILabel alloc]init];
    self.label.translatesAutoresizingMaskIntoConstraints = NO;
    self.sw = [[UISwitch alloc]init];
    self.sw.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.label];
    [self addSubview:self.sw];
    NSArray *arr1 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[_label]-5-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_label)];
    NSArray *arr2 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[_sw]-5-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_sw)];
    NSArray *arr3 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-5-[_label(==100)]-205-[_sw(==60)]-5-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_label,_sw)];
    [self addConstraints:arr1];
    [self addConstraints:arr2];
    [self addConstraints:arr3];
}
@end
