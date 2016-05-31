//
//  NoteViewController.m
//  Hcard
//
//  Created by ChenJS on 16/5/26.
//  Copyright © 2016年 黄传家. All rights reserved.
//
#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT  [UIScreen mainScreen].bounds.size.height
#import "NoteViewController.h"

//虚线
#import "UIImage+MyImage.h"
#import "Person.h"
#import "Note.h"
#import "User.h"
//block回传值 添加文本
#import "NoteTextViewController.h"
#import "NoteTableViewCell.h"

@interface NoteViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITableViewDelegate,UITableViewDataSource,NSFetchedResultsControllerDelegate>
//声明一个照片选择器
@property (strong,nonatomic)UIImagePickerController *pickerController;
//声明一个照片二进制数据
@property (strong,nonatomic)NSData *data;
//图像btn
@property (strong,nonatomic)UIButton *imageBtn;
//
@property (strong,nonatomic)UITableView *tableView;
@property (strong,nonatomic)Person *person;
//做一个全局的Note用来保存note
@property (strong,nonatomic)Note *note;
//声明通过CoreData读取数据要用到的变量
@property (strong,nonatomic) NSManagedObjectContext *managedObjectContext;
//用来存储查询并适合tableView来显示数据
@property (strong,nonatomic) NSFetchedResultsController *frc;
//全局的string 接受内容
@property (strong,nonatomic)NSString *myText;

@property(assign,nonatomic) CGFloat height;

@end

@implementation NoteViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
     [self select];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //查询之后创建
   
    [self creatUI];
   

}
//创建页面信息
-(void)creatUI{
    self.navigationItem.title = @"备注信息";
    self.tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    //设置代理
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    //自定义tableView的headerView
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 60)];
    //虚线边框
    UIImage *image = [UIImage imageWithSize:CGSizeMake(WIDTH-16, 50) borderColor:[UIColor grayColor] borderWidth:1];
    //创建一个btn
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(8, 8, WIDTH-16, 50)];
    [btn setBackgroundImage:image forState:UIControlStateNormal];
    //设置圆角
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 7;
    //设置文字
    [btn setTitle:@"+ 添加" forState:UIControlStateNormal];
    [self.tableView.tableHeaderView addSubview:btn];
    //设置字体颜色
    [btn setTitleColor:[UIColor colorWithRed:0.027 green:0.490 blue:1.000 alpha:1.00] forState:UIControlStateNormal];
    //添加点击回调
    [btn addTarget: self action:@selector(setNote) forControlEvents:UIControlEventTouchUpInside];
    
    [self createPicker];
}

//这里进行照片设置
-(void)createPicker{
    //首先实例化一个UIPickerview
    _pickerController = [[UIImagePickerController alloc] init];
    //开启图片编辑模式
    _pickerController.allowsEditing = YES;
    //设置代理
    _pickerController.delegate = self;
    //设置默认图片
    _pickerController.view.backgroundColor = [UIColor grayColor];
}

