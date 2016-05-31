//
//  MyAdvViewController.m
//  详情页demo
//
//  Created by 黄传家 on 16/5/3.
//  Copyright © 2016年 黄传家. All rights reserved.
//

#import "MyAdvViewController.h"
#import <CoreData/CoreData.h>
#import "MyAdvTableViewCell.h"
#import "MyAdvTableViewCell1.h"
#import "MyAdvTableViewCell2.h"
#import "MyAdvTableViewCell3.h"
#import "MyViewController.h"
#import "CustomeImagePicker.h"
#import "User1.h"
#import "UILabel+Automatic.h"
@interface MyAdvViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong,nonatomic)UITableView *tableView;

@property(strong,nonatomic)NSManagedObjectContext * managedObjectContext;//coredata
@property(strong,nonatomic)NSMutableArray *mArr;
@property (strong,nonatomic)NSMutableArray *arr;
@property (assign,nonatomic)float height1;
@property (assign,nonatomic)float height2;
@property (assign,nonatomic)float height3;
@property (assign,nonatomic)float height4;

@end

@implementation MyAdvViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.title = @"我的广告";
    self.arr = [NSMutableArray array];
    User1 *person1 = [User1 shareUser];
    NSFetchRequest * request = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([Dynamic class])];
    NSError * error = nil;
    NSArray * array = [self.managedObjectContext executeFetchRequest:request error:&error];
    for (Dynamic * dynamic in array) {
//        NSLog(@"[[[[[[[[[[%@",dynamic.user.name);
        if ([dynamic.user.id isEqualToString:person1.id]) {
            [self.arr addObject:dynamic];
        }
        
    }
        [self.tableView reloadData];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(Btntap)];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    id appDelegete = [[UIApplication sharedApplication]delegate];
    self.managedObjectContext = [appDelegete managedObjectContext];
    self.arr = [NSMutableArray array];
    User1 *person1 = [User1 shareUser];
    NSFetchRequest * request = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([Dynamic class])];
    NSError * error = nil;
    NSArray * array = [self.managedObjectContext executeFetchRequest:request error:&error];
    for (Dynamic * dynamic in array) {
        NSLog(@"[[[[[[[%@",dynamic);
        if ([dynamic.user.id isEqualToString:person1.id]) {
            [self.arr addObject:dynamic];
        }
        
    }
   
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.mArr = [NSMutableArray array];
        [self creatTableView];
}
-(void)creatTableView{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-40)];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
//    self.arr = [[NSArray alloc]init];
    
}
-(void)Btntap{
        MyViewController *myView = [[MyViewController alloc]init];
    [self.navigationController pushViewController:myView animated:YES];
    
}
#pragma mark - Table view data source
//返回行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  self.arr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Dynamic * dynamic = self.arr[indexPath.row];
    
   self.mArr = dynamic.image;
  
    // 已经知道有几张图片
    if (self.mArr.count == 0) {
        static NSString *cellID1 = @"cellID1";
        MyAdvTableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:cellID1];
        if (!cell1) {
            cell1 = [[MyAdvTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID1];
            }
        cell1.contextLabel.text = dynamic.content;
        cell1.timeLabel.text = dynamic.time;
        self.height1 = [cell1.contextLabel  setTextIsAutomaticHeight:cell1.contextLabel.text];
        return cell1;
    }
    if (self.mArr.count >= 1 && self.mArr.count <=3) {
        static NSString *cellID2 = @"cellID2";
        MyAdvTableViewCell1 *cell2 = [tableView dequeueReusableCellWithIdentifier:cellID2];
        if (!cell2) {
            cell2 = [[MyAdvTableViewCell1 alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID2];
            }
        cell2.contextLabel.text = dynamic.content;
        cell2.timeLabel.text = dynamic.time;
        self.height2 = [cell2.contextLabel  setTextIsAutomaticHeight:cell2.contextLabel.text];
    for (int i=0; i<self.mArr.count; i++) {
        ALAssetsLibrary * al = [[ALAssetsLibrary alloc] init];
        NSString * str1 = (NSString *)self.mArr[i];
        [al assetForURL:[NSURL URLWithString:str1] resultBlock:^(ALAsset *asset) {
            CGImageRef ref = [asset aspectRatioThumbnail];
            UIImage * image = [UIImage imageWithCGImage:ref];
            // 显示图片
            [cell2 XSimage:image withcount:i];
            
        } failureBlock:nil];
        
    }
        return cell2;
    }
    else if (self.mArr.count >= 4 && self.mArr.count <=6) {
        static NSString *cellID3 = @"cellID3";
        MyAdvTableViewCell2 *cell3 = [tableView dequeueReusableCellWithIdentifier:cellID3];
        if (!cell3) {
            cell3 = [[MyAdvTableViewCell2 alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID3];
        }
        cell3.contextLabel.text = dynamic.content;
        cell3.timeLabel.text = dynamic.time;
        self.height3 = [cell3.contextLabel  setTextIsAutomaticHeight:cell3.contextLabel.text];
        for (int i=0; i<self.mArr.count; i++) {
            ALAssetsLibrary * al = [[ALAssetsLibrary alloc] init];
            NSString * str1 = (NSString *)self.mArr[i];
            [al assetForURL:[NSURL URLWithString:str1] resultBlock:^(ALAsset *asset) {
                CGImageRef ref = [asset aspectRatioThumbnail];
                UIImage * image = [UIImage imageWithCGImage:ref];
                // 显示图片
                [cell3 XSimage:image withcount:i];
                
            } failureBlock:nil];
            
        }
        return cell3;
    }else {
        static NSString *cellID4 = @"cellID4";
        MyAdvTableViewCell3 *cell4 = [tableView dequeueReusableCellWithIdentifier:cellID4];
        if (!cell4) {
            cell4 = [[MyAdvTableViewCell3 alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID4];
        }
        cell4.contextLabel.text = dynamic.content;
        cell4.timeLabel.text = dynamic.time;
        self.height4 = [cell4.contextLabel  setTextIsAutomaticHeight:cell4.contextLabel.text];
        for (int i=0; i<self.mArr.count; i++) {
            ALAssetsLibrary * al = [[ALAssetsLibrary alloc] init];
            NSString * str1 = (NSString *)self.mArr[i];
            [al assetForURL:[NSURL URLWithString:str1] resultBlock:^(ALAsset *asset) {
                CGImageRef ref = [asset aspectRatioThumbnail];
                UIImage * image = [UIImage imageWithCGImage:ref];
                // 显示图片
                [cell4 XSimage:image withcount:i];
                
            } failureBlock:nil];
            
        }
        return cell4;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.mArr.count == 0) {
        return self.height1+100;
    }else if(self.mArr.count >= 1 && self.mArr.count <= 3){
        return self.height2+300;
    }else if (self.mArr.count >=3 && self.mArr.count <= 6){
        return self.height3+400;
    }else {
        return self.height4+500;
    }

}
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
        return UITableViewCellEditingStyleDelete;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        Dynamic * dynamic = self.arr[indexPath.row];
        // 去数据库中删除数据
        [self.arr removeObject:dynamic];
        [self.managedObjectContext deleteObject:dynamic];
        NSError * error = nil;
        // 删除后需要保存才能真正删除
        BOOL isok = [self.managedObjectContext save:&error];
        if (!isok) {
            NSLog(@"删除失败 -- %@",error);
        }
        [self.tableView reloadData];
        // 先从数据源中删除
        //        [self.array removeObjectAtIndex:indexPath.row];
        // 再删除tableview的这个一行
        //        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}
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
    }
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = self.tableView;
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            //            [self configureCell:[tableView cellForRowAtIndexPath:indexPath]
            //                    atIndexPath:indexPath];
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


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    // Get the new view controller using [segue destinationViewController].
//    // Pass the selected object to the new view controller.
//    if ([sender isMemberOfClass:[UITableViewCell class]]) {
//        NSIndexPath * indexPath = [self.tableView indexPathForCell:sender];
//        // 把本行的person对象传给（下个页面）更新页面
//        //        [[segue destinationViewController] setValue:self.array[indexPath.row] forKey:@"person"];
//        [[segue destinationViewController] setValue:[self.fetchedResultsController objectAtIndexPath:indexPath] forKey:@"advcontent"];
//    }
//
//}


@end
