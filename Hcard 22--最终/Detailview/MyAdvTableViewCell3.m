//
//  MyAdvTableViewCell3.m
//  详情页demo
//
//  Created by 黄传家 on 16/5/12.
//  Copyright © 2016年 黄传家. All rights reserved.
//

#import "MyAdvTableViewCell3.h"

@implementation MyAdvTableViewCell3

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
    [self.contentView addSubview:self.contextLabel];    self.imgBtn1 = [UIButton buttonWithType:UIButtonTypeSystem];
    self.imgBtn2 = [UIButton buttonWithType:UIButtonTypeSystem];
    self.imgBtn3 = [UIButton buttonWithType:UIButtonTypeSystem];
    self.imgBtn4 = [UIButton buttonWithType:UIButtonTypeSystem];
    self.imgBtn5 = [UIButton buttonWithType:UIButtonTypeSystem];
    self.imgBtn6 = [UIButton buttonWithType:UIButtonTypeSystem];
    self.imgBtn7 = [UIButton buttonWithType:UIButtonTypeSystem];
    self.imgBtn8 = [UIButton buttonWithType:UIButtonTypeSystem];
    self.imgBtn9 = [UIButton buttonWithType:UIButtonTypeSystem];
    self.imgBtn1.translatesAutoresizingMaskIntoConstraints = NO;
    self.imgBtn2.translatesAutoresizingMaskIntoConstraints = NO;
    self.imgBtn3.translatesAutoresizingMaskIntoConstraints = NO;
    self.imgBtn4.translatesAutoresizingMaskIntoConstraints = NO;
    self.imgBtn5.translatesAutoresizingMaskIntoConstraints = NO;
    self.imgBtn6.translatesAutoresizingMaskIntoConstraints = NO;
    self.imgBtn7.translatesAutoresizingMaskIntoConstraints = NO;
    self.imgBtn8.translatesAutoresizingMaskIntoConstraints = NO;
    self.imgBtn9.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.imgBtn1];
    [self.contentView addSubview:self.imgBtn2];
    [self.contentView addSubview:self.imgBtn3];
    [self.contentView addSubview:self.imgBtn4];
    [self.contentView addSubview:self.imgBtn5];
    [self.contentView addSubview:self.imgBtn6];
    [self.contentView addSubview:self.imgBtn7];
    [self.contentView addSubview:self.imgBtn8];
    [self.contentView addSubview:self.imgBtn9];
    NSArray *arr1 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[_imgBtn1]-5-[_imgBtn2(==_imgBtn1)]-5-[_imgBtn3(==_imgBtn1)]-10-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_imgBtn1,_imgBtn2,_imgBtn3)];
    NSArray *arr2 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[_imgBtn4]-5-[_imgBtn5(==_imgBtn4)]-5-[_imgBtn6(==_imgBtn4)]-10-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_imgBtn4,_imgBtn5,_imgBtn6)];
    NSArray *arr3 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[_imgBtn7]-5-[_imgBtn8(==_imgBtn7)]-5-[_imgBtn9(==_imgBtn7)]-10-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_imgBtn7,_imgBtn8,_imgBtn9)];
    NSArray *arr4 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-155-[_imgBtn1]-5-[_imgBtn4(==_imgBtn1)]-5-[_imgBtn7(==_imgBtn1)]-5-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_imgBtn1,_imgBtn4,_imgBtn7)];
    NSArray *arr5 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-155-[_imgBtn2]-5-[_imgBtn5(==_imgBtn2)]-5-[_imgBtn8(==_imgBtn2)]-5-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_imgBtn2,_imgBtn5,_imgBtn8)];
    NSArray *arr6 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-155-[_imgBtn3]-5-[_imgBtn6(==_imgBtn3)]-5-[_imgBtn9(==_imgBtn3)]-5-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_imgBtn3,_imgBtn6,_imgBtn9)];
    [self.contentView addConstraints:arr1];
    [self.contentView addConstraints:arr2];
    [self.contentView addConstraints:arr3];
    [self.contentView addConstraints:arr4];
    [self.contentView addConstraints:arr5];
    [self.contentView addConstraints:arr6];
    
}
-(void)XSimage:(UIImage *)image withcount:(int)count{
    if (count == 0) {
        [self.imgBtn1 setBackgroundImage:image forState:UIControlStateNormal];
    }
    if (count == 1) {
        [self.imgBtn2 setBackgroundImage:image forState:UIControlStateNormal];
    }
    if (count == 2) {
        [self.imgBtn3 setBackgroundImage:image forState:UIControlStateNormal];
    }
    if (count == 3) {
        [self.imgBtn4 setBackgroundImage:image forState:UIControlStateNormal];
    }
    if (count == 4) {
        [self.imgBtn5 setBackgroundImage:image forState:UIControlStateNormal];
    }
    if (count == 5) {
        [self.imgBtn6 setBackgroundImage:image forState:UIControlStateNormal];
    }
    if (count == 6) {
        [self.imgBtn7 setBackgroundImage:image forState:UIControlStateNormal];
    }
    if (count == 7) {
        [self.imgBtn8 setBackgroundImage:image forState:UIControlStateNormal];
    }
    if (count == 8) {
        [self.imgBtn9 setBackgroundImage:image forState:UIControlStateNormal];
    }
}
@end
