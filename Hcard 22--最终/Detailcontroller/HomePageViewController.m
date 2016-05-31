//
//  HomePageViewController.m
//  详情页demo
//
//  Created by 黄传家 on 16/4/27.
//  Copyright © 2016年 黄传家. All rights reserved.
//

#import "HomePageViewController.h"
#import "SecondViewController1.h"
#import "MyAdvViewController.h"
#import "AboutViewController.h"
#import "SetViewController.h"
#import "GXQMViewController.h"
#import "CardViewController.h"
#import "TwoDimensionCodeViewController.h"
#import "User1.h"
#import "User.h"
#import "UserCard.h"
@interface HomePageViewController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property (strong,nonatomic)UIPageControl *pageControl;

@property (strong,nonatomic)UIScrollView *scrollview;

@property (strong,nonatomic)UIButton *view1;

@property (strong,nonatomic)UIButton *view2;

@property (strong,nonatomic)UIButton *view3;

@property (strong,nonatomic)UITableView *tableView;

@property (strong,nonatomic)NSArray *array;

@property (strong,nonatomic)UIButton *imgView;

@property (strong,nonatomic)UILabel *nameLabel;

@property (strong,nonatomic)NSManagedObjectContext *managedObjectContext;

@property (strong,nonatomic)NSTimer *timer;


@property(strong,nonatomic)UILabel *naLabel;
@property(strong,nonatomic)UITextField * namefield;
@property(strong,nonatomic)UILabel *phoneLabel;
@property(strong,nonatomic)UITextField * phonefield;
@property(strong,nonatomic)UILabel *mailLabel;
@property(strong,nonatomic)UITextField * mailfield;
@property(strong,nonatomic)UILabel *qqLabel;
@property(strong,nonatomic)UITextField * qqfield;
@property(strong,nonatomic)UILabel *faxLabel;
@property(strong,nonatomic)UITextField * faxfield;
@property(strong,nonatomic)UITextField * companyfield;
@property(strong,nonatomic)UITextField * loadfield;
@property(strong,nonatomic)UILabel *label1;
@property(strong,nonatomic)UILabel *label2;
@property(strong,nonatomic)UIButton *imgV;
@end

