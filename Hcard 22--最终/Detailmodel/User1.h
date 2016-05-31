//
//  User1.h
//  Hcard
//
//  Created by 黄传家 on 16/5/23.
//  Copyright © 2016年 黄传家. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Dynamic.h"
@interface User1 : NSObject
@property (copy,nonatomic)NSString *name;
@property (strong,nonatomic)Dynamic *dy;
@property (strong,nonatomic)NSString *id;
@property (strong,nonatomic)id TX;
@property (strong,nonatomic)NSString *name1;
+(instancetype)shareUser;
@end
