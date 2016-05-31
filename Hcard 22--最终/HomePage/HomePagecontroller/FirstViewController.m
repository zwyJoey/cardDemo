//
//  FirstViewController.m
//  cardCase
//
//  Created by ChenJS on 16/4/23.
//  Copyright © 2016年 zhiyuan3g. All rights reserved.
//

#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT  [UIScreen mainScreen].bounds.size.height
#define interval  10.f;

#import "FirstViewController.h"
//导入自定义的view
#import "DropDown.h"
//增删改查
#import "MoreViewController.h"
#import "ThirdViewController.h"
#import <CoreData/CoreData.h>
#import "Person.h"
#import "User.h"
#import "Group.h"
#import "pinyin.h"
//headerBtn
#import "UpFirstTableViewController.h"

#import "UpSecondViewController.h"
//二维码
#import "TwoDimensionCodeViewController.h"
#import "DVScanQRCodeBarCodeViewController.h"
//cell
#import "SWTableViewCell.h"
//短信
#import <MessageUI/MessageUI.h>
//备注
#import "NoteViewController.h"
//导入系统联系人
#import <ContactsUI/CNContactViewController.h>
#import <ContactsUI/CNContactPickerViewController.h>



@interface FirstViewController ()<UITableViewDelegate, UITableViewDataSource,NSFetchedResultsControllerDelegate,UISearchControllerDelegate,UISearchResultsUpdating,UISearchBarDelegate,SWTableViewCellDelegate,MFMessageComposeViewControllerDelegate,MFMailComposeViewControllerDelegate,CNContactViewControllerDelegate,CNContactPickerDelegate>
{
    //判断下拉框是否出现
    BOOL isExist;
    //这是下拉列表
    DropDown *downView;
    //遮挡层
    UIView *barrierView;
    //做一个全局的 方便传值
    ThirdViewController *second;
}
//数据源


@property (strong,nonatomic) UITableView *tableView;
//声明通过CoreData读取数据要用到的变量
@property (strong,nonatomic) NSManagedObjectContext *managedObjectContext;
//用来存储查询并适合tableView来显示数据
@property (strong,nonatomic) NSFetchedResultsController *frc;
//searchBar
@property (strong,nonatomic)NSMutableArray *dataSource;
@property(strong,nonatomic)UISearchController *searchController;
@property(copy,nonatomic)NSString *searchText;
@property(strong,nonatomic)NSMutableArray *searchList;
//拨打电话
@property (strong,nonatomic)UIWebView *webView;

//rowHeightx
@property (assign,nonatomic)CGFloat height;
//声明一个user 是当前用户
@property (strong,nonatomic)User *localUser;
//查询当前用户的结果集
@property (strong,nonatomic) NSArray *array;
@end

@implementation FirstViewController
-(void)viewWillAppear:(BOOL)animated{
    if (self.navigationController.navigationBar.hidden) {
        self.navigationController.navigationBar.hidden = NO;
    }

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // 默认值 如果不设默认值 第一次点击进else方法
    isExist = YES;
    
    self.localUser = [self currentUser];
    
    //创建视图
    [self creatView];
    //绑定视图与数据库 查询数据
    [self reloadView];
    
    
    [self setHeaderBtn];
    
}
//获取当前的user
-(User *)currentUser{
    
    //取出userdefaults中存储的id
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString * userID = [userDefaults objectForKey:@"id"];
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
    NSArray * array = [self.managedObjectContext executeFetchRequest:request error:&error];
    if ([array count]>0) {
        
        User*user = array[0];
        return user;
    }else{
        return nil;
    }
}

