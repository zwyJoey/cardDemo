//
//  MoreTableViewCell.m
//  cardCase
//
//  Created by ChenJS on 16/5/21.
//  Copyright © 2016年 黄传家. All rights reserved.
//

#import "MoreTableViewCell.h"
#define UISCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define UISCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@implementation MoreTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
//cell的构造方法
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier tableView:(UITableView *)tableView{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.height = tableView.rowHeight;
        [self creatUI];
    }
    return self;
    
    
}
-(void)creatUI{
   
    self.titleLable = [[UILabel alloc] init];
    self.detailLable = [[UILabel alloc] init];
    //设置
    self.titleLable.frame = CGRectMake(0,0 ,100 ,self.height );
    self.titleLable.contentMode = UIViewContentModeCenter;
    
    self.detailLable.frame = CGRectMake(110,0,[UIScreen mainScreen].bounds.size.width-110,self.height);
    self.backgroundColor = [UIColor grayColor];
    self.titleLable.backgroundColor = [UIColor whiteColor];
    self.detailLable.backgroundColor = [UIColor whiteColor];
    //填充内容视图
    [self.contentView addSubview:self.detailLable];
    [self.contentView addSubview:self.titleLable];
    
}

@end
