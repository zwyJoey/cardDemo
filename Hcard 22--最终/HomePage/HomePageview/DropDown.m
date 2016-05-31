//
//  DropDown.m
//  cardCase
//
//  Created by ChenJS on 16/4/23.
//  Copyright © 2016年 zhiyuan3g. All rights reserved.
//
#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT  [UIScreen mainScreen].bounds.size.height
#import "DropDown.h"
#import <UIKit/UIKit.h>

@implementation DropDown

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.tv = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [self addSubview:self.tv];
        self.tv.delegate = self;
        self.tv.dataSource = self;
        self.tableArray = @[@[@"我的二维码",@"扫一扫"],@[@"导入系统联系人",@"雷达交换",@"手动输入名片"]];
        self.tv.backgroundColor = [UIColor grayColor];
        
    }
    return self;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_tableArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[_tableArray objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
    }
    NSArray *array =  [_tableArray objectAtIndex:indexPath.section];
    cell.textLabel.text = array[indexPath.row ];
    cell.textLabel.font = [UIFont systemFontOfSize:12.0f];
    cell.accessoryType  = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    return cell;
}
- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
return @"";
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

//选中cell的回调方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"进入下拉列表的点击回调方法");
    //创建一个通知
    NSNotification *notification = [NSNotification notificationWithName:@"indexPath" object:nil userInfo:@{@"indexPath":indexPath}];
    //创建通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
