//
//  PLViewController.m
//  cardCase
//
//  Created by 黄传家 on 16/5/20.
//  Copyright © 2016年 黄传家. All rights reserved.
//

#import "PLViewController.h"
#import "User1.h"
#import "PLTableViewCell.h"
@interface PLViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property (strong,nonatomic)UITableView *tableView;
@property (strong,nonatomic)NSManagedObjectContext *managedObjectContext;
@property (strong,nonatomic)NSMutableArray *arr;
@property (strong,nonatomic)NSArray *arr1;
@property (strong,nonatomic)UIImageView *imgView;
@property (strong,nonatomic)UILabel *nameLabel;
@property (strong,nonatomic)UILabel *timeLabel;
@property (strong,nonatomic)UILabel *contentLabel;
@property (strong,nonatomic)UITextField *PLTF;
@property (strong,nonatomic)UIButton *FB;
@property (strong,nonatomic)UIView *view1;
@property (strong,nonatomic)UIView *view2;
@property (assign,nonatomic) int height;
@property (strong,nonatomic)User1 *u;
@end

@implementation PLViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"评论";
    [self creatTabelView];
    [self creatUI];
    //当键盘出现或改变时调用
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
}
- (void)keyboardWillShow:(NSNotification *)aNotification

{
    //获取键盘的高度
    
    NSDictionary *userInfo = [aNotification userInfo];
    
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect keyboardRect = [aValue CGRectValue];
    
    self.height = keyboardRect.size.height;
    CGRect fram = self.view1.frame;
    self.view1.frame = CGRectMake(fram.origin.x, [UIScreen mainScreen].bounds.size.height-self.height-fram.size.height, fram.size.width, fram.size.height);
}


//当键退出时调用

- (void)keyboardWillHide:(NSNotification *)aNotification

{
    CGRect fram = self.view1.frame;
    self.view1.frame = CGRectMake(fram.origin.x, fram.origin.y+self.height-48, fram.size.width, fram.size.height);
}

-(void)creatUI{
    [self.view1 addSubview:self.PLTF];
    self.FB = [[UIButton alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-102, 1, 99, 48)];
    [self.FB setTitle:@"发表" forState:UIControlStateNormal];
    [self.FB setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
    self.FB.backgroundColor = [UIColor greenColor];
    [self.FB addTarget:self action:@selector(FBtap) forControlEvents:UIControlEventTouchUpInside];
    [self.view1 addSubview:self.FB];
    [self.view addSubview:self.view1];
}
-(void)creatTabelView{
    id app = [[UIApplication sharedApplication]delegate];
    self.managedObjectContext = [app managedObjectContext];
    
    self.imgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 50, 80, 80)];
    self.imgView.layer.masksToBounds = YES;
    self.imgView.layer.cornerRadius = 40;
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 50, [UIScreen mainScreen].bounds.size.width-110, 40)];
    self.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 105, [UIScreen mainScreen].bounds.size.width-110, 40)];
    self.contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 150, [UIScreen mainScreen].bounds.size.width-20, 100)];
