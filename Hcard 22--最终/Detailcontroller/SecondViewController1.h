//
//  SecondViewController.h
//  cardCase
//
//  Created by ChenJS on 16/4/29.
//  Copyright © 2016年 zhiyuan3g. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "User.h"
@interface SecondViewController1 : UIViewController
@property (strong,nonatomic) UIButton *imageBtn;
@property (strong,nonatomic) UIButton *deleBtn;
//当前所在城市
@property (strong,nonatomic) UITextField *city;
//公司
@property (strong,nonatomic) UITextField *company;
//公司地址
@property (strong,nonatomic) UITextField *companyAddress;
//姓名
@property (strong,nonatomic) UITextField *name;
//添加时间
@property (strong,nonatomic) NSDate *date;
//电话
@property (strong,nonatomic) UITextField *tele;
//电子邮件
@property (strong,nonatomic) UITextField *eMail;
//传真
@property (strong,nonatomic) UITextField *fax;
//兴趣爱好
@property (strong,nonatomic) UITextField *interest;
//职位
@property (strong,nonatomic) UITextField *post;
//毕业院校
@property (strong,nonatomic) UITextField *school;
//备用电话
@property (strong,nonatomic) UITextField *standByTel;
//头像
@property (strong,nonatomic) NSData *pic;
@property (strong,nonatomic)User *person;
@end