//==================================================================创建视图
-(void)creatView{
    //1 创建一个tableView
    self.tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 60.f;
    self.height = self.tableView.rowHeight;
    self.tableView.allowsSelection = NO;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.view addSubview:self.tableView];
    //2 添加加号按钮 加号按钮就是一个
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(tapBarButton)];
    self.navigationItem.rightBarButtonItem = barButton;
    //3 在navigationbar 上添加一个searchbar
    //初始化searchBar
    [self search];
    //4 下是实现下拉列表的参数
    //创建一个遮挡层
    barrierView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    barrierView.backgroundColor = [UIColor grayColor];
    barrierView.alpha = 0.1f;
    barrierView.hidden = YES;
    [self.view addSubview:barrierView];
    //添加下拉视图
    //添加下拉列表
    downView = [[DropDown alloc] initWithFrame:CGRectMake(0, 70, WIDTH, 0)];
    //view.hidden = YES;
    downView.backgroundColor = [UIColor greenColor];
    
    [self.view addSubview:downView];
    
    //5 添加点击消失方法
    //创建点击识别器
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBarButton)];
    [barrierView addGestureRecognizer:recognizer];
    //设置触摸点个数
    recognizer.numberOfTouchesRequired = 1;
    //设置连续点击次数
    recognizer.numberOfTapsRequired = 1;
    //接收通知 当下拉列表发出通知的时候 执行回调方法
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(push:) name:@"indexPath" object:nil];
    
}

