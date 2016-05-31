//
//  SignInViewController.h
//  NCard登录注册
//
//  Created by zhaowanyu on 16/4/16.
//  Copyright © 2016年 zhaowanyu. All rights reserved.
//

#import <UIKit/UIKit.h>
//协议
@protocol getValue <NSObject>

@required
-(void)getValue:(NSString *)textContent;
@end
@interface SignInViewController : UIViewController
//协议－－弱引用
@property(weak,nonatomic)id<getValue>delegate;
@end
