//
//  MoreViewController.m
//  cardCase
//
//  Created by ChenJS on 16/5/20.
//  Copyright © 2016年 黄传家. All rights reserved.
//
#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT  [UIScreen mainScreen].bounds.size.height

#import "MoreViewController.h"
#import "MoreTableViewCell.h"

#import "FirstViewController.h"
#import "ThirdViewController.h"


@interface MoreViewController ()
{
    MBTwitterScroll *myScrollView;
}

@property (strong,nonatomic)NSString *str;
@end

@implementation MoreViewController
-(void)viewWillAppear:(BOOL)animated{
    if (!self.navigationController.navigationBar.hidden) {
        self.navigationController.navigationBar.hidden = YES;
    }
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    Person *person = self.person;
    
    self.str = person.name?person.name:@"未填写";
    self.view.backgroundColor = [UIColor whiteColor];
    myScrollView = [[MBTwitterScroll alloc] initScrollViewWithBackgound:[UIImage imageNamed:@"log"] avatarImage:[UIImage imageWithData:person.pic] Person:self.person buttonTitle:@"编辑" contentHeight:1000];
    
    [self.view addSubview:myScrollView];
    
    myScrollView.delegate = self;
    myScrollView.controller = self.navigationController;
    
    //创建扫动识别器
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(turnGightView)];
    [self.view addGestureRecognizer:recognizer];
    //添加扫动方向
    recognizer.direction = UISwipeGestureRecognizerDirectionRight;
    //添加触摸点
    recognizer.numberOfTouchesRequired = 1;
}
//右扫手势的回调
-(void)turnGightView{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void) recievedMBTwitterScrollEvent {
    //    [self performSegueWithIdentifier:@"showPopover" sender:self];
    NSLog(@"弹出一个隐藏视图");
}

//编辑按钮回调
- (void) recievedMBTwitterScrollButtonClicked {
    NSLog(@"fadfa");
    //点击编辑按钮的跳转
    NSLog(@"recievedMBTwitterScrollButtonClicked == Button Clicked");
    ThirdViewController *second = [[ThirdViewController alloc] init];
    [second setValue:self.person forKey:@"person"];
    [second setValue:self.indexPath forKey:@"indexPath"];
    [self.navigationController pushViewController:second animated:YES];
    //    [self.navigationController pushViewController:second animated:YES];
    
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
