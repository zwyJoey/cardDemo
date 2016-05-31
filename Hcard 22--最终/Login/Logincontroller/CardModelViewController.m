//
//  CardModelViewController.m
//  cardCase-git
//
//  Created by zhaowanyu on 16/4/22.
//  Copyright © 2016年 zhaowanyu. All rights reserved.
//

#import "CardModelViewController.h"
#import "User1.h"
#import "User.h"


@interface CardModelViewController ()<UITextFieldDelegate,UINavigationControllerDelegate>

@end

@implementation CardModelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    id appDelegate = [[UIApplication sharedApplication] delegate];
    self.managedObjectContext = [appDelegate managedObjectContext];
    //    self.arr = [NSMutableArray array];
    self.title = @"";
    UIImageView *imgView = [[UIImageView alloc]init];
    imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    [self.view addSubview:imgView];
    UIImage * bgImg = [UIImage imageNamed:@"sign"];
    imgView.userInteractionEnabled= YES;//打开关联开关，允许控件正常使用
    imgView.image = bgImg;
    
    UIBarButtonItem * endBtn = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(tabEndBtn)];
    self.navigationItem.rightBarButtonItem = endBtn;
    
    //页面背景
    self.view.backgroundColor = [UIColor whiteColor];
    
    //第一张名片的设计(默认-极简)
    //正面
    _v1 = [[UIButton alloc]initWithFrame:CGRectMake(20, UISCREEN_HEIGHT-630, UISCREEN_WIDTH-40,UISCREEN_HEIGHT/2-100)];
    [self.view addSubview: _v1];
    self.v1.center = CGPointMake(20+335/2, (667/2)-180);
    //    _v1.backgroundColor = [UIColor blackColor];
    [_v1 setImage:[UIImage imageNamed:@"1"] forState:UIControlStateNormal];
    [_v1 addTarget:self action:@selector(tabV1) forControlEvents:UIControlEventTouchUpInside];
    
    //背面
    _v2 = [[UIButton alloc]initWithFrame:CGRectMake(20, UISCREEN_HEIGHT-130, UISCREEN_WIDTH-40,UISCREEN_HEIGHT/2-100)];
    [self.view addSubview: _v2];
    self.v2.center = CGPointMake(20+335/2, 667-250);
    //    _v2.backgroundColor = [UIColor blackColor];
    [_v2 setImage:[UIImage imageNamed:@"1"] forState:UIControlStateNormal];
    [_v2 addTarget:self action:@selector(tabV2) forControlEvents:UIControlEventTouchUpInside];
    self.image = [UIImage imageNamed:@"1"];
    
    
    [self createCardUI];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//点击navagation完成按钮，保存改动
-(void)tabEndBtn{
    User1 *person1 = [User1 shareUser];
    NSFetchRequest * request = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([UserCard class])];
    NSError * error = nil;
    NSArray * array = [self.managedObjectContext executeFetchRequest:request error:&error];
    for (UserCard *userC in array) {
        if ([userC.cardID isEqualToString:person1.id]) {
            [userC setValue:self.image forKey:@"card"];
        }
        NSLog(@"+++++++%@",userC);
    }
    
    NSError *error1 = nil;
    [self.managedObjectContext save:&error1];
    [self.navigationController popViewControllerAnimated:YES];
    
}