- (void)setNote{
    //制作一个sheet
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *text = [UIAlertAction actionWithTitle:@"添加文本" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //跳转
        NoteTextViewController *textVC = [[NoteTextViewController alloc] init];
        textVC.backValue = ^(NSString *str){
            self.myText = str;
            [self save];
        };
        [self.navigationController pushViewController:textVC animated:YES];
    }];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"图库" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //指定数据源 并跳转
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            _pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            //跳转
            [self presentViewController:_pickerController animated:YES completion:nil];
        }else{
            NSLog(@"library is not support");
        }
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //设置数据源 并跳转
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            _pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            //跳转
            [self presentViewController:_pickerController animated:YES completion:nil];
        }else{
            NSLog(@"camera is not support");
        }
    }];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //设置数据源 并跳转
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
            _pickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            //跳转
            [self presentViewController:_pickerController animated:YES completion:nil];
        }else{
            NSLog(@"album is not support");
        }
    }];
    UIAlertAction *action4 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        //设置数据源 并跳转
        NSLog(@"you touch cancel");
    }];
    
    [alert addAction:text];
    [alert addAction:action1];
    [alert addAction:action2];
    [alert addAction:action3];
    [alert addAction:action4];
    
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
    
    //保存
    [self save];
    //更新列表
    [self.tableView reloadData];
    
}
//查询
-(void)select{
    
    //通过代理获取上下文
    UIApplication *application = [UIApplication sharedApplication];
    id delegate = application.delegate;
    self.managedObjectContext = [delegate managedObjectContext];
    //通过实体名获取请求
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([Note class])];
    //添加排序及分组规则
    NSSortDescriptor *sort1 = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
    
    //把规则添加到请求中
    [request setSortDescriptors:@[sort1]];
    //取出当前的person 添加谓词删选
    NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"person = %@",self.person];
    [request setPredicate:predicate2];
    //把数据转换成tableView中可显示的数据
    self.frc = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    //声明代理
    self.frc.delegate = self;
    
    //执行frc
    NSError *error;
    if (![self.frc performFetch:&error]) {
        NSLog(@"self.frc performFetch:&error == %@",[error localizedFailureReason]);
    }
}

//保存
-(void)save{
    
    //获取Person实体对象
    if (!self.note) {
        self.note = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Note class]) inManagedObjectContext:self.managedObjectContext];
    }
    //给Person赋值
    //添加时间
    NSDate *date = [NSDate date];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy/MM/dd HH:mm"];
    [df setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    NSString *str = [df stringFromDate:date];
    self.note.date = str;
    //设置备注归属
    self.note.person = self.person;
    //设置图片
    if (_data) {
        self.note.image = _data;
    }
    if (_myText) {
        self.note.message = _myText;
    }
    
    //通过上下文保存数据
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"2 === %@",[error localizedFailureReason]);
    }
    
}

#pragma mark - dataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    Note *note = [self.frc objectAtIndexPath:indexPath];
    if (note.message) {
        return 75;
    }else{
        return 140;
    }

}
//设置行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *sections = [self.frc sections];
    id<NSFetchedResultsSectionInfo>sectionInfo = sections[section];
    return [sectionInfo numberOfObjects];
}
//设置分组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSArray *sections = [self.frc sections];
    return sections.count;
}

//设置单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    Note *note = [self.frc objectAtIndexPath:indexPath];
    NSString *str = @"note_cellidentifi";
    NoteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (!cell) {
        cell = [[NoteTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str Note:note];
    }
    cell.dateLabel.text = note.date;
    cell.imageV.image = [UIImage imageWithData:note.image];
    cell.message.text = note.message;
    
    
    
    return cell;
    
}
//设置tableView可被删除
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (void)tableView:(UITableView *)tableView

commitEditingStyle:(UITableViewCellEditingStyle)editingStyle

forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //在表中删除

    Note *note =[self.frc objectAtIndexPath:indexPath];
    //通过上下文移除实体
    [self.managedObjectContext deleteObject:note];
    //保存
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"1====%@",[error localizedDescription]);
    }

    
}



//当coredate的数据正在发生改变时 frc产生的回调
-(void)controllerWillChangeContent:(NSFetchedResultsController *)controller{
    NSLog(@"coredate的数据正在发生改变");
    [self.tableView beginUpdates];
}
//分区改变状况
- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                          withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                          withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeMove:
            
            break;
        case NSFetchedResultsChangeUpdate:
            
            break;
            
    }
}
//数据改变状况
- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            //让tableView在newIndexPath位置插入一个cell
            NSLog(@"insert - newIndexPath-section = %ld row = %ld",(long)newIndexPath.section,(long)newIndexPath.row);
            
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            //让tableView刷新indexPath位置上的cell
            NSLog(@"update - indexPath == %@",indexPath);
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}
//当CoreData的数据完成改变是，FRC产生的回调
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
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