@implementation HomePageViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    id appDelegate = [[UIApplication sharedApplication] delegate];
    self.managedObjectContext = [appDelegate managedObjectContext];
    User1 *person1 = [User1 shareUser];
    NSFetchRequest * request = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([User class])];
    NSError * error = nil;
    NSArray * array = [self.managedObjectContext executeFetchRequest:request error:&error];
    for (User *us in array) {
        if ([us.id isEqualToString:person1.id]) {
            self.nameLabel.text = us.name;
            [self.imgView setImage:us.pic forState:UIControlStateNormal];
        }
    }
    NSFetchRequest * request1 = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([UserCard class])];
    NSError * error1 = nil;
    NSArray * array1 = [self.managedObjectContext executeFetchRequest:request1 error:&error1];
    for (UserCard *userC in array1) {
        if ([userC.cardID isEqualToString:person1.id]) {
            [self.view1 setImage:userC.card forState:UIControlStateNormal];
            [self.view2 setImage:userC.card forState:UIControlStateNormal];
            [self.view3 setImage:userC.card forState:UIControlStateNormal];
        }
    }

}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView * bgimgView = [[UIImageView alloc]init];
    bgimgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    [self.view addSubview:bgimgView];
    UIImage * bgimg = [UIImage imageNamed:@"sign"];
    bgimgView.userInteractionEnabled= YES;//打开关联开关，允许控件正常使用
    bgimgView.image = bgimg;
    
    // Do any additional setup after loading the view.
    [self creatUI];
}
-(void)creatUI{
    
    
    [self.navigationController.navigationBar setTranslucent:NO];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.scrollview=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 200)];
    self.scrollview.contentSize=CGSizeMake([UIScreen mainScreen].bounds.size.width*3, 150);
    
    self.scrollview.showsHorizontalScrollIndicator = NO;
    
    self.scrollview.showsVerticalScrollIndicator = NO;
    
    self.scrollview.pagingEnabled = YES;
    
    self.scrollview.bounces = NO;
    
    self.scrollview.delegate = self;
    
    [self.view addSubview:self.scrollview];
    //    显示的内容的宽高
    self.view1 = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.scrollview.frame.size.width, self.scrollview.bounds.size.height)];
    
    [self.scrollview addSubview:self.view1];
    self.view2 = [[UIButton alloc]initWithFrame:CGRectMake(self.scrollview.frame.size.width, 0, self.scrollview.frame.size.width, self.scrollview.bounds.size.height)];
    
    [self.scrollview addSubview:self.view2];
    self.view3 = [[UIButton alloc]initWithFrame:CGRectMake(self.scrollview.frame.size.width*2, 0, self.scrollview.frame.size.width, self.scrollview.bounds.size.height)];
    [self.scrollview addSubview:self.view3];
    //姓名标题
    _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10+20, 50-20, 50, 35)];
    _nameLabel.text = @"姓名:";
    _nameLabel.textColor = [UIColor blackColor];
    _nameLabel.font = [UIFont fontWithName:@"Arial" size:10];
    [self.view1 addSubview:_nameLabel];
    [self.view3 addSubview:_nameLabel];
    //输入姓名
    _namefield = [[UITextField alloc]initWithFrame:CGRectMake(40+20, 53-20, 115, 30)];
    _namefield.clearButtonMode = UITextFieldViewModeWhileEditing;
    _namefield.textColor = [UIColor blackColor];
    _namefield.font = [UIFont fontWithName:@"Arial" size:10];
    [self.view1 addSubview:_namefield];
    [self.view3 addSubview:_namefield];
    _namefield.delegate = self;
    //一条线
    UILabel *l1 = [[UILabel alloc]init];
    l1.frame = CGRectMake(40+20, 76-20, 115, 0.5);
    l1.backgroundColor = [UIColor blackColor];
    l1.alpha = 0.7;
    [self.view1 addSubview:l1];
    [self.view3 addSubview:l1];
    
    //手机号
    _phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(10+20, 40+30+5-20, 50, 35)];
    _phoneLabel.text = @"手机:";
    _phoneLabel.textColor = [UIColor blackColor];
    _phoneLabel.font = [UIFont fontWithName:@"Arial" size:10];
    [self.view1 addSubview:_phoneLabel];
    [self.view3 addSubview:_phoneLabel];
    //输入手机号
    _phonefield = [[UITextField alloc]initWithFrame:CGRectMake(40+20, 40+30+8-20, 115, 30)];
    _phonefield.font = [UIFont fontWithName:@"Arial" size:10];
    _phonefield.clearButtonMode = UITextFieldViewModeWhileEditing;
    _phonefield.textColor = [UIColor blackColor];
    [self.view1 addSubview:_phonefield];
    [self.view3 addSubview:_phonefield];

    _phonefield.delegate = self;
    //一条线
    UILabel *l2 = [[UILabel alloc]init];
    l2.frame = CGRectMake(40+20, 100+2-20, 115, 0.5);
    l2.backgroundColor = [UIColor blackColor];
    l2.alpha = 0.7;
    [self.view1 addSubview:l2];
    [self.view3 addSubview:l2];
    
    //邮箱-13180038869@163.com
    _mailLabel = [[UILabel alloc]initWithFrame:CGRectMake(10+20, 30+30*2+5*2-20, 50, 35)];
    _mailLabel.text = @"邮箱:";
    _mailLabel.textColor = [UIColor blackColor];
    _mailLabel.font = [UIFont fontWithName:@"Arial" size:10];
    [self.view1 addSubview:_mailLabel];
    [self.view3 addSubview:_mailLabel];
    //输入邮箱
    _mailfield = [[UITextField alloc]initWithFrame:CGRectMake(40+20, 30+30*2+5*2+3-20, 115, 30)];
    _mailfield.clearButtonMode = UITextFieldViewModeWhileEditing;
    _mailfield.textColor = [UIColor blackColor];
    _mailfield.font = [UIFont fontWithName:@"Arial" size:10];
    [self.view1 addSubview:_mailfield];
    [self.view3 addSubview:_mailfield];
    _mailfield.delegate = self;
    //一条线
    UILabel *l3 = [[UILabel alloc]init];
    l3.frame = CGRectMake(40+20, 127-20, 115, 0.5);
    l3.backgroundColor = [UIColor blackColor];
    l3.alpha = 0.7;
    [self.view1 addSubview:l3];
    [self.view3 addSubview:l3];
    
    //QQ
    _qqLabel = [[UILabel alloc]initWithFrame:CGRectMake(10+20, 20+30*3+5*3-20, 50, 35)];
    _qqLabel.text = @"QQ:";
    _qqLabel.font = [UIFont fontWithName:@"Arial" size:10];
    _qqLabel.textColor = [UIColor blackColor];
    [self.view1 addSubview:_qqLabel];
    [self.view3 addSubview:_qqLabel];
    //输入QQ
    _qqfield = [[UITextField alloc]initWithFrame:CGRectMake(40+20, 20+30*3+5*3+3-20, 115, 30)];
    _qqfield.clearButtonMode = UITextFieldViewModeWhileEditing;
    _qqfield.textColor = [UIColor blackColor];
    _qqfield.font = [UIFont fontWithName:@"Arial" size:10];
    [self.view1 addSubview:_qqfield];
    [self.view3 addSubview:_qqfield];
    _qqfield.delegate = self;
    //一条线
    UILabel *l4 = [[UILabel alloc]init];
    l4.frame = CGRectMake(40+20, 150+2-20, 115, 0.5);
    l4.backgroundColor = [UIColor blackColor];
    l4.alpha = 0.7;
    [self.view1 addSubview:l4];
    [self.view3 addSubview:l4];
    
    //微信
    _faxLabel = [[UILabel alloc]initWithFrame:CGRectMake(10+20, 10+30*4+5*4-20, 50, 35)];
    _faxLabel.text = @"传真:";
    _faxLabel.font = [UIFont fontWithName:@"Arial" size:10];
    _faxLabel.textColor = [UIColor blackColor];
    [self.view1 addSubview:_faxLabel];
    [self.view3 addSubview:_faxLabel];
    //输入微信
    _faxfield = [[UITextField alloc]initWithFrame:CGRectMake(40+20, 10+30*4+5*4+3-20, 115, 30)];
    _faxfield.clearButtonMode = UITextFieldViewModeWhileEditing;
    _faxfield.textColor = [UIColor blackColor];
    _faxfield.font = [UIFont fontWithName:@"Arial" size:10];
    _faxfield.delegate = self;
    [self.view1 addSubview:_faxfield];
    [self.view3 addSubview:_faxfield];
    //一条线
    UILabel *l5 = [[UILabel alloc]init];
    l5.frame = CGRectMake(40+20, 177-20, 115, 0.5);
    l5.backgroundColor = [UIColor blackColor];
    l5.alpha = 0.7;
    [self.view1 addSubview:l5];
    [self.view3 addSubview:l5];
    self.imgV = [[UIButton alloc]initWithFrame:CGRectMake(175+20,65-20,10+30*4+5*4+3-35,10+30*4+5*4+3-35)];