//创建卡片
-(void)createCardUI{
    //正面
    
    
    _label1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 200, 35)];
    _label1.text = @"名片正面 - 点击名片放大编辑";
    _label1.textColor = [UIColor blackColor];
    _label1.font = [UIFont fontWithName:@"Arial" size:13];
    [self.view addSubview:_label1];
    
    //反面
    _label2 = [[UILabel alloc]initWithFrame:CGRectMake(10, 275, 60, 35)];
    _label2.text = @"名片反面";
    _label2.textColor = [UIColor blackColor];
    _label2.font = [UIFont fontWithName:@"Arial" size:13];
    [self.view addSubview:_label2];
    
    //姓名标题
    _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 50, 50, 35)];
    _nameLabel.text = @"姓名:";
    _nameLabel.textColor = [UIColor blackColor];
    _nameLabel.font = [UIFont fontWithName:@"Arial" size:10];
    [_v1 addSubview:_nameLabel];
    //输入姓名
    _namefield = [[UITextField alloc]initWithFrame:CGRectMake(40, 53, 115, 30)];
    _namefield.clearButtonMode = UITextFieldViewModeWhileEditing;
    _namefield.textColor = [UIColor blackColor];
    _namefield.font = [UIFont fontWithName:@"Arial" size:10];
    [_v1 addSubview:_namefield];
    _namefield.delegate = self;
    //一条线
    UILabel *l1 = [[UILabel alloc]init];
    l1.frame = CGRectMake(40, 76, 115, 0.5);
    l1.backgroundColor = [UIColor blackColor];
    l1.alpha = 0.7;
    [_v1 addSubview:l1];
    
    //手机号
    _phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 40+30+5, 50, 35)];
    _phoneLabel.text = @"手机:";
    _phoneLabel.textColor = [UIColor blackColor];
    _phoneLabel.font = [UIFont fontWithName:@"Arial" size:10];
    [_v1 addSubview:_phoneLabel];
    //输入手机号
    _phonefield = [[UITextField alloc]initWithFrame:CGRectMake(40, 40+30+8, 115, 30)];
    _phonefield.font = [UIFont fontWithName:@"Arial" size:10];
    _phonefield.clearButtonMode = UITextFieldViewModeWhileEditing;
    _phonefield.textColor = [UIColor blackColor];
    [_v1 addSubview:_phonefield];
    _phonefield.delegate = self;
    //一条线
    UILabel *l2 = [[UILabel alloc]init];
    l2.frame = CGRectMake(40, 100+2, 115, 0.5);
    l2.backgroundColor = [UIColor blackColor];
    l2.alpha = 0.7;
    [_v1 addSubview:l2];
    
    //邮箱-13180038869@163.com
    _mailLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 30+30*2+5*2, 50, 35)];
    _mailLabel.text = @"邮箱:";
    _mailLabel.textColor = [UIColor blackColor];
    _mailLabel.font = [UIFont fontWithName:@"Arial" size:10];
    [_v1 addSubview:_mailLabel];
    //输入邮箱
    _mailfield = [[UITextField alloc]initWithFrame:CGRectMake(40, 30+30*2+5*2+3, 115, 30)];
    _mailfield.clearButtonMode = UITextFieldViewModeWhileEditing;
    _mailfield.textColor = [UIColor blackColor];
    _mailfield.font = [UIFont fontWithName:@"Arial" size:10];
    [_v1 addSubview:_mailfield];
    _mailfield.delegate = self;
    //一条线
    UILabel *l3 = [[UILabel alloc]init];
    l3.frame = CGRectMake(40, 127, 115, 0.5);
    l3.backgroundColor = [UIColor blackColor];
    l3.alpha = 0.7;
    [_v1 addSubview:l3];
    
    //QQ
    _qqLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 20+30*3+5*3, 50, 35)];
    _qqLabel.text = @"QQ:";
    _qqLabel.font = [UIFont fontWithName:@"Arial" size:10];
    _qqLabel.textColor = [UIColor blackColor];
    [_v1 addSubview:_qqLabel];
    //输入QQ
    _qqfield = [[UITextField alloc]initWithFrame:CGRectMake(40, 20+30*3+5*3+3, 115, 30)];
    _qqfield.clearButtonMode = UITextFieldViewModeWhileEditing;
    _qqfield.textColor = [UIColor blackColor];
    _qqfield.font = [UIFont fontWithName:@"Arial" size:10];
    [_v1 addSubview:_qqfield];
    _qqfield.delegate = self;
    //一条线
    UILabel *l4 = [[UILabel alloc]init];
    l4.frame = CGRectMake(40, 150+2, 115, 0.5);
    l4.backgroundColor = [UIColor blackColor];
    l4.alpha = 0.7;
    [_v1 addSubview:l4];
    
    //微信
    _faxLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10+30*4+5*4, 50, 35)];
    _faxLabel.text = @"传真:";
    _faxLabel.font = [UIFont fontWithName:@"Arial" size:10];
    _faxLabel.textColor = [UIColor blackColor];
    [_v1 addSubview:_faxLabel];
    //输入微信
    _faxfield = [[UITextField alloc]initWithFrame:CGRectMake(40, 10+30*4+5*4+3, 115, 30)];
    _faxfield.clearButtonMode = UITextFieldViewModeWhileEditing;
    _faxfield.textColor = [UIColor blackColor];
    _faxfield.font = [UIFont fontWithName:@"Arial" size:10];
    _faxfield.delegate = self;
    [_v1 addSubview:_faxfield];
    //一条线
    UILabel *l5 = [[UILabel alloc]init];
    l5.frame = CGRectMake(40, 177, 115, 0.5);
    l5.backgroundColor = [UIColor blackColor];
    l5.alpha = 0.7;
    [_v1 addSubview:l5];
    self.imgView = [[UIImageView alloc]init];
    self.imgView.frame = CGRectMake(175,65,10+30*4+5*4+3-35,10+30*4+5*4+3-35);
    //    self.imageBtn.frame = CGRectMake(167,25,155,10+30*4+5*4+3-30);
    self.imgView.layer.cornerRadius = self.imgView.frame.size.height/2;
    self.imgView.layer.masksToBounds = YES;
    self.imgView.backgroundColor = [UIColor colorWithRed:0.804 green:0.859 blue:0.910 alpha:1.00];
    [_v1 addSubview:self.imgView];
    
    self.Bili = [UIScreen mainScreen].bounds.size.width/([UIScreen mainScreen].bounds.size.width-40);
    
    //背面
    //公司名称
    _companyfield = [[UITextField alloc]initWithFrame:CGRectMake(100, 200, 270, 80)];
    _companyfield.clearButtonMode = UITextFieldViewModeWhileEditing;
    _companyfield.textColor = [UIColor blackColor];
    _companyfield.center =CGPointMake(335/2+10, 100);
    _companyfield.font = [UIFont fontWithName:@"Arial" size:30];
    _companyfield.placeholder = @"所在公司";
    [_companyfield setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [_companyfield setValue:[UIFont boldSystemFontOfSize:30]      forKeyPath:@"_placeholderLabel.font"];
    _companyfield.delegate = self;
    [_v2 addSubview:_companyfield];
    //一条线
    UILabel *l6 = [[UILabel alloc]init];
    l6.frame = CGRectMake(100, 244, 251, 5);
    l6.center = CGPointMake(335/2, 100+28);
    l6.backgroundColor = [UIColor colorWithRed:0.000 green:0.000 blue:0.000 alpha:1.00];
    l6.alpha = 0.7;
    [_v2 addSubview:l6];
    User1 *person = [User1 shareUser];
    NSFetchRequest * request1 = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([User class])];
    NSError * error1 = nil;
    NSArray * array1 = [self.managedObjectContext executeFetchRequest:request1 error:&error1];
    NSLog(@"arr is %@",array1);
    for (User *user in array1) {
        if ([user.id isEqualToString:person.id]) {
            _namefield.text = user.name;
            _phonefield.text = user.id;
            _mailfield.text = user.email;
            //            _qqfield.text = user.qq;
            _faxfield.text = user.fax;
            _imgView.image = user.pic;
        }
        
    }
    
}
//点击卡片正面v1
-(void)tabV1{
    if(self.v1.frame.size.width != self.view.bounds.size.width){
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            //平移到主视图中间
            self.v1.center = CGPointMake(self.view.center.x, self.view.center.y-60);
            self.v1.transform = CGAffineTransformMakeScale(self.Bili, self.Bili);
            _v2.hidden = YES;
            _label1.hidden = YES;
            _label2.hidden = YES;
        } completion:nil];
        //
    }
    else  {
        //缩小
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            self.v1.transform = CGAffineTransformMakeScale(1, 1);
            self.v1.center = CGPointMake(20+335/2, (667/2)-180);
        } completion:nil];
        _v2.hidden = NO;
        _label1.hidden = NO;
        _label2.hidden = NO;
        [self.view endEditing:YES];
    }
}