//设置headerView上的按钮
-(void)setHeaderBtn{
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0,0 , WIDTH, 100)];
    self.tableView.tableHeaderView.backgroundColor = [UIColor grayColor];
    //btn1
    UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 49)];
   
    
    [btn1 setTitle:@"最近添加" forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [self.tableView.tableHeaderView addSubview: btn1];
    btn1.backgroundColor = [UIColor whiteColor];
    [btn1 addTarget:self action:@selector(tapBtn1) forControlEvents:UIControlEventTouchUpInside];
    //btn2
    UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(0, 50, WIDTH, 49)];
    [btn2 setTitle:@"分组" forState:UIControlStateNormal];
    [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.tableView.tableHeaderView addSubview:btn2];
    btn2.backgroundColor = [UIColor whiteColor];
    [btn2 addTarget:self action:@selector(tapBtn2) forControlEvents:UIControlEventTouchUpInside];
}
-(void)tapBtn1{
    //新的人脉
    UpFirstTableViewController *newPerson = [[UpFirstTableViewController alloc] init];
    [self.navigationController pushViewController:newPerson animated:YES];
    
}
-(void)tapBtn2{
    //分组
    UpSecondViewController *group = [[UpSecondViewController alloc] init];
    [self.navigationController pushViewController:group animated:YES];
    
}
#pragma mark - searchBar
//==================================================================searchBar的查询功能
//初始化UISearchController
-(void)search{
    //初始化UISearchController
    self.searchController=[[UISearchController alloc]initWithSearchResultsController:nil];
    //设置searchController的数据更新器和代理
    self.searchController.searchResultsUpdater=self;
    self.searchController.delegate=self;
    //搜索时背景变暗色
    self.searchController.dimsBackgroundDuringPresentation=NO;
    //隐藏导航栏
    self.searchController.hidesNavigationBarDuringPresentation=NO;
    //将搜索栏添加到tableview的最上方
    self.navigationItem.titleView=self.searchController.searchBar;
    //设置searchbar
    self.searchController.searchBar.delegate=self;
    self.searchText=self.searchController.searchBar.text;
}
#pragma mark - UISearchBarDelegate
//设置成可以编辑
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    return YES;
}
//当输入内容的时候调用，每次输入都调用
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    self.searchText=searchText;
    NSLog(@"searchBar输入内容即调用");
}
- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    return YES;
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    searchBar.text=@"";
    //注销第一响应者
    [searchBar resignFirstResponder];
}
#pragma mark - UISearchResultsUpdating
//searchBar的查询功能
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    //NSLog(@"updateSearchResultsForSearchController");
    //新建查询语句
    NSFetchRequest * request = [[NSFetchRequest alloc]initWithEntityName:NSStringFromClass([Person class])];
    //添加排序及分组规则
    NSSortDescriptor *sort1 = [[NSSortDescriptor alloc] initWithKey:@"nameTitle" ascending:YES];
    NSSortDescriptor *sort2 = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSSortDescriptor *sort3 = [[NSSortDescriptor alloc] initWithKey:@"tele" ascending:YES];
    //把规则添加到请求中
    [request setSortDescriptors:@[sort1,sort2,sort3]];
    //添加谓词
    NSString *str = [self.searchText uppercaseString];
    NSString *str1 = [self.searchText lowercaseString];
    //仅通过姓名 电话 公司 不区分大小写
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"name contains %@||nameAll contains %@||companyAll contains %@||company contains %@||tele contains %@||name contains %@||nameAll contains %@||companyAll contains %@||company contains %@||tele contains %@||name contains %@||nameAll contains %@||companyAll contains %@||company contains %@||tele contains %@",self.searchText,self.searchText,self.searchText,self.searchText,self.searchText,str,str,str,str,str,str1,str1,str1,str1,str1];
    [request setPredicate:predicate];
    //    在这里也需要添加一个谓词 仅查询本用户的复合条件的联系人
    self.localUser = [self currentUser];
    if (self.localUser!= nil) {
        
        NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"user = %@",self.localUser];
        
        [request setPredicate:predicate2];
    }else{
        NSLog(@"未登录-updateSearchResultsForSearchController");
    }
    
    //把查询结果存入fetchedResultsController中
    self.frc = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.managedObjectContext sectionNameKeyPath:@"nameTitle" cacheName:nil];
    self.frc.delegate = self;
    NSError *error;
    if (![self.frc performFetch:&error]) {
        NSLog(@"%@", [error localizedDescription]);
    }
    
    if (self.searchList!=nil) {
        //就将数组里所有数据移除
        [self.searchList removeAllObjects];
    }
    [self.tableView reloadData];
}
//点击空白处让键盘消失
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.tableView endEditing:YES];
}
#pragma mark------------------------------UISearchControllerDelegate
- (void)willPresentSearchController:(UISearchController *)searchController{
    NSLog(@"SearchBar将要出现..");
    //hear消失
    self.tableView.tableHeaderView = nil;
    //加号消失
    self.navigationItem.rightBarButtonItem = nil;
}
- (void)didPresentSearchController:(UISearchController *)searchController{
    NSLog(@"SearchBar已经出现...");
}
- (void)willDismissSearchController:(UISearchController *)searchController{
    NSLog(@"SearchBar将要消失...");
    //设置头视图出现
    [self setHeaderBtn];
    //设置加号button
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(tapBarButton)];
    self.navigationItem.rightBarButtonItem = barButton;
}
- (void)didDismissSearchController:(UISearchController *)searchController{
    NSLog(@"SearchBar已经消失...");
    //绑定视图与数据库 查询数据
    [self reloadView];
    [self.tableView reloadData];
    
}
- (void)presentSearchController:(UISearchController *)searchController{
    NSLog(@"SearchBar出现了...");
}
//==================================================================增删改查
#pragma mark - core data
//绑定view中的tableView与coredate 使列表及时更新 查询数据
-(void)reloadView{
    
    //通过代理获取上下文
    UIApplication *application = [UIApplication sharedApplication];
    id delegate = application.delegate;
    self.managedObjectContext = [delegate managedObjectContext];
    //通过实体名获取请求
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([Person class])];
    //添加排序及分组规则
    NSSortDescriptor *sort1 = [[NSSortDescriptor alloc] initWithKey:@"nameTitle" ascending:YES];
    NSSortDescriptor *sort2 = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSSortDescriptor *sort3 = [[NSSortDescriptor alloc] initWithKey:@"tele" ascending:YES];
    //把规则添加到请求中
    [request setSortDescriptors:@[sort1,sort2,sort3]];
    //取出user的person
    
    if (self.localUser != nil) {
        NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"user = %@",self.localUser];
        [request setPredicate:predicate2];
    }else{
        NSLog(@"未登录-reloadView");
    }
    //
    //把数据转换成tableView中可显示的数据
    self.frc = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.managedObjectContext sectionNameKeyPath:@"nameTitle" cacheName:nil];
    //声明代理
    self.frc.delegate = self;
    
    //执行frc
    NSError *error;
    if (![self.frc performFetch:&error]) {
        NSLog(@"self.frc performFetch:&error == %@",[error localizedFailureReason]);
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
            
            
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            //让tableView刷新indexPath位置上的cell
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
//==================================================================下拉列表的点击回调方法
-(void)push:(NSNotification *)notification{
    //初始化
    second = [[ThirdViewController alloc] init];
    TwoDimensionCodeViewController *twoDimen = [[TwoDimensionCodeViewController alloc] init];
    DVScanQRCodeBarCodeViewController *scan = [[DVScanQRCodeBarCodeViewController alloc] init];
    //根据通知内容取出弹出视图的当前列表
    NSIndexPath *indexPath = notification.userInfo[@"indexPath"];
    //提取出当前用户的账号即电话号码
    NSString *tele = self.localUser.id;
    //导入系统联系人
    //1.跳转到联系人选择页面，注意这里没有使用UINavigationController
    CNContactPickerViewController *controller = [[CNContactPickerViewController alloc] init];
    controller.delegate = self;
    
    //不能完成的提示
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"此功能暂未实现" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"我原谅你了，你已经很棒了" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"我原谅你了，你已经很棒了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self presentViewController:controller animated:YES completion:nil];
    }];
    
    
    
    
    
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    //我的二维码
                    [twoDimen setValue:tele forKey:@"str"];
                    [self.navigationController pushViewController:twoDimen animated:YES];
                    break;
                case 1:
                    //扫一扫
                    [self.navigationController pushViewController:scan animated:YES];
                    break;
                default:
                    break;
            }
            break;
        case 1:
            switch (indexPath.row) {
                case 0:
                    //导入系统联系人
                    //1.跳转到联系人选择页面，注意这里没有使用UINavigationController
                    [alert addAction:action2];
                    [self presentViewController:alert animated:YES completion:nil];
                    
                    break;
                case 1:
                    //雷达交换
                    [alert addAction:action1];
                    [self presentViewController:alert animated:YES completion:nil];
                    break;
                case 2:
                    //添加联系人
                    //                    [second setValue:self.localUser forKey:@"localUser"];
                    [self.navigationController pushViewController:second animated:YES];
                    break;
                    
                default:
                    break;
            }
            break;
        default:
            break;
    }
    //点击完成之后下拉列表也需要自动消失
    [self tapBarButton];
}
//==================================================================点击加号回调 弹出一个下拉列表
-(void)tapBarButton{
    if (isExist) {
        //动态弹出视图
        [UIView animateWithDuration:0.35f delay:0 options:0 animations:^{
            barrierView.hidden = NO;
            
            CGRect frame1 = downView.frame;
            frame1.size.height = HEIGHT/3-20;
            downView.frame =frame1;
            
            CGRect frame2 = downView.tv.frame;
            frame2.size.height = HEIGHT/3-20;
            downView.tv.frame =frame2;
            
            //弹出视图的同时search消失
            [self.searchController.searchBar removeFromSuperview];
            //加号变成×
            UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(tapBarButton)];
            self.navigationItem.rightBarButtonItem = barButton;
        } completion:nil];
        isExist = NO;
        //设置表格不能动
        [self.tableView setScrollEnabled:NO];
    }else{
        //动态取消视图视图
        [UIView animateWithDuration:0.35f delay:0 options:0 animations:^{
            
            barrierView.hidden = YES;
            
            CGRect frame1 = downView.frame;
            frame1.size.height = 0;
            downView.frame =frame1;
            
            CGRect frame2 = downView.tv.frame;
            frame2.size.height = 0;
            downView.tv.frame =frame2;
            //出现
            [self search];
            UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(tapBarButton)];
            self.navigationItem.rightBarButtonItem = barButton;
        } completion:nil];
        isExist = YES;
        //设置表格能动
        [self.tableView setScrollEnabled:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//==================================================================设置分组
#pragma mark - Table view data source
//设置分组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSArray * sections = [self.frc sections];
    return sections.count;
    
}
//设置行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSArray *sections = [self.frc sections];
    //行数
    id<NSFetchedResultsSectionInfo>sectionInfo = sections[section];
    return [sectionInfo numberOfObjects];
}
//返回分组header内容
- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    NSArray *sections = [self.frc sections];
    //行数
    id<NSFetchedResultsSectionInfo>sectionInfo = sections[section];
    
    return [sectionInfo name];
}
//设置header高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.f;
}
//设置单元格内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //获取实体对象
    Person *person = [self.frc objectAtIndexPath:indexPath];
    
    SWTableViewCell *cell = (SWTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"cellIdentifier3"];
    if (!cell) {
        //创建一个使用唯一标识符的cell
        if (cell == nil) {
            NSMutableArray *leftUtilityButtons = [NSMutableArray new];
            NSMutableArray *rightUtilityButtons = [NSMutableArray new];
            //制作左边的几个按钮 没有文字 都是图片 == 添加到分组 分享给别人（发送给联系人 邮件 短信 二维码）编辑
            [leftUtilityButtons addUtilityButtonWithColor:
             [UIColor colorWithRed:0.757 green:0.757 blue:0.757 alpha:1.00]
                                                     icon:[UIImage imageNamed:@"actionIconAdd"]];
            [leftUtilityButtons addUtilityButtonWithColor:
             [UIColor colorWithRed:0.757 green:0.757 blue:0.757 alpha:1.00]
                                                     icon:[UIImage imageNamed:@"share"]];
            
            //添加右边的两个按钮 有文字 == call  more
            [rightUtilityButtons addUtilityButtonWithColor:
             [UIColor colorWithRed:0.757 green:0.757 blue:0.757 alpha:1.00]
                                                     title:@"电话"];
            [rightUtilityButtons addUtilityButtonWithColor:
             [UIColor colorWithRed:0.757 green:0.757 blue:0.757 alpha:1.00]
                                                     title:@"更多"];
            
            cell = [[SWTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                          reuseIdentifier:@"cellIdentifier3"
                                      containingTableView:_tableView // Used for row height and selection
                                       leftUtilityButtons:leftUtilityButtons
                                      rightUtilityButtons:rightUtilityButtons];
            cell.delegate = self;
        }
        
    }
    //设置cell
    [cell.imageVB setBackgroundImage:[UIImage imageWithData:person.pic] forState:UIControlStateNormal];
    cell.nameLabel.text = person.name;
    cell.teleLabel.text = person.tele;
    NSLog(@"当前联系人的分组名 = %@",person.group.name);
    NSLog(@"当前联系人的用户id = %@",person.user.id);
    
    if ([person.name length]<=0) {
        
        cell.teleLabel.frame = CGRectMake(self.height/0.718+10*2,10/2 , WIDTH-self.height/0.718-10*3,(self.height-11));
    }
    return cell;
}
//查询所有分组
-(NSArray *)findAllGroup:(NSPredicate *)predicate{
    //获取context
    id appDelegate = [[UIApplication sharedApplication] delegate];
    self.managedObjectContext = [appDelegate managedObjectContext];
    //创建检索对象
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([Group class])];
    //设定排序方法
    NSSortDescriptor *sd1 = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES];
    fetchRequest.sortDescriptors = @[sd1];
    if (predicate) {
        [fetchRequest setPredicate:predicate];
    }
    //使用context执行检索
    NSError *error = nil;
    //array是结果集
    NSArray * array = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    return  array;
}
//左边的四个按钮
- (void)swippableTableViewCell:(SWTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    Person *person = [self.frc objectAtIndexPath:indexPath];
    switch (index) {
        case 0://添加到分组
        {    NSLog(@"left button 0 was pressed");
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"添加到分组" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction *group = [UIAlertAction actionWithTitle:@"分组" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSArray *array = [self findAllGroup:nil];
                //获取分组名集合
                NSMutableArray *mArray = [NSMutableArray array];
                for (Group *group in array) {
                    NSString *str = group.name;
                    [mArray addObject:str];
                }
                //弹出分组alert
                UIAlertController *group1 = [UIAlertController alertControllerWithTitle:@"请选择" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
                for (NSString *str in mArray) {
                    UIAlertAction * name = [UIAlertAction actionWithTitle:str style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        //点击查询出当前的分组 加1 本Person的group = 当前分组
                        //谓词
                        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name = %@",str];
                        //获取当前分组
                        NSArray *tempGroups = [self findAllGroup:predicate];
                        Group *tempGroup = tempGroups[0];
                        //分组人数加1
                        
                        int tempNumber = [tempGroup.number intValue] +1;
                        tempGroup.number = [NSNumber numberWithInt:tempNumber];
                        //把当前的人添加到这个分组中
                        person.group = tempGroup;
                        
                        //通过上下文保存数据
                        NSError *error;
                        if (![self.managedObjectContext save:&error]) {
                            NSLog(@"2 === %@",[error localizedFailureReason]);
                        }
                        
                    }];
                    [group1 addAction:name];
                }
                //取消按钮
                UIAlertAction *cancel1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                [group1 addAction:cancel1];
                [self presentViewController:group1 animated:YES completion:nil];
                
            }];
            UIAlertAction *remark = [UIAlertAction actionWithTitle:@"备注" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //跳转到备注页
                NoteViewController *note = [[NoteViewController alloc] init];
                [note setValue:person forKey:@"person"];
                [self.navigationController pushViewController:note animated:YES];
            }];
            [alert addAction:cancel];
            [alert addAction:group];
            [alert addAction:remark];
            [self presentViewController:alert animated:YES completion:nil];
        }
            [cell hideUtilityButtonsAnimated:YES];
            break;
        case 1://分享
            NSLog(@"left button 1 was pressed");
        {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"分享" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction *group1 = [UIAlertAction actionWithTitle:@"微信" style:UIAlertActionStyleDefault handler:nil];
            UIAlertAction *group2 = [UIAlertAction actionWithTitle:@"邮件" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if ([MFMailComposeViewController canSendMail]) { // 用户已设置邮件账户
                    [self sendEmailAction:cell.teleLabel.text]; // 调用发送邮件的代码
                }else{
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示信息" message:@"请添加邮件账户" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        //返回
                        [self dismissViewControllerAnimated:YES completion:nil];
                    }];
                    [alert addAction:ok];
                    [self presentViewController:alert animated:YES completion:nil];
                    
                }
            }];
            UIAlertAction *group3 = [UIAlertAction actionWithTitle:@"短信" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if( [MFMessageComposeViewController canSendText] )
                {
                    MFMessageComposeViewController * controller = [[MFMessageComposeViewController alloc] init];
                    [self presentViewController:controller animated:YES completion:nil];
                    controller.navigationBar.tintColor = [UIColor redColor];
                    controller.body = cell.teleLabel.text;
                    controller.messageComposeDelegate = self;
                    [self presentViewController:controller animated:YES completion:nil];
                    [[[[controller viewControllers] lastObject] navigationItem] setTitle:@"新信息"]; }//修改短信界面标题
                
                
            }];
            UIAlertAction *group4 = [UIAlertAction actionWithTitle:@"二维码" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //这是展示的是当前cell的电话的二维码
                TwoDimensionCodeViewController *two = [[TwoDimensionCodeViewController alloc] init];
                [two setValue:cell.teleLabel.text forKey:@"str"];
                [self presentViewController:two animated:YES completion:nil];
            }];
            [alert addAction:cancel];
            [alert addAction:group1];
            [alert addAction:group2];
            [alert addAction:group3];
            [alert addAction:group4];
            [self presentViewController:alert animated:YES completion:nil];
        }
            [cell hideUtilityButtonsAnimated:YES];
            break;
            
        default:
            break;
    }
}
- (void)sendEmailAction:(NSString *)message
{
    // 邮件服务器
    MFMailComposeViewController *mailCompose = [[MFMailComposeViewController alloc] init];
    // 设置邮件代理
    [mailCompose setMailComposeDelegate:self];
    // 设置邮件主题
    [mailCompose setSubject:@"来自cardcase的分享"];
    //    // 设置收件人
    //    [mailCompose setToRecipients:@[@"1147626297@qq.com"]];
    //    // 设置抄送人
    //    [mailCompose setCcRecipients:@[@"1229436624@qq.com"]];
    //    // 设置密抄送
    //    [mailCompose setBccRecipients:@[@"shana_happy@126.com"]];
    /**
     *  设置邮件的正文内容
     */
    NSString *emailContent = message;
    // 是否为HTML格式
    [mailCompose setMessageBody:emailContent isHTML:NO];
    // 如使用HTML格式，则为以下代码
    //	[mailCompose setMessageBody:@"<html><body><p>Hello</p><p>World！</p></body></html>" isHTML:YES];
    // 弹出邮件发送视图
    [self presentViewController:mailCompose animated:YES completion:nil];
}
- (void)sendEmailTo:(NSString *)eMail
{
    // 邮件服务器
    MFMailComposeViewController *mailCompose = [[MFMailComposeViewController alloc] init];
    // 设置邮件代理
    [mailCompose setMailComposeDelegate:self];
    // 设置邮件主题
    [mailCompose setSubject:@"来自cardcase的邮件"];
    // 设置收件人
    [mailCompose setToRecipients:@[eMail]];
    //    // 设置抄送人
    //    [mailCompose setCcRecipients:@[@"1229436624@qq.com"]];
    //    // 设置密抄送
    //    [mailCompose setBccRecipients:@[@"shana_happy@126.com"]];
    /**
     *  设置邮件的正文内容
     */
    //    NSString *emailContent = message;
    // 是否为HTML格式
    //    [mailCompose setMessageBody:emailContent isHTML:NO];
    // 如使用HTML格式，则为以下代码
    //	[mailCompose setMessageBody:@"<html><body><p>Hello</p><p>World！</p></body></html>" isHTML:YES];
    // 弹出邮件发送视图
    [self presentViewController:mailCompose animated:YES completion:nil];
}

