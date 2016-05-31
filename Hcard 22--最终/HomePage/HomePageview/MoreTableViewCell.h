//
//  MoreTableViewCell.h
//  cardCase
//
//  Created by ChenJS on 16/5/21.
//  Copyright © 2016年 黄传家. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoreTableViewCell : UITableViewCell
@property (strong,nonatomic)UILabel *titleLable;
@property (strong,nonatomic)UILabel *detailLable;
@property (assign,nonatomic)CGFloat height;
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier tableView:(UITableView *)tableView;
@end
