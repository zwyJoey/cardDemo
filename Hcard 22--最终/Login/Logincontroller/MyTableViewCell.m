//
//  MyTableViewCell.m
//  定制Cell
//
//  Created by 至远科技－05 on 16/3/11.
//  Copyright © 2016年 至远科技－05. All rights reserved.
//

#import "MyTableViewCell.h"
#define UISCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define UISCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface MyTableViewCell ()
@end



@implementation MyTableViewCell
//创建单元格代码
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}


-(void)createUI{
    
    NSInteger index = 10;
    _btn1 = [[UIButton alloc]initWithFrame:CGRectMake(index, index, 100, 100)];
    _btn1.backgroundColor = [UIColor blueColor];
    [self.contentView addSubview:self.btn1];
    
    _btn2 = [[UIButton alloc]initWithFrame:CGRectMake(index*3+100, index, 100, 100)];
    _btn2.backgroundColor = [UIColor blueColor];
    [self.contentView addSubview:_btn2];
    
    _btn3 = [[UIButton alloc]initWithFrame:CGRectMake(index*5+200, index, 100, 100)];
    _btn3.backgroundColor = [UIColor blueColor];
    [self.contentView addSubview:_btn3];
    
    //关闭原始约束
    _btn1.translatesAutoresizingMaskIntoConstraints = NO;
    _btn2.translatesAutoresizingMaskIntoConstraints = NO;
    _btn3.translatesAutoresizingMaskIntoConstraints = NO;
    
    //创建自动约束
    //高
    NSArray *hheight1 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[_btn1]-10-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_btn1)];
    
    NSArray *hheight2 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[_btn2]-10-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_btn2)];
    
    NSArray *hheight3 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[_btn3]-10-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_btn3)];
    
    NSArray *wwidth = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[_btn1]-10-[_btn2(==_btn1)]-10-[_btn3(==_btn2)]-10-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_btn1,_btn2,_btn3)];
    
    //添加约束
    [self.contentView addConstraints:wwidth];
    [self.contentView addConstraints:hheight1];
    [self.contentView addConstraints:hheight2];
    [self.contentView addConstraints:hheight3];
    
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    //    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
