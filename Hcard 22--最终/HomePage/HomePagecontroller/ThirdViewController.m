//
//  ThirdViewController.m
//  第二页
//
//  Created by ChenJS on 16/5/30.
//  Copyright © 2016年 zhiyuan3g. All rights reserved.
//

#import "ThirdViewController.h"
#import "Person.h"
#import "Group.h"
#import "Pinyin.h"
#import "User.h"
#import "Note.h"
#import "FirstViewController.h"

@interface ThirdViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,NSFetchedResultsControllerDelegate>
//声明一个照片选择器
@property (strong,nonatomic)UIImagePickerController *pickerController;
//声明一个照片二进制数据
@property (strong,nonatomic)NSData *data;
//声明一个上下文
@property (strong,nonatomic)NSManagedObjectContext *managedObjectContext;
@property (strong,nonatomic)NSFetchedResultsController *frc;
//声明一个Person实体对象 用来接收传值
@property (strong,nonatomic)Person *person;
//用户分组归属
@property (strong,nonatomic)Group *myGroup;
//当前的用户
@property (strong,nonatomic)User *localUser;
//声明一个IndexPath
@property (strong,nonatomic)NSIndexPath *indexPath;

-(NSString *)pinYinAll:(NSString *)str;

@end

@implementation ThirdViewController
-(void)viewWillAppear:(BOOL)animated{
    //判断IndexPath
    if (_indexPath) {
        //接受值
        [self jieshou];
        [self.save setHidden:NO];
    }else{
        [self.save setHidden:YES];

    }
    if (self.navigationController.navigationBar.hidden) {
        self.navigationController.navigationBar.hidden = NO;
    }
    if (self.navigationController.toolbar.hidden) {
        [self.navigationController.toolbar setHidden:YES];
    }
    
}
//点击cell的跳转时 在这里接收值
-(void)jieshou{
    self.name.text = self.person.name;
    self.tele.text = self.person.tele;
    self.post.text = self.person.post;
    self.company.text = self.person.company;
    self.address.text = self.person.companyAddress;
    self.eMail.text = self.person.email;
    self.standByTel.text = self.person.standByTel;
    self.fax.text = self.person.fax;
    
    UIImage *image = [UIImage imageWithData:self.person.pic];
    // 设备button背景图
    [self.imageBtn setBackgroundImage:image forState:UIControlStateNormal];
    //如果没有选择新的照片 则data为原本的data
    _data = self.person.pic;
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    

    
    //通过UIApplication的代理获得上下文
    UIApplication *application  = [UIApplication sharedApplication];
    id delelgate = application.delegate;
    self.managedObjectContext = [delelgate managedObjectContext];
    
    [self setNavigationBtn];
    
    [self createPicker];
    
}
//设置navigationbar上的rightbutton
-(void)setNavigationBtn{
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle:@"OK" style:UIBarButtonItemStyleDone target:self action:@selector(addPeople)];
    self.navigationItem.rightBarButtonItem = button;
    
}
-(void)buNengWeiKong:(NSString *)str{
    //弹出视图显示姓名不能为空
    NSString *str2= [NSString stringWithFormat:@"%@ 内容不能为空",str];
    UIAlertController * alertName = [UIAlertController alertControllerWithTitle:@"警告" message:str2 preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction * ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertName addAction:ok];
    
}
//获取汉字的所有拼音
-(NSString *)pinYinAll:(NSString *)str{
    //系统自带方法
    NSMutableString *mStr = [[NSMutableString alloc] initWithString:str];
    //转换为带声调的拼音
    if (CFStringTransform((__bridge  CFMutableStringRef)mStr, 0, kCFStringTransformMandarinLatin, NO)) {
        //   NSLog(@"pinyin:%@",mStr);
    }
    //转换为不带声调的拼音
    if (CFStringTransform((__bridge CFMutableStringRef)mStr, 0, kCFStringTransformStripDiacritics, NO)) {
    }
    return mStr;
}
//coredate的添加方法
-(void)addPeople{
    NSLog(@"添加联系人");
    //获取Person实体对象
    if (!self.person) {
        self.person = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Person class]) inManagedObjectContext:self.managedObjectContext];
    }
    //给Person赋值
    self.person.name = self.name.text;
    if ([self.person.name length]>0) {
        self.person.nameTitle = [[NSString stringWithFormat:@"%c",pinyinFirstLetter([self.person.name characterAtIndex:0])] uppercaseString];
    }else{
        self.person.nameTitle = @"#";
    }
    
    self.person.tele = self.tele.text;
    self.person.company = self.company.text;
    self.person.email = self.eMail.text;
    self.person.post = self.post.text;
    self.person.standByTel = self.standByTel.text;
    
    //    self.person.insterest = self.interest.text;
    //    self.person.school = self.school.text;
    //添加时间
    NSDate *date = [NSDate date];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    [df setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    NSString *str = [df stringFromDate:date];
    self.person.date = str;
    
    self.person.fax = self.fax.text;
    self.person.companyAddress = self.address.text;
    self.person.pic = _data;
    
    
    //系统自带方法
    if ([self.person.name length]>0) {
        self.person.nameAll = [self pinYinAll:self.person.name];
    }
    if ([self.person.company length]>0) {
        self.person.companyAll = [self pinYinAll:self.person.company];
    }
    //设置分组
    Group *morenGroup = [self currentGroup];
    int temp = [morenGroup.number intValue] + 1;
    morenGroup.number = [NSNumber numberWithInt:temp];
    self.person.group = morenGroup;
    //设置用户归属
    self.localUser = [self currentUser];
    if (self.localUser != nil) {
        self.person.user = self.localUser;
        morenGroup.user = self.localUser;
        
    }else{
        NSLog(@"未登录 - 添加联系人");
    }
    //创建联系人的时候添加一个备注标注联系人添加时间
    [self addNote:@"保存时间" Person:self.person];
    
    //通过上下文保存数据
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"2 === %@",[error localizedFailureReason]);
    }
    //完成之后跳转
    [self.navigationController popViewControllerAnimated:YES];
    
}
//添加备注的方法
-(void)addNote:(NSString *)str Person:(Person *)person{
    //创建一个备注
    Note *newNote;
    if (!newNote) {
        newNote = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Note class]) inManagedObjectContext:self.managedObjectContext];
    }
    //赋值
    NSDate *date = [NSDate date];
    NSDateFormatter *df2 = [[NSDateFormatter alloc] init];
    [df2 setDateFormat:@"yyyy/MM/dd HH:mm"];
    [df2 setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    NSString *strNote = [df2 stringFromDate:date];
    
    newNote.date = strNote;
    newNote.message = str;
    newNote.person = person;
    //通过上下文保存数据
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"2 === %@",[error localizedFailureReason]);
    }
    
}
//获取默认分组
-(Group *)currentGroup{
    
    //取出userdefaults中存储的id
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *groupName = [userDefaults objectForKey:@"groupName"];
    //获取context
    id appDelegate = [[UIApplication sharedApplication] delegate];
    self.managedObjectContext = [appDelegate managedObjectContext];
    
    //创建检索对象
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([Group class])];
    //添加删选条件
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name = %@",groupName];
    [request setPredicate:predicate];
    //使用context执行检索
    NSError *error = nil;
    //array是结果集
    NSArray*array = [self.managedObjectContext executeFetchRequest:request error:&error];
    if ([array count]>0) {
        Group *localGroup = array[0];
        return localGroup;
    }else{
        return nil;
    }
}

