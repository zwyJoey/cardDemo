//
//  GroupNextTableViewController.m
//  cardCase
//
//  Created by ChenJS on 16/5/7.
//  Copyright © 2016年 zhiyuan3g. All rights reserved.
//
#define WIDTH [UIScreen mainScreen].bounds.size.width

#import "UpNextViewController.h"
#import <CoreData/CoreData.h>
#import "Person.h"
#import "Group.h"
#import "User.h"
#import "ThirdViewController.h"

@interface UpNextViewController ()<NSFetchedResultsControllerDelegate,UITableViewDataSource,UITableViewDelegate>
{
    ThirdViewController *second;
}

@property (strong,nonatomic) NSFetchedResultsController *frc;
@property (strong,nonatomic) NSManagedObjectContext *managedObjectContext;
//前页的传值
@property (assign,nonatomic) NSString *groupName;
@property (strong,nonatomic) Group *localGroup;
//一个tableView 一个imageView
@property (strong,nonatomic) UITableView *tableView;
@property (strong,nonatomic) UIImageView *imageView;

@end

@implementation UpNextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"当前分组名是%@",_groupName);
    //获取当前分组
    [self currentGroup];
    //取得分组为当前分组的person
    [self getGroup];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)currentGroup{
    //根据groupname 查询出当前分组
    //获取context
    id appDelegate = [[UIApplication sharedApplication] delegate];
    self.managedObjectContext = [appDelegate managedObjectContext];
    
    //创建检索对象
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([Group class])];
    //添加删选条件
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name = %@",self.groupName];
    [request setPredicate:predicate];
    //使用context执行检索
    NSError *error = nil;
    //array是结果集
    NSArray * array = [self.managedObjectContext executeFetchRequest:request error:&error];
    if ([array count]>0) {
        self.localGroup = array[0];
        NSLog(@"查询出的group%@ - %@",self.localGroup.name,self.localGroup.number);
    }
    
}

-(void)getGroup{
    //通过代理获取上下文
    UIApplication *application = [UIApplication sharedApplication];
    id delegate = application.delegate;
    self.managedObjectContext = [delegate managedObjectContext];
    //通过实体名获取请求
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([Person class])];
    //添加排序规则
    
    NSSortDescriptor *sort2 = [[NSSortDescriptor alloc] initWithKey:@"nameTitle" ascending:YES];
    NSSortDescriptor *sort3 = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSSortDescriptor *sort4 = [[NSSortDescriptor alloc] initWithKey:@"tele" ascending:YES];
    [request setSortDescriptors:@[sort2,sort3,sort4]];
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
    NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"group = %@",self.localGroup];
    [request setPredicate:predicate2];
    
    self.frc = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.managedObjectContext sectionNameKeyPath:@"date" cacheName:nil];
    self.frc.delegate = self;
    //保存
    NSError *error;
    if (![self.frc performFetch:&error]) {
        NSLog(@"%@",[error localizedDescription]);
    }
    //查询结果
    NSArray *sections = [self.frc sections];
    NSLog(@"[sections count] = %lu",(unsigned long)[sections count]);
       if ([sections count]) {
        self.tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
           self.tableView.delegate = self;
           self.tableView.dataSource = self;
        [self.view addSubview:self.tableView];
    }else{
        self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
        self.imageView.frame = CGRectMake(0, 200, WIDTH, 300);
        //居中使用自动布局
        self.imageView.backgroundColor = [UIColor redColor];
        [self.view addSubview:self.imageView];
        self.view.backgroundColor = [UIColor whiteColor];
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
    //如果有结果 表明当前有用户
    if ([array count]>0) {
        User*localUser = array[0];
        return localUser;
    }else{
        return nil;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSArray *sections = [self.frc sections];
    
    return sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *sections = [self.frc sections];
    id<NSFetchedResultsSectionInfo>sectionInfo = sections[section];
    return [sectionInfo numberOfObjects];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell_indexPath2"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell_indexPath2"];
    }
    
    // Configure the cell...
    Person *person = [self.frc objectAtIndexPath:indexPath];
    NSLog(@"person.name %@",person.name);
    NSLog(@"person.tele %@",person.tele);
    cell.textLabel.text = person.name;
    cell.detailTextLabel.text = person.tele;
    cell.imageView.image = [UIImage imageWithData:person.pic];
    cell.accessoryType = UITableViewCellAccessoryDetailButton;
    
    return cell;
}
//返回分组header内容
- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    NSArray *sections = [self.frc sections];
    //行数
    id<NSFetchedResultsSectionInfo>sectionInfo = sections[section];
    return [sectionInfo name];
}
//选中cell时的回调
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //获取实体对象
    Person *person = [self.frc objectAtIndexPath:indexPath];
    second = [[ThirdViewController alloc] init];
    [second setValue:person forKey:@"person"];
    [second setValue:indexPath forKey:@"indexPath"];
    //同时进行传值
    [self.navigationController pushViewController:second animated:YES];
}


// 设置可被删除 删除之后 分组名为默认
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// 删除当前联系人的意思是将联系人从当前分组中去掉
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //获取实体变量
        Person *person = [self.frc objectAtIndexPath:indexPath];
        person.group.name = @"默认";
        //保存
        NSError *error;
        if (![self.managedObjectContext save:&error]) {
            NSLog(@"%@",error.localizedDescription);
        }
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
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
