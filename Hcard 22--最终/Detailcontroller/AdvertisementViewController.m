//
//  AdvertisementViewController.m
//  详情页demo
//
//  Created by 黄传家 on 16/4/27.
//  Copyright © 2016年 黄传家. All rights reserved.
//

#import "AdvertisementViewController.h"
#import <CoreData/CoreData.h>
#import "AdvTableViewCell1.h"
#import "AdvTableViewCell2.h"
#import "AdvTableViewCell3.h"
#import "AdvTableViewCell4.h"
#import "CustomeImagePicker.h"
#import "User1.h"
#import "MyViewController.h"
#import "PLViewController.h"
#import "UILabel+Automatic.h"
@interface AdvertisementViewController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>
@property (strong,nonatomic)UIScrollView *scorlView;
@property (strong,nonatomic)UIPageControl *pageControl;
@property (strong,nonatomic)UITableView *tableView;
@property (strong,nonatomic)NSMutableArray *arr;
@property (strong,nonatomic)NSMutableArray *arr1;
@property (strong,nonatomic)NSManagedObjectContext *managedObjectContext;
@property (strong,nonatomic)NSMutableArray *mArr;
@property (strong,nonatomic)NSString *str1;
@property (strong,nonatomic)id img;
@property (assign,nonatomic)float height1;
@property (assign,nonatomic)float height2;
@property (assign,nonatomic)float height3;
@property (assign,nonatomic)float height4;
@end

@implementation AdvertisementViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.arr = [NSMutableArray array];
    User1 *u = [User1 shareUser];
    NSFetchRequest * request = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([Dynamic class])];
    NSError * error = nil;
    NSArray * array = [self.managedObjectContext executeFetchRequest:request error:&error];
    for (Dynamic * dynamic in array) {
        if ([dynamic.user.id isEqualToString:u.id]) {
            [self.arr addObject:dynamic];
//            name和pic应该是注册用户时的名字和选取的头像，从user表中取
//            [self.arr addObject:dynamic.per.name];
//            [self.arr addObject:dynamic.per.pic];
        }
    }
    self.arr1 = [NSMutableArray array];
    NSFetchRequest * request1 = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([User class])];
    NSError * error1 = nil;
    NSArray * array1 = [self.managedObjectContext executeFetchRequest:request1 error:&error1];
    for (User *user in array1) {
        if ([user.id isEqualToString:u.id]) {
            self.str1 = user.name;
            self.img = user.pic;
        }
    }

    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    id appDelegate = [[UIApplication sharedApplication] delegate];
    self.managedObjectContext = [appDelegate managedObjectContext];
    self.arr = [NSMutableArray array];
    User1 *person1 = [User1 shareUser];
    NSFetchRequest * request = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([Dynamic class])];
    NSError * error = nil;
    NSArray * array = [self.managedObjectContext executeFetchRequest:request error:&error];
    for (Dynamic * dynamic in array) {
        if ([dynamic.user.id isEqualToString:person1.id]) {
            [self.arr addObject:dynamic];
        }
    }
    self.arr1 = [NSMutableArray array];
    NSFetchRequest * request1 = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([User class])];
    NSError * error1 = nil;
    NSArray * array1 = [self.managedObjectContext executeFetchRequest:request1 error:&error1];
    for (User *user in array1) {
        if ([user.id isEqualToString:person1.id]) {
            self.str1 = user.name;
            self.img = user.pic;
        }
    }
    [self creatScorlView];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.mArr = [NSMutableArray array];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 50, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    [self.view addSubview:self.tableView];
    self.tableView.dataSource = self;
    self.tableView.delegate =self;
    self.tableView.tableHeaderView = self.scorlView;
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(Btntap)];
    self.navigationItem.rightBarButtonItem = item;
    }
-(void)creatScorlView{
    //    [UIScreen mainScreen).bounds 屏幕尺寸CGRect
    self.scorlView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 50, [UIScreen mainScreen].bounds.size.width, 200)];
    self.scorlView.backgroundColor=[UIColor redColor];
    [self.view addSubview:self.scorlView];
    //    显示的内容的宽高
    self.scorlView.contentSize=CGSizeMake([UIScreen mainScreen].bounds.size.width*4 , 200);
    self.pageControl=[[UIPageControl alloc]initWithFrame:CGRectMake((([UIScreen mainScreen].bounds.size.width-150)/2), 140, 150, 30)];
    //    self.pageControl.backgroundColor=[UIColor redColor];
    //    设置页数
    self.pageControl.numberOfPages=4;
    self.pageControl.currentPage=0;
    [self.view addSubview:self.pageControl];
    [self.pageControl addTarget:self action:@selector(hcj:) forControlEvents:UIControlEventValueChanged];
    UIButton *Vi1 = [[UIButton alloc]init];
    [Vi1 setBackgroundImage:[UIImage imageNamed:@"1"] forState:UIControlStateNormal];
    Vi1.frame = CGRectMake(0, 0, self.scorlView.bounds.size.width, self.scorlView.bounds.size.height);
    [self.scorlView addSubview:Vi1];
    
    UIButton *Vi2 = [[UIButton alloc]init];
    [Vi2 setBackgroundImage:[UIImage imageNamed:@"2"] forState:UIControlStateNormal];
    Vi2.frame = CGRectMake(self.scorlView.bounds.size.width, 0, self.scorlView.bounds.size.width, self.scorlView.bounds.size.height);
    [self.scorlView addSubview:Vi2];
    
    UIButton *Vi3 = [[UIButton alloc]init];
    [Vi3 setBackgroundImage:[UIImage imageNamed:@"3"] forState:UIControlStateNormal];
    Vi3.frame = CGRectMake(self.scorlView.bounds.size.width*2, 0, self.scorlView.bounds.size.width, self.scorlView.bounds.size.height);
    [self.scorlView addSubview:Vi3];
    
    UIButton *Vi4 = [[UIButton alloc]init];
    [Vi4 setBackgroundImage:[UIImage imageNamed:@"4"] forState:UIControlStateNormal];
    Vi4.frame = CGRectMake(self.scorlView.bounds.size.width*3, 0, self.scorlView.bounds.size.width, self.scorlView.bounds.size.height);
    [self.scorlView addSubview:Vi4];
    //    设置翻页效果 不允许反弹 不显示水平滑动 设置代理自己
    self.scorlView.pagingEnabled=YES;//设置翻页效果
    self.scorlView.bounces=NO;//不允许反弹
    self.scorlView.showsHorizontalScrollIndicator=NO;//不显示水平滑动
    self.scorlView.delegate=self;//设置代理自己
    //    UIPageControl
}
-(void)Btntap{
    
    MyViewController *myView = [[MyViewController alloc]init];
    [self.navigationController pushViewController:myView animated:YES];
}

