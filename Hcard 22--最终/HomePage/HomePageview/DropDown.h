//
//  DropDown.h
//  cardCase
//
//  Created by ChenJS on 16/4/23.
//  Copyright © 2016年 zhiyuan3g. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DropDown : UIView<UITableViewDelegate,UITableViewDataSource>

@property (strong,nonatomic) UITableView *tv;//下拉列表
@property (strong,nonatomic) NSArray *tableArray;//下拉列表数据
@end
