//
//  MyViewController.m
//  详情页demo
//
//  Created by 黄传家 on 16/5/3.
//  Copyright © 2016年 黄传家. All rights reserved.
//

#import "MyViewController.h"
#import "MyAdvViewController.h"
#import "CustomeImagePicker.h"
#import "User1.h"
@interface MyViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,CustomeImagePickerDelegate>
@property (strong,nonatomic)NSMutableArray *mArray;
@property (strong,nonatomic)UITextField *contentTF;
@property (strong,nonatomic)UIButton *imgBtn1;
@property (strong,nonatomic)UIButton *imgBtn2;
@property (strong,nonatomic)UIButton *imgBtn3;
@property (strong,nonatomic)UIButton *imgBtn4;
@property (strong,nonatomic)UIButton *imgBtn5;
@property (strong,nonatomic)UIButton *imgBtn6;
@property (strong,nonatomic)UIButton *imgBtn7;
@property (strong,nonatomic)UIButton *imgBtn8;
@property (strong,nonatomic)UIButton *imgBtn9;
@property (strong,nonatomic)UIButton *saveBtn;
@property (strong,nonatomic)UIButton *backBtn1;
@property (strong,nonatomic)UIImagePickerController *imagePicker;
@property (strong,nonatomic)NSManagedObjectContext * managedObjectContext;


@end

@implementation MyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.contentTF = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 200)];
    
    self.contentTF.placeholder = @"广告内容";
    [self.view addSubview:self.contentTF];
    self.imgBtn1= [[UIButton alloc]initWithFrame:CGRectMake(5, 200, 100, 100)];
    [self.imgBtn1 setTitle:@"添加图片" forState:UIControlStateNormal];
    [self.imgBtn1 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.view addSubview:self.imgBtn1];
    [self.imgBtn1 addTarget:self action:@selector(imgBtntap) forControlEvents:UIControlEventTouchUpInside];
    
    self.imgBtn2 = [[UIButton alloc]initWithFrame:CGRectMake(120, 200, 100, 100)];
    
    [self.view addSubview:self.imgBtn2];
    [self.imgBtn2 addTarget:self action:@selector(imgBtntap) forControlEvents:UIControlEventTouchUpInside];
    
    self.imgBtn3 = [[UIButton alloc]initWithFrame:CGRectMake(235, 200, 100, 100)];
    
    [self.view addSubview:self.imgBtn3];
    [self.imgBtn3 addTarget:self action:@selector(imgBtntap) forControlEvents:UIControlEventTouchUpInside];
    
    self.imgBtn4 = [[UIButton alloc]initWithFrame:CGRectMake(5, 305, 100, 100)];
    
    [self.view addSubview:self.imgBtn4];
    [self.imgBtn4 addTarget:self action:@selector(imgBtntap) forControlEvents:UIControlEventTouchUpInside];
    
    self.imgBtn5 = [[UIButton alloc]initWithFrame:CGRectMake(120, 305, 100, 100)];
    
    [self.view addSubview:self.imgBtn5];
    [self.imgBtn5 addTarget:self action:@selector(imgBtntap) forControlEvents:UIControlEventTouchUpInside];
    
    self.imgBtn6 = [[UIButton alloc]initWithFrame:CGRectMake(235, 305, 100, 100)];
    
    [self.view addSubview:self.imgBtn6];
    [self.imgBtn6 addTarget:self action:@selector(imgBtntap) forControlEvents:UIControlEventTouchUpInside];
    
    self.imgBtn7 = [[UIButton alloc]initWithFrame:CGRectMake(5, 410, 100, 100)];
    
    [self.view addSubview:self.imgBtn7];
    [self.imgBtn7 addTarget:self action:@selector(imgBtntap) forControlEvents:UIControlEventTouchUpInside];
    
    self.imgBtn8 = [[UIButton alloc]initWithFrame:CGRectMake(120, 410, 100, 100)];
    
    [self.view addSubview:self.imgBtn8];
    [self.imgBtn8 addTarget:self action:@selector(imgBtntap) forControlEvents:UIControlEventTouchUpInside];
    
    self.imgBtn9 = [[UIButton alloc]initWithFrame:CGRectMake(235, 410, 100, 100)];
    
    [self.view addSubview:self.imgBtn9];
    [self.imgBtn9 addTarget:self action:@selector(imgBtntap) forControlEvents:UIControlEventTouchUpInside];
    
    self.saveBtn = [[UIButton alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-60, 0, 60, 40)];
    [self.saveBtn setTitle:@"完成" forState:UIControlStateNormal];
    [self.saveBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.view addSubview:self.saveBtn];
    [self.saveBtn addTarget:self action:@selector(saveBtntap) forControlEvents:UIControlEventTouchUpInside];
    // 获取context
    id appDelegate = [[UIApplication sharedApplication] delegate];
    self.managedObjectContext = [appDelegate managedObjectContext];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(saveBtntap)];
    self.navigationItem.rightBarButtonItem = item;
    // 实例化imagePicker
    _imagePicker = [[UIImagePickerController alloc] init];
    // 指定数据源 图库
    //    _imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    // 开启图片编辑模式
    _imagePicker.allowsEditing = YES;
    // 设置代理
    _imagePicker.delegate = self;
    // 设置背景色
    _imagePicker.view.backgroundColor = [UIColor orangeColor];
