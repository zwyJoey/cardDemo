//
//  CardModelViewController.h
//  cardCase-git
//
//  Created by zhaowanyu on 16/4/22.
//  Copyright © 2016年 zhaowanyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserCard.h"

//宽
#define UISCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
//高
#define UISCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
@interface CardModelViewController : UIViewController
@property (strong,nonatomic)UserCard *userCard;

@property(strong,nonatomic)UIImageView *imgView;
@property(strong,nonatomic)UIButton * v1;
@property(strong,nonatomic)UIButton * v2;
@property(strong,nonatomic)UILabel *nameLabel;
@property(strong,nonatomic)UITextField * namefield;
@property(strong,nonatomic)UILabel *phoneLabel;
@property(strong,nonatomic)UITextField * phonefield;
@property(strong,nonatomic)UILabel *mailLabel;
@property(strong,nonatomic)UITextField * mailfield;
@property(strong,nonatomic)UILabel *qqLabel;
@property(strong,nonatomic)UITextField * qqfield;
@property(strong,nonatomic)UILabel *faxLabel;
@property(strong,nonatomic)UITextField * faxfield;
@property(strong,nonatomic)UITextField * companyfield;
@property(strong,nonatomic)UITextField * loadfield;
@property(strong,nonatomic)UILabel *label1;
@property(strong,nonatomic)UILabel *label2;
@property(assign,nonatomic)BOOL flag;
@property (assign,nonatomic)CGFloat Bili;
@property (strong,nonatomic)NSManagedObjectContext *managedObjectContext;
@property (strong,nonatomic)UIImage *image;
@end
