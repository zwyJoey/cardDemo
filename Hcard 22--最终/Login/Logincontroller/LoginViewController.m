//
//  LoginViewController.m
//  NCard登录注册
//
//  Created by zhaowanyu on 16/4/16.
//  Copyright © 2016年 zhaowanyu. All rights reserved.
//

#import "LoginViewController.h"
#import "SignInViewController.h"
#import <CoreData/CoreData.h>
#import "User.h"
#import "User1.h"
#import "FirstViewController.h"
#import "MyAdvViewController.h"
#import "ViewController.h"
#import "LSEViewController.h"
#import "LESTableViewCell.h"
#import "HomePageViewController.h"
#import "AdvertisementViewController.h"
@interface LoginViewController ()<UITextFieldDelegate,NSFetchedResultsControllerDelegate,UITableViewDelegate>
@property(strong,nonatomic)UITextField * idLog;//账号
@property(strong,nonatomic)UITextField * passLog;//密码
@property(strong,nonatomic)UIButton * logInBtn;//登录按钮
@property(strong,nonatomic)UIButton * signInBtn;//注册按钮
@property (strong,nonatomic)NSManagedObjectContext *managedObjectContext;
@property (strong,nonatomic)NSFetchedResultsController *frc;
@property(strong,nonatomic)FirstViewController *fir;
@property(strong,nonatomic)SignInViewController * sign;
@property(strong,nonatomic)LSEViewController *lseView;
@property(strong,nonatomic)UIImageView * imgView;
@property(strong,nonatomic)NSArray *objects;
@end

@implementation LoginViewController

