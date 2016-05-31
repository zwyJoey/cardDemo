//
//  AdvTableViewCell1.m
//  cardCase
//
//  Created by 黄传家 on 16/5/18.
//  Copyright © 2016年 黄传家. All rights reserved.
//

#import "AdvTableViewCell1.h"

@implementation AdvTableViewCell1

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
    self.DZ = [UIButton buttonWithType:UIButtonTypeSystem];
    self.PL = [UIButton buttonWithType:UIButtonTypeSystem];
    
    self.DZ.translatesAutoresizingMaskIntoConstraints = NO;
    self.PL.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.DZ setTitle:@"点赞" forState: UIControlStateNormal];
    [self.PL setTitle:@"评论" forState: UIControlStateNormal];
    
    [self.DZ setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.PL setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    
    
    [self.contentView addSubview:self.imgView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.contenLabel];
    [self.contentView addSubview:self.DZ];
    [self.contentView addSubview:self.PL];
    
    NSArray *arr1 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-95-[_DZ]-100-[_PL(==_DZ)]-10-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_DZ,_PL)];
    NSArray *arr2 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-130-[_DZ(==40)]-5-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_DZ)];
    NSArray *arr3 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-130-[_PL(==40)]-5-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_PL)];
    
    [self.contentView addConstraints:arr1];
    [self.contentView addConstraints:arr2];
    [self.contentView addConstraints:arr3];
}
-(void)addTagPL:(id)target action:(SEL)action tag:(NSInteger)tag{
    [self.PL addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    self.PL.tag = tag;
}
@end
