//
//  SignInViewController.m
//  NCard登录注册
//
//  Created by zhaowanyu on 16/4/16.
//  Copyright © 2016年 zhaowanyu. All rights reserved.
//

#import "SignInViewController.h"
#import "LoginViewController.h"
#import <SMS_SDK/SMSSDK.h>
#import <SMS_SDK/Extend/SMSSDK+AddressBookMethods.h>
#import <SMS_SDK/Extend/SMSSDK+DeprecatedMethods.h>
#import <SMS_SDK/Extend/SMSSDK+ExtexdMethods.h>
#import <CoreData/CoreData.h>
#import "User.h"
#import "User1.h"
#import "Group.h"
#import "FirstViewController.h"
#import "HomePageViewController.h"
#import "AdvertisementViewController.h"
@interface SignInViewController ()<UITextFieldDelegate>
@property(strong,nonatomic)UITextField * idSign;//账号
@property(strong,nonatomic)UITextField * passSign;//密码
@property(strong,nonatomic)UIButton * logInBtn;//注册完成按钮
@property (strong,nonatomic)UITextField *YZMTF;//验证码文本框
@property (strong,nonatomic)UIButton *YZMBtn;//验证码按钮
@property(strong,nonatomic)UIButton * signInBtn;//取消按钮
@property (strong,nonatomic)NSFetchedResultsController *frc;
@property (strong,nonatomic)NSManagedObjectContext *managedObjectContext;
@property (strong,nonatomic)User *user;
@property (strong,nonatomic)Group *group;
@property(strong,nonatomic)FirstViewController * fir;
@property(strong,nonatomic)UIButton * disSign;//注册按钮
@property(strong,nonatomic)UIImageView * imgView;
@property(assign,nonatomic)int secondsContDown;
@property(strong,nonatomic)NSTimer * countDownTimer;
@property(assign,nonatomic)BOOL flag;
@end

@implementation SignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置背景
    [self createSign];
}