// 视图每次打开都会调用
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.imgView reloadInputViews];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.objects = [NSArray array];
    _imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    [self.view addSubview:_imgView];
    UIImage * bgImg = [UIImage imageNamed:@"log"];
    _imgView.userInteractionEnabled= YES;//打开关联开关，允许控件正常使用
    _imgView.image = bgImg;
    //
    
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSString * str = [userDefaults objectForKey:@"id"];
    if (str) {
        //navagition左侧按钮
        UIBarButtonItem * leftBar = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(tabLeftBar)];
        self.navigationItem.leftBarButtonItem = leftBar;
    }
    
    
    //V-Card
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(375/2-125, 100-70+30, 250, 200)];
    label.text = @"V-Card";
    label.font = [UIFont fontWithName:@"Helvetica-Bold" size:75];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    //    label.backgroundColor = [UIColor blackColor];
    [self.view addSubview:label];
    
    //账号框
    _idLog= [[UITextField alloc]initWithFrame:CGRectMake(375/2-125, 120+80+160-70, 250, 40)];
    //    _idLog.backgroundColor = [UIColor whiteColor];
    _idLog.borderStyle= UITextBorderStyleLine;
    _idLog.placeholder = @"请输入手机号";//默认字体
    _idLog.clearButtonMode = UITextFieldViewModeAlways;
    [_idLog setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];//默认字体的颜色
    _idLog.layer.cornerRadius = 10;
    _idLog.layer.borderColor = [UIColor whiteColor].CGColor;
    _idLog.layer.borderWidth = 1.5;
    _idLog.textColor = [UIColor whiteColor];
    [_imgView addSubview:_idLog];
    //设置代理
    _idLog.delegate = self;
    
    //密码框
    _passLog= [[UITextField alloc]initWithFrame:CGRectMake(375/2-125, 120+40+20+80+160-70, 250, 40)];
    _passLog.borderStyle= UITextBorderStyleLine;
    //    _passLog.backgroundColor = [UIColor whiteColor];
    _passLog.clearButtonMode = UITextFieldViewModeAlways;
    _passLog.placeholder = @"请输入密码";
    _passLog.layer.borderColor = [UIColor whiteColor].CGColor;
    _passLog.layer.borderWidth = 1.5;
    [_passLog setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    _passLog.textColor = [UIColor whiteColor];
    _passLog.layer.cornerRadius = 10;
    _passLog.secureTextEntry = YES;
    [_imgView addSubview:_passLog];
    //设置代理
    _passLog.delegate = self;
    
    //登录按钮
    _logInBtn = [[UIButton alloc]initWithFrame:CGRectMake(375/2-125, 120+40+20+120+30+160-70, 90+25, 40)];
    //    _logInBtn.backgroundColor = [UIColor blackColor];
    _logInBtn.tintColor = [UIColor colorWithRed:0.094 green:0.761 blue:0.937 alpha:1.00];
    [_logInBtn setTitle:@"登录" forState:UIControlStateNormal];
    [_logInBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef borderColorRef = CGColorCreate(colorSpace,(CGFloat[]){ 1, 1, 1, 1 });//r, g, b, alpha
    _logInBtn.layer.borderColor = borderColorRef;
    _logInBtn.layer.borderWidth = 1.5;
    _logInBtn.layer.cornerRadius = 10;
    [_logInBtn addTarget:self action:@selector(tabBtnAndSendValue) forControlEvents:UIControlEventTouchUpInside];
    [_imgView addSubview:_logInBtn];
    
    
    
    //注册按钮
    _signInBtn = [[UIButton alloc]initWithFrame:CGRectMake(375/2+10, 120+40+20+120+30+160-70, 90+25, 40)];;
    //    _signInBtn.backgroundColor = [UIColor blackColor];
    _signInBtn.tintColor = [UIColor colorWithRed:0.094 green:0.761 blue:0.937 alpha:1.00];
    [_signInBtn setTitle:@"注册" forState:UIControlStateNormal];
    [_signInBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _signInBtn.layer.cornerRadius = 10;
    [_signInBtn addTarget:self action:@selector(tabSignInBtn) forControlEvents:UIControlEventTouchUpInside];
    CGColorSpaceRef colorSpace1 = CGColorSpaceCreateDeviceRGB();
    CGColorRef borderColorRef1 = CGColorCreate(colorSpace1,(CGFloat[]){ 1, 1, 1, 1 });//r, g, b, alpha
    _signInBtn.layer.borderColor = borderColorRef1;
    _signInBtn.layer.borderWidth = 1.5;
    _signInBtn.layer.cornerRadius = 10;
    [_imgView addSubview:_signInBtn];
    
    
}




//点击navigation左侧按钮
-(void)tabLeftBar{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString * str = [userDefaults objectForKey:@"id"];
    NSLog(@"点击返回，id==%@",str);
    [self.navigationController popViewControllerAnimated:YES];
}

//登录
-(void)tabBtnAndSendValue{
    
    //如果没输入账号弹出警告
    if (_idLog.text.length<=0||_passLog.text.length<=0) {
        //账号为空
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"友情提示" message:@"请输入账号/密码" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAlertAction = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:okAlertAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }else{
        
        //coreData请求数据
        UIApplication *application = [UIApplication sharedApplication];
        id delegate = [application delegate];
        self.managedObjectContext = [delegate managedObjectContext];
        //通过实体类获取请求设置要查询的实体
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([User class])];
        //设置排序(id升序)
        NSSortDescriptor *idSort = [NSSortDescriptor sortDescriptorWithKey:@"id" ascending:YES];
        NSSortDescriptor *passSort = [NSSortDescriptor sortDescriptorWithKey:@"passWord" ascending:YES];
        [request setSortDescriptors:@[idSort,passSort]];
        //添加谓词查询（条件过滤）
        NSPredicate * predicate = [NSPredicate predicateWithFormat:@"id = %@，passWord = %@",_idLog.text,_passLog.text];
        request.predicate = predicate;
        //通过上下文查询
        self.frc = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
        NSError *error;
        if (![self.frc performFetch:&error]) {
            NSLog(@"%@",[error localizedDescription]);
        }
        self.frc.delegate = self;
        NSArray *objects = [self.frc fetchedObjects];
        
        //如果frc为空，代表查不到账号
        if(objects.count<=0){
            NSLog(@"登录账号不存在");
            //账号为空，弹出警告
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"友情提示" message:@"账号不存在" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *okAlertAction = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:okAlertAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }else{
            //提取账号密码
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            User *userMessage = [self.frc objectAtIndexPath:indexPath];
            
            if ([_idLog.text isEqualToString:userMessage.id]&&[_passLog.text isEqualToString:userMessage.passWord]){
                NSLog(@"密码正确，继续登录");
                //登陆成功
                //保存到userdefaults
                NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
                [userdefaults setObject:_idLog.text forKey:@"id"];
                [userdefaults setObject:_passLog.text forKey:@"password"];
                //最后跳转r
                // 首页
                User1 *u = [User1 shareUser];
                u.id = self.idLog.text;
                HomePageViewController *v1 = [[HomePageViewController alloc]init];
                UINavigationController *na1 = [self addController:v1 addTitle:@"third" normalImage:@"b1" selectImage:@"b2"];
                
                FirstViewController *v2 = [[FirstViewController alloc]init];
                UINavigationController *na2 = [self addController:v2 addTitle:@"third" normalImage:@"a1" selectImage:@"a2"];
                AdvertisementViewController *v3 = [[AdvertisementViewController alloc]init];
                UINavigationController *na3 = [self addController:v3 addTitle:@"third" normalImage:@"c1" selectImage:@"c2"];
                v1.title = @"详情页";
                v2.title = @"主页";
                v3.title = @"广告";
                
                
                UITabBarController *tab = [[UITabBarController alloc]init];
                tab.viewControllers = @[na2,na1,na3];
                [self presentViewController:tab animated:YES completion:nil];
            }else if (![_passLog.text isEqualToString:userMessage.passWord]){
                //账号为空，弹出警告
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"友情提示" message:@"密码错误！" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *okAlertAction = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault handler:nil];
                [alertController addAction:okAlertAction];
                [self presentViewController:alertController animated:YES completion:nil];
            }
        }
    }
}

//重写导航栏方法
-(UINavigationController *)addController:(UIViewController *)controller addTitle:(NSString *)title normalImage:(NSString *)normal selectImage:(NSString *)selectImage{
    //创建导航栏
    UINavigationController *na = [[UINavigationController alloc]initWithRootViewController:controller];
    //导航图片
    [controller.tabBarItem setImage:[UIImage imageNamed:normal]];
    //渲染图片颜色
    UIImage *selectIma = [[UIImage imageNamed:selectImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [controller.tabBarItem setSelectedImage:selectIma];
    //设置tabBar上文字的渲染颜色（控制器底部文字）
    [controller.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} forState:UIControlStateNormal];
    return na;
}



//点击注册按钮跳转到注册页面
-(void)tabSignInBtn{
    
    self.idLog.text = nil;
    self.passLog.text = nil;
    SignInViewController *signViewController = [[SignInViewController alloc]init];
    [self presentViewController:signViewController animated:YES completion:nil];
}


//隐藏底栏tabBar
-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed=YES;
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//点击空白处结束编辑状态(有什么效果想在点击空白处实现，可以把代码写进这里)
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    
}
//开始编辑
- (void)textFieldDidBegEditing:(UITextField *)textField{
}

//结束编辑
-(void)textFieldDidEndEditing:(UITextField *)textField{
    
}



//点击Return键（标志着编辑已经结束了）
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
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
