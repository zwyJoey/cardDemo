//
//  AdvTableViewCell1.h
//  cardCase
//
//  Created by 黄传家 on 16/5/18.
//  Copyright © 2016年 黄传家. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AdvTableViewCell1 : UITableViewCell
@property (strong,nonatomic)UILabel *nameLabel;
@property (strong,nonatomic)UILabel *contenLabel;
@property (strong,nonatomic)UILabel *timeLabel;
//头像
@property (strong,nonatomic)UIImageView *imgView;
@property (strong,nonatomic)UIButton *DZ;
@property (strong,nonatomic)UIButton *PL;
-(void)addTagPL:(id)target action:(SEL)action tag:(NSInteger)tag;
@end
