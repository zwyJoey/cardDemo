//
//  CardThreeViewController.m
//  Hcard
//
//  Created by ChenJS on 16/5/30.
//  Copyright © 2016年 黄传家. All rights reserved.
//

#import "CardThreeViewController.h"

@interface CardThreeViewController ()

@end

@implementation CardThreeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.v1 setImage:[UIImage imageNamed:@"4"] forState:UIControlStateNormal];
    [self.v2 setImage:[UIImage imageNamed:@"4"] forState:UIControlStateNormal];
    self.image = [UIImage imageNamed:@"4"];
    
    // Do any additional setup after loading the view.
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
