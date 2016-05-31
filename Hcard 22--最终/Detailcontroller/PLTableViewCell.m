//
//  PLTableViewCell.m
//  cardCase
//
//  Created by 黄传家 on 16/5/20.
//  Copyright © 2016年 黄传家. All rights reserved.
//

#import "PLTableViewCell.h"

@implementation PLTableViewCell

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
    self.namePL = [[UILabel alloc]init];
    self.contentPL = [[UILabel alloc]init];
    
    self.namePL.translatesAutoresizingMaskIntoConstraints = NO;
    self.contentPL.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.contentView addSubview:self.namePL];
    [self.contentView addSubview:self.contentPL];
    
    NSArray *arr1 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-5-[_namePL(==100)]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_namePL)];
    NSArray *arr2 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[_namePL(==40)]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_namePL)];
    NSArray *arr3 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-50-[_contentPL]-5-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_contentPL)];
    NSArray *arr4 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-45-[_contentPL(==100)]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_contentPL)];
    [self.contentView addConstraints:arr1];
    [self.contentView addConstraints:arr2];
    [self.contentView addConstraints:arr3];
    [self.contentView addConstraints:arr4];
}
@end
