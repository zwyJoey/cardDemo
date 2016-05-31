//
//  XGMMViewController.m
//  详情页demo
//
//  Created by 黄传家 on 16/5/6.
//  Copyright © 2016年 黄传家. All rights reserved.
//

#import "XGMMViewController.h"
#import <CoreData/CoreData.h>
#import "User.h"
#import "User1.h"
@interface XGMMViewController ()

@property (strong,nonatomic)UITextField *oldTF;
@property (strong,nonatomic)UITextField *NewTF1;
@property (strong,nonatomic)UITextField *NewTF2;
@property (strong,nonatomic)UIButton *saveBtn;
@property (strong,nonatomic)NSManagedObjectContext *managedObjectContext;
@end

@implementation XGMMViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self createUI];
}
-(void)createUI{
//    self.numbTF.borderStyle = UITextBorderStyleRoundedRect;
//    self.numbTF.layer.masksToBounds = YES;
//    self.numbTF.layer.cornerRadius = 5;
    self.title = @"修改密码";
    self.oldTF = [[UITextField alloc]initWithFrame:CGRectMake(5, 100, [UIScreen mainScreen].bounds.size.width-10, 40)];
    self.NewTF1 = [[UITextField alloc]initWithFrame:CGRectMake(5, 160, [UIScreen mainScreen].bounds.size.width-10, 40)];
    self.NewTF2 = [[UITextField alloc]initWithFrame:CGRectMake(5, 220, [UIScreen mainScreen].bounds.size.width-10, 40)];
    self.saveBtn = [[UIButton alloc]initWithFrame:CGRectMake(5, 280, [UIScreen mainScreen].bounds.size.width-10, 40)];
    
    self.oldTF.borderStyle = UITextBorderStyleRoundedRect;
    self.oldTF.layer.masksToBounds = YES;
    self.oldTF.layer.cornerRadius = 5;
    self.oldTF.placeholder = @"旧密码";
    
    self.NewTF1.borderStyle = UITextBorderStyleRoundedRect;
    self.NewTF1.layer.masksToBounds = YES;
    self.NewTF1.layer.cornerRadius = 5;
    self.NewTF1.placeholder = @"新密码";
    
    self.NewTF2.borderStyle = UITextBorderStyleRoundedRect;
    self.NewTF2.layer.masksToBounds = YES;
    self.NewTF2.layer.cornerRadius = 5;
    self.NewTF2.placeholder = @"新密码";
    
    [self.saveBtn setTitle:@"确定" forState:UIControlStateNormal];
    [self.saveBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.saveBtn addTarget:self action:@selector(saveBtntap) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.oldTF];
    [self.view addSubview:self.NewTF1];
    [self.view addSubview:self.NewTF2];
    [self.view addSubview:self.saveBtn];
}
-(void)saveBtntap{
    if ([self.NewTF1.text isEqualToString:self.NewTF2.text]) {
    id appDelegete = [[UIApplication sharedApplication]delegate];
    self.managedObjectContext = [appDelegete managedObjectContext];
    User1 *person1 = [User1 shareUser];
    NSFetchRequest * request = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([User class])];
    NSError * error = nil;
    NSArray * array = [self.managedObjectContext executeFetchRequest:request error:&error];
    for (User * user in array) {
        
        if ([user.id isEqualToString:person1.id]) {
            user.passWord = self.NewTF1.text;
        }
    }
    }else{
        NSLog(@"huhuhuhuh");
    }
    
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