//点击卡片正面v2
-(void)tabV2{
    if(self.v2.frame.size.width != self.view.bounds.size.width){
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            //平移到主视图中间
            self.v2.center = CGPointMake(self.view.center.x, self.view.center.y-60);
            self.v2.transform = CGAffineTransformMakeScale(self.Bili, self.Bili);
            _v1.hidden = YES;
            _label1.hidden = YES;
            _label2.hidden = YES;
        } completion:nil];
    }
    else  {
        //缩小
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            self.v2.transform = CGAffineTransformMakeScale(1, 1);
            self.v2.center = CGPointMake(20+335/2, 667-250);
        } completion:nil];
        _v1.hidden = NO;
        _label1.hidden = NO;
        _label2.hidden = NO;
        [self.view endEditing:YES];
    }
}
#pragma mark - textFieldDelegate
//点击空白处结束编辑状态
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    //缩小
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.v1.transform = CGAffineTransformMakeScale(1, 1);
        self.v1.center = CGPointMake(20+335/2, (667/2)-180);
        _v2.hidden = NO;
        _label1.hidden = YES;
        _label2.hidden = YES;
    } completion:nil];
    
    //缩小
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.v2.transform = CGAffineTransformMakeScale(1, 1);
        self.v2.center = CGPointMake(20+335/2, 667-250);
        _v1.hidden = NO;
        _label1.hidden = NO;
        _label2.hidden = NO;
    } completion:nil];
    
}
//开始编辑
- (void)textFieldDidBegEditing:(UITextField *)textField{
    _companyfield.placeholder = @"";
}
//结束编辑
-(void)textFieldDidEndEditing:(UITextField *)textField{
    
}
//点击Return键（标志着编辑已经结束了）
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

//判断是否是数字，不是的话输入失败
//-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
////    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:kal]];
//}



/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
