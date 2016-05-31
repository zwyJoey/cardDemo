//
//  User1.m
//  Hcard
//
//  Created by 黄传家 on 16/5/23.
//  Copyright © 2016年 黄传家. All rights reserved.
//

#import "User1.h"

@implementation User1
+(instancetype)shareUser{
    static User1 *user;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        user = [[User1 alloc]init];
    });
    return user;
}

@end