//代理方法，当短信界面关闭的时候调用，发完后会自动回到原应用
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    // 关闭短信界面
    [controller dismissViewControllerAnimated:YES completion:nil];
    if (result == MessageComposeResultCancelled) {
        NSLog(@"取消发送");
    } else if (result == MessageComposeResultSent) {
        NSLog(@"已经发出");
    } else {
        NSLog(@"发送失败");
    }
}
//代理方法 当邮件界面关闭时候调用 发完后自动回到原应用
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled: // 用户取消编辑
            NSLog(@"Mail send canceled...");
            break;
        case MFMailComposeResultSaved: // 用户保存邮件
            NSLog(@"Mail saved...");
            break;
        case MFMailComposeResultSent: // 用户点击发送
            NSLog(@"Mail sent...");
            break;
        case MFMailComposeResultFailed: // 用户尝试保存或发送邮件失败
            NSLog(@"Mail send errored: %@...", [error localizedDescription]);
            break;
    }
    // 关闭邮件发送视图
    [self dismissViewControllerAnimated:YES completion:nil];
}
//右边的两个按钮的点击回调
- (void)swippableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    
    if (index == 0) {//call
        NSLog(@"call button was pressed");
        if (!_webView) {
            _webView = [[UIWebView alloc] initWithFrame:CGRectZero];
        }
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",cell.teleLabel.text]];
        [_webView loadRequest:[NSURLRequest requestWithURL:url]];
        
        [cell hideUtilityButtonsAnimated:YES];
        
    }
    else if (index == 1)//more alert
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *message = [UIAlertAction actionWithTitle:@"短信" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if( [MFMessageComposeViewController canSendText] )
            {
                MFMessageComposeViewController * controller = [[MFMessageComposeViewController alloc] init];
                [self presentViewController:controller animated:YES completion:nil];
                controller.navigationBar.tintColor = [UIColor redColor];
                controller.recipients = @[cell.teleLabel.text];
                controller.messageComposeDelegate = self;
                [self presentViewController:controller animated:YES completion:nil];
                [[[[controller viewControllers] lastObject] navigationItem] setTitle:@"新信息"]; }//修改短信界面标题
        }];
        UIAlertAction *eMail = [UIAlertAction actionWithTitle:@"邮件" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if ([MFMailComposeViewController canSendMail]) { // 用户已设置邮件账户
                //通过cell的到当前Person在frc中的位置
                NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
                Person *person = [self.frc objectAtIndexPath:indexPath];
                if ([person.email length]<=0) {
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示信息" message:@"该用户没有添加邮箱账号" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        //返回
                        [self dismissViewControllerAnimated:YES completion:nil];
                    }];
                    [alert addAction:ok];
                    [self presentViewController:alert animated:YES completion:nil];
                }else{
                    [self sendEmailAction:cell.teleLabel.text]; // 调用发送邮件的代码
                }
                
                
            }else{
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示信息" message:@"请添加邮件账户" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    //返回
                    [self dismissViewControllerAnimated:YES completion:nil];
                }];
                [alert addAction:ok];
                [self presentViewController:alert animated:YES completion:nil];
                
            }
            
            
        }];
        UIAlertAction *delete = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            //删除功能
            //通过coredate删除对象
            //通过IndexPath获取我们要删除的实体
            NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
            Person *person =[self.frc objectAtIndexPath:indexPath];
            //通过上下文移除实体
            [self.managedObjectContext deleteObject:person];
            //保存
            NSError *error;
            if (![self.managedObjectContext save:&error]) {
                NSLog(@"1====%@",[error localizedDescription]);
            }
            
        }];
        [alert addAction:cancel];
        [alert addAction:message];
        [alert addAction:eMail];
        [alert addAction:delete];
        [self presentViewController:alert animated:YES completion:nil];
        [cell hideUtilityButtonsAnimated:YES];
        
    }else{
        
        [cell hideUtilityButtonsAnimated:YES];
    }
    
}

//设置索引
-(NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    NSLog(@"设置索引");
    //通过frc获取Section数量
    NSArray *sections = [self.frc sections];
    //创建可变数组来返回索引数组
    NSMutableArray *index = [NSMutableArray arrayWithCapacity:sections.count];
    //通过循环取出每个Section的hear
    for (int i=0; i<sections.count; i++) {
        id<NSFetchedResultsSectionInfo>info = sections[i];
        [index addObject:[info name]];
    }
    //返回索引数组
    return index;
}

//==================================================================设置弹出动画
//选中cell时的回调
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //获取实体对象 同时进行传值
    Person *person = [self.frc objectAtIndexPath:indexPath];
    //    second = [[SecondViewController alloc] init];
    //    [second setValue:person forKey:@"person"];
    //    [second setValue:indexPath forKey:@"indexPath"];
    //    //跳转
    //    [self.navigationController pushViewController:second animated:YES];
    
    
    MoreViewController *more = [[MoreViewController alloc] init];
    [more setValue:person forKey:@"person"];
    [more setValue:indexPath forKey:@"indexPath"];
    [self.navigationController pushViewController:more animated:YES];
}

@end
