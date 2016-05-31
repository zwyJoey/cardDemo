//
//  MyViewController.h
//  详情页demo
//
//  Created by 黄传家 on 16/5/3.
//  Copyright © 2016年 黄传家. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Dynamic.h"
#import "User.h"
@interface MyViewController : UIViewController
@property (strong,nonatomic)Dynamic * dynamic;
@property (strong,nonatomic)User *user;
@end
