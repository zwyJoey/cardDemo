//
//  NoteTableViewCell.h
//  Hcard
//
//  Created by ChenJS on 16/5/29.
//  Copyright © 2016年 黄传家. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Note.h"

@interface NoteTableViewCell : UITableViewCell
@property (strong,nonatomic)UILabel *dateLabel;
@property (strong,nonatomic)UILabel *message;
@property (strong,nonatomic)UIImageView *imageV;
@property (assign,nonatomic)CGFloat height;
@property (strong,nonatomic)id viewController;
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier  Note:(Note *)note;

@end