//    if (!self.pl) {
//        self.pl = [NSEntityDescription insertNewObjectForEntityForName:@"PinLun" inManagedObjectContext:self.managedObjectContext];
//    }
    self.u = [User1 shareUser];
    NSFetchRequest * request1 = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([Dynamic class])];
    NSError * error1 = nil;
    NSArray * array1 = [self.managedObjectContext executeFetchRequest:request1 error:&error1];
    for (Dynamic *dynamic in array1) {
        if ([dynamic.contentID isEqualToNumber:self.u.dy.contentID]) {
            self.timeLabel.text = dynamic.time;
            self.contentLabel.text = dynamic.content;
            [self.imgView setImage:self.u.TX];
            self.nameLabel.text = self.u.name1;
            [self.pl setValue:dynamic.contentID forKey:@"plID"];
        }
    }
    self.view1 = [[UIView alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-100, [UIScreen mainScreen].bounds.size.width, 50)];
    self.view1.backgroundColor = [UIColor purpleColor];
    self.PLTF = [[UITextField alloc]initWithFrame:CGRectMake(1, 1, [UIScreen mainScreen].bounds.size.width-100, 48)];
    self.PLTF.layer.borderWidth = 1.0;
    self.PLTF.layer.borderColor = (__bridge CGColorRef _Nullable)([UIColor yellowColor]);
    self.PLTF.delegate = self;
    self.view2 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 250)];
    [self.view2 addSubview:self.imgView];
    [self.view2 addSubview:self.nameLabel];
    [self.view2 addSubview:self.timeLabel];
    [self.view2 addSubview:self.contentLabel];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 50, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    self.tableView.dataSource = self;
    self.tableView.delegate =self;
    self.tableView.tableHeaderView = self.view2;
    [self.view addSubview:self.tableView];
    self.arr = [NSMutableArray array];
    NSFetchRequest * request = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([PinLun class])];
    NSError *error = nil;
    NSArray *arr2 = [self.managedObjectContext executeFetchRequest:request error:&error];
    for (PinLun *PL in arr2) {
        if ([PL.plID isEqualToNumber:self.u.dy.contentID]) {
            [self.arr addObject:PL];
        }
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    PinLun *pinlun = self.arr[indexPath.row];
    
    static NSString *cellID = @"cellID";
    PLTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[PLTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    PinLun *P = self.arr[indexPath.row];
    cell.namePL.text = P.name;
    cell.contentPL.text = P.cont;
    return cell;
}
-(void)FBtap{
    NSFetchRequest * request = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([PinLun class])];
    NSError *error = nil;
    NSArray *arr1 = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (arr1.count == 1) {
    for (PinLun *pin in arr1) {
        if ([pin.plID isEqualToNumber:self.u.dy.contentID]) {
            [pin setValue:self.PLTF.text forKey:@"cont"];
            NSDate *currentDate = [NSDate date];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
            [dateFormatter setDateFormat:@"YYYY/MM/dd hh:mm:ss"];
            NSString *dateString = [dateFormatter stringFromDate:currentDate];
            [pin setValue:dateString forKey:@"time"];
            [pin setValue:self.u.name forKey:@"name"];
        }
        NSLog(@"++++++++%@",pin);
      }
    }else{
        self.pl = [NSEntityDescription insertNewObjectForEntityForName:@"PinLun" inManagedObjectContext:self.managedObjectContext];
        [self.pl setValue:self.PLTF.text forKey:@"cont"];
        NSDate *currentDate = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"YYYY/MM/dd hh:mm:ss"];
        NSString *dateString = [dateFormatter stringFromDate:currentDate];
        [self.pl setValue:dateString forKey:@"time"];
        [self.pl setValue:self.u.name forKey:@"name"];
    }
    NSError *error1 = nil;
    [self.managedObjectContext save:&error1];
    
    [self.tableView reloadData];
    
    [self.PLTF resignFirstResponder];
    
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (self.tableView.contentOffset.y<0) {
        self.tableView.contentOffset = CGPointMake(self.tableView.contentOffset.x, 0);
    }
    
}

//准备开始编辑
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    //    NSLog(@"adsfag");
    
    //    [textField canBecomeFirstResponder];
    return YES;
}
//'return'键按下时调用
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    //    NSLog(@"'return'键按下时调用");
    [self.PLTF resignFirstResponder];
    return YES;
}
//将要结束
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    //    NSLog(@"准备结束");
    return YES;
}
//结束编辑时调用
- (void)textFieldDidEndEditing:(UITextField *)textFiel{
    //    NSLog(@"已经结束");
    //    [self.tableView reloadData];
    //    [self.pinlun resignFirstResponder];
    //    self.lable.text = textFiel.text;
    self.PLTF.text = @"";
    //    [self.PLTF resignFirstResponder];
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
