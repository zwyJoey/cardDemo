//
//  SetViewController.m
//  Hcard
//
//  Created by 黄传家 on 16/5/23.
//  Copyright © 2016年 黄传家. All rights reserved.
//

#import "SetViewController.h"
#import "SetTableViewCell.h"
#import "User1.h"
#import "LSEViewController.h"
#import "ZHTBViewController.h"
#import "AboutViewController.h"
#import "HelpViewController.h"
@interface SetViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (strong,nonatomic)UITableView *tableView;
@property (strong,nonatomic)NSArray *arr;
@end

@implementation SetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 50, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-50)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    self.arr = [NSArray array];
    self.arr = @[@"账户与同步",@"帮助与反馈",@"关于",@"退出登入"];
    
    // Do any additional setup after loading the view.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  self.arr.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"cellID";
    SetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[SetTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    if (indexPath.row>=0 ||  indexPath.row<=3) {
        cell.accessoryType =UITableViewCellAccessoryDisclosureIndicator;
    }

    cell.label.text = self.arr[indexPath.row];
    if (indexPath.row == 0) {
        User1 *user = [User1 shareUser];
        NSLog(@"----%@",user.id);
        cell.conLabel.text = user.id;
    }
    
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UIViewController *VC = nil;
    switch (indexPath.row) {
        case 0:
            VC = [[ZHTBViewController alloc]init];
            break;
        case 1:
            VC = [[HelpViewController alloc]init];
            break;
        case 2:
            VC = [[AboutViewController alloc]init];
            break;
        case 3:
            VC = [[LSEViewController alloc]init];
            break;
            
        default:
            break;
    }
    [self.navigationController pushViewController:VC animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
