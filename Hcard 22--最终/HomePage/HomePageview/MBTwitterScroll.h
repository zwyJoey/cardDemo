//
//  MBTwitterScroll.h
//  TwitterScroll
//
//  Created by Martin Blampied on 07/02/2015.
//  Copyright (c) 2015 MartinBlampied. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Person.h"
//短信
#import <MessageUI/MessageUI.h>
#import "Note.h"

typedef enum : NSUInteger {
    MBTable,
    MBScroll,
} MBType;


@protocol MBTwitterScrollDelegate <NSObject>
-(void)recievedMBTwitterScrollEvent;

@optional
-(void)recievedMBTwitterScrollButtonClicked;
-(void)dismissViewController;
@end


@interface MBTwitterScroll : UIView <UIScrollViewDelegate, MBTwitterScrollDelegate,UITextViewDelegate,NSFetchedResultsControllerDelegate>


- (MBTwitterScroll *)initTableViewWithBackgound:(UIImage*)backgroundImage avatarImage:(UIImage *)avatarImage Person:(Person *)person buttonTitle:(NSString *)buttonTitle;
- (MBTwitterScroll *)initScrollViewWithBackgound:(UIImage*)backgroundImage avatarImage:(UIImage *)avatarImage Person:(Person *)person buttonTitle:(NSString *)buttonTitle contentHeight:(CGFloat)height;
-(void)updateHeaderImage:(UIImage*)newImage;

@property (strong, nonatomic) UIImageView *avatarImage;
@property (strong, nonatomic) UIView *header;
@property (strong, nonatomic) UILabel *headerLabel;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIImageView *headerImageView;
@property (strong, nonatomic) UIButton *headerButton;
@property (strong, nonatomic) UILabel *subtitleLabel;
@property (strong, nonatomic) UILabel *titleLabel;

@property (nonatomic, strong) NSMutableArray *blurImages;
@property (nonatomic,strong) id<MBTwitterScrollDelegate>delegate;
@property (strong,nonatomic) UIWebView *webView;
@property (strong,nonatomic) Person *person;
@property (strong,nonatomic) UITextView *textView;
@property (strong,nonatomic) Note *note;
//跳转
@property (strong,nonatomic)id controller;
//声明一个上下文
@property (strong,nonatomic)NSManagedObjectContext *managedObjectContext;
@property (strong,nonatomic)NSFetchedResultsController *frc;

@end
