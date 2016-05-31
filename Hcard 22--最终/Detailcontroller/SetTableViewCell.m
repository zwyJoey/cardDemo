//
//  SetTableViewCell.m
//  Hcard
//
//  Created by 黄传家 on 16/5/24.
//  Copyright © 2016年 黄传家. All rights reserved.
//

#import "SetTableViewCell.h"

@implementation SetTableViewCell

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
    self.label = [[UILabel alloc]init];
    self.label.translatesAutoresizingMaskIntoConstraints = NO;
    self.conLabel = [[UILabel alloc]init];
    self.conLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.label];
    [self.contentView addSubview:self.conLabel];
    NSArray *arr1 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[_label]-5-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_label)];
    NSArray *arr2 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[_conLabel]-5-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_conLabel)];
    NSArray *arr3 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-5-[_label]-5-[_conLabel(==_label)]-5-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_label,_conLabel)];
    [self.contentView addConstraints:arr1];
    [self.contentView addConstraints:arr2];
    [self.contentView addConstraints:arr3];
    
}
@end
