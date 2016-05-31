//
//  CardViewController.m
//  cardCase
//
//  Created by zhaowanyu on 16/5/19.
//  Copyright © 2016年 黄传家. All rights reserved.
//

#import "CardViewController.h"
#import "MyTableViewCell.h"
#import "LoginViewController.h"
#import "CardModelViewController.h"
#import "CardoneViewController.h"
#import "CardTwoViewController.h"
#import "CardThreeViewController.h"
#import "CardFourViewController.h"
#import "CardFiveViewController.h"
#import "CardSixViewController.h"
#import "CardSevenViewController.h"
#import "CardEightViewController.h"

@interface CardViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(strong,nonatomic) UITableView * tableView;
@property(strong,nonatomic)NSArray * header;
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
@property(strong,nonatomic) NSManagedObjectContext *managedObjectContext;
@end

@implementation CardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"名片设计";
    
    [self createTableView];
    _header = @[@"简约",@"时尚",@"卡通"];
    
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
    return 3;
}


//每行内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"cell1";
    MyTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:cellID] ;
    if (!cell) {
        cell = [[MyTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    switch (indexPath.section) {
        case 0:
            [cell.btn1 setImage:[UIImage imageNamed:@"1"] forState:UIControlStateNormal];
            [cell.btn1 addTarget:self action:@selector(tabBtn1) forControlEvents:UIControlEventTouchUpInside];
            
            [cell.btn2 setImage:[UIImage imageNamed:@"2"] forState:UIControlStateNormal];
            [cell.btn2 addTarget:self action:@selector(tabBtn2) forControlEvents:UIControlEventTouchUpInside];
            
            [cell.btn3 setImage:[UIImage imageNamed:@"3"] forState:UIControlStateNormal];
            [cell.btn3 addTarget:self action:@selector(tabBtn3) forControlEvents:UIControlEventTouchUpInside];
            
            break;
        case 1:
            [cell.btn1 setImage:[UIImage imageNamed:@"4"] forState:UIControlStateNormal];
            [cell.btn1 addTarget:self action:@selector(tabBtn4) forControlEvents:UIControlEventTouchUpInside];
            
            [cell.btn2 setImage:[UIImage imageNamed:@"5"] forState:UIControlStateNormal];
            [cell.btn2 addTarget:self action:@selector(tabBtn5) forControlEvents:UIControlEventTouchUpInside];
            
            [cell.btn3 setImage:[UIImage imageNamed:@"6"] forState:UIControlStateNormal];
            [cell.btn3 addTarget:self action:@selector(tabBtn6) forControlEvents:UIControlEventTouchUpInside];
            break;
        case 2:
            [cell.btn1 setImage:[UIImage imageNamed:@"7"] forState:UIControlStateNormal];
            [cell.btn1 addTarget:self action:@selector(tabBtn7) forControlEvents:UIControlEventTouchUpInside];
            
            [cell.btn2 setImage:[UIImage imageNamed:@"8"] forState:UIControlStateNormal];
            [cell.btn2 addTarget:self action:@selector(tabBtn8) forControlEvents:UIControlEventTouchUpInside];
            
            [cell.btn3 setImage:[UIImage imageNamed:@"9"] forState:UIControlStateNormal];
            [cell.btn3 addTarget:self action:@selector(tabBtn9) forControlEvents:UIControlEventTouchUpInside];
            break;
            
        default:
            break;
    }
    
    return cell;
}

//控制行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}

// 返回分组header的内容
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return _header[section];
}


#pragma mark - cardMethod * 9

-(void)tabBtn1{
    self.cardModel = [[CardModelViewController alloc]init];
    [self.navigationController pushViewController:_cardModel animated:YES];
}


-(void)tabBtn2{
    self.cardOne = [[CardoneViewController alloc]init];
    [self.navigationController pushViewController:_cardOne animated:YES];
}


-(void)tabBtn3{
    self.cardTwo = [[CardTwoViewController alloc]init];
    [self.navigationController pushViewController:_cardTwo animated:YES];
}

-(void)tabBtn4{
    self.cardThree = [[CardThreeViewController alloc]init];
    [self.navigationController pushViewController:_cardThree animated:YES];
}

-(void)tabBtn5{
    self.cardFour = [[CardFourViewController alloc]init];
    [self.navigationController pushViewController:_cardFour animated:YES];
    ;
}

-(void)tabBtn6{
    self.cardFive = [[CardFiveViewController alloc]init];
    [self.navigationController pushViewController:_cardFive animated:YES];
    ;
}
-(void)tabBtn7{
    self.cardSix = [[CardSixViewController alloc]init];
    [self.navigationController pushViewController:_cardSix animated:YES];
    
}
-(void)tabBtn8{
    self.cardSeven = [[CardSevenViewController alloc]init];
    [self.navigationController pushViewController:_cardSeven animated:YES];
    
}
-(void)tabBtn9{
    self.cardEight = [[CardEightViewController alloc]init];
    [self.navigationController pushViewController:_cardEight animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
