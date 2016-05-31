//
//  AdvTableViewCell3.m
//  cardCase
//
//  Created by 黄传家 on 16/5/18.
//  Copyright © 2016年 黄传家. All rights reserved.
//

#import "AdvTableViewCell3.h"

@implementation AdvTableViewCell3

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
    self.imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
    self.imgView.layer.masksToBounds = YES;
    self.imgView.layer.cornerRadius = 40;
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(85, 5, [UIScreen mainScreen].bounds.size.width-90, 40)];
    self.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(85, 50, [UIScreen mainScreen].bounds.size.width-90, 30)];
    self.contenLabel = [[UILabel alloc]initWithFrame:CGRectMake(85, 95, [UIScreen mainScreen].bounds.size.width-90, 100)];
    self.imgBtn1 = [UIButton buttonWithType:UIButtonTypeSystem];
    self.imgBtn2 = [UIButton buttonWithType:UIButtonTypeSystem];
    self.imgBtn3 = [UIButton buttonWithType:UIButtonTypeSystem];
    self.imgBtn4 = [UIButton buttonWithType:UIButtonTypeSystem];
    self.imgBtn5 = [UIButton buttonWithType:UIButtonTypeSystem];
    self.imgBtn6 = [UIButton buttonWithType:UIButtonTypeSystem];
    self.DZ = [UIButton buttonWithType:UIButtonTypeSystem];
    self.PL = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.DZ setTitle:@"点赞" forState: UIControlStateNormal];
    [self.PL setTitle:@"评论" forState: UIControlStateNormal];
    
    [self.DZ setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.PL setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    
    self.imgBtn1.translatesAutoresizingMaskIntoConstraints = NO;
    self.imgBtn2.translatesAutoresizingMaskIntoConstraints = NO;
    self.imgBtn3.translatesAutoresizingMaskIntoConstraints = NO;
    self.imgBtn4.translatesAutoresizingMaskIntoConstraints = NO;
    self.imgBtn5.translatesAutoresizingMaskIntoConstraints = NO;
    self.imgBtn6.translatesAutoresizingMaskIntoConstraints = NO;
    self.DZ.translatesAutoresizingMaskIntoConstraints = NO;
    self.PL.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.contentView addSubview:self.imgView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.contenLabel];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.imgBtn1];
    [self.contentView addSubview:self.imgBtn2];
    [self.contentView addSubview:self.imgBtn3];
    [self.contentView addSubview:self.imgBtn4];
    [self.contentView addSubview:self.imgBtn5];
    [self.contentView addSubview:self.imgBtn6];
    [self.contentView addSubview:self.DZ];
    [self.contentView addSubview:self.PL];
    NSArray *arr1 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-85-[_imgBtn1]-5-[_imgBtn2(==_imgBtn1)]-5-[_imgBtn3(==_imgBtn1)]-10-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_imgBtn1,_imgBtn2,_imgBtn3)];
    NSArray *arr2 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-95-[_DZ]-100-[_PL(==_DZ)]-10-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_DZ,_PL)];
    NSArray *arr3 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-85-[_imgBtn4]-5-[_imgBtn5(==_imgBtn4)]-5-[_imgBtn6(==_imgBtn4)]-10-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_imgBtn4,_imgBtn5,_imgBtn6)];
    NSArray *arr4 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-135-[_imgBtn1]-5-[_imgBtn4(==_imgBtn1)]-5-[_DZ(==40)]-5-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_imgBtn1,_imgBtn4,_DZ)];
    NSArray *arr5 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-135-[_imgBtn2]-5-[_imgBtn5(==_imgBtn2)]-50-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_imgBtn2,_imgBtn5)];
    NSArray *arr6 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-135-[_imgBtn3]-5-[_imgBtn6(==_imgBtn3)]-5-[_PL(==40)]-5-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_imgBtn3,_imgBtn6,_PL)];
    [self.contentView addConstraints:arr1];
    [self.contentView addConstraints:arr2];
    [self.contentView addConstraints:arr3];
    [self.contentView addConstraints:arr4];
    [self.contentView addConstraints:arr5];
    [self.contentView addConstraints:arr6];
}
-(void)addTagPL:(id)target action:(SEL)action tag:(NSInteger)tag{
    [self.PL addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    self.PL.tag = tag;
}
-(void)XSimage:(UIImage *)image withcount:(int)count{
    if (count == 0) {
        [self.imgBtn1 setBackgroundImage:image forState:UIControlStateNormal];
    }
    if (count == 1) {
        [self.imgBtn2 setBackgroundImage:image forState:UIControlStateNormal];
    }
    
    if (count == 2) {
        [self.imgBtn4 setBackgroundImage:image forState:UIControlStateNormal];
    }
    
    if (count == 3) {
        [self.imgBtn5 setBackgroundImage:image forState:UIControlStateNormal];
    }
    
    if (count == 4) {
        [self.imgBtn3 setBackgroundImage:image forState:UIControlStateNormal];
    }
    if (count == 5) {
        [self.imgBtn6 setBackgroundImage:image forState:UIControlStateNormal];
    }
    
}

@end