-(void)hcj:(UIPageControl *)sender{
    //scorllView 大小
    CGSize viewSize = self.scorlView.frame.size;
    //大小和位置
    CGRect rect = CGRectMake(sender.currentPage * viewSize.width, 0, viewSize.width, viewSize.height);
    [self.scorlView scrollRectToVisible:rect animated:YES];
}
//滑动动作结束减速动作时调用
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //    纪录scrollView 的当前位子，因为已经设置了分页效果，所以：位子／屏幕大小＝第几页
    //    scrollView.contentOffset 当前内容的位置
    int current=scrollView.contentOffset.x/[UIScreen mainScreen].bounds.size.width;
    //    把计算出来的当前页给pageControl
    self.pageControl.currentPage=current;
}
//返回行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    Dynamic *dynamic = self.arr[indexPath.row];
    self.mArr = dynamic.image;
    
    
    if (self.mArr.count == 0) {
        static NSString *cellID1 = @"cellID1";
        AdvTableViewCell1 *cell1 = [tableView dequeueReusableCellWithIdentifier:cellID1];
        if (!cell1) {
            cell1 = [[AdvTableViewCell1 alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID1];
        }
        cell1.nameLabel.text = self.str1;
        cell1.contenLabel.text = dynamic.content;
        cell1.timeLabel.text = dynamic.time;
        [cell1 addTagPL:self action:@selector(PLtap:) tag:indexPath.row];
        [cell1.imgView setImage:self.img];
        self.height1 = [cell1.contenLabel  setTextIsAutomaticHeight:cell1.contenLabel.text];
        return cell1;
    }
    if (self.mArr.count >= 1 && self.mArr.count <=3) {
        static NSString *cellID2 = @"cellID2";
        AdvTableViewCell2 *cell2 = [tableView dequeueReusableCellWithIdentifier:cellID2];
        if (!cell2) {
            cell2 = [[AdvTableViewCell2 alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID2];
        }
        cell2.nameLabel.text = self.str1;
        cell2.contenLabel.text = dynamic.content;
        cell2.timeLabel.text = dynamic.time;
        [cell2 addTagPL:self action:@selector(PLtap:) tag:indexPath.row];
        [cell2.imgView setImage:self.img];
        self.height2 = [cell2.contenLabel  setTextIsAutomaticHeight:cell2.contenLabel.text];
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
        AdvTableViewCell3 *cell3 = [tableView dequeueReusableCellWithIdentifier:cellID3];
        if (!cell3) {
            cell3 = [[AdvTableViewCell3 alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID3];
        }
        cell3.nameLabel.text = self.str1;
        cell3.contenLabel.text = dynamic.content;
        cell3.timeLabel.text = dynamic.time;
        [cell3 addTagPL:self action:@selector(PLtap:) tag:indexPath.row];
        [cell3.imgView setImage:self.img];
        self.height3 = [cell3.contenLabel  setTextIsAutomaticHeight:cell3.contenLabel.text];
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
        AdvTableViewCell4 *cell4 = [tableView dequeueReusableCellWithIdentifier:cellID4];
        if (!cell4) {
            cell4 = [[AdvTableViewCell4 alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID4];
        }
        cell4.nameLabel.text = self.str1;
        cell4.contenLabel.text = dynamic.content;
        cell4.timeLabel.text = dynamic.time;
        [cell4 addTagPL:self action:@selector(PLtap:) tag:indexPath.row];
        [cell4.imgView setImage:self.img];
        self.height4 = [cell4.contenLabel  setTextIsAutomaticHeight:cell4.contenLabel.text];
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
-(void)PLtap:(UIButton *)b{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:b.tag inSection:0];
    Dynamic *dynamic = self.arr[indexPath.row];
    User1 *u = [User1 shareUser];
    u.dy = dynamic;
    u.name1 = self.str1;
    u.TX = self.img;
    PLViewController *PL = [[PLViewController alloc]init];
    [self.navigationController pushViewController:PL animated:YES];
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
