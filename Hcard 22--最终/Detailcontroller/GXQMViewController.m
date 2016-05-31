//
//  GXQMViewController.m
//  Hcard
//
//  Created by 黄传家 on 16/5/24.
//  Copyright © 2016年 黄传家. All rights reserved.
//

#import "GXQMViewController.h"
#import "HomePageViewController.h"
@interface GXQMViewController ()
@property (strong,nonatomic)UITextField *textField;
@property (strong,nonatomic)UIButton *saveButton;

@end

@implementation GXQMViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个性签名";
    
    //设置背景
    UIImageView * bgimgView = [[UIImageView alloc]init];
    bgimgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    [self.view addSubview:bgimgView];
    UIImage * bgimg = [UIImage imageNamed:@"sign"];
    bgimgView.userInteractionEnabled= YES;//打开关联开关，允许控件正常使用
    bgimgView.image = bgimg;
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.textField = [[UITextField alloc]initWithFrame:CGRectMake(10, 150, [UIScreen mainScreen].bounds.size.width-20, 120)];
    self.textField.backgroundColor = [UIColor whiteColor];
    
    
    [self.view addSubview:self.textField];
    self.saveButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 310, [UIScreen mainScreen].bounds.size.width-20, 60)];
    self.saveButton.backgroundColor = [UIColor colorWithRed:0.929 green:0.820 blue:0.553 alpha:1.00];
    [self.saveButton setTitle:@"完成" forState:UIControlStateNormal];
//    [self.saveButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.view addSubview:self.saveButton];
    [self.saveButton addTarget:self action:@selector(saveButtontap) forControlEvents:UIControlEventTouchUpInside];
    // Do any additional setup after loading the view.
}
-(void)saveButtontap{
//    HomePageViewController *home = [[HomePageViewController alloc]init];
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    [userdefaults setObject:self.textField.text forKey:@"gxqm"];
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
