//
//  ZHTBViewController.m
//  Hcard
//
//  Created by 黄传家 on 16/5/24.
//  Copyright © 2016年 黄传家. All rights reserved.
//

#import "ZHTBViewController.h"
#import "SetTableViewCell.h"
#import "BYSJViewController.h"
#import "BYYXViewController.h"
#import "XGMMViewController.h"
#import "User1.h"
@interface ZHTBViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong,nonatomic)UITableView *tableView;
@property (strong,nonatomic)NSArray *arr;
@end

@implementation ZHTBViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"账号与同步";
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-100)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    self.arr = [NSArray array];
    self.arr = @[@"主手机",@"添加备用手机",@"添加备用邮箱",@"修改密码"];
    // Do any additional setup after loading the view.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arr.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"cellID";
    SetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[SetTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.accessoryType =UITableViewCellAccessoryDisclosureIndicator;
    
    
    cell.label.text = self.arr[indexPath.row];
    if (indexPath.row == 0) {
        User1 *user = [User1 shareUser];
        NSLog(@"----%@",user.id);
        cell.conLabel.text = user.id;
    }
    if (indexPath.row == 1){
        NSUserDefaults *u = [NSUserDefaults standardUserDefaults];
        cell.conLabel.text = [u objectForKey:@"number"];
    }
    if (indexPath.row == 2) {
        NSUserDefaults *you = [NSUserDefaults standardUserDefaults];
        cell.conLabel.text = [you objectForKey:@"youxiang"];
    }
    return cell;

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UIViewController *VC = nil;
    switch (indexPath.row) {
        case 0:
            
            break;
        case 1:
            VC = [[BYSJViewController alloc]init];
            break;
        case 2:
            VC = [[BYYXViewController alloc]init];
            break;
        case 3:
            VC = [[XGMMViewController alloc]init];
            break;
        case 4:
            NSLog(@"huhuhu");
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
