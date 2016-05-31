//
//  MoreViewController.h
//  cardCase
//
//  Created by ChenJS on 16/5/20.
//  Copyright © 2016年 黄传家. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBTwitterScroll.h"
#import "Person.h"

@interface MoreViewController : UIViewController< MBTwitterScrollDelegate>
@property (strong,nonatomic)Person *person;
@property (strong,nonatomic)NSIndexPath *indexPath;
@end
