//
//  BYSJViewController.m
//  Hcard
//
//  Created by 黄传家 on 16/5/24.
//  Copyright © 2016年 黄传家. All rights reserved.
//

#import "BYSJViewController.h"

@interface BYSJViewController ()
//@property (strong,nonatomic)UILabel *label;
@property (strong,nonatomic)UITextField *numbTF;
@property (strong,nonatomic)UITextField *YZMTF;
@property (strong,nonatomic)UIButton *button;
@property (strong,nonatomic)UIButton *saveBtn;
@end

@implementation BYSJViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"备用手机";
    self.view.backgroundColor = [UIColor whiteColor];
    self.numbTF = [[UITextField alloc]initWithFrame:CGRectMake(5, 100, [UIScreen mainScreen].bounds.size.width-10, 40)];
    self.YZMTF = [[UITextField alloc]initWithFrame:CGRectMake(5, 165, [UIScreen mainScreen].bounds.size.width-150, 40)];
    self.button = [[UIButton alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-145, 165, 140, 40)];
    self.saveBtn = [[UIButton alloc]initWithFrame:CGRectMake(5, 210, [UIScreen mainScreen].bounds.size.width-10, 40)];
    
    self.numbTF.borderStyle = UITextBorderStyleRoundedRect;
    self.numbTF.layer.masksToBounds = YES;
    self.numbTF.layer.cornerRadius = 5;
    
    self.YZMTF.borderStyle = UITextBorderStyleRoundedRect;
    self.YZMTF.layer.masksToBounds = YES;
    self.YZMTF.layer.cornerRadius = 5;
    
    [self.button setTitle:@"获取验证码" forState:UIControlStateNormal];
    [self.button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    self.button.layer.masksToBounds = YES;
    self.button.layer.cornerRadius = 5;
    [self.button addTarget:self action:@selector(buttontap) forControlEvents:UIControlEventTouchUpInside];
    
    [self.saveBtn setTitle:@"完成" forState:UIControlStateNormal];
    [self.saveBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    self.saveBtn.layer.masksToBounds = YES;
    self.saveBtn.layer.cornerRadius = 5;
    [self.saveBtn addTarget:self action:@selector(saveBtntap) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.numbTF];
    [self.view addSubview:self.YZMTF];
    [self.view addSubview:self.button];
    [self.view addSubview:self.saveBtn];
    // Do any additional setup after loading the view.
}
-(void)buttontap{
    
}
-(void)saveBtntap{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:self.numbTF.text forKey:@"number"];
    [self.navigationController popViewControllerAnimated:YES];
    
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
