//
//  MyAdvTableViewCell3.h
//  详情页demo
//
//  Created by 黄传家 on 16/5/12.
//  Copyright © 2016年 黄传家. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyAdvTableViewCell3 : UITableViewCell
@property (strong,nonatomic)UILabel *timeLabel;
@property (strong,nonatomic)UILabel *contextLabel;
@property (strong,nonatomic)UIButton *imgBtn1;
@property (strong,nonatomic)UIButton *imgBtn2;
@property (strong,nonatomic)UIButton *imgBtn3;
@property (strong,nonatomic)UIButton *imgBtn4;
@property (strong,nonatomic)UIButton *imgBtn5;
@property (strong,nonatomic)UIButton *imgBtn6;
@property (strong,nonatomic)UIButton *imgBtn7;
@property (strong,nonatomic)UIButton *imgBtn8;
@property (strong,nonatomic)UIButton *imgBtn9;
-(void)XSimage:(UIImage *)image withcount:(int)count;
@end
