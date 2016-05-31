//
//  AboutViewController.m
//  详情页demo
//
//  Created by 黄传家 on 16/4/28.
//  Copyright © 2016年 黄传家. All rights reserved.
//

#import "AboutViewController.h"
//#import "SetViewController.h"
#import "GZTableViewController.h"
@interface AboutViewController ()

@property (strong,nonatomic)UIButton *scoreBtn;
@property (strong,nonatomic)UIButton *attentionBtn;
@property (strong,nonatomic)UIButton *TJBtn;
@property (strong,nonatomic)UIButton *contactBtn;

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.scoreBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, 40)];
    [self.scoreBtn setTitle:@"去评分" forState:UIControlStateNormal];
    [self.scoreBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.scoreBtn addTarget:self action:@selector(scoreBtntap) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.scoreBtn];
    
    self.attentionBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 180, [UIScreen mainScreen].bounds.size.width, 40)];
    [self.attentionBtn setTitle:@"关注我们" forState:UIControlStateNormal];
    [self.attentionBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.attentionBtn addTarget:self action:@selector(attentionBtntap) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.attentionBtn];
    
    self.TJBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 260, [UIScreen mainScreen].bounds.size.width, 40)];
    [self.TJBtn setTitle:@"推荐给朋友" forState:UIControlStateNormal];
    [self.TJBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.view addSubview:self.TJBtn];
    
    self.contactBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 340, [UIScreen mainScreen].bounds.size.width, 40)];
    [self.contactBtn setTitle:@"联系我们" forState:UIControlStateNormal];
    [self.contactBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.view addSubview:self.contactBtn];
    [self.contactBtn addTarget:self action:@selector(contactBtntap) forControlEvents:UIControlEventTouchUpInside];
}
-(void)scoreBtntap{
    
}
-(void)attentionBtntap{
    GZTableViewController *gz = [[GZTableViewController alloc]init];
    [self.navigationController pushViewController:gz animated:YES];
}
-(void)contactBtntap{
    UIAlertController *Alert = [UIAlertController alertControllerWithTitle:@"联系我们" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"电话热线" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIWebView*callWebview =[[UIWebView alloc] init];
        NSURL *telURL =[NSURL URLWithString:@"tel:13315036351"];// 貌似tel:// 或者 tel: 都行
        [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
        //记得添加到view上
        [self.view addSubview:callWebview];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [Alert addAction:action1];
    [Alert addAction:action2];
    [self presentViewController:Alert animated:YES completion:nil];
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
