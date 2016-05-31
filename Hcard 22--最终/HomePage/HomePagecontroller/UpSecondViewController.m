//
//  GroupTableViewController.m
//  cardCase
//
//  Created by ChenJS on 16/5/6.
//  Copyright © 2016年 zhiyuan3g. All rights reserved.
//
#define WIDTH [UIScreen mainScreen].bounds.size.width

#import "UpSecondViewController.h"
#import <CoreData/CoreData.h>
#import "Person.h"
#import "Group.h"
#import "User.h"
#import "UpNextViewController.h"
#import "SWTableViewCell.h"
@interface UpSecondViewController ()<NSFetchedResultsControllerDelegate,SWTableViewCellDelegate,UITableViewDelegate,UITableViewDataSource>

@property (strong,nonatomic)NSManagedObjectContext *managedObjectContext;
@property (strong,nonatomic)NSFetchedResultsController *frc;
@property (strong,nonatomic)UpNextViewController *next;
//全局的按钮 接受OK按钮的状态
@property (strong,nonatomic)UIAlertAction *secureTextAlertAction;
//全局的分组
@property (strong,nonatomic)Group *group;
//弹出的TextField的text 用来查询所有分组名为str的人
@property (strong,nonatomic)NSString *text;
@property (strong,nonatomic)UITableView *tableView;
@property (assign,nonatomic)CGFloat height;
//定义一个全局的位置
@property (strong,nonatomic)NSIndexPath *indexPath;
@end

@implementation UpSecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //1 创建一个tableView
    self.tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 60.f;
    self.height = self.tableView.rowHeight;
    self.tableView.allowsSelection = NO;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.view addSubview:self.tableView];
    [self tableHeaderView];
    
    self.navigationItem.title = @"分组";
    [self getGroup];
    
    
}
//====================================================添加分组的方法
-(void)tableHeaderView{
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 40)];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 40)];
    //设置button的内容
    [btn  setTitle:@"添加分组" forState:UIControlStateNormal];
    [self.tableView.tableHeaderView addSubview:btn];
    //添加button的点击事件
    [btn addTarget:self action:@selector(addGroup) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitleColor:[UIColor colorWithRed:0.412 green:0.667 blue:0.894 alpha:1.00] forState:UIControlStateNormal];
    UIImageView *view2 = [[UIImageView alloc] initWithFrame:CGRectMake(15, 2.5, 35, 35)];
    [btn addSubview:view2];
    view2.image = [UIImage imageNamed:@"actionIconAdd"];
    
    //设置button内容的偏移量
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, -WIDTH/2-20, 0, 0);
}
-(void)addGroup{
    //获取本地库文件
    NSString *title = NSLocalizedString(@"添加分组", nil);
    NSString *message = NSLocalizedString(@"分组名由汉字组成", nil);
    NSString *cancelButtonTitle = NSLocalizedString(@"取消", nil);
    NSString *okButtonTitle = NSLocalizedString(@"确定", nil);
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    // 添加TextField 并添加对TextField的值改变事件的通知
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        
        //添加通知中心
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handlerTextFieldTextDidChangeNotification:) name:UITextFieldTextDidChangeNotification object:textField];
        //text的内容可见
        textField.secureTextEntry = NO;
        //设置键盘
        [textField becomeFirstResponder];
        textField.text = self.text;
        
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        NSLog(@"点击取消按钮");
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:alertController.textFields.firstObject];
    }];
    
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:okButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSLog(@"点击确定按钮");
        //准备正则符
        NSString * regex = @"^[\u4e00-\u9fa5]{0,}$";
        //拼接谓词
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self matches %@",regex];
        //判断输入是否合法
        BOOL result = [predicate evaluateWithObject:self.text];
        if (result) {
            
            [self addNewGroup];
            
        }else{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"输入分组名只能是汉字" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
        }
        
        //移除通知
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:alertController.textFields.firstObject];
        
        [self.tableView reloadData];
    }];
    
    //刚开始不能点击确定
    otherAction.enabled = NO;
    
    [alertController addAction:cancelAction];
    [alertController addAction:otherAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
    //定义一个全局变量
    self.secureTextAlertAction = otherAction;
}

//监听TextField值改变事件
-(void)handlerTextFieldTextDidChangeNotification:(NSNotification*) notification
{
    UITextField *textField=notification.object;
    self.secureTextAlertAction.enabled=textField.text.length>=1;
    self.text = [[NSString alloc] init];
    //获得分组名字
    self.text = textField.text;
    NSLog(@"%@",textField.text);
}
//添加分组
-(void)addNewGroup{
    NSLog(@"添加分组");
    if (!self.group) {
        //获取实体对象
        self.group = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Group class]) inManagedObjectContext:self.managedObjectContext];
        
        self.group.name = self.text;
        //获取当前时间
        NSDate *date = [NSDate date];
        //设置格式
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"yyyy-MM-dd"];
        //设置时区
        [df setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CH"]];
        //时间转字符串
        self.group.date = [df stringFromDate:date];
        self.group.number = [NSNumber numberWithInt:0];
        User *user = [self currentUser];
        if (user != nil) {
            self.group.user = user;
        }else{
            NSLog(@"未登录-添加分组");
        }
    }else{
        self.group.name = self.text;
    }
    //保存
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"%@",error.localizedDescription);
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
        User*localUser = array[0];
        return localUser;
    }else{
        return nil;
    }
}

