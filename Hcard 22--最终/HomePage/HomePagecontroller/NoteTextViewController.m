//
//  NoteTextViewController.m
//  Hcard
//
//  Created by ChenJS on 16/5/28.
//  Copyright © 2016年 黄传家. All rights reserved.
//
#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT  [UIScreen mainScreen].bounds.size.height
#import "NoteTextViewController.h"

@interface NoteTextViewController ()<UITextViewDelegate>
@property (strong,nonatomic)UITextView *field;
@property (assign,nonatomic)int height;


@end

@implementation NoteTextViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];// 1
    //设置TextField为第一响应者
    [self.field becomeFirstResponder];
}
- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationItem.title = @"编辑备注";
//    self.view.backgroundColor = [UIColor grayColor];
//    
//    //增加监听，当键盘出现或改变时收出消息
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWillShow:)
//                                                 name:UIKeyboardWillShowNotification
//                                               object:nil];
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-self.height)];
//    [self.view addSubview:view];
//    view.backgroundColor = [UIColor whiteColor];
//    //设置TextField
//    CGRect rectNav = self.navigationController.navigationBar.frame;
//    NSLog(@"nav width - %f", rectNav.size.width); // 宽度
//    NSLog(@"nav height - %f", rectNav.size.height);
//    
//    //textView自适应高度 自动换行
//    self.field = [[UITextView alloc] initWithFrame:CGRectMake(5, rectNav.size.height+25, WIDTH-10, 30)];
//    [view addSubview:self.field];
//    self.field.backgroundColor = [UIColor redColor];
//    self.field.scrollEnabled = YES;
//    self.field.font = [UIFont systemFontOfSize:14];
//    self.field.userInteractionEnabled = NO;
//    //设置textview换行
//    self.field.delegate = self;//设置它的委托方法
//    self.field.returnKeyType = UIReturnKeyDefault;//返回键的类型
//    self.field.keyboardType = UIKeyboardTypeDefault;//键盘类型
//    self.field.scrollEnabled = YES;//是否可以拖动
//    self.field.editable = YES;
//    self.field.autoresizingMask = UIViewAutoresizingFlexibleHeight;//自适应高度
    [self creatUI];
    
    
}

-(void)creatUI{
    self.view.backgroundColor = [UIColor grayColor];
    
    UIBarButtonItem * save = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveValue)];
    
    self.navigationItem.rightBarButtonItem = save;
    
    self.field = [[UITextView alloc] initWithFrame:CGRectMake(10, 70, [UIScreen mainScreen].bounds.size.width-20, 100)];
    
    self.field.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    
    self.field.delegate = self;
    
    self.field.backgroundColor = [UIColor whiteColor];
    
    self.field.layer.cornerRadius = 5;
    
    [self.view addSubview:self.field];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
}

-(void)saveValue{
    if ([self.field.text isEqualToString: @""]||self.field.text == nil) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    }else{
        
        self.backValue(self.field.text);

        [self.navigationController popViewControllerAnimated:YES];
        
    }
    
}





- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    /*
     iphone 6:
     中文
     2014-12-31 11:16:23.643 Demo[686:41289] 键盘高度是  258
     2014-12-31 11:16:23.644 Demo[686:41289] 键盘宽度是  375
     英文
     2014-12-31 11:55:21.417 Demo[1102:58972] 键盘高度是  216
     2014-12-31 11:55:21.417 Demo[1102:58972] 键盘宽度是  375
     
     iphone  6 plus：
     英文：
     2014-12-31 11:31:14.669 Demo[928:50593] 键盘高度是  226
     2014-12-31 11:31:14.669 Demo[928:50593] 键盘宽度是  414
     中文：
     2015-01-07 09:22:49.438 Demo[622:14908] 键盘高度是  271
     2015-01-07 09:22:49.439 Demo[622:14908] 键盘宽度是  414
     
     iphone 5 :
     2014-12-31 11:19:36.452 Demo[755:43233] 键盘高度是  216
     2014-12-31 11:19:36.452 Demo[755:43233] 键盘宽度是  320
     
     ipad Air：
     2014-12-31 11:28:32.178 Demo[851:48085] 键盘高度是  264
     2014-12-31 11:28:32.178 Demo[851:48085] 键盘宽度是  768
     
     ipad2 ：
     2014-12-31 11:33:57.258 Demo[1014:53043] 键盘高度是  264
     2014-12-31 11:33:57.258 Demo[1014:53043] 键盘宽度是  768
     */
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    self.height = keyboardRect.size.height;
    
    
}
- (void)textViewDidBeginEditing:(UITextView *)textView{
    
    self.field.text = @"";
    
}

-(void)back{
    self.backValue(self.field.text);
    [self dismissViewControllerAnimated:YES completion:nil];
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
