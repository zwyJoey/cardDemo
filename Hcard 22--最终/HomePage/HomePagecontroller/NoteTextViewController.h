//
//  NoteTextViewController.h
//  Hcard
//
//  Created by ChenJS on 16/5/26.
//  Copyright © 2016年 黄传家. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoteTextViewController : UIViewController
@property (copy,nonatomic)void (^backValue)(NSString *str);
@end