//=======================================================查询所有分组
-(void)getGroup{
    //通过代理获取上下文
    UIApplication *application = [UIApplication sharedApplication];
    id delegate = application.delegate;
    self.managedObjectContext = [delegate managedObjectContext];
    
    //通过实体名获取请求
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([Group class])];
    //添加排序规则
    NSSortDescriptor *sort1  =[[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES];
    [request setSortDescriptors:@[sort1]];
    //添加谓词 查询出当前user的分组
    User *user = [self currentUser];
    if (user!= nil) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"user = %@",user];
        [request setPredicate:predicate];
    }else{
        NSLog(@"未登录-获取分组");
    }
    //把查询结果存入frc中 按照group分组
    self.frc = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    self.frc.delegate = self;
    NSError *error;
    if (![self.frc performFetch:&error]) {
        NSLog(@"%@",[error localizedDescription]);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//========================================================设置单元格
#pragma mark - Table view data source
//分组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSArray *sections = [self.frc sections];
    return sections.count;
}
//分组行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSArray *sections = [self.frc sections];
    id<NSFetchedResultsSectionInfo>sectionInfo = sections[section];
    
    return [sectionInfo numberOfObjects];
}
//设置cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SWTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell_indexPath" ];
    if (!cell) {
        NSMutableArray *rightUtilityButtons = [NSMutableArray new];
        //制作右边重命名
        [rightUtilityButtons addUtilityButtonWithColor:
         [UIColor colorWithRed:0.757 green:0.757 blue:0.757 alpha:1.00]
                                                 title:@"重命名"];
        
        
        //添加右边删除
        [rightUtilityButtons addUtilityButtonWithColor:
         [UIColor colorWithRed:0.757 green:0.757 blue:0.757 alpha:1.00]
                                                 title:@"删除"];
        
        cell = [[SWTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:@"cellIdentifier4"
                                  containingTableView:self.tableView // Used for row height and selection
                                   leftUtilityButtons:nil
                                  rightUtilityButtons:rightUtilityButtons];
        cell.delegate = self;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    //获取实体对象
    Group *group = [self.frc objectAtIndexPath:indexPath];
    //cell的内容是当前分组名
    //    cell.nameLabel.hidden = YES;
    //    cell.teleLabel.hidden = YES;
    cell.nameLabel.frame = CGRectMake(20, 5, WIDTH-20, _height-10);
    
    cell.nameLabel.text =[NSString stringWithFormat:@"%@ (%@)",group.name,group.number];
    
    NSLog(@"name = %@",group.name);
    
    return cell;
}
//右边的删除的回调
- (void)swippableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    
    if (index == 0) {
        NSLog(@"重命名");
        //通过cell获取IndexPath
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        Group *group = [self.frc objectAtIndexPath:indexPath];
        self.group = group;
        [self addGroup];
        
        
    }else if (index == 1){
        NSLog(@"删除");
        //通过cell获取IndexPath 获取当前的分组
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        Group *group = [self.frc objectAtIndexPath:indexPath];
        //获取分组所有人
        NSArray *array = [self getPersonOfGroup:group];
        //获取默认分组
        Group *moren = [self getMorenGroup];
        for (Person *person in array) {
            person.group = moren;
        }
        //删除group分组
        [self.managedObjectContext deleteObject:group];
        NSError *error;
        if ([self.managedObjectContext save:&error]) {
            NSLog(@"%@", [error localizedDescription]);
        }
        //删除之后所有的分组成员回到默认分组中
        
    }
    
}
//获取默认group
-(Group *)getMorenGroup{
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
    Group *group = array[0];
    return group;

}
//查询出group中的所有人
-(NSArray *)getPersonOfGroup:(Group *)group{
    
    //获取context
    id appDelegate = [[UIApplication sharedApplication] delegate];
    self.managedObjectContext = [appDelegate managedObjectContext];
    //通过实体名获取请求
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([Person class])];
    //添加谓词 筛选出当前用户的分组
    User *user = [self currentUser];
    if (user != nil) {
        NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"user = %@",user];
        [request setPredicate:predicate1];
    }else{
        NSLog(@"未登录-显示分组内容");
    }
    //添加谓词查询出当前分组的person
    //把查询结果存入frc中
    NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"group = %@",group];
    [request setPredicate:predicate2];
    //使用context执行检索
    NSError *error = nil;
    //array是结果集
    NSArray *array = [self.managedObjectContext executeFetchRequest:request error:&error];
    return array;

}
//选中cell时的回调 跳转到第三页 编辑页
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //获取实体对象
    Group *group = [self.frc objectAtIndexPath:indexPath];
    NSString *str = group.name;
    _next = [[UpNextViewController alloc] init];
    //在下一页中查询出所有分组名是str的Person
    [_next setValue:str forKey:@"groupName"];
    NSLog(@"传到下一页的分组名是%@",str);
    //同时进行传值
    [self.navigationController pushViewController:_next animated:YES];
}
//========================================================删除分组
//设置header
- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString *str =@"左划重命名或删除分组";
    return str;
}
//设置
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 30)];
    label.text =@"左划重命名或删除分组";
    label.textColor = [UIColor grayColor];
    return label;
}

//设置可被删除 删除之后当前分组的所有group = 默认
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}
//========================================================coredate
//当coredate的数据正在发生改变时 frc产生的回调
-(void)controllerWillChangeContent:(NSFetchedResultsController *)controller{
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
            NSLog(@"newPerson - insert - newIndexPath-section = %ld row = %ld",(long)newIndexPath.section,(long)newIndexPath.row);
            
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


/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
