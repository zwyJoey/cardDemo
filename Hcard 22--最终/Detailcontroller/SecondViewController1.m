//
//  SecondViewController.m
//  cardCase
//
//  Created by ChenJS on 16/4/29.
//  Copyright © 2016年 zhiyuan3g. All rights reserved.
//

#import "SecondViewController1.h"
#import "User1.h"

@interface SecondViewController1 ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (strong,nonatomic)UIImagePickerController *pickerController;
//声明一个照片二进制数据

//声明一个上下文
@property (strong,nonatomic)NSManagedObjectContext *managedObjectContext;

@property (strong,nonatomic)UIImage *image;

@property (strong,nonatomic)NSArray *array;

@property (strong,nonatomic)NSMutableArray *arr1;
@end

@implementation SecondViewController1
-(void)viewWillAppear:(BOOL)animated{
   
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"编辑个人资料";
    self.arr1 = [NSMutableArray array];
    id appDelegete = [[UIApplication sharedApplication]delegate];
    self.managedObjectContext = [appDelegete managedObjectContext];
    
    NSFetchRequest * request = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([User class])];
    NSError * error = nil;
    self.array = [self.managedObjectContext executeFetchRequest:request error:&error];
    //创造视图
    [self creatView];
 
}

-(void)creatView{
    //添加navigationBarButton
//    [self setNavigationBtn];
    

        UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle:@"OK" style:UIBarButtonItemStyleDone target:self action:@selector(buttonTap)];
        self.navigationItem.rightBarButtonItem = button;
    self.view.backgroundColor = [UIColor grayColor];
    //头像
    _imageBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 10, 100, 100)];
    _imageBtn.backgroundColor = [UIColor whiteColor];
    _imageBtn.layer.masksToBounds = YES;
    _imageBtn.layer.cornerRadius = 50;
     [_imageBtn.layer setBorderWidth:1.0]; //边框宽度
    [self.view addSubview:_imageBtn];
    [_imageBtn addTarget:self action:@selector(setImage) forControlEvents:UIControlEventTouchUpInside];
    //照片选择器
    [self createPicker];
    //姓名
    _name = [[UITextField alloc] initWithFrame:CGRectMake(130, 40, 220, 30)];
    _name.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_name];
    
    //电话
    _tele = [[UITextField alloc] initWithFrame:CGRectMake(130, 85, 220, 30)];
    _tele.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_tele];
   
    
    //公司
    _company = [[UITextField alloc] initWithFrame:CGRectMake(30, 130, 320, 30)];
    _company.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_company];
    
    //公司地址
    _companyAddress = [[UITextField alloc] initWithFrame:CGRectMake(30, 175, 320, 30)];
    _companyAddress.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_companyAddress];
    
    //邮件
    _eMail = [[UITextField alloc] initWithFrame:CGRectMake(30, 220, 320, 30)];
    _eMail.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_eMail];
        //当前所在城市
    _city = [[UITextField alloc] initWithFrame:CGRectMake(30, 265, 320, 30)];
    _city.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_city];
    
    //职位
    _post = [[UITextField alloc] initWithFrame:CGRectMake(30, 310, 320, 30)];
    _post.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_post];
        //兴趣
    _interest = [[UITextField alloc] initWithFrame:CGRectMake(30, 355, 320, 30)];
    _interest.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_interest];
    
    //传真 fax
    _fax = [[UITextField alloc] initWithFrame:CGRectMake(30, 400, 320, 30)];
    _fax.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_fax];
       //备用电话 standBy
    _standByTel = [[UITextField alloc] initWithFrame:CGRectMake(30, 445, 320, 30)];
    _standByTel.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_standByTel];
    //毕业院校
    _school = [[UITextField alloc] initWithFrame:CGRectMake(30, 490, 320, 30)];
    _school.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_school];
    User1 *user1 = [User1 shareUser];
    for (User *u in self.array) {
        if ([u.id isEqualToString:user1.id]) {
            self.name.text = u.name;
            self.tele.text = u.id;
            self.company.text = u.company;
            self.companyAddress.text = u.companyAddress;
            self.eMail.text = u.email;
            self.city.text = u.city;
            self.post.text = u.post;
            self.interest.text = u.insterest;
            self.fax.text = u.fax;
            self.standByTel.text = u.standByTel;
            self.school.text = u.school;
            [self.imageBtn setBackgroundImage:u.pic forState:UIControlStateNormal];
        }else{
            _name.placeholder = @"姓名*";
            _tele.placeholder = @"电话*";
            _company.placeholder = @"公司";
            _companyAddress.placeholder = @"公司地址";
            _eMail.placeholder = @"邮箱";
            _city.placeholder = @"当前城市";
            _post.placeholder = @"职位";
            _interest.placeholder = @"兴趣爱好";
            _fax.placeholder = @"传真";
            _standByTel.placeholder = @"备用电话";
            _school.placeholder = @"毕业院校";
        }
    }
    
}
-(void)buttonTap{
    User1 *person1 = [User1 shareUser];
    for (User * us in self.array) {
        if ([us.id isEqualToString:person1.id]) {
//            [self.person setValue:person1.id forKey:@"id"];
            [us setValue:self.name.text forKey:@"name"];
//            [us setValue:self.tele.text forKey:@"tele"];
            [us setValue:self.company.text forKey:@"company"];
            [us setValue:self.companyAddress.text forKey:@"companyAddress"];
            [us setValue:self.eMail.text forKey:@"email"];
            [us setValue:self.city.text forKey:@"city"];
            [us setValue:self.post.text forKey:@"post"];
            [us setValue:self.interest.text forKey:@"insterest"];
            [us setValue:self.fax.text forKey:@"fax"];
            [us setValue:self.standByTel.text forKey:@"standByTel"];
            [us setValue:self.school.text forKey:@"school"];
            [us setValue:self.image forKey:@"pic"];
        }
        
    }
    NSError *error1 = nil;
    [self.managedObjectContext save:&error1];
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark - 设置照片
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

- (void)setImage{
    //制作一个sheet
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"头像选择" message:@"请选择图片位置" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction * action1 = [UIAlertAction actionWithTitle:@"照相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // 判断设备是否支持相机模式
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            // 设置数据源为相机
            _pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            // 打开imagePicker
            [self presentViewController:_pickerController animated:YES completion:nil];
        }else{
            NSLog(@"相机不可用");
        }
    }];
    UIAlertAction * action2 = [UIAlertAction actionWithTitle:@"图库" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            // 设置数据源为图库
            _pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            // 打开imagePicker
            [self presentViewController:_pickerController animated:YES completion:nil];
        }else{
            NSLog(@"图库不可用");
        }
    }];
    UIAlertAction * action3 = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
            // 设置数据源为相册
            _pickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            // 打开imagePicker
            [self presentViewController:_pickerController animated:YES completion:nil];
        }else{
            NSLog(@"相册不可用");
        }
    }];
    UIAlertAction * action4 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction * action5 = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        // 删除真是数据
        // 删除button背景图
        [_imageBtn setBackgroundImage:nil forState:UIControlStateNormal];
        // 显示button title
        [_imageBtn setTitle:@"选择头像" forState:UIControlStateNormal];
    }];
    [alert addAction:action1];
    [alert addAction:action2];
    [alert addAction:action3];
    [alert addAction:action4];
    
    // 如果button有背景图，则显示该选项
    if ([_imageBtn backgroundImageForState:UIControlStateNormal]) {
        [alert addAction:action5];
    }
    // 打开actionSheet
    [self presentViewController:alert animated:YES completion:nil];
}
//选取完成后
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    self.image = info[@"UIImagePickerControllerEditedImage"];
    // 给button设置背景图
    [_imageBtn setBackgroundImage:self.image forState:UIControlStateNormal];
    // 取消button的title
    [_imageBtn setTitle:@"" forState:UIControlStateNormal];
    // imagePicker弹下去
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{

    // imagePicker弹下去
    [picker dismissViewControllerAnimated:YES completion:nil];
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
