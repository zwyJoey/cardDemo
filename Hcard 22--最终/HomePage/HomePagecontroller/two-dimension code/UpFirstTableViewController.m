//
//  NewPersonTableViewController.m
//  cardCase
//
//  Created by ChenJS on 16/5/6.
//  Copyright © 2016年 zhiyuan3g. All rights reserved.
//

#import "UpFirstTableViewController.h"
#import <CoreData/CoreData.h>
#import "Person.h"
#import "User.h"
#import "ThirdViewController.h"

@interface UpFirstTableViewController ()<NSFetchedResultsControllerDelegate>
@property (strong,nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong,nonatomic) NSFetchedResultsController *frc;
@property (strong,nonatomic) ThirdViewController *second;
//当前用户
@property (strong,nonatomic) User *user;
@end

@implementation UpFirstTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getNewPerson];
    
    self.frc.delegate = self;
    
    self.navigationItem.title = @"最近添加";
}
-(void)getNewPerson{
    //通过代理获取上下文
    UIApplication *application = [UIApplication sharedApplication];
    id delegate = application.delegate;
    self.managedObjectContext = [delegate managedObjectContext];
    //通过实体名获取请求
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([Person class])];
    //添加排序规则
    NSSortDescriptor *sort1  =[[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES];
    NSSortDescriptor *sort2 = [[NSSortDescriptor alloc] initWithKey:@"nameTitle" ascending:YES];
    NSSortDescriptor *sort3 = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSSortDescriptor *sort4 = [[NSSortDescriptor alloc] initWithKey:@"tele" ascending:YES];
    [request setSortDescriptors:@[sort1,sort2,sort3,sort4]];
    //添加谓词 筛选出最近两周人脉
    NSTimeInterval forteen = 14*24*60*60;
    //当前时间
    NSDate *current = [NSDate date];
    //两周前
    NSDate *forteenAgo = [current dateByAddingTimeInterval:-forteen];
    //添加时间在当前时间与两周之前为最近人脉
    NSPredicate *perdicate1 = [NSPredicate predicateWithFormat:@"date<%@ AND date>%@",current,forteenAgo];
    [request setPredicate:perdicate1];
    //添加当前用户的谓词
    self.user = [self currentUser];
    if (self.user != nil) {
        NSPredicate *perdicate2 = [NSPredicate predicateWithFormat:@"user = %@",self.user];
        [request setPredicate:perdicate2];
    }else{
        NSLog(@"未登录-最近添加的人");
    }
    
    //把查询结果存入frc中
    self.frc = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.managedObjectContext sectionNameKeyPath:@"date" cacheName:nil];
    NSError *error;
    if (![self.frc performFetch:&error]) {
        NSLog(@"%@",[error localizedDescription]);
    }
    [self.tableView reloadData];
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
        NSLog(@"%@",localUser);
        return localUser;
    }else{
        return nil;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
//分组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSArray *sections = [self.frc sections];
    
    return sections.count;
}
//行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *sections = [self.frc sections];
    id<NSFetchedResultsSectionInfo>sectionInfo = sections[section];
    NSLog(@"%ld",[sectionInfo numberOfObjects]);
    
    return [sectionInfo numberOfObjects];
}
//设置表头
- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSArray *sections = [self.frc sections];
    id<NSFetchedResultsSectionInfo>sectionInfo = sections[section];
    
    return [sectionInfo name];
}
//设置单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    //获取实体对象
    Person *person = [self.frc objectAtIndexPath:indexPath];
    cell.textLabel.text = person.name;
    cell.detailTextLabel.text = person.tele;
    cell.imageView.image = [UIImage imageWithData:person.pic];
    cell.accessoryType = UITableViewCellAccessoryDetailButton;
    
    return cell;
}

//选中cell时的回调
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //获取实体对象
    Person *person = [self.frc objectAtIndexPath:indexPath];
    _second = [[ThirdViewController alloc] init];
    [_second setValue:person forKey:@"person"];
    [_second setValue:indexPath forKey:@"indexPath"];
    //同时进行传值
    [self.navigationController pushViewController:_second animated:YES];
}


//删除功能
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}


//开启编辑之后
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //通过coredate删除对象
        //通过IndexPath获取我们要删除的实体
        Person *person =[self.frc objectAtIndexPath:indexPath];
        //通过上下文移除实体
        [self.managedObjectContext deleteObject:person];
        //保存
        NSError *error;
        if (![self.managedObjectContext save:&error]) {
            NSLog(@"%@",[error localizedDescription]);
        }
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}
//当coredate的数据正在发生改变时 frc产生的回调
-(void)controllerWillChangeContent:(NSFetchedResultsController *)controller{
    NSLog(@"1341234123421");
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