-(User *)currentUser{
    
    //取出userdefaults中存储的id
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *userID = [userDefaults objectForKey:@"id"];
    //获取context
    id appDelegate = [[UIApplication sharedApplication] delegate];
    self.managedObjectContext = [appDelegate managedObjectContext];
    
    //创建检索对象
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([User class])];
    //添加删选条件
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id = %@",userID];
    [request setPredicate:predicate];
    //使用context执行检索
    NSError *error = nil;
    //array是结果集
    NSArray*array = [self.managedObjectContext executeFetchRequest:request error:&error];
    if ([array count]>0) {
        
        User*user = array[0];
        return user;
    }else{
        return nil;
    }
}
//===============================================选取照片
//这里进行照片设置
-(void)createPicker{
    if (![_imageBtn backgroundImageForState:UIControlStateNormal]) {
        [self.imageBtn setBackgroundImage:[UIImage imageNamed:@"search_mic"] forState:UIControlStateNormal];    //默认图片
    }
    //首先实例化一个UIPickerview
    _pickerController = [[UIImagePickerController alloc] init];
    //开启图片编辑模式
    _pickerController.allowsEditing = YES;
    //设置代理
    _pickerController.delegate = self;
    //设置默认图片
    _pickerController.view.backgroundColor = [UIColor grayColor];
}

- (void)setHeaderImage{
    //制作一个sheet
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"select Image" message:@"from" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"library" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //指定数据源 并跳转
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            _pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            //跳转
            [self presentViewController:_pickerController animated:YES completion:nil];
        }else{
            NSLog(@"library is not support");
        }
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //设置数据源 并跳转
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            _pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            //跳转
            [self presentViewController:_pickerController animated:YES completion:nil];
        }else{
            NSLog(@"camera is not support");
        }
    }];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"album" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //设置数据源 并跳转
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
            _pickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            //跳转
            [self presentViewController:_pickerController animated:YES completion:nil];
        }else{
            NSLog(@"album is not support");
        }
    }];
    UIAlertAction *action4 = [UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        //设置数据源 并跳转
        NSLog(@"you touch cancel");
    }];
    UIAlertAction *action5 = [UIAlertAction actionWithTitle:@"delelte" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        //返回默认图片
        [self.imageBtn setBackgroundImage:[UIImage imageNamed:@"search_mic"] forState:UIControlStateNormal];
        //初始化data
        self.data = UIImagePNGRepresentation([UIImage imageNamed:@"search_mic"]);
    }];
    
    [alert addAction:action1];
    [alert addAction:action2];
    [alert addAction:action3];
    [alert addAction:action4];
    if ([_imageBtn backgroundImageForState:UIControlStateNormal]&&self.person.pic!= UIImagePNGRepresentation([UIImage imageNamed:@"search_mic"])) {
        [alert addAction:action5];
    }
    
    //弹出sheet
    [self presentViewController:alert animated:YES completion:nil];
}
//选取完成后
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    //跳转到选取之前的页面
    [self dismissViewControllerAnimated:YES completion:nil ];
    //将照片设置为UIImagePickerControllerEditedImage
    UIImage * tempImage = info[@"UIImagePickerControllerEditedImage"];
    [_imageBtn setBackgroundImage:tempImage forState:UIControlStateNormal];
    //选取完成之后将照片转为二进制赋给data
    _data = UIImagePNGRepresentation(tempImage);
    
}

- (IBAction)setImage:(UIButton *)sender {
    [self setHeaderImage];
}

//删除按钮
- (IBAction)save:(id)sender {
    //通过上下文移除实体
    [self.managedObjectContext deleteObject:self.person];
    //保存
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"1====%@",[error localizedDescription]);
    }
//跳转
    FirstViewController *first = [[FirstViewController alloc] init];
    [self.navigationController popToViewController:first animated:YES];
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
