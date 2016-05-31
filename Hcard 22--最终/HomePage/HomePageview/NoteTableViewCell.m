//
//  NoteTableViewCell.m
//  Hcard
//
//  Created by ChenJS on 16/5/28.
//  Copyright © 2016年 黄传家. All rights reserved.
//

#import "NoteTableViewCell.h"
#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height

@implementation NoteTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
//cell的构造方法
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier  Note:(Note *)note{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self creatUI:note];
    }
    return self;
    
}
-(void)creatUI:(Note *)note{
    self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, WIDTH-20,20)];
    
    
    [self.contentView addSubview:self.dateLabel];
    if (note.image) {
        self.imageV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 40, WIDTH-20, 100)];
        self.imageV.contentMode = UIViewContentModeRedraw;
        [self.contentView addSubview:self.imageV];
    }else{
        self.message = [[UILabel alloc] initWithFrame:CGRectMake(10, 40, WIDTH-20, 35)];
        
        [self.contentView addSubview:self.message];
    }
    
    
    
}

@end
