//
//  AdvTableViewCell3.h
//  cardCase
//
//  Created by 黄传家 on 16/5/18.
//  Copyright © 2016年 黄传家. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AdvTableViewCell3 : UITableViewCell
@property (strong,nonatomic)UILabel *nameLabel;
@property (strong,nonatomic)UILabel *contenLabel;
@property (strong,nonatomic)UILabel *timeLabel;
//头像
@property (strong,nonatomic)UIImageView *imgView;
@property (strong,nonatomic)UIButton *imgBtn1;
@property (strong,nonatomic)UIButton *imgBtn2;
@property (strong,nonatomic)UIButton *imgBtn3;
@property (strong,nonatomic)UIButton *imgBtn4;
@property (strong,nonatomic)UIButton *imgBtn5;
@property (strong,nonatomic)UIButton *imgBtn6;
@property (strong,nonatomic)UIButton *DZ;
@property (strong,nonatomic)UIButton *PL;
-(void)addTagPL:(id)target action:(SEL)action tag:(NSInteger)tag;
-(void)XSimage:(UIImage *)image withcount:(int)count;
@end
