//
//  CardViewController.m
//  cardCase
//
//  Created by zhaowanyu on 16/5/19.
//  Copyright © 2016年 黄传家. All rights reserved.
//

#import "LSEViewController.h"
#import "MyTableViewCell.h"
#import "LoginViewController.h"
#import "CardModelViewController.h"
#import "CardOneViewController.h"
#import "CardTwoViewController.h"
#import "CardThreeViewController.h"
#import "CardFourViewController.h"
#import "CardFiveViewController.h"
#import "CardSixViewController.h"
#import "CardSevenViewController.h"
#import "CardEightViewController.h"
#import "LESTableViewCell.h"
#import "ThirdViewController.h"
@interface LSEViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(strong,nonatomic) UITableView * tableView;
//card页面
@property(strong,nonatomic)CardModelViewController *cardModel;
@property(strong,nonatomic) CardoneViewController * cardOne;
@property(strong,nonatomic) CardTwoViewController * cardTwo;
@property(strong,nonatomic) CardThreeViewController * cardThree;
@property(strong,nonatomic) CardFourViewController * cardFour;
@property(strong,nonatomic) CardFiveViewController * cardFive;
@property(strong,nonatomic) CardSixViewController * cardSix;
@property(strong,nonatomic) CardSevenViewController * cardSeven;
@property(strong,nonatomic) CardEightViewController * cardEight;
@property(strong,nonatomic) LoginViewController * logView;
@property(strong,nonatomic) ThirdViewController *secView;
@end

@implementation LSEViewController

// 视图每次打开都会调用
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

// 视图第一次打开时调用
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createTableView];
    
}


-(void)createTableView{
    _tableView = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds  style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
}


//每组行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
//组数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}


//每行内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"cell1";
    LESTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[LESTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    if (indexPath.section==0) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString * str = [userDefaults objectForKey:@"id"];
        if (str) {
            cell.textLabel.text = [NSString stringWithFormat:@"当前用户：%@",str] ;
            NSLog(@"有id,%@",str);
            //            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            NSLog(@"登陆成功，当前用户:%@",str);
        }else{
            NSLog(@"没有id,%@",str);
            cell.textLabel.text = @"登录";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }else if (indexPath.section==1){
        cell.textLabel.text = @"退出";
    }
    return cell;
}

//控制行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}


#pragma-mark - tabelViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString * str = [userDefaults objectForKey:@"id"];
    if (indexPath.section == 0) {
        //        if (str) {
        //            //如果当前有用户
        //            _secView = [[SecondViewController alloc]init];
        //            [self.navigationController pushViewController:_secView animated:YES];
        //        }else{
        //如果当前没有用户登录-跳转登录
        //            _logView =[[LoginViewController alloc]init];
        //            [self.navigationController pushViewController:_logView animated:YES];
        //        }
    }else if (indexPath.section ==1){
        if (str) {
            //退出登录
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"友情提示" message:@"确认退出登录吗？" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAlertAction = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //删除userdefaults数据，退出到登录页面
                //                ！！！！此处有bug,暂时不改
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                NSDictionary *dic = [userDefaults dictionaryRepresentation];
                for (id  key in dic) {
                    [userDefaults removeObjectForKey:key];
                }
                [userDefaults synchronize];
                
                _logView =[[LoginViewController alloc]init];
                [self presentViewController:_logView animated:YES completion:^{
                }];
                NSLog(@"退出到登录页面 ,id==%@",str);
            }];
            //cancle
            UIAlertAction *cancleAlertAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSLog(@"取消退出");
            }];
            [alertController addAction:cancleAlertAction];
            [alertController addAction:okAlertAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }else {
            //当前没有账号登录
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"友情提示" message:@"当前无账号登录" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAlertAction = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:okAlertAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }
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