//    self.imgV.frame = CGRectMake(175+20,65-20,10+30*4+5*4+3-35,10+30*4+5*4+3-35);
    //    self.imageBtn.frame = CGRectMake(167,25,155,10+30*4+5*4+3-30);
    self.imgV.layer.cornerRadius = self.imgV.frame.size.height/2;
    self.imgV.layer.masksToBounds = YES;
    self.imgV.backgroundColor = [UIColor colorWithRed:0.804 green:0.859 blue:0.910 alpha:1.00];
    [self.view1 addSubview:self.imgV];
    [self.view3 addSubview:self.imgV];
    
    
    //背面
    //公司名称
    _companyfield = [[UITextField alloc]initWithFrame:CGRectMake(100+20, 200-20, 270, 80)];
    _companyfield.clearButtonMode = UITextFieldViewModeWhileEditing;
    _companyfield.textColor = [UIColor blackColor];
    _companyfield.center =CGPointMake(335/2+10+20, 100-20);
    _companyfield.font = [UIFont fontWithName:@"Arial" size:30];
    _companyfield.placeholder = @"所在公司";
    [_companyfield setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [_companyfield setValue:[UIFont boldSystemFontOfSize:30]      forKeyPath:@"_placeholderLabel.font"];
    _companyfield.delegate = self;
    [self.view2 addSubview:_companyfield];
    //一条线
    UILabel *l6 = [[UILabel alloc]init];
    l6.frame = CGRectMake(100, 244, 251, 5);
    l6.center = CGPointMake(335/2+20, 100+28-20);
    l6.backgroundColor = [UIColor colorWithRed:0.000 green:0.000 blue:0.000 alpha:1.00];
    l6.alpha = 0.7;
    [self.view2 addSubview:l6];
//    User1 *person = [User1 shareUser];
//    NSFetchRequest * request1 = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([User class])];
//    NSError * error1 = nil;
//    NSArray * array1 = [self.managedObjectContext executeFetchRequest:request1 error:&error1];
//    NSLog(@"arr is %@",array1);
//    for (User *user in array1) {
//        if ([user.id isEqualToString:person.id]) {
//            
//        }
//        
//    }

    self.scrollview.backgroundColor = [UIColor redColor];
//    self.scrollview.
    self.pageControl=[[UIPageControl alloc]initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width/4), self.scrollview.frame.size.height - 30 , 200, 30)];
    //    self.pageControl.backgroundColor=[UIColor redColor];
    //    设置页数
    self.pageControl.numberOfPages=2;
    self.pageControl.currentPage=0;
    [self.view addSubview:self.pageControl];
    [self.pageControl addTarget:self action:@selector(hcj:) forControlEvents:UIControlEventValueChanged];
    
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(scrollviewtime) userInfo:nil repeats:YES];
    [self.timer fire];
    //    NSTimer *timer = [[NSTimer alloc]init];
    self.imgView = [[UIButton alloc]initWithFrame:CGRectMake(20, 180, 100, 100)];
    User1 *person1 = [User1 shareUser];
    NSFetchRequest * request = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([User class])];
    NSError * error = nil;
    NSArray * array = [self.managedObjectContext executeFetchRequest:request error:&error];
    for (User *us in array) {
        if ([us.id isEqualToString:person1.id]) {
            self.nameLabel.text = us.name;
            [self.imgView setImage:us.pic forState:UIControlStateNormal];
            _namefield.text = us.name;
            _phonefield.text = us.id;
            _mailfield.text = us.email;
            _faxfield.text = us.fax;
            [self.imgV setImage:us.pic forState:UIControlStateNormal];
        }
    }

    