-(void)createSign{
    _imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    [self.view addSubview:_imgView];
    UIImage * bgImg = [UIImage imageNamed:@"sign"];
    _imgView.userInteractionEnabled= YES;//打开关联开关，允许控件正常使用
    _imgView.image = bgImg;
    
    
    //V-Card
    UILabel *vLabel = [[UILabel alloc]initWithFrame:CGRectMake(375/2-125, 60, 250, 180)];
    vLabel.text = @"V-Card";
    vLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:60];
    vLabel.textColor = [UIColor whiteColor];
    vLabel.textAlignment = NSTextAlignmentCenter;
    //    label.backgroundColor = [UIColor blackColor];
    [self.view addSubview:vLabel];
    
    //账号框
    _idSign= [[UITextField alloc]initWithFrame:CGRectMake(375/2-125, 250, 250, 40)];
    //    _idLog.backgroundColor = [UIColor whiteColor];
    _idSign.borderStyle= UITextBorderStyleLine;
    _idSign.placeholder = @"请输入手机号";//默认字体
    _idSign.clearButtonMode = UITextFieldViewModeAlways;
    [_idSign setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];//默认字体的颜色
    _idSign.layer.cornerRadius = 10;
    _idSign.layer.borderColor = [UIColor whiteColor].CGColor;
    _idSign.layer.borderWidth = 1.5;
    _idSign.textColor = [UIColor whiteColor];
    [_imgView addSubview:_idSign];
    //设置代理
    _idSign.delegate = self;
    
    //密码框
    _passSign= [[UITextField alloc]initWithFrame:CGRectMake(375/2-125, 310, 250, 40)];
    _passSign.borderStyle= UITextBorderStyleLine;
    //    _passLog.backgroundColor = [UIColor whiteColor];
    _passSign.clearButtonMode = UITextFieldViewModeAlways;
    _passSign.placeholder = @"请输入密码";
    _passSign.layer.borderColor = [UIColor whiteColor].CGColor;
    _passSign.layer.borderWidth = 1.5;
    [_passSign setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    _passSign.textColor = [UIColor whiteColor];
    _passSign.layer.cornerRadius = 10;
    _passSign.secureTextEntry = YES;
    [_imgView addSubview:_passSign];
    //设置代理
    _passSign.delegate = self;
    
    //输入验证码文本框
    self.YZMTF = [[UITextField alloc]initWithFrame:CGRectMake(375/2-125, 365, 90+25, 40)];
    self.YZMTF.borderStyle= UITextBorderStyleLine;
    //    _passLog.backgroundColor = [UIColor whiteColor];
    self.YZMTF.clearButtonMode = UITextFieldViewModeAlways;
    self.YZMTF.placeholder = @"请输入验证码";
    self.YZMTF.layer.borderColor = [UIColor whiteColor].CGColor;
    self.YZMTF.layer.borderWidth = 1.5;
    [self.YZMTF setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    self.YZMTF.textColor = [UIColor whiteColor];
    self.YZMTF.layer.cornerRadius = 10;
    //    self.YZMTF.secureTextEntry = YES;
    [_imgView addSubview:self.YZMTF];
    //设置代理
    self.YZMTF.delegate = self;
    
    //获取验证码
    self.YZMBtn = [[UIButton alloc]initWithFrame:CGRectMake(375/2+10, 365, 90+25, 40)];
    self.YZMBtn.backgroundColor = [UIColor colorWithRed:0.996 green:0.878 blue:0.251 alpha:1.00];
    self.YZMBtn.tintColor = [UIColor whiteColor];
    [self.YZMBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [self.YZMBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    CGColorSpaceRef colorSpace2 = CGColorSpaceCreateDeviceRGB();
    CGColorRef borderColorRef2 = CGColorCreate(colorSpace2,(CGFloat[]){ 1, 1, 1, 1 });//r, g, b, alpha
    self.YZMBtn.layer.borderColor = borderColorRef2;
    self.YZMBtn.layer.borderWidth = 1.5;
    self.self.YZMBtn.layer.cornerRadius = 10;
    [_imgView addSubview:self.YZMBtn];
    [self.YZMBtn addTarget:self action:@selector(YZMBtntap) forControlEvents:UIControlEventTouchUpInside];
    
    //分割线
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 425, 375, 3)];
    label.backgroundColor = [UIColor colorWithRed:0.996 green:0.878 blue:0.251 alpha:1.00];
    [_imgView addSubview:label];
    
    //完成
    _logInBtn = [[UIButton alloc]initWithFrame:CGRectMake(375/2-125, 450, 90+25, 40)];
    //    _logInBtn.backgroundColor = [UIColor blackColor];
    _logInBtn.tintColor = [UIColor colorWithRed:0.094 green:0.761 blue:0.937 alpha:1.00];
    [_logInBtn setTitle:@"完成" forState:UIControlStateNormal];
    [_logInBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef borderColorRef = CGColorCreate(colorSpace,(CGFloat[]){ 1, 1, 1, 1 });//r, g, b, alpha
    _logInBtn.layer.borderColor = borderColorRef;
    _logInBtn.layer.borderWidth = 1.5;
    _logInBtn.layer.cornerRadius = 10;
    [_logInBtn addTarget:self action:@selector(tabBtnAndSendValue) forControlEvents:UIControlEventTouchUpInside];
    [_imgView addSubview:_logInBtn];
    
    //取消注册
    _signInBtn = [[UIButton alloc]initWithFrame:CGRectMake(375/2+10, 450, 90+25, 40)];;
    //    _signInBtn.backgroundColor = [UIColor blackColor];
    _signInBtn.tintColor = [UIColor colorWithRed:0.094 green:0.761 blue:0.937 alpha:1.00];
    [_signInBtn setTitle:@"取消" forState:UIControlStateNormal];
    [_signInBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _signInBtn.layer.cornerRadius = 10;
    [_signInBtn addTarget:self action:@selector(tabDisSignBtn) forControlEvents:UIControlEventTouchUpInside];
    CGColorSpaceRef colorSpace1 = CGColorSpaceCreateDeviceRGB();
    CGColorRef borderColorRef1 = CGColorCreate(colorSpace1,(CGFloat[]){ 1, 1, 1, 1 });//r, g, b, alpha
    _signInBtn.layer.borderColor = borderColorRef1;
    _signInBtn.layer.borderWidth = 1.5;
    _signInBtn.layer.cornerRadius = 10;
    [_imgView addSubview:_signInBtn];
    
    //    //关闭原始约束
    //    vLabel.translatesAutoresizingMaskIntoConstraints = NO;
    //    _idSign.translatesAutoresizingMaskIntoConstraints = NO;
    //    _passSign.translatesAutoresizingMaskIntoConstraints = NO;
    //    _YZMTF.translatesAutoresizingMaskIntoConstraints = NO;
    //    _YZMBtn.translatesAutoresizingMaskIntoConstraints = NO;
    //    label.translatesAutoresizingMaskIntoConstraints = NO;
    //    _signInBtn.translatesAutoresizingMaskIntoConstraints = NO;
    //    _disSign.translatesAutoresizingMaskIntoConstraints = NO;
    //
    //    //添加自动约束
    //    //高
    //    NSArray *hheight1 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-60-[vLabel]-10-[_idSign]-20-[_passSign(==_idSign)]-80-[label]-150-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(vLabel,_idSign,_passSign,label)];
    //
    //    NSArray *hheight2 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-365-[_YZMTF]-180-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_YZMTF)];
    //
    //    NSArray *hheight3 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-365-[_YZMBtn]-180-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_YZMBtn)];
    //
    //    NSArray *hheight4 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-450-[_signInBtn]-90-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_signInBtn)];
    //
    //    NSArray *hheight5 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-450-[_disSign]-90-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_disSign)];
    //
    //    //宽
    //    NSArray *wwidth1 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-63-[vLabel]-63-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(vLabel)];
    //    NSArray *wwidth2 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-63-[_idSign]-63-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_idSign)];
    //    NSArray *wwidth3 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-63-[_passSign]-63-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_passSign)];
    //    NSArray *wwidth4 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-63-[_YZMTF]-20-[_YZMBtn(==_YZMTF)]-63-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_YZMTF,_YZMBtn)];
    //    NSArray *wwidth5 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[label]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(label)];
    //    NSArray *wwidth6 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-63-[_signInBtn]-20-[_disSign(==_signInBtn)]-63-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_signInBtn,_disSign)];
    //
    //    //添加约束
    //
    //    [_imgView addConstraints:wwidth1];
    //    [_imgView addConstraints:wwidth2];
    //    [_imgView addConstraints:wwidth3];
    //    [_imgView addConstraints:wwidth4];
    //    [_imgView addConstraints:wwidth5];
    //    [_imgView addConstraints:hheight1];
    //    [_imgView addConstraints:hheight2];
    //    [_imgView addConstraints:hheight3];
    //    [_imgView addConstraints:wwidth6];
    //    [_imgView addConstraints:hheight4];
    //    [_imgView addConstraints:hheight5];
    //
    
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



//点击获取验证码--------需要加判断，每30s内发送一条
-(void)YZMBtntap{
    if (_idSign.text.length<11||_idSign.text.length>11){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"友情提示" message:@"请输入正确手机号！" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAlertAction = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:okAlertAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }else if (_passSign.text.length < 5 ||_passSign.text.length >11){
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"友情提示" message:@"密码长度在5-11之间！" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAlertAction = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:okAlertAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }else{
        [self.YZMBtn removeTarget:self action:@selector(YZMBtn) forControlEvents:UIControlEventTouchUpInside];
        self.YZMBtn.backgroundColor = [UIColor grayColor];
        //设置倒计时总时长
        _secondsContDown = 60;//60秒倒计时
        //开始倒计时
        _countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES]; //启动倒计时后会每秒钟调用一次方法 timeFireMethod
        
        //设置倒计时显示的时间
        [_YZMBtn setTitle:[NSString stringWithFormat:@"(%d)",_secondsContDown] forState:UIControlStateNormal] ;
        
        [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:_idSign.text zone:@"86" customIdentifier:nil result:^(NSError *error) {
            if (!error) {
                NSLog(@"验证码发送成功");
            }else{
                NSLog(@"%@",error);
            }
        }];
        
    }
}



//验证码延迟
-(void)timeFireMethod{
    //倒计时-1
    _secondsContDown--;
    //修改倒计时标签现实内容
    [_YZMBtn setTitle:[NSString stringWithFormat:@"%d",_secondsContDown] forState:UIControlStateNormal] ;
    
    //当倒计时到0时，做需要的操作，比如验证码过期不能提交
    if(_secondsContDown==0){
        
        self.YZMBtn.backgroundColor = [UIColor colorWithRed:0.996 green:0.878 blue:0.251 alpha:1.00];
        [self.YZMBtn setTitle:@"重新获取" forState:UIControlStateNormal];
        [self.YZMBtn addTarget:self action:@selector(YZMBtntap) forControlEvents:UIControlEventTouchUpInside];
        [_countDownTimer invalidate];
    }else if(_secondsContDown < 0){
        
    }
}



//取消注册
-(void)tabDisSignBtn{
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

//注册完成
-(void)tabBtnAndSendValue{
//    //检索全文
//    UIApplication *application = [UIApplication sharedApplication];
//    id delegate = [application delegate];
//    self.managedObjectContext = [delegate managedObjectContext];
//    //获取user实体对象
//    if (!_user) {
//        _user = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([User class]) inManagedObjectContext:self.managedObjectContext ];
//    }
//    NSError *error;
//    if (![self.managedObjectContext save:&error]) {
//        NSLog(@"注册页错误%@",[error localizedDescription]);
//    }
    
    //判断用户输入是否出错
    if ([self.idSign.text isEqualToString:@""]||[self.idSign.text isEqual:nil]) {
        //账号为空，弹出警告
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"<友情提示>" message:@"请输入账号" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAlertAction = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alertController addAction:okAlertAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }else if ([self.passSign.text isEqual: nil]||[self.passSign.text isEqualToString:@""]){
        //密码为空，弹出警告
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"<友情提示>" message:@"请输入密码" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAlertAction = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alertController addAction:okAlertAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }else{
        //提交验证码，检验是否正确
        [SMSSDK commitVerificationCode: self.YZMTF.text phoneNumber:_idSign.text zone:@"86" result:^(NSError *error) {
            if (!error) {
                NSLog(@"验证成功");
                //保存注册用户的账号密码
                //通过代理获取上下文
                UIApplication *application = [UIApplication sharedApplication];
                id delegate = [application delegate];
                self.managedObjectContext = [delegate managedObjectContext];
                //获取user实体对象
                if (!_user) {
                    _user = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([User class]) inManagedObjectContext:self.managedObjectContext ];
                }
                //保存注册用户的账号密码到coreData
                _user.id = self.idSign.text;
                _user.passWord = self.passSign.text;
                User1 *u = [User1 shareUser];
                u.id = self.idSign.text;
                //保存
                NSError *error;
                if (![self.managedObjectContext save:&error]) {
                    NSLog(@"注册页错误%@",[error localizedDescription]);
                }
                
                //创建分组
                if (!_group) {
                    _group = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Group class]) inManagedObjectContext:self.managedObjectContext ];
                }
                self.group.name = @"默认";
                self.group.number = [NSNumber numberWithInt:0];
                
                //添加时间
                NSDate *date = [NSDate date];
                NSDateFormatter *df = [[NSDateFormatter alloc] init];
                [df setDateFormat:@"yyyy-MM-dd"];
                [df setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
                NSString *str = [df stringFromDate:date];
                self.group.date = str;
                self.group.user = _user;
                //保存到表中
                if (![self.managedObjectContext save:&error]) {
                    NSLog(@"注册页错误%@",[error localizedDescription]);
                }
                //存userDefaults
                //保存到userdefaults
                NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
                [userdefaults setObject:_idSign.text forKey:@"id"];
                [userdefaults setObject:_passSign.text forKey:@"password"];
                [userdefaults setObject:self.group.name forKey:@"groupName"];
                //登陆成功，跳转页面
                // 首页
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
                
                //                        [self.navigationController popToViewController:tab animated:YES];
                [self presentViewController:tab animated:YES completion:nil];
            }else{
                NSLog(@"验证码错了:%@",error);
                //验证码错误，弹出警告
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"<友情提示>" message:@"验证码错误~" preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *okAlertAction = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                }];
                [alertController addAction:okAlertAction];
                //页面跳转
                [self presentViewController:alertController animated:YES completion:nil];
            }
        }];
    }
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
