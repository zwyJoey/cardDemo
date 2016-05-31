//
//  FKWTViewController.m
//  Hcard
//
//  Created by 黄传家 on 16/5/26.
//  Copyright © 2016年 黄传家. All rights reserved.
//

#import "FKWTViewController.h"

@interface FKWTViewController ()
@property (strong,nonatomic)UITextField *proTF;
@property (strong,nonatomic)UITextField *idTF;
@end

@implementation FKWTViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.proTF = [[UITextField alloc]initWithFrame:CGRectMake(10, 100, [UIScreen mainScreen].bounds.size.width-20, 200)];
    self.proTF.borderStyle = UITextBorderStyleRoundedRect;
    self.proTF.layer.masksToBounds = YES;
    self.proTF.layer.cornerRadius = 5;
    self.proTF.placeholder = @"请描述你的问题";
    [self.view addSubview:self.proTF];
    self.idTF = [[UITextField alloc]initWithFrame:CGRectMake(10, 310, [UIScreen mainScreen].bounds.size.width-20, 40)];
    self.idTF.borderStyle = UITextBorderStyleRoundedRect;
    self.idTF.layer.masksToBounds = YES;
    self.idTF.layer.cornerRadius = 5;
    NSUserDefaults *us = [NSUserDefaults standardUserDefaults];
    self.idTF.text = [us objectForKey:@"id"];
    [self.view addSubview:self.idTF];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(saveBtntap)];
    self.navigationItem.rightBarButtonItem = item;
    
    
    
    // Do any additional setup after loading the view.
}
-(void)saveBtntap{
    
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