//    if (self.dynamic) {
//        self.contentTF.text = self.dynamic.content;
////        [self.imgBtn1 setBackgroundImage:self.advcontent.img forState:UIControlStateNormal];
//    }
}

-(void)saveBtntap{
    if (!self.dynamic) {
        self.dynamic = [NSEntityDescription insertNewObjectForEntityForName:@"Dynamic" inManagedObjectContext:self.managedObjectContext];
    }
    
    User1 *person1 = [User1 shareUser];
//    检索所有user
    NSFetchRequest * request = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([User class])];
    NSError * error = nil;
    NSArray * array = [self.managedObjectContext executeFetchRequest:request error:&error];
    
    NSFetchRequest * request1 = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([Dynamic class])];
    NSError * error1 = nil;
    NSArray * array1 = [self.managedObjectContext executeFetchRequest:request1 error:&error1];
//    NSSortDescriptor * sd1 = [NSSortDescriptor sortDescriptorWithKey:@"time" ascending:NO];
//    request1.sortDescriptors = @[sd1];
    NSInteger count = 0;
    for (Dynamic *dyna in array1) {
        count++;
        if ([dyna.contentID integerValue] !=count) {
            [self.dynamic setValue:[NSNumber numberWithInteger:count] forKey:@"contentID"];
        }
    }
    for (User *us in array) {
        
        if ([us.id isEqualToString:person1.id]) {
            [self.dynamic setValue:us forKey:@"user"];
            [self.dynamic setValue:self.contentTF.text forKey:@"content"];
            [self.dynamic setValue:self.mArray forKey:@"image"];
            NSDate *currentDate = [NSDate date];//获取当前时间，日期
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"YYYY/MM/dd hh:mm:ss"];
            NSString *dateString = [dateFormatter stringFromDate:currentDate];
            [self.dynamic setValue:dateString forKey:@"time"];
            NSError *error1 = nil;
            [self.managedObjectContext save:&error1];
            
        }
    }
    // 跳回上个页面
    [self.navigationController popViewControllerAnimated:YES];
}
//回调方法
-(void)imgBtntap{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"选择图片" message:@"请选择图片位置" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction * action1 = [UIAlertAction actionWithTitle:@"照相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // 判断设备是否支持相机模式
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            // 设置数据源为相机
            _imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            // 打开imagePicker
            [self presentViewController:_imagePicker animated:YES completion:nil];
        }else{
            NSLog(@"相机不可用");
        }
    }];
    UIAlertAction * action2 = [UIAlertAction actionWithTitle:@"图库" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        第三方 访问相册
        CustomeImagePicker *cip = [[CustomeImagePicker alloc] init];
        cip.delegate = self;
        [cip setHideSkipButton:NO];
        [cip setHideNextButton:NO];
        [cip setMaxPhotos:9];
        [cip setShowOnlyPhotosWithGPS:NO];
        
        [self presentViewController:cip animated:YES completion:^{
        }
         ];

    }];
    UIAlertAction * action3 = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        CustomeImagePicker *cip = [[CustomeImagePicker alloc] init];
        cip.delegate = self;
        [cip setHideSkipButton:NO];
        [cip setHideNextButton:NO];
        [cip setMaxPhotos:9];
        [cip setShowOnlyPhotosWithGPS:NO];
        
        [self presentViewController:cip animated:YES completion:^{
        }
         ];
        
    }];
    UIAlertAction * action4 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction * action5 = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        // 删除真是数据
        // 删除button背景图
        [self.imgBtn1 setBackgroundImage:nil forState:UIControlStateNormal];
        // 显示button title
        [self.imgBtn1 setTitle:@"选择图片" forState:UIControlStateNormal];
    }];
    [alert addAction:action1];
    [alert addAction:action2];
    [alert addAction:action3];
    [alert addAction:action4];
    
    // 如果button有背景图，则显示该选项
    if ([self.imgBtn1 backgroundImageForState:UIControlStateNormal]) {
        [alert addAction:action5];
    }
    // 打开actionSheet
    [self presentViewController:alert animated:YES completion:nil];
}
//方法回调，将选取的图片显示在button上
-(void) imageSelected:(NSArray *)arrayOfImages
{
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{ // 1
        dispatch_async(dispatch_get_main_queue(), ^{
//            [self.view showActivityView];
        }); // Main Queue to Display the Activity View
        int count = 0;
        for(NSString *imageURLString in arrayOfImages)
        {
            // Asset URLs
            
            ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
            [assetsLibrary assetForURL:[NSURL URLWithString:imageURLString] resultBlock:^(ALAsset *asset) {
                
            ALAssetRepresentation *representation = [asset defaultRepresentation];
            CGImageRef imageRef = [representation fullScreenImage];
            UIImage *image = [UIImage imageWithCGImage:imageRef];
                if (imageRef) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if(count==0)
                        {
                            [self.imgBtn1 setBackgroundImage:image forState:UIControlStateNormal];
                        }
                        if(count==1)
                        {
                            [self.imgBtn2 setBackgroundImage:image forState:UIControlStateNormal];
                        }
                        if(count==2)
                        {
                            [self.imgBtn3 setBackgroundImage:image forState:UIControlStateNormal];
                        }
                        if(count==3)
                        {
                            [self.imgBtn4 setBackgroundImage:image forState:UIControlStateNormal];
                        }
                        if(count==4)
                        {
                            [self.imgBtn5 setBackgroundImage:image forState:UIControlStateNormal];
                        }
                        if(count==5)
                        {
                            [self.imgBtn6 setBackgroundImage:image forState:UIControlStateNormal];
                        }
                        if(count==6)
                        {
                            [self.imgBtn7 setBackgroundImage:image forState:UIControlStateNormal];
                        }
                        if(count==7)
                        {
                            [self.imgBtn8 setBackgroundImage:image forState:UIControlStateNormal];
                        }
                        if(count==8)
                        {
                            [self.imgBtn9 setBackgroundImage:image forState:UIControlStateNormal];
                        }
                       
                    });
                    
                } // Valid Image URL
            } failureBlock:^(NSError *error) {
            }];
//            [self.imagemanager setValue:forKey:@"imgID"];
            
            count++;
        } // All Images I got
        dispatch_async(dispatch_get_main_queue(), ^{
//            [self.view hideActivityView];
            [self.imgBtn1 setTitle:@"" forState:UIControlStateNormal];
        });
    }); // Queue for reloading all images
    
    self.mArray = [NSMutableArray arrayWithArray:arrayOfImages];
    
}

// 完成选取时调用
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    //    NSLog(@"%@",info);
    // 保存图片...
    // 获取编辑后的图片
    UIImage * image = info[@"UIImagePickerControllerEditedImage"];
    // 给button设置背景图
    [_imgBtn1 setBackgroundImage:image forState:UIControlStateNormal];
    // 取消button的title
    [_imgBtn1 setTitle:@"" forState:UIControlStateNormal];
    // imagePicker弹下去
    [picker dismissViewControllerAnimated:YES completion:nil];
}
// 取消选取时调用
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    NSLog(@"cancel..");
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