//    [self.imgView setBackgroundImage:[UIImage imageNamed:@"234A7833"] forState:UIControlStateNormal];
    self.imgView.layer.masksToBounds = YES;
    self.imgView.layer.cornerRadius = 50;
    [self.view addSubview:self.imgView];
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(125, 220, [UIScreen mainScreen].bounds.size.width-80, 40)];
   
    self.nameLabel.textColor = [UIColor blueColor];
    [self.view addSubview:self.nameLabel];
    
    id appDelegate = [[UIApplication sharedApplication] delegate];
    self.managedObjectContext = [appDelegate managedObjectContext];
    User1 *person2 = [User1 shareUser];
    NSFetchRequest * request2 = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([UserCard class])];
    NSError * error2 = nil;
    NSArray * array2 = [self.managedObjectContext executeFetchRequest:request2 error:&error2];
    for (UserCard *userC in array2) {
        if ([userC.cardID isEqualToString:person2.id]) {
            [self.view1 setImage:userC.card forState:UIControlStateNormal];
            [self.view2 setImage:userC.card forState:UIControlStateNormal];
            [self.view3 setImage:userC.card forState:UIControlStateNormal];
        }
    }
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 290, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-360)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.array = [[NSArray alloc]init];
    self.array = @[@"个性签名",@"编辑资料",@"名片设计",@"我的广告",@"设置"];
}
-(void)scrollviewtime{
    int current = self.scrollview.contentOffset.x/self.scrollview.frame.size.width;
    
    if (current<=1) {
        [self.scrollview setContentOffset:CGPointMake(self.scrollview.contentOffset.x+self.scrollview.frame.size.width, 0) animated:YES];
    }else{
    [self.scrollview setContentOffset:CGPointMake(0, 0) animated:NO];
        [self.timer fire];
    }
    if (current == 2) {
        self.pageControl.currentPage = 0;
    }
    else{
        self.pageControl.currentPage = current;
    }
    
//    self.pageControl.currentPage=current;
}
-(void)hcj:(UIPageControl *)sender{
    //scorllView 大小
    CGSize viewSize = self.scrollview.frame.size;
    //大小和位置
    CGRect rect = CGRectMake(sender.currentPage * viewSize.width, 0, viewSize.width, viewSize.height);
    [self.scrollview scrollRectToVisible:rect animated:YES];
}


//滑动动作结束减速动作时调用
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //    纪录scrollView 的当前位子，因为已经设置了分页效果，所以：位子／屏幕大小＝第几页
    //    scrollView.contentOffset 当前内容的位置
    int current=scrollView.contentOffset.x/scrollView.frame.size.width;
    //    把计算出来的当前页给pageControl
    self.pageControl.currentPage=current;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.array.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"cellID";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    cell.textLabel.text = self.array[indexPath.row];
        cell.accessoryType =UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.row ==0) {
        NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
        NSString *str = [userdefaults objectForKey:@"gxqm"];

        cell.detailTextLabel.text = str;
    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *VC = nil;
       switch (indexPath.row) {
        case 0:
            VC = [[GXQMViewController alloc]init];
            break;
        case 1:
            VC = [[SecondViewController1 alloc]init];
            break;
            break;
        case 2:
            VC = [[CardViewController alloc]init];
            break;
        case 3:
            VC = [[MyAdvViewController alloc]init];
            break;
        case 4:
            VC = [[SetViewController alloc]init];
            break;
            
        default:
            break;
    }
    [self.navigationController pushViewController:VC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - textFieldDelegate
//点击空白处结束编辑状态
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
